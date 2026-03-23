#!/usr/bin/env bash

set -euo pipefail

# Build a self-contained static launch page for the novel.
# The generated website contains only:
# - website/index.html
# - website/cover.png
# - website/back-cover.png
# - website/Endless Darkness.pdf

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
website_dir="$script_dir/website"
chapter_path="$script_dir/chapters/chapter-01-the-ones-in-the-dark.md"
cover_source_path="$script_dir/front-cover.png"
cover_output_path="$website_dir/cover.png"
back_cover_source_path="$script_dir/back-cover.png"
back_cover_output_path="$website_dir/back-cover.png"
pdf_source_path="$script_dir/Endless Darkness.pdf"
pdf_output_path="$website_dir/Endless Darkness.pdf"
index_path="$website_dir/index.html"

if [[ ! -f "$chapter_path" ]]; then
	echo "Missing chapter source: $chapter_path" >&2
	exit 1
fi

if [[ ! -f "$cover_source_path" ]]; then
	echo "Missing cover image: $cover_source_path" >&2
	exit 1
fi

if [[ ! -f "$back_cover_source_path" ]]; then
  echo "Missing back cover image: $back_cover_source_path" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
	echo "python3 is required but not installed." >&2
	exit 1
fi

bash "$script_dir/rebuild-pdf.sh"

if [[ ! -f "$pdf_source_path" ]]; then
	echo "Missing PDF after rebuild: $pdf_source_path" >&2
	exit 1
fi

rm -rf "$website_dir"
mkdir -p "$website_dir"

cp "$cover_source_path" "$cover_output_path"
cp "$back_cover_source_path" "$back_cover_output_path"
cp "$pdf_source_path" "$pdf_output_path"

CHAPTER_PATH="$chapter_path" INDEX_PATH="$index_path" python3 <<'PY'
from __future__ import annotations

import html
import os
import re
from pathlib import Path


def render_inline(text: str) -> str:
    escaped = html.escape(text, quote=False)
    escaped = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", escaped)
    escaped = re.sub(r"\*(.+?)\*", r"<em>\1</em>", escaped)
    return escaped


def render_markdown(markdown_text: str) -> str:
    lines = markdown_text.splitlines()
    blocks: list[str] = []
    paragraph_lines: list[str] = []

    def flush_paragraph() -> None:
        if not paragraph_lines:
            return
        text = " ".join(line.strip() for line in paragraph_lines)
        blocks.append(f"<p>{render_inline(text)}</p>")
        paragraph_lines.clear()

    for raw_line in lines:
        line = raw_line.rstrip()
        stripped = line.strip()

        if not stripped:
            flush_paragraph()
            continue

        if stripped in {"---", "***"}:
            flush_paragraph()
            blocks.append("<hr>")
            continue

        heading_match = re.match(r"^(#{1,3})\s+(.*)$", stripped)
        if heading_match:
            flush_paragraph()
            level = len(heading_match.group(1))
            content = render_inline(heading_match.group(2).strip())
            blocks.append(f"<h{level}>{content}</h{level}>")
            continue

        paragraph_lines.append(stripped)

    flush_paragraph()
    return "\n".join(blocks)


chapter_path = Path(os.environ["CHAPTER_PATH"])
index_path = Path(os.environ["INDEX_PATH"])
chapter_source = chapter_path.read_text(encoding="utf-8")
chapter_html = render_markdown(chapter_source)

page_title = "Endless Darkness"
author_name = "Joshua Szepietowski"
hero_kicker = "A literary science fiction novel of inheritance, vigilance, and fragile human tenderness inside a ship that has mistaken endurance for peace."
positioning_copy = (
    "Inside a generation ship halfway through an impossible mission, Jonah Hale grows up under false dawns, quiet faith, system scrutiny, "
    "and the inherited fear that the mind can turn against its own home. Endless Darkness is intimate, austere science fiction about steel, obedience, family, and the pressure of staying whole while the machine keeps watching."
)
atmosphere_copy = (
    "The ship is all structure: seams, maintenance bands, sensor logs, ritual language, managed light. The people inside it are not. "
    "They love, endure, conceal, pray, monitor one another, and try to keep from becoming the point where anything breaks."
)
download_copy = (
    "The complete novel is available here as a free PDF. Read the opening below, or step directly into the full manuscript."
)
closing_copy = (
  "What waits outside the hull is indifferent. What remains inside it is obligation, memory, prayer, and the fragile work of not letting one another disappear."
)

