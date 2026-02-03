# Noor AI - LLM Training Workbook
## Mac Mini M1 Training Guide (10-12 Hours)

**Hardware:** Mac Mini M1 (8-core, 16GB RAM)
**Base Model:** Qwen2.5-7B-Instruct
**Output:** 4.7GB mobile-ready GGUF model
**Total Time:** ~14 hours (12 hours training + 2 hours setup)

**Note:** Training will be slower on M1 compared to M4 Pro. Expect ~600-800 tokens/sec vs 1200+ on M4 Pro.

---

## Quick Start Checklist

```bash
# Verify you have:
python3.11 --version  # Python 3.11+
brew --version        # Homebrew installed
# 100GB+ free disk space
# Fast internet for 15GB download
```

---

## Step 1: Setup (30 minutes)

```bash
# Install dependencies
brew install python@3.11 git-lfs
pip3 install mlx mlx-lm huggingface_hub transformers datasets

# Create project directory
mkdir -p ~/noor-ai-training/{models/base,models/finetuned,models/quantized,data,logs}
cd ~/noor-ai-training

# Login to Hugging Face
huggingface-cli login
# Get token from: https://huggingface.co/settings/tokens
```

---

## Step 2: Download Qwen2.5-7B (60 minutes)

```bash
cd ~/noor-ai-training/models/base

# Download model (15GB)
huggingface-cli download Qwen/Qwen2.5-7B-Instruct \
  --local-dir . \
  --local-dir-use-symlinks False

# Convert to MLX format
cd ~/noor-ai-training
python -m mlx_lm.convert \
  --hf-path models/base \
  --mlx-path models/base-mlx \
  --quantize
```

---

## Step 3: Prepare Training Data (2-3 hours)

### Data Format: JSONL with Qwen chat template

```json
{"text": "<|im_start|>system\nYou are Noor AI, an Islamic knowledge assistant. Always cite sources.<|im_end|>\n<|im_start|>user\nWhat are the 5 pillars of Islam?<|im_end|>\n<|im_start|>assistant\nThe 5 pillars are:\n1. Shahada\n2. Salah\n3. Zakat\n4. Sawm\n5. Hajj\nSources: [Quran 2:177] [Bukhari 8]<|im_end|>"}
```

### Create Sample Dataset

```bash
cd ~/noor-ai-training/data

# Create test dataset (3 samples)
cat > islamic_qa_sample.jsonl << 'EOF'
{"text": "<|im_start|>system\nYou are Noor AI, a knowledgeable Islamic education assistant. Provide accurate information based on Quran and authentic hadith. Always cite sources.<|im_end|>\n<|im_start|>user\nWhat are the 5 pillars of Islam?<|im_end|>\n<|im_start|>assistant\nThe 5 pillars of Islam are:\n\n1. **Shahada** - Declaration of Faith\n2. **Salah** - Five daily prayers\n3. **Zakat** - Charity (2.5% annually)\n4. **Sawm** - Fasting during Ramadan\n5. **Hajj** - Pilgrimage to Mecca\n\nSources: [Quran 2:177], [Bukhari 8]<|im_end|>"}
{"text": "<|im_start|>system\nYou are Noor AI, a knowledgeable Islamic education assistant. Provide accurate information based on Quran and authentic hadith. Always cite sources.<|im_end|>\n<|im_start|>user\nExplain Ayat al-Kursi<|im_end|>\n<|im_start|>assistant\nAyat al-Kursi (Quran 2:255) is considered the greatest verse in the Quran.\n\nKey themes:\n- Allah's eternal sovereignty\n- His infinite knowledge\n- His power that never tires\n- His throne encompasses heavens and earth\n\nProphet Muhammad ﷺ said it is the greatest verse in the Quran.\n\nSources: [Quran 2:255], [Muslim 810]<|im_end|>"}
{"text": "<|im_start|>system\nYou are Noor AI, a knowledgeable Islamic education assistant. Provide accurate information based on Quran and authentic hadith. Always cite sources.<|im_end|>\n<|im_start|>user\nHow do I perform wudu?<|im_end|>\n<|im_start|>assistant\nWudu (ablution) steps:\n\n1. Intention (niyyah)\n2. Say Bismillah\n3. Wash hands 3x\n4. Rinse mouth 3x\n5. Rinse nose 3x\n6. Wash face 3x\n7. Wash arms to elbows 3x\n8. Wipe head once\n9. Wipe ears once\n10. Wash feet to ankles 3x\n\nSources: [Quran 5:6], [Bukhari 159]<|im_end|>"}
EOF

# For production: You need 50,000 samples
# Split: 47,500 train, 2,500 validation
cp islamic_qa_sample.jsonl train.jsonl
cp islamic_qa_sample.jsonl valid.jsonl
```

