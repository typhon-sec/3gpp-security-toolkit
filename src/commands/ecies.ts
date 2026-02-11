import { Command } from 'commander';
import chalk from 'chalk';
import { readFileSync } from 'node:fs';
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';
import type { EciesProfile, EciesTestVector, ProtectionScheme } from '../lib/types.js';

const __dirname = dirname(fileURLToPath(import.meta.url));

function loadProfiles(): EciesProfile[] {
  return JSON.parse(readFileSync(join(__dirname, '..', '..', 'extracts', 'ecies-profiles.json'), 'utf-8'));
}

function loadTestVectors(): EciesTestVector[] {
  return JSON.parse(readFileSync(join(__dirname, '..', '..', 'extracts', 'ecies-test-vectors.json'), 'utf-8'));
}

function loadSchemes(): ProtectionScheme[] {
  return JSON.parse(readFileSync(join(__dirname, '..', '..', 'extracts', 'protection-schemes.json'), 'utf-8'));
}

export const eciesCommand = new Command('ecies')
  .description('Show ECIES profiles, protection schemes, and test vectors')
  .argument('[profile]', 'Profile to show details for (A or B)')
  .option('--test-vectors', 'Include full test vector data')
  .option('--schemes', 'Show protection scheme identifiers')
  .action((profile?: string, opts?: { testVectors?: boolean; schemes?: boolean }) => {
    const profiles = loadProfiles();

    if (opts?.schemes) {
      const schemes = loadSchemes();
      console.log(chalk.cyan('\nSUPI Protection Scheme Identifiers (TS 33.501 Annex C.1)\n'));
      for (const s of schemes) {
        const id = s.id ?? s.range ?? '';
        console.log(`  ${chalk.yellow(id.padEnd(10))} ${chalk.white.bold(s.name.padEnd(14))} ${chalk.gray(s.description)}`);
      }
      console.log();
      return;
    }

    if (!profile) {
      // Comparison table
      console.log(chalk.cyan('\nECIES Profiles for SUPI Concealment (TS 33.501 Annex C.3.4)\n'));

      const fields: [string, (p: EciesProfile) => string][] = [
        ['Scheme ID', p => p.schemeId],
        ['Curve', p => p.curve],
        ['DH Primitive', p => p.dhPrimitive],
        ['Point Compression', p => String(p.pointCompression)],
        ['KDF', p => p.kdf],
        ['Hash', p => p.hash],
        ['MAC', p => p.mac],
        ['MAC Key Length', p => `${p.macKeyLen} bytes`],
        ['MAC Tag Length', p => `${p.macLen} bytes`],
        ['Encryption', p => p.enc],
        ['Enc Key Length', p => `${p.encKeyLen} bytes`],
        ['ICB Length', p => `${p.icbLen} bytes`],
        ['Eph. Pub Key', p => `${p.ephPubKeySize} bytes`],
      ];

      const labelWidth = 20;
      console.log(
        chalk.gray('  ' + ''.padEnd(labelWidth)) +
        chalk.white.bold('Profile A'.padEnd(36)) +
        chalk.white.bold('Profile B'),
      );
      console.log(chalk.gray('  ' + '─'.repeat(80)));

      for (const [label, getter] of fields) {
        const a = getter(profiles[0]);
        const b = getter(profiles[1]);
        const same = a === b;
        console.log(
          '  ' +
          chalk.white(label.padEnd(labelWidth)) +
          (same ? chalk.gray : chalk.green)(a.padEnd(36)) +
          (same ? chalk.gray : chalk.yellow)(b),
        );
      }
      console.log();

      if (opts?.testVectors) {
        showTestVectors();
      }
      return;
    }

    // Show specific profile
    const p = profiles.find(pr => pr.id.toLowerCase() === profile.toLowerCase());
    if (!p) {
      console.log(chalk.red(`Profile "${profile}" not found. Use A or B.`));
      return;
    }

    console.log(chalk.cyan.bold(`\nECIES Profile ${p.id} (Scheme ID: ${p.schemeId})\n`));
    console.log(chalk.white('  Curve:            ') + chalk.green(p.curve));
    console.log(chalk.white('  DH Primitive:     ') + chalk.green(p.dhPrimitive));
    console.log(chalk.white('  Point Compress.:  ') + chalk.green(String(p.pointCompression)));
    console.log(chalk.white('  KDF:              ') + chalk.green(p.kdf));
    console.log(chalk.white('  Hash:             ') + chalk.green(p.hash));
    console.log(chalk.white('  MAC:              ') + chalk.green(p.mac));
    console.log(chalk.white('  MAC Key Length:   ') + chalk.green(`${p.macKeyLen} bytes (${p.macKeyLen * 8} bits)`));
    console.log(chalk.white('  MAC Tag Length:   ') + chalk.green(`${p.macLen} bytes (${p.macLen * 8} bits)`));
    console.log(chalk.white('  Encryption:       ') + chalk.green(p.enc));
    console.log(chalk.white('  Enc Key Length:   ') + chalk.green(`${p.encKeyLen} bytes (${p.encKeyLen * 8} bits)`));
    console.log(chalk.white('  ICB Length:       ') + chalk.green(`${p.icbLen} bytes (${p.icbLen * 8} bits)`));
    console.log(chalk.white('  Eph. Pub Key:     ') + chalk.green(`${p.ephPubKeySize} bytes`));
    console.log(chalk.white('  Output Size:      ') + chalk.gray(p.schemeOutputSize));
    console.log();

    if (opts?.testVectors) {
      showTestVectors(p.id);
    }
  });

function showTestVectors(profileFilter?: string): void {
  const vectors = loadTestVectors();
  const filtered = profileFilter
    ? vectors.filter(v => v.profile.includes(profileFilter))
    : vectors;

  console.log(chalk.cyan.bold('  Test Vectors (TS 33.501 Annex C.4):\n'));

  for (const v of filtered) {
    console.log(chalk.white.bold(`  ${v.id} (${v.supiType}):`));
    console.log(chalk.gray(`    Profile: ${v.profile}`));
    console.log(chalk.gray(`    Scheme Input:  ${v.schemeInput}`));
    if (v.ciphertext) console.log(chalk.gray(`    Ciphertext:    ${v.ciphertext}`));
    if (v.macTag) console.log(chalk.gray(`    MAC Tag:       ${v.macTag}`));
    console.log(chalk.gray(`    Scheme Output: ${v.schemeOutput}`));

    if (v.keys) {
      console.log(chalk.gray('    Keys:'));
      for (const [key, val] of Object.entries(v.keys)) {
        console.log(chalk.gray(`      ${key}: ${val}`));
      }
    }
    console.log();
  }
}