html_output = f"""<!DOCTYPE html>
<html lang=\"en\">
<head>
  <meta charset=\"utf-8\">
  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
  <title>{page_title}</title>
  <meta name=\"description\" content=\"A literary science fiction novel by {author_name}, set aboard a generation ship where inherited pressure, faith, surveillance, and tenderness coexist in the dark.\">
  <style>
    :root {{
      --bg: #07090c;
      --bg-elevated: rgba(17, 22, 28, 0.86);
      --bg-panel: rgba(10, 14, 18, 0.84);
      --line: rgba(175, 188, 201, 0.18);
      --line-strong: rgba(201, 182, 133, 0.35);
      --text: #e8e2d6;
      --muted: #a9b0b5;
      --muted-strong: #c5c8c9;
      --accent: #b9a274;
      --accent-cool: #7b94a6;
      --shadow: rgba(0, 0, 0, 0.45);
      --reading-width: 42rem;
      --content-width: 76rem;
      --hero-width: 82rem;
      --body-font: Georgia, 'Times New Roman', serif;
      --display-font: 'Palatino Linotype', 'Book Antiqua', Palatino, Georgia, serif;
      --ui-font: 'Helvetica Neue', Helvetica, Arial, sans-serif;
    }}

    * {{ box-sizing: border-box; }}

    html {{
      scroll-behavior: smooth;
      background:
        radial-gradient(circle at top, rgba(94, 112, 130, 0.12), transparent 32%),
        linear-gradient(180deg, #0a0d10 0%, #050608 42%, #08090c 100%);
      background-color: var(--bg);
    }}

    body {{
      margin: 0;
      color: var(--text);
      font-family: var(--body-font);
      line-height: 1.7;
      background:
        linear-gradient(180deg, rgba(8, 10, 13, 0.88), rgba(5, 7, 9, 0.96)),
        repeating-linear-gradient(180deg, transparent 0, transparent 3px, rgba(255, 255, 255, 0.012) 3px, rgba(255, 255, 255, 0.012) 4px),
        radial-gradient(circle at 20% 10%, rgba(120, 138, 156, 0.08), transparent 25%),
        radial-gradient(circle at 80% 0%, rgba(185, 162, 116, 0.06), transparent 22%),
        var(--bg);
      min-height: 100vh;
      letter-spacing: 0.01em;
    }}

    body::before {{
      content: \"\";
      position: fixed;
      inset: 0;
      pointer-events: none;
      background:
        linear-gradient(90deg, transparent 0%, rgba(255, 255, 255, 0.02) 48%, transparent 100%),
        radial-gradient(circle at 50% -10%, rgba(255, 255, 255, 0.06), transparent 35%);
      opacity: 0.38;
      mix-blend-mode: screen;
    }}

    a {{
      color: inherit;
      text-decoration: none;
    }}

    img {{
      max-width: 100%;
      display: block;
    }}

    .shell {{
      position: relative;
      overflow: hidden;
      isolation: isolate;
    }}

    .shell::before,
    .shell::after {{
      content: \"\";
      position: absolute;
      inset: 0;
      pointer-events: none;
      z-index: 0;
    }}

    .shell > * {{
      position: relative;
      z-index: 1;
    }}

    .shell::before {{
      background:
        linear-gradient(90deg, transparent 0%, rgba(185, 162, 116, 0.05) 48%, transparent 100%),
        linear-gradient(180deg, rgba(255, 255, 255, 0.03), transparent 12%, transparent 88%, rgba(255, 255, 255, 0.02));
      opacity: 0.4;
    }}

    .shell::after {{
      background-image:
        linear-gradient(rgba(169, 176, 181, 0.06) 1px, transparent 1px),
        linear-gradient(90deg, rgba(169, 176, 181, 0.04) 1px, transparent 1px);
      background-size: 100% 9rem, 9rem 100%;
      mask-image: linear-gradient(180deg, rgba(0, 0, 0, 0.8), transparent 90%);
      opacity: 0.12;
    }}

    .topbar {{
      position: sticky;
      top: 0;
      z-index: 20;
      backdrop-filter: blur(18px);
      background: rgba(6, 8, 10, 0.72);
      border-bottom: 1px solid var(--line);
    }}

    .topbar-inner {{
      width: min(calc(100% - 2rem), var(--content-width));
      margin: 0 auto;
      padding: 0.85rem 0;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 1rem;
    }}

    .wordmark {{
      font-family: var(--display-font);
      font-size: 0.92rem;
      letter-spacing: 0.28em;
      text-transform: uppercase;
      color: var(--muted-strong);
      white-space: nowrap;
    }}

    .nav {{
      display: flex;
      align-items: center;
      gap: 1rem;
      font-family: var(--ui-font);
      font-size: 0.78rem;
      letter-spacing: 0.16em;
      text-transform: uppercase;
      color: var(--muted);
    }}

    .nav a {{
      padding: 0.35rem 0;
      position: relative;
    }}

    .nav a::after {{
      content: \"\";
      position: absolute;
      left: 0;
      bottom: 0;
      width: 100%;
      height: 1px;
      background: linear-gradient(90deg, transparent, var(--accent), transparent);
      opacity: 0;
      transform: scaleX(0.65);
      transition: opacity 220ms ease, transform 220ms ease;
    }}

    .nav a:hover::after,
    .nav a:focus-visible::after {{
      opacity: 1;
      transform: scaleX(1);
    }}

    main {{
      width: 100%;
    }}

    section {{
      position: relative;
    }}

    .hero {{
      width: min(calc(100% - 2rem), var(--hero-width));
      margin: 0 auto;
      padding: 5rem 0 3rem;
      display: grid;
      grid-template-columns: minmax(0, 1.2fr) minmax(18rem, 0.82fr);
      gap: 3.5rem;
      align-items: center;
    }}

    .eyebrow {{
      margin: 0 0 1rem;
      color: var(--accent);
      font-family: var(--ui-font);
      font-size: 0.74rem;
      letter-spacing: 0.28em;
      text-transform: uppercase;
    }}

    h1 {{
      margin: 0;
      font-family: var(--display-font);
      font-size: clamp(3.2rem, 9vw, 6.3rem);
      line-height: 0.92;
      letter-spacing: 0.03em;
      text-transform: uppercase;
      text-wrap: balance;
      max-width: 12ch;
    }}

    .author {{
      margin: 1.1rem 0 0;
      color: var(--muted-strong);
      font-size: 1rem;
      letter-spacing: 0.16em;
      text-transform: uppercase;
      font-family: var(--ui-font);
    }}

    .hero-line {{
      margin: 1.8rem 0 0;
      max-width: 38rem;
      font-size: clamp(1.1rem, 2vw, 1.35rem);
      color: var(--text);
      text-wrap: balance;
    }}

    .hero-copy {{
      margin: 1.5rem 0 0;
      max-width: 38rem;
      color: var(--muted);
      font-size: 1rem;
    }}

    .hero-meta {{
      margin: 2rem 0 0;
      display: flex;
      flex-wrap: wrap;
      gap: 0.85rem;
      color: var(--muted);
      font-family: var(--ui-font);
      font-size: 0.74rem;
      letter-spacing: 0.14em;
      text-transform: uppercase;
    }}

    .hero-meta span {{
      padding: 0.55rem 0.75rem;
      border: 1px solid var(--line);
      background: rgba(255, 255, 255, 0.02);
    }}

    .cta-row {{
      margin: 2.2rem 0 0;
      display: flex;
      flex-wrap: wrap;
      gap: 0.9rem;
      align-items: center;
    }}

    .button,
    .ghost-button {{
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-height: 3.2rem;
      padding: 0.85rem 1.25rem;
      border: 1px solid transparent;
      font-family: var(--ui-font);
      font-size: 0.78rem;
      letter-spacing: 0.18em;
      text-transform: uppercase;
      transition: transform 220ms ease, border-color 220ms ease, background 220ms ease, box-shadow 220ms ease;
    }}

    .button {{
      color: #0a0d10;
      background: linear-gradient(180deg, #d2c3a0, #ae9365);
      box-shadow: 0 0.9rem 2.5rem rgba(0, 0, 0, 0.35);
    }}

    .ghost-button {{
      color: var(--muted-strong);
      border-color: var(--line);
      background: rgba(255, 255, 255, 0.03);
    }}

    .button:hover,
    .button:focus-visible,
    .ghost-button:hover,
    .ghost-button:focus-visible {{
      transform: translateY(-1px);
    }}

    .button:hover,
    .button:focus-visible {{
      box-shadow: 0 1.2rem 2.8rem rgba(0, 0, 0, 0.42);
    }}

    .ghost-button:hover,
    .ghost-button:focus-visible {{
      border-color: var(--line-strong);
      background: rgba(255, 255, 255, 0.05);
    }}

    .hero-visual {{
      justify-self: end;
      width: min(100%, 25rem);
      padding: 1rem;
      border: 1px solid var(--line);
      background:
        linear-gradient(180deg, rgba(22, 28, 34, 0.72), rgba(11, 14, 19, 0.96)),
        var(--bg-panel);
      box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.04),
        0 2rem 5rem rgba(0, 0, 0, 0.45);
      position: relative;
    }}

    .hero-visual::before {{
      content: \"Structural observation / stable for now\";
      position: absolute;
      top: -0.7rem;
      left: 1rem;
      padding: 0.18rem 0.5rem;
      background: #0b0f14;
      border: 1px solid var(--line);
      color: var(--muted);
      font-family: var(--ui-font);
      font-size: 0.63rem;
      letter-spacing: 0.14em;
      text-transform: uppercase;
    }}

    .cover-frame {{
      border: 1px solid rgba(255, 255, 255, 0.08);
      background: linear-gradient(180deg, rgba(6, 8, 10, 0.22), rgba(255, 255, 255, 0.02));
      padding: 0.8rem;
    }}

    .cover-frame img {{
      width: 100%;
      height: auto;
      box-shadow: 0 1.2rem 3.2rem rgba(0, 0, 0, 0.48);
    }}

    .visual-caption {{
      margin: 0.9rem 0 0;
      padding-top: 0.8rem;
      border-top: 1px solid rgba(255, 255, 255, 0.08);
      color: var(--muted);
      font-family: var(--ui-font);
      font-size: 0.7rem;
      letter-spacing: 0.16em;
      text-transform: uppercase;
      display: flex;
      justify-content: space-between;
      gap: 1rem;
    }}

    .section-block {{
      width: min(calc(100% - 2rem), var(--content-width));
      margin: 0 auto;
      padding: 2rem 0 0;
    }}

    .panel {{
      padding: clamp(1.5rem, 3vw, 2.4rem);
      border: 1px solid var(--line);
      background:
        linear-gradient(180deg, rgba(16, 20, 24, 0.88), rgba(7, 9, 12, 0.92)),
        var(--bg-elevated);
      box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.03);
    }}

    .section-heading {{
      margin: 0;
      font-family: var(--display-font);
      font-size: clamp(1.9rem, 4vw, 2.8rem);
      line-height: 1.05;
      letter-spacing: 0.03em;
      text-transform: uppercase;
    }}

    .section-label {{
      margin: 0 0 0.8rem;
      color: var(--accent-cool);
      font-family: var(--ui-font);
      font-size: 0.72rem;
      letter-spacing: 0.24em;
      text-transform: uppercase;
    }}

    .positioning-grid {{
      display: grid;
      grid-template-columns: minmax(0, 1.1fr) minmax(16rem, 0.75fr);
      gap: 2rem;
      align-items: start;
    }}

    .positioning-copy p,
    .download-copy p {{
      margin: 0;
      color: var(--muted-strong);
      font-size: 1.06rem;
    }}

    .signal-list {{
      margin: 0;
      padding: 0;
      list-style: none;
      display: grid;
      gap: 0.75rem;
      color: var(--muted);
      font-family: var(--ui-font);
      font-size: 0.78rem;
      letter-spacing: 0.12em;
      text-transform: uppercase;
    }}

    .signal-list li {{
      padding: 0.8rem 0.9rem;
      border: 1px solid rgba(255, 255, 255, 0.07);
      background: rgba(255, 255, 255, 0.025);
    }}

    .reading-section {{
      width: min(calc(100% - 2rem), calc(var(--reading-width) + 10rem));
      margin: 0 auto;
      padding: 4.5rem 0 0;
    }}

    .reading-intro {{
      max-width: var(--reading-width);
      margin: 0 auto 2rem;
      padding: 0 0.25rem;
    }}

    .reading-intro p {{
      margin: 1rem 0 0;
      color: var(--muted);
      font-size: 1rem;
    }}

    .chapter-panel {{
      position: relative;
      z-index: 2;
      border: 1px solid var(--line);
      background:
        linear-gradient(180deg, rgba(14, 17, 21, 0.95), rgba(7, 9, 12, 0.98)),
        #090b0f;
      box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.035),
        0 1.8rem 4rem rgba(0, 0, 0, 0.34);
      overflow: hidden;
    }}

    .chapter-panel::before {{
      content: \"Chapter access / close-reading mode\";
      display: block;
      padding: 0.9rem 1.3rem;
      border-bottom: 1px solid var(--line);
      color: var(--muted);
      font-family: var(--ui-font);
      font-size: 0.68rem;
      letter-spacing: 0.18em;
      text-transform: uppercase;
      background: rgba(255, 255, 255, 0.025);
    }}

    .chapter-content {{
      max-width: var(--reading-width);
      margin: 0 auto;
      position: relative;
      z-index: 3;
      padding: clamp(1.6rem, 4vw, 3.2rem) clamp(1.1rem, 4vw, 2.4rem) clamp(2.4rem, 5vw, 3.6rem);
      font-size: clamp(1.03rem, 1.8vw, 1.14rem);
      line-height: 1.9;
      color: #eee7db;
    }}

    .chapter-content h1,
    .chapter-content h2,
    .chapter-content h3 {{
      max-width: none;
      margin-left: 0;
      margin-right: 0;
      text-transform: none;
      letter-spacing: 0.01em;
      line-height: 1.1;
      text-wrap: pretty;
    }}

    .chapter-content h1 {{
      margin-top: 0;
      margin-bottom: 1.5rem;
      font-size: clamp(2rem, 4vw, 2.85rem);
      font-family: var(--display-font);
    }}

    .chapter-content h2 {{
      margin-top: 2.4rem;
      margin-bottom: 1rem;
      font-size: clamp(1.4rem, 3vw, 1.9rem);
      font-family: var(--display-font);
      color: var(--text);
    }}

    .chapter-content h3 {{
      margin-top: 1.9rem;
      margin-bottom: 0.8rem;
      font-size: 1.2rem;
      font-family: var(--display-font);
      color: var(--muted-strong);
    }}

    .chapter-content p {{
      margin: 0 0 1.3rem;
      text-wrap: pretty;
    }}

    .chapter-content hr {{
      border: 0;
      height: 1px;
      margin: 2.4rem auto;
      width: 5rem;
      background: linear-gradient(90deg, transparent, rgba(185, 162, 116, 0.7), transparent);
    }}

    .chapter-content em {{
      color: #f2ece0;
    }}

    .download-section {{
      width: min(calc(100% - 2rem), 62rem);
      margin: 0 auto;
      padding: 4.5rem 0 5.5rem;
    }}

    .download-panel {{
      display: grid;
      grid-template-columns: minmax(0, 1fr) auto;
      gap: 1.5rem;
      align-items: center;
    }}

    .download-actions {{
      display: flex;
      flex-wrap: wrap;
      gap: 0.85rem;
      align-items: center;
      justify-content: flex-end;
    }}

    .closing-visual-section {{
      width: min(calc(100% - 2rem), var(--content-width));
      margin: 0 auto;
      padding: 0 0 3.5rem;
    }}

    .closing-visual-panel {{
      position: relative;
      overflow: hidden;
      border: 1px solid var(--line);
      background:
        linear-gradient(180deg, rgba(13, 17, 22, 0.92), rgba(7, 9, 12, 0.98)),
        var(--bg-panel);
      box-shadow:
        inset 0 1px 0 rgba(255, 255, 255, 0.03),
        0 2rem 4.8rem rgba(0, 0, 0, 0.35);
    }}

    .closing-visual-copy {{
      position: absolute;
      inset: auto auto 0 0;
      width: min(100%, 34rem);
      padding: clamp(1.25rem, 3vw, 2rem);
      background: linear-gradient(180deg, rgba(7, 9, 12, 0.18), rgba(7, 9, 12, 0.88));
      border-top: 1px solid rgba(255, 255, 255, 0.08);
      border-right: 1px solid rgba(255, 255, 255, 0.08);
      backdrop-filter: blur(8px);
    }}

    .closing-visual-copy p {{
      margin: 0.9rem 0 0;
      color: var(--muted-strong);
      font-size: 1rem;
      max-width: 30rem;
    }}

    .closing-visual-image {{
      width: 100%;
      height: auto;
      display: block;
      filter: saturate(0.9) contrast(1.02) brightness(0.9);
    }}

    footer {{
      width: min(calc(100% - 2rem), var(--content-width));
      margin: 0 auto;
      padding: 0 0 2rem;
      color: var(--muted);
      font-family: var(--ui-font);
      font-size: 0.72rem;
      letter-spacing: 0.14em;
      text-transform: uppercase;
      display: flex;
      justify-content: space-between;
      gap: 1rem;
      border-top: 1px solid rgba(255, 255, 255, 0.06);
      padding-top: 1.1rem;
    }}

    @media (max-width: 58rem) {{
      .hero,
      .positioning-grid,
      .download-panel {{
        grid-template-columns: 1fr;
      }}

      .hero {{
        padding-top: 3.8rem;
      }}

      .hero-visual {{
        justify-self: start;
        width: min(100%, 22rem);
      }}

      .download-actions {{
        justify-content: flex-start;
      }}

      .closing-visual-copy {{
        position: static;
        width: 100%;
        border-right: 0;
      }}

      footer {{
        flex-direction: column;
      }}
    }}

    @media (max-width: 40rem) {{
      .topbar-inner {{
        align-items: flex-start;
        flex-direction: column;
      }}

      .nav {{
        flex-wrap: wrap;
        gap: 0.7rem 1rem;
      }}

      .hero {{
        gap: 2.2rem;
      }}

      h1 {{
        font-size: clamp(2.7rem, 16vw, 4.2rem);
      }}

      .cta-row {{
        flex-direction: column;
        align-items: stretch;
      }}

      .button,
      .ghost-button {{
        width: 100%;
      }}

      .hero-meta {{
        gap: 0.55rem;
      }}

      .hero-meta span {{
        width: 100%;
      }}
    }}
  </style>
</head>
<body>
  <div class=\"shell\">
    <header class=\"topbar\">
      <div class=\"topbar-inner\">
        <a class=\"wordmark\" href=\"#top\">Endless Darkness</a>
        <nav class=\"nav\" aria-label=\"Primary\">
          <a href=\"#atmosphere\">Atmosphere</a>
          <a href=\"#chapter-one\">Chapter One</a>
          <a href=\"#download\">Download</a>
        </nav>
      </div>
    </header>

    <main id=\"top\">
      <section class=\"hero\">
        <div>
          <p class=\"eyebrow\">Launch Edition / Free Download</p>
          <h1>{page_title}</h1>
          <p class=\"author\">Joshua Szepietowski</p>
          <p class=\"hero-line\">{hero_kicker}</p>
          <p class=\"hero-copy\">{positioning_copy}</p>
          <div class=\"hero-meta\" aria-label=\"Book themes\">
            <span>Generation Ship</span>
            <span>Faith and Inheritance</span>
            <span>Psychological Fragility</span>
            <span>Systems and Surveillance</span>
          </div>
          <div class=\"cta-row\">
            <a class=\"button\" href=\"Endless%20Darkness.pdf\" download>Download the PDF</a>
            <a class=\"ghost-button\" href=\"#chapter-one\">Read Chapter One</a>
          </div>
        </div>

        <aside class=\"hero-visual\">
          <div class=\"cover-frame\">
            <img src=\"cover.png\" alt=\"Cover for Endless Darkness by Joshua Szepietowski\">
          </div>
          <div class=\"visual-caption\">
            <span>Steel / Vigilance / Prayer</span>
            <span>Current file: stable</span>
          </div>
        </aside>
      </section>

      <section id=\"atmosphere\" class=\"section-block\">
        <div class=\"panel positioning-grid\">
          <div class=\"positioning-copy\">
            <p class=\"section-label\">Positioning</p>
            <h2 class=\"section-heading\">A ship of systems. A family under strain.</h2>
            <p>{atmosphere_copy}</p>
          </div>
          <ul class=\"signal-list\" aria-label=\"Atmospheric signals\">
            <li>False dawns over engineered soil</li>
            <li>Cold seams, access hatches, hull glass</li>
            <li>Ritual language beside maintenance doctrine</li>
            <li>Monitoring, logging, and the fear of drift</li>
            <li>Love asked to bear more than it should</li>
          </ul>
        </div>
      </section>

      <section id=\"chapter-one\" class=\"reading-section\">
        <div class=\"reading-intro\">
          <p class=\"section-label\">Read Chapter One</p>
          <h2 class=\"section-heading\">The opening has already begun.</h2>
          <p>The full first chapter is rendered below from the manuscript source. Start here, then continue into the complete book whenever you want the rest of the dark.</p>
        </div>
        <div class=\"chapter-panel\">
          <article class=\"chapter-content\">
            {chapter_html}
          </article>
        </div>
      </section>

      <section id=\"download\" class=\"download-section\">
        <div class=\"panel download-panel\">
          <div class=\"download-copy\">
            <p class=\"section-label\">Free Download</p>
            <h2 class=\"section-heading\">Take the full manuscript.</h2>
            <p>{download_copy}</p>
          </div>
          <div class=\"download-actions\">
            <a class=\"button\" href=\"Endless%20Darkness.pdf\" download>Download Endless Darkness.pdf</a>
            <a class=\"ghost-button\" href=\"#top\">Return to Top</a>
          </div>
        </div>
      </section>

      <section class=\"closing-visual-section\" aria-label=\"Back cover feature\">
        <div class=\"closing-visual-panel\">
          <img class=\"closing-visual-image\" src=\"back-cover.png\" alt=\"Back cover artwork for Endless Darkness\">
          <div class=\"closing-visual-copy\">
            <p class=\"section-label\">Outer Hull / Final View</p>
            <h2 class=\"section-heading\">The dark remains larger than the ship.</h2>
            <p>{closing_copy}</p>
          </div>
        </div>
      </section>
    </main>

    <footer>
      <span>Endless Darkness</span>
      <span>Joshua Szepietowski</span>
      <span>Static launch page build</span>
    </footer>
  </div>

</body>
</html>
"""

index_path.write_text(html_output, encoding="utf-8")
PY

echo "Created $index_path"
