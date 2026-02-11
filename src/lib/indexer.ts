import { readFileSync, readdirSync, existsSync } from 'node:fs';
import { join } from 'node:path';
import type { ParsedSection, SearchResult } from './types.js';

export class SpecIndex {
  private sections: Map<string, ParsedSection> = new Map();

  constructor(private specDir: string) {}

  load(): void {
    const sectionsDir = join(this.specDir, 'sections');
    if (!existsSync(sectionsDir)) {
      throw new Error(`Sections directory not found: ${sectionsDir}`);
    }

    const files = readdirSync(sectionsDir).filter(f => f.endsWith('.md')).sort();
    for (const file of files) {
      const content = readFileSync(join(sectionsDir, file), 'utf-8');
      const heading = content.split('\n').find(l => l.startsWith('#'))?.replace(/^#+\s*/, '').trim() ?? file;
      const id = file.replace('section-', '').replace('.md', '');
      this.sections.set(id, { id, filename: file, heading, content });
    }
  }

  getSection(id: string): ParsedSection | undefined {
    // Try exact match first
    if (this.sections.has(id)) return this.sections.get(id);

    // Try case-insensitive partial match
    const normalized = id.toLowerCase().replace(/\./g, '-');
    for (const [key, section] of this.sections) {
      if (key.toLowerCase() === normalized) return section;
    }

    // Try matching by heading content
    for (const [, section] of this.sections) {
      if (section.heading.toLowerCase().includes(id.toLowerCase())) return section;
    }

    return undefined;
  }

  listSections(): ParsedSection[] {
    return Array.from(this.sections.values());
  }

  search(query: string, limit = 10): SearchResult[] {
    const terms = query.toLowerCase().split(/\s+/).filter(Boolean);
    const results: SearchResult[] = [];

    for (const [, section] of this.sections) {
      const lowerContent = section.content.toLowerCase();
      const lowerHeading = section.heading.toLowerCase();

      let score = 0;
      let allTermsFound = true;

      for (const term of terms) {
        const contentMatches = (lowerContent.match(new RegExp(escapeRegex(term), 'g')) || []).length;
        const headingMatches = (lowerHeading.match(new RegExp(escapeRegex(term), 'g')) || []).length;

        if (contentMatches === 0 && headingMatches === 0) {
          allTermsFound = false;
          break;
        }

        score += contentMatches + headingMatches * 5;
      }

      if (!allTermsFound) continue;

      // Extract snippet around first match
      const firstTermIdx = lowerContent.indexOf(terms[0]);
      const snippetStart = Math.max(0, firstTermIdx - 60);
      const snippetEnd = Math.min(section.content.length, firstTermIdx + 120);
      let snippet = section.content.slice(snippetStart, snippetEnd).replace(/\n/g, ' ').trim();
      if (snippetStart > 0) snippet = '...' + snippet;
      if (snippetEnd < section.content.length) snippet = snippet + '...';

      results.push({ sectionId: section.id, heading: section.heading, snippet, score });
    }

    return results.sort((a, b) => b.score - a.score).slice(0, limit);
  }
}

function escapeRegex(str: string): string {
  return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
