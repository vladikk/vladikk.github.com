# SEO audit & maintenance

## Re-running the audit

```sh
scripts/seo-audit.sh https://vladikk.com
```

Auto-discovers pages from the sitemap. Log the results in `scripts/history.csv`,
and add the Search Console average position monthly (Performance → filter by query,
28-day window). **That number, not Lighthouse, is the real KPI.**

## How to read the numbers

- **Page weight is the stable metric.** Lighthouse Performance swings ±15 points
  between identical runs; never treat a single-run move as a result.
- Lighthouse SEO score ~92+ is fine; chasing 100 has no ranking payoff.
- GSC lags 2–3 days and a "3 months" average is dominated by pre-change data —
  compare 28-day windows starting ~2 weeks after a change.

## What was changed (July 2026) and why

1. **robots.txt** — removed Jekyll front-matter cruft that was served verbatim;
   sitemap URL switched to https.
2. **404 page** — now `noindex` (via `layouts/partials/head.html` override).
3. **Titles** — category/section pages get a ` - Rants on Software Design` suffix
   (they were 2–10 chars, too short for SERPs).
4. **Meta descriptions** — site-wide fallback (`Params.description` in config.yaml),
   generated descriptions for category pages, and the `<meta name=description>` is
   capped at 160 chars at template level (og:description keeps full text).
   All in the `layouts/partials/head.html` override — the theme file is untouched.
5. **JSON-LD structured data** — WebSite + Person on the homepage, BlogPosting on
   posts, in `layouts/partials/head_custom.html`.
6. **Images** — 21 images totaling 16.5MB re-encoded to WebP (2.0MB total), resized
   to max 1460px wide (2× the 750px display width). Homepage went from ~9MB to
   ~0.5MB. Content `<img>`/markdown refs point at `.webp`; **original PNG/JPGs are
   kept** because `share_img:` (og:image) still uses them — social platform WebP
   support is unreliable.
7. **Removed Octopress/Middleman leftovers** — `static/public/` (an entire 15MB
   copy of the 2012–2017 blog served as duplicate content at /public/), `sass/`,
   `plugins/`, `config.rb`, `config.ru`, plus ~550 orphan files in blog-public
   (dead category pages, old fonts/css, a draft post that was still live).
   `/resume/resume.pdf` was deliberately preserved (external links may point at it).
8. **Fixed broken og:images** — `share_img` typos in the ai-toc-bc and
   solid-principles-ai-era posts pointed at nonexistent files.

## Traps for whoever touches this next

- **Hugo (0.56, the `../hugo` binary) does not prune the publish dir.** blog-public
  is committed and served as-is. After deleting/renaming anything, empty blog-public
  (keep `.git`!) and rebuild, or the old file stays live forever.
- **Don't add `loading="lazy"` or `width`/`height` attributes to images** without
  verifying every image still loads and renders at the same size — the theme's CSS
  controls sizing; HTML size attributes can stretch, and lazy-loading zero-size
  images makes them never load.
- **Re-encoding can make files bigger.** Always compare sizes and keep the original
  if smaller (the zen/header.jpg was left alone for this reason).
- **Renaming a page?** Add the old path to `aliases:` front matter instead of
  breaking the URL.
- The `layouts/partials/head.html` override shadows the theme's version — if the
  theme is ever updated, re-diff the two.

## What remains (needs the site owner, not a terminal)

- **Search Console / Bing Webmaster**: resubmit sitemap, check the 404 report and
  add `aliases:` for externally-linked dead URLs, Request Indexing on key pages.
- **Backlinks and content** — technical SEO is a floor, not a lever; rankings move
  on links and content depth.
- Optional perf: self-host the Google Fonts / Bootstrap / KaTeX CDN assets and drop
  AddThis (s7.addthis.com is defunct-adjacent and render-blocking).
