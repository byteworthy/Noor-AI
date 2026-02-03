# Awesome LLM Apps - Patterns for Noor AI
## Extracted Patterns & Implementation Guide

**Source Repository:** https://github.com/Shubhamsaboo/awesome-llm-apps
**Location:** `/c/Coding Projects - ByteWorthy/awesome-llm-apps`
**Purpose:** Identify and adapt relevant patterns for Noor AI implementation

---

## Summary of Useful Patterns

### ✅ Highly Relevant (Implement First)

1. **Qwen Local RAG** (`rag_tutorials/qwen_local_rag/`)
   - **What:** RAG system using Qwen models locally
   - **Why Relevant:** Noor AI uses Qwen2.5-7B-Instruct
   - **Use Case:** Quran/Hadith Q&A with citations
   - **Status:** ✅ Adapted in `docs/RAG-IMPLEMENTATION-GUIDE.md`

2. **Local RAG Agent** (`rag_tutorials/local_rag_agent/`)
   - **What:** Fully local RAG without external APIs
   - **Why Relevant:** Privacy-first, offline-capable
   - **Use Case:** On-device Islamic Q&A

3. **Agentic RAG with Reasoning** (`rag_tutorials/agentic_rag_with_reasoning/`)
   - **What:** RAG with chain-of-thought reasoning
   - **Why Relevant:** Complex fiqh questions need reasoning
   - **Use Case:** Madhab-aware responses, complex rulings

### 🔄 Moderately Relevant (Consider Later)

4. **Hybrid Search RAG** (`rag_tutorials/hybrid_search_rag/`)
   - **What:** Combines semantic + keyword search
   - **Why Relevant:** Better Arabic text matching
   - **Use Case:** Searching Quran by Arabic keywords + semantics

5. **Vision RAG** (`rag_tutorials/vision_rag/`)
   - **What:** RAG with image processing
   - **Why Relevant:** Photo-to-Quran recognition
   - **Use Case:** Scan Quran page, get enriched context

6. **Voice AI Agents** (`voice_ai_agents/`)
   - **What:** Voice-enabled AI interactions
   - **Why Relevant:** Arabic pronunciation practice
   - **Use Case:** Quran recitation checking, Arabic tutoring

### 📚 Reference Only (Study Patterns)

7. **Multi-Agent Systems** (`advanced_ai_agents/multi_agent_apps/`)
   - **What:** Coordinated agent teams
   - **Why Relevant:** Future feature - Islamic scholar consensus simulation
   - **Use Case:** Show multiple madhab perspectives

8. **MCP AI Agents** (`mcp_ai_agents/`)
   - **What:** Model Context Protocol implementations
   - **Why Relevant:** Learn agent architecture patterns
   - **Use Case:** Better conversation context management

---

## Implementation Priority

### Phase 1: Core RAG (NOW - period)
✅ **Qwen Local RAG** → Islamic Q&A
- Implement vector database (Qdrant)
- Embed Quran + Hadith
- Build RAG query service
- Create Flutter API client

### Phase 2: Enhanced Search (period)
🔄 **Hybrid Search RAG** → Better Arabic Search
- Add BM25 keyword search alongside semantic
- Improve Arabic root-word matching
- Combine scores for ranking

### Phase 3: Visual Features (period0)
🔄 **Vision RAG** → Photo-to-Quran
- Integrate GPT-4 Vision OCR
- Match extracted text to verse database
- Show enriched context (tafsir, audio, translation)

### Phase 4: Voice Features (period1-12)
🔄 **Voice AI Agents** → Arabic Tutor
- Whisper ASR for pronunciation
- Real-time feedback
- Conversational practice scenarios

---

## Detailed Pattern Analysis

### 1. Qwen Local RAG (IMPLEMENTED ✅)

**Location:** `rag_tutorials/qwen_local_rag/qwen_local_rag_agent.py`

**Key Components:**
- Qdrant vector database
- OllamaEmbedder for embeddings
- RecursiveCharacterTextSplitter for chunking
- Similarity search with threshold
- Citation tracking

**Adaptations for Noor AI:**
- Pre-loaded Islamic corpus instead of user uploads
- Custom citation format: `[Quran 2:177]`, `[Bukhari 52, Sahih]`
- Hadith grading display
- Madhab awareness in responses
- AI disclaimer on every response

**Implementation:** See `docs/RAG-IMPLEMENTATION-GUIDE.md`

---

### 2. Local RAG Agent

**Location:** `rag_tutorials/local_rag_agent/`

**Key Features:**
- Fully offline operation
- No external API dependencies
- Local LLM + local embeddings + local vector DB

