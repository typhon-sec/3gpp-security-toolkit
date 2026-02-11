import { Command } from 'commander';
import chalk from 'chalk';
import { SpecIndex } from '../lib/indexer.js';
import { resolveSpecDir } from './helpers.js';

export const sectionCommand = new Command('section')
  .description('Display a specific section by ID')
  .argument('<id>', 'Section identifier (e.g., A.2, C.3, 5)')
  .option('--spec <id>', 'Spec identifier', 'ts33501-v20')
  .action((id: string, opts) => {
    const specDir = resolveSpecDir(opts.spec);
    const index = new SpecIndex(specDir);
    index.load();

    const section = index.getSection(id);
    if (!section) {
      console.log(chalk.red(`Section "${id}" not found.`));
      console.log(chalk.gray('Use "3gpp list" to see available sections.'));
      return;
    }

    console.log(chalk.cyan.bold(`\n=== ${section.heading} ===\n`));
    console.log(section.content);
  });
