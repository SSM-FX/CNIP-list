#!/usr/bin/env bash
set -euo pipefail

readarray -t IPV4_SOURCES <<< "$IPV4_SOURCES"
readarray -t IPV6_SOURCES <<< "$IPV6_SOURCES"

IPV4_SOURCES=($(printf '%s\n' "${IPV4_SOURCES[@]}" | grep -v '^\s*$'))
IPV6_SOURCES=($(printf '%s\n' "${IPV6_SOURCES[@]}" | grep -v '^\s*$'))

OUTPUT_DIR="${OUTPUT_DIR:-./output}"
IPV4_OUTPUT="cn_ipv4.txt"
IPV6_OUTPUT="cn_ipv6.txt"
MERGED_OUTPUT="cn.txt"
TMP_DIR=$(mktemp -d)

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

download_file() {
    curl -fsSL --connect-timeout 10 --max-time 60 -o "$2" "$1" 2>/dev/null
}

merge_sources() {
    local -n sources=$1
    local output=$2
    local success_count=0
    local merged_file="$TMP_DIR/$$_merged.txt"
    : > "$merged_file"

    local idx=0
    for url in "${sources[@]}"; do
        local tmp_file="$TMP_DIR/$$_${idx}.txt"
        if download_file "$url" "$tmp_file"; then
            grep -v '^\s*$' "$tmp_file" | grep -v '^\s*#' >> "$merged_file"
            success_count=$((success_count + 1))
        fi
        idx=$((idx + 1))
    done

    [[ $success_count -eq 0 ]] && return 1

    if [[ "$output" == "$IPV4_OUTPUT" ]]; then
        sort -u -V "$merged_file" > "$OUTPUT_DIR/$output"
    else
        sort -u "$merged_file" > "$OUTPUT_DIR/$output"
    fi
}

main() {
    mkdir -p "$OUTPUT_DIR"
    merge_sources IPV4_SOURCES "$IPV4_OUTPUT" || true
    merge_sources IPV6_SOURCES "$IPV6_OUTPUT" || true
    if [[ -f "$OUTPUT_DIR/$IPV4_OUTPUT" || -f "$OUTPUT_DIR/$IPV6_OUTPUT" ]]; then
        cat "$OUTPUT_DIR/$IPV4_OUTPUT" "$OUTPUT_DIR/$IPV6_OUTPUT" 2>/dev/null \
            | grep -v '^\s*$' > "$OUTPUT_DIR/$MERGED_OUTPUT"
    fi
}

main "$@"