**Noor AI Adaptation:**
```python
# On-device RAG for mobile
class OnDeviceNoorRAG:
    def __init__(self):
        # Use llamadart for on-device LLM
        self.llm = LlamaDart(model_path='assets/models/noor-ai-7b-q4km.gguf')

        # Use sentence-transformers mobile model
        self.encoder = SentenceTransformersMobile('all-MiniLM-L6-v2')

        # Use SQLite for vector storage (Drift in Flutter)
        self.db = DriftVectorDB()

    def query(self, question: str):
        # Embed question
        query_vector = self.encoder.encode(question)

        # Search local DB
        results = self.db.search_similar(query_vector, top_k=3)

        # Generate with local LLM
        context = "\n".join([r['text'] for r in results])
        response = self.llm.generate(f"Context: {context}\n\nQ: {question}\nA:")

        return response
```

**Benefits for Noor AI:**
- Works completely offline
- Privacy-preserving (no data leaves device)
- Fast (no network latency)
- Lower costs (no API fees)

---

### 3. Agentic RAG with Reasoning

**Location:** `rag_tutorials/agentic_rag_with_reasoning/`

**Key Features:**
- Chain-of-thought reasoning before answering
- Self-correction if initial answer insufficient
- Multi-step retrieval

**Noor AI Use Case: Complex Fiqh Questions**

Example: "Can I pray with shoes on?"

**Standard RAG:**
> "Yes, you can pray with shoes if they are clean."

**Agentic RAG with Reasoning:**
> 🤔 **Thinking:**
> 1. User asks about praying with shoes
> 2. This likely has madhab differences
> 3. Need to retrieve: (a) Hadith evidence, (b) Scholar opinions, (c) Conditions
> 4. Should mention all 4 madhabs
>
> ✅ **Answer:**
> Praying with shoes is permissible if certain conditions are met:
>
> **Evidence:**
> [Bukhari 386, Sahih] - The Prophet ﷺ sometimes prayed with shoes and sometimes removed them.
>
> **Conditions (All Madhabs):**
> 1. Shoes must be clean (free of najasah)
> 2. Check soles before prayer
>
> **Madhab Positions:**
> - **Hanafi, Shafi'i, Hanbali:** Permissible if clean
> - **Maliki:** Generally discouraged unless necessary
>
> **Note:** Many mosques have carpets, so cultural norms vary by location.

**Implementation Approach:**
```python
class AgenticNoorAI:
    def __init__(self):
        self.rag_service = NoorAIRAGService()

    def answer_with_reasoning(self, question: str):
        # Step 1: Analyze question complexity
        complexity = self.analyze_complexity(question)

        if complexity == "simple":
            # Direct RAG
            return self.rag_service.generate_response(question)

        elif complexity == "complex":
            # Multi-step reasoning
            thinking = []

            # Identify sub-questions
            thinking.append("Identifying aspects to address...")
            sub_questions = self.decompose_question(question)

            # Retrieve for each aspect
            all_context = []
            for sq in sub_questions:
                thinking.append(f"Searching for: {sq}")
                context = self.rag_service.search(sq)
                all_context.append(context)

            # Check for madhab differences
            thinking.append("Checking madhab perspectives...")
            madhab_info = self.get_madhab_views(question)

            # Generate comprehensive answer
            final_answer = self.synthesize_answer(
                question=question,
                contexts=all_context,
                madhab_info=madhab_info
            )

            return {
                "thinking": thinking,
                "answer": final_answer
            }
```

---

### 4. Hybrid Search RAG

**Location:** `rag_tutorials/hybrid_search_rag/`

**Key Features:**
- Semantic search (vector similarity)
- Keyword search (BM25)
- Score fusion (combines both)

**Why Important for Arabic:**
- Semantic search: "prayer times" → صلاة، وقت
- Keyword search: Exact match for "صلاة" even if semantics differ
- Better for Quranic text (exact phrase matching)

**Implementation:**
```python
class HybridSearchNoorAI:
    def search(self, query: str, top_k: int = 5):
        # Semantic search
        semantic_results = self.vector_search(query, top_k=10)

        # Keyword search (BM25 on Arabic text)
        keyword_results = self.bm25_search(query, top_k=10)

        # Fusion: Reciprocal Rank Fusion
        fused_results = self.fuse_results(semantic_results, keyword_results)

        return fused_results[:top_k]
```

---

### 5. Vision RAG (Photo-to-Quran)

**Location:** `rag_tutorials/vision_rag/`

**Key Features:**
- OCR text extraction from images
- Combine visual + text context
- Multi-modal reasoning

**Noor AI Flow:**
1. User takes photo of Quran page
2. GPT-4 Vision extracts Arabic text
3. Match to verse database
4. Show enriched context:
   - Translation
   - Tafsir
   - Audio recitation
   - Related verses
   - Thematic tags

