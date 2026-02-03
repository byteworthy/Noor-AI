# Noor AI - RAG Implementation Guide
## Adapting Qwen Local RAG for Islamic Q&A

**Source:** Adapted from awesome-llm-apps/rag_tutorials/qwen_local_rag
**Purpose:** Implement Retrieval-Augmented Generation for Quran & Hadith Q&A
**Model:** Qwen2.5-7B-Instruct (trained on Islamic content)

---

## Overview

This guide shows how to adapt the Qwen Local RAG pattern for Noor AI's Islamic Q&A feature, where users ask questions and receive answers grounded in Quran and authentic Hadith.

**Key Differences from Generic RAG:**
- ✅ Pre-loaded Islamic corpus (Quran + Hadith) instead of user uploads
- ✅ Citation formatting with Islamic references [Quran 2:177], [Bukhari 52]
- ✅ Madhab-aware responses
- ✅ Hadith grading display (Sahih, Hasan, Daif)
- ✅ AI disclaimer on every response
- ✅ No fabricated hadith allowed
- ✅ Mobile-optimized (Flutter, not Streamlit)

---

## Architecture

```
User Question
     ↓
Query Embedding (Ollama/Sentence Transformers)
     ↓
Vector Search in Qdrant
  - Quran Collection (6,236 verses)
  - Hadith Collection (38,000+ hadiths)
     ↓
Retrieve Top 5 Relevant Passages
     ↓
Noor AI LLM (Qwen2.5-7B fine-tuned)
  - Context: Retrieved passages
  - Prompt: User question
  - Instructions: Cite sources, show madhab differences, include disclaimer
     ↓
Response with Citations
```

---

## Phase 1: Vector Database Setup (Python)

### 1.1 Install Dependencies

```bash
cd ~/noor-ai-training

# Create RAG environment
python3.11 -m venv venv-rag
source venv-rag/bin/activate

# Install packages
pip install qdrant-client sentence-transformers langchain langchain-community
```

### 1.2 Start Qdrant Vector Database

```bash
# Using Docker (recommended)
docker pull qdrant/qdrant

docker run -d -p 6333:6333 -p 6334:6334 \
    -v $(pwd)/qdrant_storage:/qdrant/storage:z \
    --name noor-ai-qdrant \
    qdrant/qdrant

# Verify it's running
curl http://localhost:6333/healthz
# Should return: {"title":"qdrant","version":"...","commit":"..."}
```

### 1.3 Create Collections

```python
# File: ~/noor-ai-training/create_collections.py

from qdrant_client import QdrantClient
from qdrant_client.models import Distance, VectorParams

client = QdrantClient(url="http://localhost:6333")

# Create Quran collection
client.create_collection(
    collection_name="quran_verses",
    vectors_config=VectorParams(
        size=768,  # Sentence-transformer embedding size
        distance=Distance.COSINE
    )
)

# Create Hadith collection
client.create_collection(
    collection_name="hadiths",
    vectors_config=VectorParams(
        size=768,
        distance=Distance.COSINE
    )
)

print("✅ Collections created!")
```

Run it:
```bash
python create_collections.py
```

---

## Phase 2: Embed & Index Content (Python)

### 2.1 Embed Quran Verses

```python
# File: ~/noor-ai-training/embed_quran.py

from qdrant_client import QdrantClient
from qdrant_client.models import PointStruct
from sentence_transformers import SentenceTransformer
import json
from uuid import uuid4

# Initialize
client = QdrantClient(url="http://localhost:6333")
model = SentenceTransformer('sentence-transformers/paraphrase-multilingual-mpnet-base-v2')

# Load Quran data (exported from your Drift database or API)
# Example format: {"surah": 1, "ayah": 1, "arabic": "...", "english": "...", "reference": "Quran 1:1"}
with open('quran_data.jsonl', 'r', encoding='utf-8') as f:
    verses = [json.loads(line) for line in f]

print(f"📖 Embedding {len(verses)} verses...")

points = []
for i, verse in enumerate(verses):
    # Combine Arabic + English for richer semantic search
    text = f"{verse['arabic']} {verse['english']}"

    # Generate embedding
    embedding = model.encode(text).tolist()

    # Create point
    point = PointStruct(
        id=str(uuid4()),
        vector=embedding,
        payload={
            "surah": verse["surah"],
            "ayah": verse["ayah"],
            "arabic": verse["arabic"],
            "english": verse["english"],
            "reference": verse["reference"],
            "type": "quran"
        }
    )
    points.append(point)

    if (i + 1) % 100 == 0:
        print(f"  Embedded {i + 1} verses...")

# Upload in batches
batch_size = 100
for i in range(0, len(points), batch_size):
    batch = points[i:i+batch_size]
    client.upsert(collection_name="quran_verses", points=batch)
    print(f"  Uploaded batch {i//batch_size + 1}")

print(f"✅ Indexed {len(verses)} Quran verses!")
```

Run it:
```bash
python embed_quran.py
```

### 2.2 Embed Hadiths

