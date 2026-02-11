import { Command } from 'commander';
import chalk from 'chalk';
import { readFileSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import type { AlgorithmRegistry } from '../lib/types.js';

const __dirname = dirname(fileURLToPath(import.meta.url));

function loadAlgorithms(): AlgorithmRegistry {
  const p = join(__dirname, '..', '..', 'extracts', 'algorithms.json');
  return JSON.parse(readFileSync(p, 'utf-8'));
}

export const algorithmsCommand = new Command('algorithms')
  .description('Show 5G ciphering and integrity algorithm registry')
  .option('--type <type>', 'Filter: cipher, integrity, or distinguishers')
  .action((opts) => {
    const reg = loadAlgorithms();

    const showCipher = !opts.type || opts.type === 'cipher';
    const showIntegrity = !opts.type || opts.type === 'integrity';
    const showDist = !opts.type || opts.type === 'distinguishers';

    console.log(chalk.cyan('\n5G Security Algorithms (TS 33.501 §5.11 / Annex D)\n'));

    if (showCipher) {
      console.log(chalk.white.bold('  Ciphering Algorithms:'));
      console.log(
        chalk.gray('  ' + 'ID'.padEnd(8) + 'Name'.padEnd(14) + 'Key'.padEnd(8) + 'Description'),
      );
      console.log(chalk.gray('  ' + '─'.repeat(70)));
      for (const a of reg.ciphering) {
        console.log(
          '  ' +
          chalk.yellow(a.id.padEnd(8)) +
          chalk.white.bold(a.name.padEnd(14)) +
          chalk.green((a.keyLength ? `${a.keyLength}b` : '—').padEnd(8)) +
          chalk.gray(a.fullName),
        );
      }
      console.log();
    }

    if (showIntegrity) {
      console.log(chalk.white.bold('  Integrity Algorithms:'));
      console.log(
        chalk.gray('  ' + 'ID'.padEnd(8) + 'Name'.padEnd(14) + 'Key'.padEnd(8) + 'Description'),
      );
      console.log(chalk.gray('  ' + '─'.repeat(70)));
      for (const a of reg.integrity) {
        console.log(
          '  ' +
          chalk.yellow(a.id.padEnd(8)) +
          chalk.white.bold(a.name.padEnd(14)) +
          chalk.green((a.keyLength ? `${a.keyLength}b` : '—').padEnd(8)) +
          chalk.gray(a.fullName),
        );
      }
      console.log();
    }

    if (showDist) {
      console.log(chalk.white.bold('  Type Distinguishers (for algorithm key derivation):'));
      console.log(chalk.gray('  ' + 'Value'.padEnd(8) + 'Name'.padEnd(20) + 'Description'));
      console.log(chalk.gray('  ' + '─'.repeat(55)));
      for (const d of reg.typeDistinguishers) {
        console.log(
          '  ' +
          chalk.yellow(d.value.padEnd(8)) +
          chalk.white.bold(d.name.padEnd(20)) +
          chalk.gray(d.description),
        );
      }
      console.log();
    }
  });
