# ADR-0001: Machine-Readable 3GPP Spec Extracts

**Status:** Accepted
**Date:** 2026-02-11
**Deciders:** Founder

**Related ADRs:**
- [cross-repo] `core/docs/adr/0001-rust-for-core-detection-engine.md` — Detection engine consumes these spec extracts
- [cross-repo] `core/docs/adr/0002-e2e-encryption-protocol-design.md` — Crypto protocol informed by 3GPP security algorithms

---

## Context

3GPP specifications (particularly TS 33.501 — "Security architecture and procedures for 5G System") contain critical machine-readable data locked inside 500+ page DOCX files:

- **Key Derivation Functions (KDFs)** — Input parameters, output lengths, FC values
- **Algorithm identifiers** — NEA/NIA/ECIES algorithm registries
- **ECIES profiles** — Curve parameters, key sizes, protection schemes
- **Test vectors** — Known-good input/output pairs for implementation validation

This data is essential for implementing and validating cellular security tools, but no machine-readable extract existed. Researchers and developers had to manually parse the DOCX files, leading to errors and inconsistencies.

We evaluated two approaches:

1. **Manual curation** — Hand-pick relevant sections and manually create JSON. Accurate but tedious, error-prone, and doesn't scale to spec updates.
2. **Automated parsing** — Build a parser that ingests the DOCX, extracts structured data, and produces JSON artifacts. Repeatable on spec updates. CLI for querying.

## Decision

Build an automated parsing pipeline and CLI tool:

**Parser:**
- Ingest TS 33.501 V20.0.0 DOCX via `mammoth` (DOCX → HTML) + `cheerio` (HTML → DOM)
- Extract sections preserving hierarchy (142 sections, 5885 paragraphs)
- Output section markdown files with kebab-case naming (`section-A-2.md`, `section-C-3-4.md`)

**Structured extracts (JSON):**
- `kdfs.json` — 25 Key Derivation Functions with inputs, outputs, FC values
- `algorithms.json` — NEA/NIA algorithm registry
- `ecies-profiles.json` — ECIES curve parameters and protection schemes
- `ecies-test-vectors.json` — 6 known-good ECIES test vectors
- `protection-schemes.json` — SUPI/SUCI protection scheme registry

**CLI tool (commander-based, 7 commands):**
- `search` — Full-text search across parsed sections
- `list` — List all sections with hierarchy
- `section` — Display a specific section by number
- `kdf` — Query KDF parameters by name or FC value
- `algorithms` — List algorithm registries
- `ecies` — Query ECIES profiles and test vectors
- `ingest` — Re-run parser on updated spec DOCX

Published as `@typhon-sec/3gpp-security-toolkit` on npm. MIT licensed.

## Consequences

### Positive
- Machine-readable spec data enables automated validation of detection engine implementations
- ECIES test vectors provide known-good values for crypto implementation testing
- CLI tool enables rapid spec lookups during development without opening 500-page documents
- Automated parsing is repeatable when 3GPP publishes spec updates
- MIT license allows unrestricted use by the security research community

### Negative
- Parser is tightly coupled to TS 33.501 DOCX structure — spec format changes may break extraction
- Section file naming convention (kebab-case with `section-` prefix) can be surprising for appendix sections
- Only TS 33.501 is parsed — other security-relevant specs (TS 33.401, TS 35.206) are not yet covered

### Neutral
- 142 sections and 5885 paragraphs parsed — large output but well-organized
- JSON extracts are static snapshots — must re-run parser on spec updates
- CLI depends on commander.js, a widely-used and stable dependency