```python
# File: ~/noor-ai-training/embed_hadiths.py

from qdrant_client import QdrantClient
from qdrant_client.models import PointStruct
from sentence_transformers import SentenceTransformer
import json
from uuid import uuid4

client = QdrantClient(url="http://localhost:6333")
model = SentenceTransformer('sentence-transformers/paraphrase-multilingual-mpnet-base-v2')

# Load Hadith data
# Example format: {"collection": "Bukhari", "number": 52, "arabic": "...", "english": "...", "grade": "Sahih"}
with open('hadith_data.jsonl', 'r', encoding='utf-8') as f:
    hadiths = [json.loads(line) for line in f]

print(f"📚 Embedding {len(hadiths)} hadiths...")

points = []
for i, hadith in enumerate(hadiths):
    text = f"{hadith['arabic']} {hadith['english']}"
    embedding = model.encode(text).tolist()

    point = PointStruct(
        id=str(uuid4()),
        vector=embedding,
        payload={
            "collection": hadith["collection"],
            "number": hadith["number"],
            "arabic": hadith["arabic"],
            "english": hadith["english"],
            "narrator": hadith.get("narrator", "Unknown"),
            "grade": hadith["grade"],
            "reference": f"{hadith['collection']} {hadith['number']}",
            "type": "hadith"
        }
    )
    points.append(point)

    if (i + 1) % 100 == 0:
        print(f"  Embedded {i + 1} hadiths...")

# Upload in batches
batch_size = 100
for i in range(0, len(points), batch_size):
    batch = points[i:i+batch_size]
    client.upsert(collection_name="hadiths", points=batch)
    print(f"  Uploaded batch {i//batch_size + 1}")

print(f"✅ Indexed {len(hadiths)} hadiths!")
```

---

## Phase 3: RAG Query Service (Python)

### 3.1 Create RAG Service

```python
# File: ~/noor-ai-training/noor_ai_rag_service.py

from qdrant_client import QdrantClient
from sentence_transformers import SentenceTransformer
import ollama

class NoorAIRAGService:
    def __init__(self):
        self.client = QdrantClient(url="http://localhost:6333")
        self.encoder = SentenceTransformer('sentence-transformers/paraphrase-multilingual-mpnet-base-v2')

    def search_quran(self, query: str, top_k: int = 3):
        """Search for relevant Quran verses."""
        query_vector = self.encoder.encode(query).tolist()

        results = self.client.search(
            collection_name="quran_verses",
            query_vector=query_vector,
            limit=top_k,
            score_threshold=0.5  # Only include if similarity > 0.5
        )

        return [
            {
                "reference": hit.payload["reference"],
                "arabic": hit.payload["arabic"],
                "english": hit.payload["english"],
                "score": hit.score
            }
            for hit in results
        ]

    def search_hadiths(self, query: str, top_k: int = 3):
        """Search for relevant hadiths."""
        query_vector = self.encoder.encode(query).tolist()

        results = self.client.search(
            collection_name="hadiths",
            query_vector=query_vector,
            limit=top_k,
            score_threshold=0.5
        )

        return [
            {
                "reference": hit.payload["reference"],
                "english": hit.payload["english"],
                "grade": hit.payload["grade"],
                "narrator": hit.payload["narrator"],
                "score": hit.score
            }
            for hit in results
        ]

    def generate_response(self, question: str):
        """Generate RAG response with citations."""

        # Step 1: Retrieve relevant context
        quran_results = self.search_quran(question, top_k=2)
        hadith_results = self.search_hadiths(question, top_k=2)

        # Step 2: Build context string
        context_parts = []

        if quran_results:
            context_parts.append("Relevant Quran verses:")
            for result in quran_results:
                context_parts.append(f"[{result['reference']}]: {result['english']}")

        if hadith_results:
            context_parts.append("\nRelevant Hadiths:")
            for result in hadith_results:
                grade_icon = "✅" if result['grade'] == "Sahih" else "⚠️"
                context_parts.append(f"[{result['reference']}, {result['grade']}] {grade_icon}: {result['english']}")

        context = "\n".join(context_parts) if context_parts else "No directly relevant verses or hadiths found."

        # Step 3: Build prompt
        system_prompt = """You are Noor AI, a knowledgeable Islamic education assistant.

CRITICAL RULES:
1. Always cite sources in format [Quran X:Y] or [Bukhari Z]
2. NEVER make up citations
3. If no relevant sources provided, say "I don't have specific sources for this"
4. Show hadith grading (Sahih/Hasan/Daif)
5. Note madhab differences when relevant
6. Be respectful and educational

Remember: This is AI-generated content. Users should consult scholars for rulings."""

        user_prompt = f"""Context from Islamic sources:
{context}

User Question: {question}

Provide a comprehensive answer based on the available sources. Always cite your sources."""

        # Step 4: Generate with Ollama (using local Qwen model)
        response = ollama.chat(
            model='qwen2.5:7b',  # Your quantized model
            messages=[
                {'role': 'system', 'content': system_prompt},
                {'role': 'user', 'content': user_prompt}
            ]
        )

        return {
            "answer": response['message']['content'],
            "sources": {
                "quran": quran_results,
                "hadith": hadith_results
            }
        }

# Example usage
if __name__ == "__main__":
    service = NoorAIRAGService()

    question = "What are the 5 pillars of Islam?"
    result = service.generate_response(question)

    print("Question:", question)
    print("\nAnswer:", result["answer"])
    print("\nSources:")
    print("Quran:", len(result["sources"]["quran"]), "verses")
    print("Hadith:", len(result["sources"]["hadith"]), "hadiths")
```

