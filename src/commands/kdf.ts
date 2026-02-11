import { Command } from 'commander';
import chalk from 'chalk';
import { readFileSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import type { KdfEntry } from '../lib/types.js';

const __dirname = dirname(fileURLToPath(import.meta.url));

function loadKdfs(): KdfEntry[] {
  const p = join(__dirname, '..', '..', 'extracts', 'kdfs.json');
  return JSON.parse(readFileSync(p, 'utf-8'));
}

export const kdfCommand = new Command('kdf')
  .description('Query 5G KDF catalog (Annex A)')
  .argument('[name]', 'KDF name or ID to show details for')
  .action((name?: string) => {
    const kdfs = loadKdfs();

    if (!name) {
      // Show summary table
      console.log(chalk.cyan('\n5G Key Derivation Functions (TS 33.501 Annex A)\n'));
      console.log(
        chalk.white.bold('  Section'.padEnd(12)) +
        chalk.white.bold('FC'.padEnd(8)) +
        chalk.white.bold('Output Key'.padEnd(28)) +
        chalk.white.bold('Name'),
      );
      console.log(chalk.gray('  ' + '─'.repeat(80)));

      for (const k of kdfs) {
        if (!k.fc && k.id === 'kdf-interface') continue; // Skip framework entry
        console.log(
          chalk.white('  ' + k.section.padEnd(10)) +
          chalk.yellow((k.fc ?? '—').padEnd(8)) +
          chalk.green((k.outputKey ?? '—').slice(0, 26).padEnd(28)) +
          chalk.gray(k.name),
        );
      }
      console.log(chalk.gray(`\n  ${kdfs.length - 1} KDF specifications\n`));
      return;
    }

    // Find specific KDF
    const lower = name.toLowerCase();
    const match = kdfs.find(
      k =>
        k.id.toLowerCase() === lower ||
        k.name.toLowerCase().includes(lower) ||
        k.section.toLowerCase() === lower ||
        (k.outputKey?.toLowerCase().includes(lower) ?? false),
    );

    if (!match) {
      console.log(chalk.red(`KDF "${name}" not found.`));
      return;
    }

    console.log(chalk.cyan.bold(`\n${match.name}`));
    console.log(chalk.gray(`Section ${match.section}\n`));
    console.log(chalk.white('  FC:         ') + chalk.yellow(match.fc ?? 'N/A'));
    console.log(chalk.white('  Input Key:  ') + chalk.green(match.inputKey ?? 'N/A'));
    console.log(chalk.white('  Output Key: ') + chalk.green(match.outputKey ?? 'N/A'));
    console.log(chalk.white('  Applies to: ') + chalk.gray(match.applicability));

    if (match.parameters.length > 0) {
      console.log(chalk.white('\n  Parameters:'));
      for (const p of match.parameters) {
        console.log(`    ${chalk.yellow(p.id.padEnd(4))} ${chalk.white(p.name.padEnd(50))} ${chalk.gray(p.length)}`);
      }
    }

    if (match.notes) {
      console.log(chalk.white('\n  Notes: ') + chalk.gray(match.notes));
    }
    console.log();
  });
