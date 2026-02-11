import { Command } from 'commander';
import chalk from 'chalk';
import { SpecIndex } from '../lib/indexer.js';
import { resolveSpecDir } from './helpers.js';

export const searchCommand = new Command('search')
  .description('Full-text search across all loaded specs')
  .argument('<query...>', 'Search terms')
  .option('--spec <id>', 'Filter to specific spec', 'ts33501-v20')
  .option('--limit <n>', 'Max results', '10')
  .action((queryParts: string[], opts) => {
    const query = queryParts.join(' ');
    const specDir = resolveSpecDir(opts.spec);
    const index = new SpecIndex(specDir);
    index.load();

    const results = index.search(query, parseInt(opts.limit, 10));

    if (results.length === 0) {
      console.log(chalk.yellow(`No results for "${query}"`));
      return;
    }

    console.log(chalk.cyan(`\n${results.length} results for "${query}":\n`));

    for (const r of results) {
      console.log(chalk.white.bold(`  [${r.sectionId}]`) + ' ' + chalk.gray(r.heading));

      // Highlight query terms in snippet
      let snippet = r.snippet;
      for (const term of query.split(/\s+/)) {
        snippet = snippet.replace(
          new RegExp(`(${term})`, 'gi'),
          chalk.cyan.bold('$1'),
        );
      }
      console.log('    ' + snippet);
      console.log();
    }
  });
