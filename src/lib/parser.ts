import { writeFileSync, mkdirSync, existsSync } from 'node:fs';
import { join } from 'node:path';

interface Paragraph {
  style: string;
  text: string;
  heading_level: number | null;
}

export async function parseDocx(docxPath: string, outputDir: string): Promise<void> {
  // Dynamic import so mammoth is only required when actually ingesting
  const mammoth = await import('mammoth');

  if (!existsSync(outputDir)) {
    mkdirSync(outputDir, { recursive: true });
  }

  const sectionsDir = join(outputDir, 'sections');
  mkdirSync(sectionsDir, { recursive: true });

  // Convert DOCX to HTML
  const result = await mammoth.convertToHtml({ path: docxPath });

  // Also extract raw text with style info
  const rawResult = await mammoth.extractRawText({ path: docxPath });

  // Parse HTML into paragraphs
  const paragraphs = parseHtmlToParagraphs(result.value);

  // Write full.json
  writeFileSync(join(outputDir, 'full.json'), JSON.stringify(paragraphs, null, 2));

  // Build markdown
  const markdown = paragraphsToMarkdown(paragraphs);
  writeFileSync(join(outputDir, 'full.md'), markdown);

  // Extract tables
  const tables = extractTables(result.value);
  writeFileSync(join(outputDir, 'tables.json'), JSON.stringify(tables, null, 2));

  // Split into sections
  const sections = splitIntoSections(paragraphs);
  let sectionCount = 0;
  for (const [sectionId, content] of Object.entries(sections)) {
    const filename = `section-${sectionId}.md`;
    writeFileSync(join(sectionsDir, filename), content);
    sectionCount++;
  }

  // Write metadata
  const meta = {
    spec: 'Unknown',
    version: '0.0.0',
    release: 0,
    date: new Date().toISOString().slice(0, 7),
    title: 'Parsed 3GPP specification',
    sectionCount,
    paragraphCount: paragraphs.length,
    tableCount: tables.length,
  };
  writeFileSync(join(outputDir, 'meta.json'), JSON.stringify(meta, null, 2));

  console.log(`Parsed ${paragraphs.length} paragraphs into ${sectionCount} sections`);
  if (result.messages.length > 0) {
    console.log(`Warnings: ${result.messages.length}`);
  }
}

function parseHtmlToParagraphs(html: string): Paragraph[] {
  const paragraphs: Paragraph[] = [];
  // Simple regex-based HTML parsing for headings and paragraphs
  const blockRegex = /<(h[1-6]|p|li)[^>]*>([\s\S]*?)<\/\1>/gi;
  let match;
  while ((match = blockRegex.exec(html)) !== null) {
    const tag = match[1].toLowerCase();
    const text = stripHtml(match[2]).trim();
    if (!text) continue;

    let headingLevel: number | null = null;
    let style = 'Normal';
    if (tag.startsWith('h')) {
      headingLevel = parseInt(tag[1], 10);
      style = `Heading${headingLevel}`;
    } else if (tag === 'li') {
      style = 'ListParagraph';
    }

    paragraphs.push({ style, text, heading_level: headingLevel });
  }
  return paragraphs;
}

function stripHtml(html: string): string {
  return html.replace(/<[^>]+>/g, '').replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&nbsp;/g, ' ').replace(/&#\d+;/g, '');
}

function paragraphsToMarkdown(paragraphs: Paragraph[]): string {
  return paragraphs
    .map(p => {
      if (p.heading_level) return '#'.repeat(p.heading_level) + ' ' + p.text;
      return p.text;
    })
    .join('\n\n');
}

function extractTables(html: string): { index: number; rows: string[][] }[] {
  const tables: { index: number; rows: string[][] }[] = [];
  const tableRegex = /<table[^>]*>([\s\S]*?)<\/table>/gi;
  let tableMatch;
  let idx = 0;
  while ((tableMatch = tableRegex.exec(html)) !== null) {
    const rows: string[][] = [];
    const rowRegex = /<tr[^>]*>([\s\S]*?)<\/tr>/gi;
    let rowMatch;
    while ((rowMatch = rowRegex.exec(tableMatch[1])) !== null) {
      const cells: string[] = [];
      const cellRegex = /<t[dh][^>]*>([\s\S]*?)<\/t[dh]>/gi;
      let cellMatch;
      while ((cellMatch = cellRegex.exec(rowMatch[1])) !== null) {
        cells.push(stripHtml(cellMatch[1]).trim());
      }
      if (cells.length > 0) rows.push(cells);
    }
    if (rows.length > 0) tables.push({ index: idx++, rows });
  }
  return tables;
}

function splitIntoSections(paragraphs: Paragraph[]): Record<string, string> {
  const sections: Record<string, string> = {};
  let currentId = 'frontmatter';
  let currentContent: string[] = [];

  for (const p of paragraphs) {
    if (p.heading_level && p.heading_level <= 3) {
      // Save previous section
      if (currentContent.length > 0) {
        sections[currentId] = currentContent.join('\n');
      }
      // Derive section ID from heading text
      const headingMatch = p.text.match(/^([A-Z]?\d+(?:\.\d+)*|[A-Z](?:\.\d+)*|Annex\s+[A-Z]|Foreword)/i);
      if (headingMatch) {
        currentId = headingMatch[1].replace(/\./g, '-').replace(/\s+/g, '-');
      } else {
        currentId = p.text.slice(0, 30).replace(/[^a-zA-Z0-9]/g, '-').replace(/-+/g, '-').toLowerCase();
      }
      currentContent = ['#'.repeat(p.heading_level) + ' ' + p.text];
    } else {
      const line = p.heading_level ? '#'.repeat(p.heading_level) + ' ' + p.text : p.text;
      currentContent.push(line);
    }
  }

  // Save last section
  if (currentContent.length > 0) {
    sections[currentId] = currentContent.join('\n');
  }

  return sections;
}
