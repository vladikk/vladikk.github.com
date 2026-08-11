// WebMCP tool: ask_site — retrieval over the site's own content.
//
// Side-effect free: defineTool validates at module load, nothing registers here.
// Registration lives in ../entry.js.
//
// The content bundle is generated at build time by layouts/index.json.

import { defineTool } from "@agentlane/webmcp";

const INDEX_URL = "/index.json";
const EXCERPT_RADIUS = 220;
const MAX_EXCERPTS = 3;

// Weights favour the fields an author curates over incidental body mentions.
const WEIGHT = { title: 12, categories: 6, description: 4, body: 1 };
const BODY_HITS_COUNTED = 8;

const STOP_WORDS = new Set([
  "a", "the", "and", "or", "but", "if", "of", "to", "in", "on", "at", "for",
  "with", "from", "by", "is", "are", "was", "were", "be", "been", "being", "do",
  "does", "did", "how", "what", "why", "when", "where", "which", "who", "whom",
  "this", "that", "these", "those", "it", "its", "as", "an", "you", "your", "i",
  "me", "my", "we", "our", "he", "she", "they", "them", "his", "her", "their",
  "about", "any", "can", "could", "would", "should", "have", "has", "had", "there",
  "vlad", "vladik", "khononov",
]);

/** Cached across calls on a page; a failed load is not cached. */
let indexPromise = null;

function loadIndex() {
  if (!indexPromise) {
    indexPromise = fetch(INDEX_URL, { headers: { accept: "application/json" } })
      .then(async (response) => {
        if (!response.ok) {
          throw new Error(
            `ask_site: content index ${INDEX_URL} returned HTTP ${response.status}`,
          );
        }
        const data = await response.json();
        if (!data || !Array.isArray(data.docs)) {
          throw new Error(
            `ask_site: content index ${INDEX_URL} is malformed — expected a "docs" array`,
          );
        }
        return data;
      })
      .catch((error) => {
        indexPromise = null;
        throw error;
      });
  }
  return indexPromise;
}

function toTerms(query) {
  const words = query.toLowerCase().match(/[a-z0-9][a-z0-9'+#._-]*/g) ?? [];
  const meaningful = [...new Set(words)].filter(
    (word) => word.length > 1 && !STOP_WORDS.has(word),
  );
  // An all-stopword query ("how do you do it?") still deserves a real attempt.
  return meaningful.length > 0 ? meaningful : [...new Set(words)];
}

function countHits(haystack, term, limit = Number.POSITIVE_INFINITY) {
  if (!haystack) return 0;
  let hits = 0;
  let from = 0;
  while (hits < limit) {
    const at = haystack.indexOf(term, from);
    if (at === -1) break;
    hits += 1;
    from = at + term.length;
  }
  return hits;
}

function scoreDoc(doc, terms) {
  const title = (doc.title ?? "").toLowerCase();
  const description = (doc.description ?? "").toLowerCase();
  const body = (doc.body ?? "").toLowerCase();
  const labels = [...(doc.categories ?? []), ...(doc.tags ?? [])]
    .join(" ")
    .toLowerCase();

  let score = 0;
  let matched = 0;
  for (const term of terms) {
    const inTitle = countHits(title, term, 1);
    const inLabels = countHits(labels, term, 1);
    const inDescription = countHits(description, term, 2);
    const inBody = countHits(body, term, BODY_HITS_COUNTED);
    if (inTitle + inLabels + inDescription + inBody === 0) continue;

    matched += 1;
    score +=
      inTitle * WEIGHT.title +
      inLabels * WEIGHT.categories +
      inDescription * WEIGHT.description +
      inBody * WEIGHT.body;
  }

  // Pages covering more of the question outrank pages repeating one word.
  return matched === 0 ? 0 : score * matched;
}

function buildExcerpts(body, terms) {
  if (!body) return [];
  const haystack = body.toLowerCase();
  const spans = [];

  for (const term of terms) {
    const at = haystack.indexOf(term);
    if (at === -1) continue;
    const start = Math.max(0, at - EXCERPT_RADIUS);
    const end = Math.min(body.length, at + term.length + EXCERPT_RADIUS);
    const overlapping = spans.find((span) => start < span.end && end > span.start);
    if (overlapping) {
      overlapping.start = Math.min(overlapping.start, start);
      overlapping.end = Math.max(overlapping.end, end);
    } else {
      spans.push({ start, end });
    }
  }

  return spans
    .sort((a, b) => a.start - b.start)
    .slice(0, MAX_EXCERPTS)
    .map(({ start, end }) => {
      const text = body.slice(start, end).trim();
      return `${start > 0 ? "…" : ""}${text}${end < body.length ? "…" : ""}`;
    });
}

export const askSite = defineTool({
  stableKey: "site.ask",
  name: "ask_site",
  title: "Search vladikk.com",
  description:
    "Search and retrieve content from vladikk.com — Vlad Khononov's blog posts on software design, domain-driven design, coupling, microservices, and AI-assisted engineering, plus his pages on consulting services, conference talks, books, reading list, and contact details. Use this to answer any question about what Vlad has written, what he thinks about a topic, what services he offers, or how to reach him. Returns matching pages with title, URL, publication date, categories, and the excerpts that matched — compose your answer from those excerpts and cite the URLs. Read-only; does not change the page.",
  inputSchema: {
    type: "object",
    properties: {
      query: {
        type: "string",
        minLength: 1,
        description:
          "What the visitor wants to know, in their own words — e.g. 'what is balanced coupling' or 'does Vlad run on-site training'.",
      },
      limit: {
        type: "integer",
        minimum: 1,
        maximum: 10,
        default: 5,
        description: "Maximum number of pages to return. Defaults to 5.",
      },
    },
    required: ["query"],
    additionalProperties: false,
  },
  annotations: { readOnlyHint: true },
  async execute({ query, limit }) {
    const trimmed = (query ?? "").trim();
    if (!trimmed) throw new Error("ask_site: `query` must be a non-empty string");

    const max = Math.min(Math.max(Number.isInteger(limit) ? limit : 5, 1), 10);
    const index = await loadIndex();
    const terms = toTerms(trimmed);

    const results = index.docs
      .map((doc) => ({ doc, score: scoreDoc(doc, terms) }))
      .filter((scored) => scored.score > 0)
      .sort((a, b) => b.score - a.score || (b.doc.date ?? "").localeCompare(a.doc.date ?? ""))
      .slice(0, max)
      .map(({ doc }) => ({
        title: doc.title,
        url: doc.url,
        date: doc.date || null,
        section: doc.section,
        categories: doc.categories ?? [],
        excerpts: buildExcerpts(doc.body, terms),
      }));

    if (results.length === 0) {
      return {
        query: trimmed,
        results: [],
        note:
          `No page on ${index.site || "this site"} matches "${trimmed}". The site is a personal blog ` +
          `covering software design, domain-driven design, coupling, microservices and AI-assisted ` +
          `engineering, plus pages on consulting, conference talks, books and contact details. ` +
          `It has ${index.count ?? index.docs.length} pages in total — try different wording, or a broader topic.`,
      };
    }

    return { query: trimmed, results };
  },
});
