#!/usr/bin/env bash
# Technical SEO audit for any live site.
#
# Usage:
#   ./seo-audit.sh https://example.com                    # auto-picks pages from sitemap
#   ./seo-audit.sh https://example.com / /about /pricing  # explicit pages
#   ./seo-audit.sh https://example.com --skip-lighthouse  # fast checks only (~10s)
#
# Env:
#   SEO_OUT=./seo-audit    output directory (results + history.csv live here)
#   SEO_MAX_PAGES=5        how many pages to auto-pick from the sitemap
#
# Requires: curl, jq, node, and Chrome (for Lighthouse; fetched via npx).
set -uo pipefail

HOST=""
PAGES=()
SKIP_LH=0
for arg in "$@"; do
  case "$arg" in
    --skip-lighthouse) SKIP_LH=1 ;;
    http://*|https://*) HOST="${arg%/}" ;;
    /*) PAGES+=("$arg") ;;
  esac
done

if [ -z "$HOST" ]; then
  echo "usage: $0 https://example.com [/path ...] [--skip-lighthouse]" >&2
  exit 2
fi

OUTDIR="${SEO_OUT:-./seo-audit}"
MAX_PAGES="${SEO_MAX_PAGES:-5}"
STAMP="$(date +%Y-%m-%d_%H%M)"
OUT="$OUTDIR/results/$STAMP"
HISTORY="$OUTDIR/history.csv"
REPORT="$OUT/report.txt"
mkdir -p "$OUT"

say() { echo "$@" | tee -a "$REPORT"; }

say "SEO audit — $STAMP — $HOST"
say "======================================================"

sitemap=$(curl -s --max-time 20 "$HOST/sitemap.xml")

# Auto-pick pages from the sitemap when none were given.
if [ ${#PAGES[@]} -eq 0 ]; then
  PAGES=("/")
  while read -r u; do
    [ -z "$u" ] && continue
    p="${u#$HOST}"
    [ "$p" = "/" ] && continue
    case "$p" in /*) PAGES+=("$p") ;; esac
    [ ${#PAGES[@]} -ge "$MAX_PAGES" ] && break
  done < <(echo "$sitemap" | grep -o '<loc>[^<]*</loc>' | sed -e 's|<loc>||' -e 's|</loc>||')
  say "(auto-selected ${#PAGES[@]} pages from sitemap; pass paths explicitly to override)"
fi

# ---------- Site-wide checks ----------
checks_passed=0
checks_total=0
check() { # check <label> <pass:0|1> <detail>
  checks_total=$((checks_total + 1))
  if [ "$2" = "1" ]; then
    checks_passed=$((checks_passed + 1)); say "  PASS  $1  $3"
  else
    say "  FAIL  $1  $3"
  fi
}

say ""
say "Site-wide:"

robots=$(curl -s --max-time 15 "$HOST/robots.txt")
robots_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 15 "$HOST/robots.txt")
check "robots.txt reachable" "$([ "$robots_code" = 200 ] && echo 1 || echo 0)" "(HTTP $robots_code)"

n=$(echo "$robots" | grep -ci "^sitemap:")
check "robots.txt lists sitemap" "$([ "$n" -ge 1 ] && echo 1 || echo 0)" ""

# grep -o + wc -l, not grep -c: minified sitemaps put every <loc> on one line.
url_count=$(echo "$sitemap" | grep -o "<loc>" | wc -l | tr -d ' ')
check "sitemap.xml reachable" "$([ "$url_count" -ge 1 ] && echo 1 || echo 0)" "($url_count URLs)"

n=$(echo "$sitemap" | grep -c "localhost\|127\.0\.0\.1")
check "sitemap has no localhost URLs" "$([ "$n" = 0 ] && echo 1 || echo 0)" ""

# lastmod dates should not all be identical (a sign of a stale/hardcoded date).
# Only meaningful on a multi-page sitemap.
if [ "$url_count" -ge 2 ]; then
  lastmods=$(echo "$sitemap" | grep -o "<lastmod>[^<]*</lastmod>" | sort -u | wc -l | tr -d ' ')
  check "sitemap lastmod dates vary" "$([ "$lastmods" -ge 2 ] && echo 1 || echo 0)" \
    "($lastmods distinct values across $url_count URLs)"
fi

httphost="http://${HOST#https://}"
rc=$(curl -s -o /dev/null -w "%{http_code}" --max-time 15 "$httphost/")
check "http -> https redirect" "$([ "$rc" = 301 ] || [ "$rc" = 308 ] && echo 1 || echo 0)" "(HTTP $rc)"

nf=$(curl -s --max-time 15 "$HOST/this-page-should-not-exist-$RANDOM/")
n=$(echo "$nf" | grep -ci 'name="\?robots"\? content="\?noindex')
check "404 page is noindex" "$([ "$n" -ge 1 ] && echo 1 || echo 0)" ""

# ---------- Per-page checks ----------
for p in "${PAGES[@]}"; do
  html=$(curl -s --max-time 20 "$HOST$p")
  say ""
  say "Page: $p"

  title=$(echo "$html" | tr -d '\n' | grep -o "<title>[^<]*</title>" | head -1 | sed -e 's|<title>||' -e 's|</title>||')
  tlen=${#title}
  check "title 15-70 chars" "$([ "$tlen" -ge 15 ] && [ "$tlen" -le 70 ] && echo 1 || echo 0)" "(${tlen}: \"$title\")"

  desc=$(echo "$html" | tr -d '\n' | grep -o 'name="\?description"\? content="[^"]*"' | head -1 | sed -e 's|.*content="||' -e 's|"$||')
  dlen=${#desc}
  check "meta description 50-165 chars" "$([ "$dlen" -ge 50 ] && [ "$dlen" -le 165 ] && echo 1 || echo 0)" "($dlen chars)"

  n=$(echo "$html" | grep -c 'rel="\?canonical')
  check "canonical present" "$([ "$n" -ge 1 ] && echo 1 || echo 0)" ""

  n=$(echo "$html" | grep -o "<h1[ >]" | wc -l | tr -d ' ')
  check "exactly one h1" "$([ "$n" = 1 ] && echo 1 || echo 0)" "($n found)"

  # every ld+json block must parse
  res=$(echo "$html" | node -e '
    let s=""; process.stdin.on("data",d=>s+=d).on("end",()=>{
      const m = s.match(/<script[^>]*application\/ld\+json[^>]*>([\s\S]*?)<\/script>/g) || [];
      let ok = m.length > 0;
      for (const b of m) {
        try { JSON.parse(b.replace(/<script[^>]*>|<\/script>/g, "")); } catch { ok = false; }
      }
      console.log((ok?1:0) + " " + m.length);
    })' 2>/dev/null)
  ok="${res%% *}"; blocks="${res##* }"
  check "structured data valid" "${ok:-0}" "(${blocks:-0} JSON-LD blocks)"
done

# ---------- Lighthouse ----------
seo_scores=(); perf_scores=(); weights=()
if [ "$SKIP_LH" = 0 ]; then
  say ""
  say "Lighthouse (~30s per page):"
  for p in "${PAGES[@]}"; do
    slug=$(echo "$p" | sed -e 's|^/$|home|' -e 's|^/||' -e 's|/$||' -e 's|/|-|g')
    json="$OUT/lighthouse-${slug:-home}.json"
    # lighthouse@12 pinned: v13 needs Node 22+ and silently nulls the SEO score on older Node.
    npx --yes lighthouse@12 "$HOST$p" \
      --only-categories=seo,performance \
      --output=json --output-path="$json" \
      --chrome-flags="--headless --no-sandbox" --quiet >/dev/null 2>&1
    if [ -s "$json" ]; then
      seo=$(jq -r '(.categories.seo.score // 0) * 100 | round' "$json")
      perf=$(jq -r '(.categories.performance.score // 0) * 100 | round' "$json")
      kb=$(jq -r '((.audits["total-byte-weight"].numericValue // 0) / 1024) | round' "$json")
      seo_scores+=("$seo"); perf_scores+=("$perf"); weights+=("$kb")
      say "  $p  SEO: $seo  Performance: $perf  Weight: ${kb}KB"
    else
      say "  $p  Lighthouse FAILED to run"
    fi
  done
fi

avg() { [ -z "${1:-}" ] && echo "" || echo "$@" | tr ' ' '\n' | awk '{s+=$1} END {printf "%.0f", s/NR}'; }
avg_seo=$(avg "${seo_scores[@]:-}")
avg_perf=$(avg "${perf_scores[@]:-}")
avg_kb=$(avg "${weights[@]:-}")

say ""
say "======================================================"
say "Checks passed: $checks_passed/$checks_total"
if [ -n "$avg_seo" ]; then
  say "Avg Lighthouse SEO: $avg_seo   Avg Performance: $avg_perf   Avg page weight: ${avg_kb}KB"
  say "(Performance swings ~15 pts run-to-run. Page weight is the stable metric.)"
fi
say "Report: $REPORT"

[ -f "$HISTORY" ] || echo "date,checks_passed,checks_total,avg_lighthouse_seo,avg_lighthouse_perf,avg_page_weight_kb,gsc_avg_position,notes" > "$HISTORY"
echo "$STAMP,$checks_passed,$checks_total,$avg_seo,$avg_perf,$avg_kb,," >> "$HISTORY"

if [ "$(wc -l < "$HISTORY" | tr -d ' ')" -gt 2 ]; then
  say ""
  say "Previous: $(tail -2 "$HISTORY" | head -1)"
  say "Current:  $(tail -1 "$HISTORY")"
fi

say ""
say "Reminder: the real KPI is Search Console average position — add it to $HISTORY monthly."
