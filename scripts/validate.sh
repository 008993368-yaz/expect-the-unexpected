#!/usr/bin/env bash
# validate.sh — lint the expect-the-unexpected skill package (no external deps)
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
errors=0

fail() {
  echo "validate: $*" >&2
  errors=$((errors + 1))
}

echo "validate: checking package layout under $ROOT"

# Required paths (README layout + skill contract)
required=(
  SKILL.md
  README.md
  CHANGELOG.md
  references/failure-taxonomy.md
  references/scenario-generation.md
  references/execution-mode.md
  examples/README.md
  examples/webhook-double-delivery/input.md
  examples/webhook-double-delivery/output.md
  examples/checkout-diff-stage0/input.md
  examples/checkout-diff-stage0/output.md
  evals/benchmark.json
  evals/README.md
  extensions/pre-deploy-gate/README.md
  extensions/pre-deploy-gate/scripts/pre-deploy-gate.sh
)

for path in "${required[@]}"; do
  if [[ ! -e "$path" ]]; then
    fail "missing required path: $path"
  fi
done

# SKILL.md frontmatter: name + description (+ version)
if ! head -n 1 SKILL.md | tr -d '\r' | grep -q '^---$'; then
  fail "SKILL.md missing opening --- frontmatter"
else
  fm="$(awk 'NR==1{next} /^---\r?$/{exit} {gsub(/\r$/,""); print}' SKILL.md)"
  echo "$fm" | grep -q '^name:' || fail "SKILL.md frontmatter missing name:"
  echo "$fm" | grep -q '^description:' || fail "SKILL.md frontmatter missing description:"
  echo "$fm" | grep -q '^version:' || fail "SKILL.md frontmatter missing version:"
fi

# references/*.md links from SKILL.md
while IFS= read -r ref || [[ -n "${ref:-}" ]]; do
  [[ -z "${ref:-}" ]] && continue
  ref="${ref#references/}"
  ref="${ref%%#*}"
  if [[ ! -f "references/$ref" ]]; then
    fail "SKILL.md links to missing reference: references/$ref"
  fi
done < <(grep -oE 'references/[a-zA-Z0-9_.-]+\.md' SKILL.md | sort -u || true)

# Internal markdown links (relative paths only)
check_md_links() {
  local file="$1"
  local dir link target
  local -a _links=()
  dir="$(dirname "$file")"
  mapfile -t _links < <(grep -oE '\]\([^)]+\)' "$file" 2>/dev/null | sed 's/^](//;s/)$//' || true)
  for link in "${_links[@]}"; do
    [[ "$link" =~ ^https?:// ]] && continue
    [[ "$link" =~ ^# ]] && continue
    target="${link%%#*}"
    if [[ ! -e "$dir/$target" && ! -e "$target" ]]; then
      echo "validate: $file: broken link → $link" >&2
      echo 1 > "$ROOT/.validate_link_err"
    fi
  done
}

rm -f "$ROOT/.validate_link_err"
for md in SKILL.md README.md references/*.md examples/README.md evals/README.md extensions/pre-deploy-gate/README.md; do
  [[ -f "$md" ]] && check_md_links "$md"
done
if [[ -f "$ROOT/.validate_link_err" ]]; then
  rm -f "$ROOT/.validate_link_err"
  fail "one or more broken markdown links (see above)"
fi

# evals/benchmark.json minimal schema
if command -v python3 >/dev/null 2>&1; then
  python3 - <<'PY' || fail "evals/benchmark.json invalid or missing benchmarks"
import json, sys
from pathlib import Path
p = Path("evals/benchmark.json")
data = json.loads(p.read_text(encoding="utf-8"))
assert data.get("skill") == "expect-the-unexpected"
assert isinstance(data.get("benchmarks"), list) and len(data["benchmarks"]) >= 1
for b in data["benchmarks"]:
    assert b.get("id") and b.get("prompt")
    assert "with_skill" in b and "expected_behaviors" in b["with_skill"]
PY
elif command -v python >/dev/null 2>&1; then
  python - <<'PY' || fail "evals/benchmark.json invalid or missing benchmarks"
import json, sys
from pathlib import Path
p = Path("evals/benchmark.json")
data = json.loads(p.read_text(encoding="utf-8"))
assert data.get("skill") == "expect-the-unexpected"
assert isinstance(data.get("benchmarks"), list) and len(data["benchmarks"]) >= 1
for b in data["benchmarks"]:
    assert b.get("id") and b.get("prompt")
    assert "with_skill" in b and "expected_behaviors" in b["with_skill"]
PY
else
  echo "validate: skip JSON schema check (python not found)"
fi

# README install paths: skill folder must contain SKILL.md at root (documented)
grep -q 'SKILL.md' README.md || fail "README.md should document SKILL.md at skill root"

# pre-deploy-gate fail-open trap present
grep -q 'fail.open\|fail_open\|allowing deploy' extensions/pre-deploy-gate/scripts/pre-deploy-gate.sh \
  || fail "pre-deploy-gate.sh should fail-open on errors"

if [[ "$errors" -gt 0 ]]; then
  echo "validate: FAILED with $errors error(s)" >&2
  exit 1
fi

echo "validate: OK"
