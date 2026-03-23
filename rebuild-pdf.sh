#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
manuscript_path="$script_dir/MANUSCRIPT.md"
cover_path="$script_dir/front-cover.png"
back_cover_path="$script_dir/back-cover.png"
output_path="$script_dir/Endless Darkness.pdf"

if ! command -v pandoc >/dev/null 2>&1; then
	echo "pandoc is required but not installed." >&2
	exit 1
fi

if ! command -v pdflatex >/dev/null 2>&1; then
	echo "pdflatex is required but not installed." >&2
	exit 1
fi

if [[ ! -f "$cover_path" ]]; then
	echo "Missing cover image: $cover_path" >&2
	exit 1
fi

if [[ ! -f "$back_cover_path" ]]; then
	echo "Missing back cover image: $back_cover_path" >&2
	exit 1
fi

"$script_dir/rebuild-manuscript.sh"

if [[ ! -f "$manuscript_path" ]]; then
	echo "Missing manuscript file after rebuild: $manuscript_path" >&2
	exit 1
fi

tmp_dir="$(mktemp -d)"
header_path="$tmp_dir/header.tex"
cover_tex_path="$tmp_dir/cover.tex"
back_cover_tex_path="$tmp_dir/back-cover.tex"
chapter_filter_path="$tmp_dir/chapter-headings.lua"
latex_bs='\'

cleanup() {
	rm -rf "$tmp_dir"
}

trap cleanup EXIT

cat <<EOF > "$header_path"
\usepackage[T1]{fontenc}
\usepackage[utf8]{inputenc}
\usepackage{graphicx}
\usepackage{microtype}
\usepackage[sc]{mathpazo}
\usepackage{textgreek}
\usepackage{newunicodechar}
\newunicodechar{σ}{\textsigma}
\newunicodechar{ }{\hspace*{0.5em}}
\linespread{1.05}
\usepackage{setspace}
\setstretch{1.08}
\usepackage{fancyhdr}
\usepackage{titlesec}
\usepackage{emptypage}
\raggedbottom
\setlength{\parindent}{1.2em}
\setlength{\parskip}{0pt}
\clubpenalty=10000
\widowpenalty=10000
\displaywidowpenalty=10000

${latex_bs}titleformat{\chapter}[display]
	{\normalfont\huge\bfseries}
	{\Large\MakeUppercase{Chapter \thechapter}}
	{0.75em}
	{}

${latex_bs}titlespacing*{\chapter}{0pt}{0pt}{2.5em}

\pagestyle{fancy}
\fancyhf{}
\fancyhead[R]{\nouppercase{\leftmark}}
\fancyfoot[C]{\thepage}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0pt}
\setlength{\headheight}{14pt}
EOF

cat <<EOF > "$cover_tex_path"
\newgeometry{margin=0in}
\begin{titlepage}
${latex_bs}thispagestyle{empty}
\noindent\includegraphics[width=\paperwidth,height=\paperheight]{$cover_path}
\end{titlepage}
\restoregeometry
\setcounter{page}{1}
EOF

cat <<EOF > "$back_cover_tex_path"
\clearpage
\newgeometry{margin=0in}
${latex_bs}thispagestyle{empty}
\noindent\includegraphics[width=\paperwidth,height=\paperheight]{$back_cover_path}
\clearpage
\restoregeometry
EOF

cat <<'EOF' > "$chapter_filter_path"
function Header(el)
	if el.level ~= 1 then
		return nil
	end

	local text = pandoc.utils.stringify(el.content)
	local stripped = text:match("^Chapter%s+%d+:%s*(.+)$")
	if not stripped then
		return nil
	end

	return pandoc.Header(1, stripped, el.attr)
end
EOF

pandoc "$manuscript_path" \
	--standalone \
	--from=gfm \
	--pdf-engine=pdflatex \
	--lua-filter="$chapter_filter_path" \
	--include-in-header="$header_path" \
	--include-before-body="$cover_tex_path" \
	--include-after-body="$back_cover_tex_path" \
	--top-level-division=chapter \
	--variable=documentclass:book \
	--variable=classoption:oneside \
	--variable=classoption:openany \
	--variable=fontsize:11pt \
	--variable=linestretch:1.08 \
	--variable=geometry:paperwidth=6in \
	--variable=geometry:paperheight=9in \
	--variable=geometry:top=0.85in \
	--variable=geometry:bottom=0.85in \
	--variable=geometry:inner=0.8in \
	--variable=geometry:outer=0.7in \
	--variable=colorlinks:false \
	--output "$output_path"

echo "Created $output_path"