**Implementation:** Already specified in `docs/MASTER-PRD.md` Section 5.3

---

### 6. Voice AI Agents

**Location:** `voice_ai_agents/`

**Key Features:**
- Speech-to-text (Whisper)
- Text-to-speech (ElevenLabs/Coqui)
- Conversational AI
- Real-time feedback

**Noor AI Use Cases:**

**A. Quran Memorization Helper:**
```
User recites → Whisper transcribes → Compare to correct text → Give feedback
```

**B. Conversational Arabic Tutor:**
```
AI: "مرحبا! كيف حالك؟" (Hello! How are you?)
User: [speaks Arabic]
AI: [detects pronunciation errors]
AI: "Good! But try pronouncing حالك with more emphasis on the ح sound."
```

**C. Islamic Q&A Voice Mode:**
```
User: "Alexa-style" → "What are the conditions for tayammum?"
AI: [retrieves context] → [generates answer] → [speaks response]
```

---

## Code Examples to Study

### Example 1: Document Chunking Strategy

**File:** `rag_tutorials/qwen_local_rag/qwen_local_rag_agent.py:166-170`

```python
text_splitter = RecursiveCharacterTextSplitter(
    chunk_size=1000,
    chunk_overlap=200
)
return text_splitter.split_documents(documents)
```

**Adaptation for Noor AI:**
```python
# For Quran: Keep ayahs together (natural boundaries)
def chunk_quran(surah_data):
    chunks = []
    for ayah in surah_data['ayahs']:
        # Each ayah is one chunk
        chunk = {
            'text': f"{ayah['arabic']} {ayah['english']}",
            'metadata': {
                'surah': surah_data['number'],
                'ayah': ayah['number'],
                'reference': f"Quran {surah_data['number']}:{ayah['number']}"
            }
        }
        chunks.append(chunk)
    return chunks

# For Hadith: Keep complete hadith as one chunk
def chunk_hadith(hadith_data):
    return {
        'text': f"{hadith_data['arabic']} {hadith_data['english']}",
        'metadata': {
            'collection': hadith_data['collection'],
            'number': hadith_data['number'],
            'grade': hadith_data['grade'],
            'reference': f"{hadith_data['collection']} {hadith_data['number']}"
        }
    }
```

### Example 2: Similarity Threshold Tuning

**File:** `rag_tutorials/qwen_local_rag/qwen_local_rag_agent.py:289-299`

```python
def check_document_relevance(query: str, vector_store, threshold: float = 0.7):
    retriever = vector_store.as_retriever(
        search_type="similarity_score_threshold",
        search_kwargs={"k": 5, "score_threshold": threshold}
    )
    docs = retriever.invoke(query)
    return bool(docs), docs
```

**Noor AI Thresholds:**
- 0.8+ : Highly relevant (direct answer)
- 0.6-0.8: Somewhat relevant (related topic)
- <0.6: Not relevant (fallback to general knowledge)

---

## Repository Structure Reference

```
awesome-llm-apps/
├── rag_tutorials/
│   ├── qwen_local_rag/          ✅ USED
│   ├── local_rag_agent/         🔄 TODO
│   ├── agentic_rag_with_reasoning/ 🔄 TODO
│   ├── hybrid_search_rag/       🔄 TODO
│   ├── vision_rag/              🔄 TODO
│   └── rag_chain/
├── voice_ai_agents/             🔄 TODO (Phase 4)
├── advanced_ai_agents/          📚 Reference
├── mcp_ai_agents/               📚 Reference
└── starter_ai_agents/           📚 Reference
```

---

## Next Actions

1. ✅ **Completed:** Reviewed Qwen Local RAG pattern
2. ✅ **Completed:** Created RAG implementation guide
3. ⏭️ **Next:** Implement basic RAG for Noor AI (period)
4. ⏭️ **Next:** Study hybrid search for Arabic optimization
5. ⏭️ **Next:** Plan vision RAG for photo-to-Quran
6. ⏭️ **Next:** Explore voice agent patterns for Arabic tutor

---

## Resources

**Repository:** https://github.com/Shubhamsaboo/awesome-llm-apps
**Local Clone:** `/c/Coding Projects - ByteWorthy/awesome-llm-apps`
**Noor AI Docs:**
- `docs/MASTER-PRD.md` - Complete product spec
- `docs/RAG-IMPLEMENTATION-GUIDE.md` - RAG adaptation guide
- `docs/LLM-TRAINING-WORKBOOK.md` - LLM training on Mac Mini M1

---

**Last Updated:** February 3, 2026