Run it:
```bash
python noor_ai_rag_service.py
```

---

## Phase 4: Flutter Integration

### 4.1 Add Dependencies to pubspec.yaml

```yaml
dependencies:
  # HTTP client for RAG service
  http: ^1.2.0

  # JSON handling
  json_annotation: ^4.9.0
```

### 4.2 Create RAG Service in Flutter

```dart
// File: lib/features/noor_ai/data/services/noor_ai_rag_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class NoorAIRAGService {
  final String baseUrl;

  NoorAIRAGService({this.baseUrl = 'http://localhost:5000'});

  Future<Map<String, dynamic>> askQuestion(String question) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/ask'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'question': question}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get answer');
    }
  }
}
```

### 4.3 Create Flask API Server

```python
# File: ~/noor-ai-training/api_server.py

from flask import Flask, request, jsonify
from flask_cors import CORS
from noor_ai_rag_service import NoorAIRAGService

app = Flask(__name__)
CORS(app)  # Enable CORS for Flutter app

rag_service = NoorAIRAGService()

@app.route('/api/ask', methods=['POST'])
def ask_question():
    data = request.json
    question = data.get('question', '')

    if not question:
        return jsonify({'error': 'No question provided'}), 400

    try:
        result = rag_service.generate_response(question)
        return jsonify(result)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({'status': 'healthy'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
```

Install Flask:
```bash
pip install flask flask-cors
```

Run API server:
```bash
python api_server.py
```

---

## Phase 5: Mobile Optimization (Optional - On-Device RAG)

For fully offline mobile app, use Flutter packages:

```yaml
dependencies:
  # Vector search on device
  vector_math: ^2.2.0

  # SQLite for local vector storage
  sqflite: ^2.3.0

  # LLM inference on device
  llamadart: ^latest  # Or flutter_llama
```

See `docs/MASTER-PRD.md` Section 4.2 for on-device LLM setup.

---

## Expected Results

**Input:** "What are the 5 pillars of Islam?"

**Output:**
```
The 5 pillars of Islam are:

1. **Shahada** - Declaration of Faith
2. **Salah** - Five daily prayers
3. **Zakat** - Charity (2.5% of wealth annually)
4. **Sawm** - Fasting during Ramadan
5. **Hajj** - Pilgrimage to Mecca (once in lifetime if able)

**Sources:**
[Quran 2:177] - "Righteousness is not that you turn your faces toward the east or the west, but [true] righteousness is [in] one who believes in Allah, the Last Day, the angels, the Book, and the prophets and gives wealth, in spite of love for it, to relatives, orphans, the needy, the traveler, those who ask [for help], and for freeing slaves; [and who] establishes prayer and gives zakah..."

[Bukhari 8, Sahih] ✅ - Narrated Ibn 'Umar: Allah's Messenger ﷺ said: "Islam is based on five (principles): To testify that none has the right to be worshipped but Allah and Muhammad is Allah's Messenger, to offer prayers perfectly, to pay Zakat, to perform Hajj, and to observe fast during Ramadan."

⚠️ **AI Disclaimer:** This is AI-generated educational content. For religious rulings specific to your situation, please consult a qualified Islamic scholar.
```

---

## Performance Metrics

**Target Performance:**
- Query latency: <2 seconds (including LLM generation)
- Vector search: <100ms
- Context retrieval: Top 5 results in <50ms
- Embedding generation: <200ms per query
- LLM generation: 10-20 tokens/sec on mobile

**Optimization Tips:**
1. Pre-compute embeddings for all Quran/Hadith (one-time, ~2 hours)
2. Use quantized model (Q4_K_M) for faster inference
3. Cache frequently asked questions
4. Use semantic caching for similar queries
5. Batch embed if processing multiple queries

---

## Next Steps

1. ✅ Set up Qdrant vector database
2. ✅ Embed Quran verses (6,236)
3. ✅ Embed Hadiths (38,000+)
4. ✅ Create Python RAG service
5. ✅ Create Flask API server
6. ✅ Integrate with Flutter app
7. ⏭️ Add caching layer
8. ⏭️ Implement on-device RAG (optional)
9. ⏭️ Add madhab-specific filtering
10. ⏭️ Implement conversation memory

---

**Last Updated:** February 3, 2026
**Source:** Adapted from awesome-llm-apps/rag_tutorials/qwen_local_rag
