#!/usr/bin/env bash
# XML quality checks for PenText.
#   well-formed  - xmllint --noout per file
#   schema       - XSD validation of files declaring xsi:noNamespaceSchemaLocation
#   format       - zpretty --check on every *.xml file
# No arg or `all` runs all three; exit non-zero if any phase has failures.
#
# When GITHUB_OUTPUT is set (inside a GitHub Actions step), each phase
# writes `total=` and `failed=` to it so the workflow summary can report
# counts.
set -uo pipefail

phase="${1:-all}"

mapfile -t xml_files < <(
  find . -type f -name "*.xml" \
    -not -path "./target/*" \
    -not -path "./.git/*" \
    -not -path "./.github/*" \
    | sort
)

emit_summary() {
  local name="$1" total="$2" failed="$3"
  echo "SUMMARY phase=$name total=$total failed=$failed"
  if [[ -n "${GITHUB_OUTPUT:-}" ]]; then
    {
      echo "total=$total"
      echo "failed=$failed"
    } >> "$GITHUB_OUTPUT"
  fi
}

run_wellformed() {
  echo "::group::Well-formedness (${#xml_files[@]} files)"
  local failed=0
  for f in "${xml_files[@]}"; do
    if ! xmllint --noout "$f"; then
      failed=$((failed + 1))
    fi
  done
  echo "::endgroup::"
  emit_summary well-formed "${#xml_files[@]}" "$failed"
  [[ $failed -eq 0 ]]
}

run_schema() {
  echo "::group::XSD schema validation"
  local fails=0 checked=0
  local dtd_dir
  dtd_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/dtd"
  for f in "${xml_files[@]}"; do
    local xsd_rel xsd_name xsd_abs
    xsd_rel=$(grep -m1 -oE 'xsi:noNamespaceSchemaLocation="[^"]+"' "$f" \
              | sed -E 's/.*="([^"]+)"/\1/' || true)
    [[ -z "$xsd_rel" ]] && continue
    xsd_name="$(basename "$xsd_rel")"
    xsd_abs="$dtd_dir/$xsd_name"
    if [[ ! -f "$xsd_abs" ]]; then
      echo "WARN: schema not found in dtd/ for $f -> $xsd_name" >&2
      fails=$((fails + 1))
      continue
    fi
    checked=$((checked + 1))
    echo "-> $f  (schema: $xsd_name)"
    if ! xmllint --noout --xinclude --schema "$xsd_abs" "$f"; then
      fails=$((fails + 1))
    fi
  done
  echo "::endgroup::"
  emit_summary schema "$checked" "$fails"
  [[ $fails -eq 0 ]]
}

run_format() {
  echo "::group::zpretty formatting (${#xml_files[@]} files)"
  local out
  out=$(zpretty --check --max-line-length 120 --first-attribute-on-new-line "${xml_files[@]}" 2>&1 || true)
  echo "$out"
  local failed
  failed=$(printf '%s\n' "$out" | grep -c "^This file would be rewritten:" || true)
  echo "::endgroup::"
  emit_summary format "${#xml_files[@]}" "$failed"
  [[ $failed -eq 0 ]]
}

case "$phase" in
  well-formed) run_wellformed ;;
  schema)      run_schema ;;
  format)      run_format ;;
  all)
    rc=0
    run_wellformed || rc=1
    run_schema     || rc=1
    run_format     || rc=1
    exit $rc
    ;;
  *) echo "usage: $0 {well-formed|schema|format|all}" >&2; exit 2 ;;
esac
