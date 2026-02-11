# 3GPP Security Toolkit

> Machine-readable 5G security data extracted from 3GPP specifications. Query KDF parameters, algorithm registries, ECIES profiles, and SUPI concealment test vectors from your terminal or your code.

**Why this exists:** 3GPP security specs contain critical machine-readable data — key derivation parameters, algorithm identifiers, cryptographic test vectors — but it's buried in 500+ page DOCX files. This project parses those specs into structured JSON and provides a CLI to query them. Built for security researchers, telecom engineers, protocol implementers, and anyone building on 5G security primitives.

Currently covering **TS 33.501 V20.0.0** (5G Security Architecture and Procedures, Release 20, January 2026).

## What's included

### Structured spec data (`specs/`)
- Full specification parsed into **142 queryable sections** and **5,885 paragraphs**
- Per-section markdown files for targeted reading
- Extracted tables in structured JSON

### Machine-readable extracts (`extracts/`)
| File | Contents |
|------|----------|
| `kdfs.json` | All 25 key derivation functions from Annex A — FC values, input keys, parameters, output keys |
| `algorithms.json` | NEA0–3 ciphering and NIA0–3 integrity algorithm registry with type distinguishers |
| `ecies-profiles.json` | ECIES Profile A (Curve25519) and Profile B (secp256r1) — full parameter sets |
| `ecies-test-vectors.json` | 6 complete test vectors from Annex C.4 with all intermediate cryptographic values |
| `protection-schemes.json` | SUPI concealment protection scheme identifiers (null, Profile A/B, reserved ranges) |

### CLI tool (`src/`)
TypeScript CLI for searching, browsing, and querying spec data from the terminal.

## Quick start

```bash
# Install and build
pnpm install
pnpm build

# Search across the entire spec
node dist/cli.js search "SUPI concealment"
node dist/cli.js search "key derivation"

# Browse sections
node dist/cli.js list                 # List all 142 sections
node dist/cli.js section A.2          # Show KAUSF derivation (full text)
node dist/cli.js section C.3          # Show ECIES procedures

# Query the KDF catalog
node dist/cli.js kdf                  # Summary table of all 25 KDFs
node dist/cli.js kdf KAUSF            # Details: FC=0x6A, CK||IK input, parameters

# Algorithm registry
node dist/cli.js algorithms           # NEA/NIA tables + type distinguishers
node dist/cli.js algorithms --type cipher

# ECIES profiles and test vectors
node dist/cli.js ecies                # Side-by-side Profile A vs B comparison
node dist/cli.js ecies A              # Profile A: Curve25519, X25519, AES-128-CTR
node dist/cli.js ecies --schemes      # Protection scheme identifiers
node dist/cli.js ecies --test-vectors # Full Annex C.4 test vector data

# Ingest additional 3GPP specs
node dist/cli.js ingest path/to/spec.docx --spec ts33102 --version v18
```

## Use the extracts in your own code

The JSON files in `extracts/` are designed for programmatic consumption — import them directly:

```typescript
import kdfs from './extracts/kdfs.json';
import algorithms from './extracts/algorithms.json';
import profiles from './extracts/ecies-profiles.json';
import vectors from './extracts/ecies-test-vectors.json';

// Find a KDF by FC value
const kausf = kdfs.find(k => k.fc === '0x6A');
// → { id: "kausf", section: "A.2", inputKey: "CK || IK", outputKey: "KAUSF", ... }

// Get all integrity algorithms
const integrityAlgs = algorithms.integrity;
// → [{ name: "NIA0", ... }, { name: "128-NIA1", ... }, ...]

// Look up ECIES Profile A parameters
const profileA = profiles.find(p => p.id === 'A');
// → { curve: "Curve25519", enc: "AES-128-CTR", macLen: 8, ... }

// Validate against official test vectors
const testVec = vectors.find(v => v.id === 'profile-a-imsi');
// → { keys: { ephPublicKey: "b2e9...", ... }, ciphertext: "cb02352410", ... }
```

## Spec coverage

| Spec | Version | Release | Sections | Paragraphs | Status |
|------|---------|---------|----------|------------|--------|
| TS 33.501 | V20.0.0 (2026-01) | Rel-20 | 142 | 5,885 | Parsed |

Additional specs can be ingested using the `ingest` command. The parser handles 3GPP DOCX formatting (heading hierarchies, nested clauses, tables) and outputs the same structured format.

## Project structure

```
3gpp-security-toolkit/
├── specs/ts33501-v20/          # Parsed TS 33.501
│   ├── full.json               #   All paragraphs with style metadata
│   ├── full.md                 #   Full markdown render
│   ├── tables.json             #   Extracted tables
│   ├── meta.json               #   Spec metadata
│   └── sections/               #   142 per-section markdown files
├── extracts/                   # Machine-readable data
│   ├── kdfs.json               #   Key derivation function catalog
│   ├── algorithms.json         #   Cipher/integrity algorithm registry
│   ├── ecies-profiles.json     #   ECIES Profile A & B parameters
│   ├── ecies-test-vectors.json #   Annex C.4 test vectors
│   └── protection-schemes.json #   SUPI concealment scheme IDs
└── src/                        # TypeScript CLI
    ├── cli.ts                  #   Entry point (commander)
    ├── commands/               #   search, section, list, kdf, algorithms, ecies, ingest
    └── lib/                    #   Parser, indexer, types
```

## Contributing

Contributions are welcome. If you've parsed additional 3GPP security specs (TS 33.102, TS 33.401, TS 35.xxx) and want to add them, open a PR with the parsed data in `specs/` and any new extracts.

## License

MIT — See [LICENSE](./LICENSE).

Parsed specification data is derived from 3GPP technical specifications. 3GPP specifications are publicly available at [3gpp.org](https://www.3gpp.org/specifications) and are subject to [3GPP terms of use](https://www.3gpp.org/specifications/specification-numbering).

## Related

- [3GPP TS 33.501](https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=3169) — Security architecture and procedures for 5G system
- [SECG SEC 1 v2](https://www.secg.org/sec1-v2.pdf) — Elliptic Curve Cryptography (ECIES reference)
- [RFC 7748](https://www.rfc-editor.org/rfc/rfc7748) — Elliptic Curves for Security (Curve25519/X25519)

---

Built by [Typhon Security](https://github.com/typhon-sec) to support open 5G security research.
