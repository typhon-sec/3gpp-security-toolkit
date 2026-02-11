import { Command } from 'commander';
import chalk from 'chalk';
import { existsSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import { parseDocx } from '../lib/parser.js';

const __dirname = dirname(fileURLToPath(import.meta.url));

export const ingestCommand = new Command('ingest')
  .description('Parse a 3GPP DOCX file into structured data')
  .argument('<docx-path>', 'Path to the DOCX file')
  .requiredOption('--spec <spec-id>', 'Spec identifier (e.g., ts33501)')
  .requiredOption('--version <ver>', 'Version string (e.g., v20)')
  .action(async (docxPath: string, opts: { spec: string; version: string }) => {
    if (!existsSync(docxPath)) {
      console.log(chalk.red(`File not found: ${docxPath}`));
      process.exit(1);
    }

    const outputDir = join(__dirname, '..', '..', 'specs', `${opts.spec}-${opts.version}`);
    console.log(chalk.cyan(`\nIngesting ${docxPath}...`));
    console.log(chalk.gray(`Output: ${outputDir}\n`));

    try {
      await parseDocx(docxPath, outputDir);
      console.log(chalk.green('\nDone! Spec data written to: ') + outputDir);
      console.log(chalk.gray('Run "3gpp list --spec ' + opts.spec + '-' + opts.version + '" to browse sections.'));
    } catch (err) {
      console.error(chalk.red('Ingestion failed:'), err);
      process.exit(1);
    }
  });