---

## Step 4: Train with LoRA (6-8 hours)

```bash
cd ~/noor-ai-training

# Start training
python -m mlx_lm.lora \
  --model models/base-mlx \
  --train \
  --data data/train.jsonl \
  --valid-data data/valid.jsonl \
  --batch-size 4 \
  --lora-layers 16 \
  --lora-rank 64 \
  --lora-alpha 128 \
  --learning-rate 2e-4 \
  --num-iters 15000 \
  --steps-per-eval 500 \
  --save-every 1000 \
  --adapter-path models/finetuned

# Expected output:
# Iter 10: Train loss 2.45, Val loss 2.51, Tokens/sec 650
# ...
# Iter 15000: Train loss 1.05, Val loss 1.12, Tokens/sec 680

# Training takes 10-12 hours on Mac Mini M1
# Note: M1 is slower than M4 Pro but still very capable!
```

**Expected Loss Progression:**
- Start: ~2.5
- After 5000 steps: ~1.7
- After 10000 steps: ~1.3
- Final: ~1.0-1.2

---

## Step 5: Merge LoRA Adapters (15 minutes)

```bash
cd ~/noor-ai-training

# Merge LoRA weights into base model
python -m mlx_lm.fuse \
  --model models/base-mlx \
  --adapter-path models/finetuned/adapters \
  --save-path models/finetuned/merged
```

---

## Step 6: Quantize to GGUF (30 minutes)

```bash
cd ~/noor-ai-training

# Clone llama.cpp
git clone https://github.com/ggerganov/llama.cpp.git
cd llama.cpp
make

# Convert to GGUF FP16 first
python convert.py \
  ../models/finetuned/merged \
  --outtype f16 \
  --outfile ../models/quantized/noor-ai-7b-f16.gguf

# Quantize to Q4_K_M (mobile-ready)
./quantize \
  ../models/quantized/noor-ai-7b-f16.gguf \
  ../models/quantized/noor-ai-7b-q4km.gguf \
  Q4_K_M

# Result: 4.7GB file (95% quality of FP16)
```

---

## Step 7: Test the Model (15 minutes)

```bash
cd ~/noor-ai-training/llama.cpp

# Interactive test
./main \
  -m ../models/quantized/noor-ai-7b-q4km.gguf \
  -n 512 \
  --temp 0.7 \
  -c 4096 \
  --color \
  -i \
  -p "<|im_start|>system
You are Noor AI, a knowledgeable Islamic education assistant.<|im_end|>
<|im_start|>user
What are the 5 pillars of Islam?<|im_end|>
<|im_start|>assistant"

# The model should respond with accurate info + sources!
```

**Test Questions:**
1. "What are the 5 pillars of Islam?"
2. "Explain Ayat al-Kursi"
3. "How do I perform wudu?"
4. "Can I pray with shoes on?" (should mention madhab differences)

---

## Step 8: Copy to Flutter Project (5 minutes)

```bash
# Copy final model to Flutter
mkdir -p ~/noor_ai_flutter/assets/models
cp ~/noor-ai-training/models/quantized/noor-ai-7b-q4km.gguf \
   ~/noor_ai_flutter/assets/models/

# Add to pubspec.yaml:
# flutter:
#   assets:
#     - assets/models/noor-ai-7b-q4km.gguf
```

---

## Troubleshooting

**Out of Memory:**
```bash
# Reduce batch size
--batch-size 2 --gradient-accumulation 8
```

**Model generates gibberish:**
```bash
# Verify chat template format
<|im_start|>system\n...<|im_end|>\n
```

**Training too slow:**
```bash
# Check GPU usage
python -c "import mlx.core as mx; print(mx.metal.is_available())"
# Should print: True
```

**Loss not decreasing:**
```bash
# Lower learning rate
--learning-rate 1e-4
```

---

## Summary: One-Command Training

```bash
# After setup and data preparation:
python -m mlx_lm.lora \
  --model models/base-mlx \
  --train \
  --data data/train.jsonl \
  --batch-size 4 \
  --lora-rank 64 \
  --num-iters 15000 \
  --adapter-path models/finetuned

# Wait 6-8 hours, then merge and quantize!
```

---

**Total Cost: $599-$699 (Mac Mini M1) + $3 electricity = ~$600-$700**

**Result: Production-ready 4.7GB Islamic LLM that runs on mobile devices!** 🎉

**Performance Note:** M1 is perfectly capable for this task. Training just takes a bit longer (10-12 hours vs 6-8 hours on M4 Pro), but the final model quality is identical!
