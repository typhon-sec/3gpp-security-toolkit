# CLAUDE.md — 3GPP Security Toolkit

## What This Repo Is

Public repo (`typhon-sec/3gpp-security-toolkit`) containing machine-readable data extracted from 3GPP security specifications, plus a TypeScript CLI for querying the data. Currently covers **TS 33.501 V20.0.0** (5G Security Architecture, Release 20, January 2026).

**License:** MIT

---

## Build Commands

```bash
pnpm install              # Install dependencies
pnpm build                # Compile TypeScript (tsc → dist/)
```

## CLI Usage

```bash
# Via tsx (development)
npx tsx src/cli.ts <command>

# Via compiled output (after pnpm build)
node dist/cli.js <command>

# Commands:
search <query>           # Full-text search across spec sections
list                     # List all 142 sections
section <id>             # Display a section (e.g., "A.2" for KAUSF derivation)
kdf [name]               # Query KDF catalog (25 entries) or specific KDF
algorithms               # NEA/NIA algorithm registry + type distinguishers
ecies [profile]          # ECIES Profile A/B comparison, --test-vectors, --schemes
ingest <docx> --spec <id> --version <ver>  # Parse a new 3GPP DOCX
```

---

## Project Structure

```
specs/ts33501-v20/         # Parsed TS 33.501
  full.json                #   5,885 paragraphs with style metadata
  full.md                  #   Full markdown render
  tables.json              #   13 extracted tables
  meta.json                #   Spec metadata (version, section count, etc.)
  sections/                #   142 per-section markdown files

extracts/                  # Machine-readable data
  kdfs.json                #   25 key derivation functions (Annex A) — FC values, params, keys
  algorithms.json          #   NEA0-3 ciphering + NIA0-3 integrity + 6 type distinguishers
  ecies-profiles.json      #   ECIES Profile A (Curve25519) and Profile B (secp256r1)
  ecies-test-vectors.json  #   6 test vectors from Annex C.4 (null-scheme, Profile A, Profile B)
  protection-schemes.json  #   SUPI concealment scheme IDs (0x0-0xF)

src/
  cli.ts                   #   CLI entry point (commander)
  commands/                #   search, section, list, kdf, algorithms, ecies, ingest
  lib/
    types.ts               #   TypeScript interfaces
    indexer.ts              #   In-memory full-text search over section files
    parser.ts              #   DOCX → structured data (mammoth)
```

---

## Extract Data Summary

| File | Contents | Count |
|------|----------|-------|
| `kdfs.json` | Key derivation functions from Annex A | 25 (FC: 0x69-0x84) |
| `algorithms.json` | Ciphering + integrity algorithms + type distinguishers | 4+4+6 |
| `ecies-profiles.json` | ECIES Profile A (Curve25519) + Profile B (secp256r1) | 2 |
| `ecies-test-vectors.json` | Full test vectors with intermediate crypto values | 6 |
| `protection-schemes.json` | SUPI concealment scheme identifiers | 5 ranges |

---

## Code Conventions

- TypeScript strict mode, ES2022 target, NodeNext modules
- ESM (`"type": "module"` in package.json)
- All spec data is JSON — designed for programmatic consumption
- CLI uses `commander` for subcommand parsing, `chalk` for colored output
- Parser uses `mammoth` for DOCX → HTML → structured data
- Section files use kebab-case naming: `section-A-2.md`, `section-C-3-4.md`

## Adding New Specs

Use the `ingest` command to parse additional 3GPP DOCX files:

```bash
npx tsx src/cli.ts ingest path/to/spec.docx --spec ts33102 --version v18
```

This outputs to `specs/<spec-id>-v<ver>/` in the same structured format.

---

## CI

GitHub Actions workflow (`.github/workflows/ci.yml`):
- Node 20, pnpm
- Build TypeScript
- Smoke tests: help output, list sections, kdf query, algorithms, ecies, search, JSON validation

## GitHub

- Repo: `typhon-sec/3gpp-security-toolkit` (public)
- Topics: 3gpp, 5g, 5g-security, telecom, ts33501, ecies, kdf, cryptography, security-research, supi, suci, cli, typescript
