#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
manuscript_path="$script_dir/MANUSCRIPT.md"
cover_path="$script_dir/front-cover.png"
output_path="$script_dir/Endless Darkness.epub"

require_command() {
	if ! command -v "$1" >/dev/null 2>&1; then
		printf 'Missing required command: %s\n' "$1" >&2
		exit 1
	fi
}

require_file() {
	if [[ ! -f "$1" ]]; then
		printf 'Required file not found: %s\n' "$1" >&2
		exit 1
	fi
}

require_command pandoc
require_file "$script_dir/rebuild-manuscript.sh"
require_file "$cover_path"

(
	cd "$script_dir"
	./rebuild-manuscript.sh
)
require_file "$manuscript_path"

pandoc "$manuscript_path" \
	--from gfm \
	--to epub3 \
	--toc \
	--toc-depth=2 \
	--split-level=2 \
	--metadata title="Endless Darkness" \
	--metadata author="Joshua Szepietowski" \
	--metadata lang="en-US" \
	--resource-path="$script_dir" \
	--epub-cover-image="$cover_path" \
	--output "$output_path"

printf 'Created %s\n' "$output_path"
