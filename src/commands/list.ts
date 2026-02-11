import { Command } from 'commander';
import chalk from 'chalk';
import { SpecIndex } from '../lib/indexer.js';
import { resolveSpecDir } from './helpers.js';

export const listCommand = new Command('list')
  .description('List all sections in a spec')
  .option('--spec <id>', 'Spec identifier', 'ts33501-v20')
  .action((opts) => {
    const specDir = resolveSpecDir(opts.spec);
    const index = new SpecIndex(specDir);
    index.load();

    const sections = index.listSections();

    // Group by top-level section
    const groups = new Map<string, typeof sections>();
    for (const s of sections) {
      const topLevel = s.id.split('-')[0];
      if (!groups.has(topLevel)) groups.set(topLevel, []);
      groups.get(topLevel)!.push(s);
    }

    console.log(chalk.cyan(`\nTS 33.501 V20.0.0 — ${sections.length} sections\n`));

    for (const [group, secs] of groups) {
      const isAnnex = /^[A-Z]$/.test(group) || group === 'Foreword' || group === 'frontmatter';
      const prefix = isAnnex ? chalk.magenta('Annex ') : chalk.white('§');

      for (const s of secs) {
        const id = s.id.replace(/-/g, '.').padEnd(14);
        console.log(`  ${prefix}${chalk.white.bold(id)} ${chalk.gray(s.heading)}`);
      }
    }
    console.log();
  });
