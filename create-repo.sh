#!/usr/bin/env bash
set -euo pipefail

# 3GPP Security Toolkit — Offline Repo Generator
# Creates the full repo structure, extracts, and CLI source code.
# Usage: bash create-repo.sh [--spec-dir /path/to/33501-parsed]

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SPEC_DIR="${1:---spec-dir}"

# Parse --spec-dir flag
if [[ "$SPEC_DIR" == "--spec-dir" ]]; then
  shift 2>/dev/null || true
  SPEC_DIR="${1:-/tmp/33501-parsed}"
fi

echo "==> Creating 3GPP Security Toolkit repo at: $REPO_DIR"
echo "==> Spec source: $SPEC_DIR"

###############################################################################
# 1. Directory structure
###############################################################################
echo "--- Creating directories..."
mkdir -p "$REPO_DIR"/{specs/ts33501-v20/sections,extracts,src/{commands,lib},scripts,.github/workflows}

###############################################################################
# 2. Copy parsed spec data (if available)
###############################################################################
if [[ -d "$SPEC_DIR" ]]; then
  echo "--- Copying parsed spec data from $SPEC_DIR..."
  cp "$SPEC_DIR/ts33501-full.json"   "$REPO_DIR/specs/ts33501-v20/full.json"   2>/dev/null || echo "    WARN: full.json not found"
  cp "$SPEC_DIR/ts33501-full.md"     "$REPO_DIR/specs/ts33501-v20/full.md"     2>/dev/null || echo "    WARN: full.md not found"
  cp "$SPEC_DIR/ts33501-tables.json" "$REPO_DIR/specs/ts33501-v20/tables.json" 2>/dev/null || echo "    WARN: tables.json not found"
  if [[ -d "$SPEC_DIR/sections" ]]; then
    cp "$SPEC_DIR/sections/"*.md "$REPO_DIR/specs/ts33501-v20/sections/" 2>/dev/null || echo "    WARN: no section files"
    SECTION_COUNT=$(ls "$REPO_DIR/specs/ts33501-v20/sections/"*.md 2>/dev/null | wc -l | tr -d ' ')
    echo "    Copied $SECTION_COUNT section files"
  fi
else
  echo "    WARN: Spec dir $SPEC_DIR not found — skipping spec copy. Run 'ingest' later."
  SECTION_COUNT=0
fi

# Count paragraphs/tables if files exist
PARA_COUNT=0
TABLE_COUNT=0
if [[ -f "$REPO_DIR/specs/ts33501-v20/full.json" ]]; then
  PARA_COUNT=$(python3 -c "import json; print(len(json.load(open('$REPO_DIR/specs/ts33501-v20/full.json'))))" 2>/dev/null || echo 0)
fi
if [[ -f "$REPO_DIR/specs/ts33501-v20/tables.json" ]]; then
  TABLE_COUNT=$(python3 -c "import json; print(len(json.load(open('$REPO_DIR/specs/ts33501-v20/tables.json'))))" 2>/dev/null || echo 0)
fi

###############################################################################
# 3. Package config files
###############################################################################
echo "--- Writing config files..."

cat > "$REPO_DIR/package.json" << 'PKGJSON'
{
  "name": "@typhon-sec/3gpp-security-toolkit",
  "version": "0.1.0",
  "description": "Machine-readable extracts and CLI tools for 3GPP security specifications",
  "license": "MIT",
  "type": "module",
  "bin": {
    "3gpp": "./dist/cli.js"
  },
  "scripts": {
    "build": "tsc",
    "dev": "tsx src/cli.ts",
    "test": "node --test dist/**/*.test.js"
  },
  "dependencies": {
    "chalk": "^5.3.0",
    "commander": "^12.1.0",
    "glob": "^11.0.0",
    "mammoth": "^1.8.0"
  },
  "devDependencies": {
    "@types/node": "^22.0.0",
    "tsx": "^4.19.0",
    "typescript": "^5.7.0"
  },
  "engines": {
    "node": ">=20"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/typhon-sec/3gpp-security-toolkit.git"
  },
  "keywords": ["3gpp", "5g", "security", "ts33501", "ecies", "kdf", "telecom"]
}
PKGJSON

cat > "$REPO_DIR/tsconfig.json" << 'TSCONFIG'
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "outDir": "dist",
    "rootDir": "src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["src/**/*.ts"],
  "exclude": ["node_modules", "dist"]
}
TSCONFIG

cat > "$REPO_DIR/.gitignore" << 'GITIGNORE'
node_modules/
dist/
*.tgz
.DS_Store
GITIGNORE

cat > "$REPO_DIR/LICENSE" << 'LICENSE'
MIT License

Copyright (c) 2026 Typhon Security

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
LICENSE

###############################################################################
# 4. Spec metadata
###############################################################################
echo "--- Writing spec metadata..."

cat > "$REPO_DIR/specs/ts33501-v20/meta.json" << METAJSON
{
  "spec": "TS 33.501",
  "version": "20.0.0",
  "release": 20,
  "date": "2026-01",
  "title": "Security architecture and procedures for 5G system",
  "sectionCount": ${SECTION_COUNT:-142},
  "paragraphCount": ${PARA_COUNT:-5885},
  "tableCount": ${TABLE_COUNT:-13}
}
METAJSON

###############################################################################
# 5. Machine-readable extracts
###############################################################################
echo "--- Writing extract files..."

# --- 5a. KDF catalog (23 entries from Annex A) ---
cat > "$REPO_DIR/extracts/kdfs.json" << 'KDFJSON'
[
  {
    "id": "kdf-interface",
    "name": "KDF interface and input parameter construction",
    "section": "A.1",
    "fc": null,
    "inputKey": null,
    "parameters": [],
    "outputKey": null,
    "applicability": "General framework — defines FC value space 0x69–0x79, 0x7B–0x7D, 0x83–0x84",
    "notes": "All key derivations use KDF from TS 33.220 Annex B.2.0"
  },
  {
    "id": "kausf",
    "name": "KAUSF derivation",
    "section": "A.2",
    "fc": "0x6A",
    "inputKey": "CK || IK",
    "parameters": [
      { "id": "P0", "name": "serving network name", "length": "variable (per TS 24.501)" },
      { "id": "P1", "name": "SQN ⊕ AK", "length": "0x00 0x06" }
    ],
    "outputKey": "KAUSF",
    "applicability": "5G AKA only",
    "notes": "SQN XOR AK sent as part of AUTN. If AK not used, treat as 000…0."
  },
  {
    "id": "ck-ik-prime",
    "name": "CK' and IK' derivation",
    "section": "A.3",
    "fc": null,
    "inputKey": "CK || IK",
    "parameters": [
      { "id": "P0", "name": "serving network name (as access network identity)", "length": "variable" }
    ],
    "outputKey": "CK' || IK'",
    "applicability": "EAP-AKA' based procedures",
    "notes": "Uses KDF from TS 33.402 clause A.2 with serving network name as P0"
  },
  {
    "id": "res-star",
    "name": "RES* and XRES* derivation",
    "section": "A.4",
    "fc": "0x6B",
    "inputKey": "CK || IK",
    "parameters": [
      { "id": "P0", "name": "serving network name", "length": "variable (per TS 24.501)" },
      { "id": "P1", "name": "RAND", "length": "0x00 0x10" },
      { "id": "P2", "name": "RES or XRES", "length": "variable (0x00 0x04 to 0x00 0x10)" }
    ],
    "outputKey": "RES* / XRES* (128 least significant bits)",
    "applicability": "5G AKA",
    "notes": "Output is the 128 least significant bits of KDF output"
  },
  {
    "id": "hres-star",
    "name": "HRES* and HXRES* derivation",
    "section": "A.5",
    "fc": null,
    "inputKey": null,
    "parameters": [
      { "id": "P0", "name": "RAND", "length": "16 bytes" },
      { "id": "P1", "name": "RES* or XRES*", "length": "16 bytes" }
    ],
    "outputKey": "HRES* / HXRES* (128 least significant bits of SHA-256)",
    "applicability": "5G AKA",
    "notes": "Uses SHA-256 hash (not KDF). Input is P0 || P1 concatenation."
  },
  {
    "id": "kseaf",
    "name": "KSEAF derivation",
    "section": "A.6",
    "fc": "0x6C",
    "inputKey": "KAUSF",
    "parameters": [
      { "id": "P0", "name": "serving network name", "length": "variable" }
    ],
    "outputKey": "KSEAF",
    "applicability": "All 5G authentication methods",
    "notes": "Serving network name constructed per clause 6.1.1.4"
  },
  {
    "id": "kamf",
    "name": "KAMF derivation",
    "section": "A.7",
    "fc": "0x6D",
    "inputKey": "KSEAF (256-bit)",
    "parameters": [
      { "id": "P0", "name": "SUPI (IMSI, NAI, GCI, or GLI)", "length": "variable" },
      { "id": "P1", "name": "ABBA parameter", "length": "variable" }
    ],
    "outputKey": "KAMF",
    "applicability": "All 5G authentication methods",
    "notes": "ABBA default value 0x0000; variable length for forward compatibility"
  },
  {
    "id": "algorithm-keys",
    "name": "Algorithm key derivation (NAS/RRC/UP)",
    "section": "A.8",
    "fc": "0x69",
    "inputKey": "KAMF (for NAS keys) or KgNB/KSN (for RRC/UP keys)",
    "parameters": [
      { "id": "P0", "name": "algorithm type distinguisher", "length": "0x00 0x01" },
      { "id": "P1", "name": "algorithm identity", "length": "0x00 0x01" }
    ],
    "outputKey": "KNASint, KNASenc, KRRCint, KRRCenc, KUPint, KUPenc",
    "applicability": "All 5G — NAS, RRC, UP algorithm keys",
    "notes": "P0 type distinguishers: 0x01=N-NAS-enc-alg, 0x02=N-NAS-int-alg, 0x03=N-RRC-enc-alg, 0x04=N-RRC-int-alg, 0x05=N-UP-enc-alg, 0x06=N-UP-int-alg. Algorithm identity in 4 LSBs."
  },
  {
    "id": "kgnb",
    "name": "KgNB / KWAGF / KTNGF / KTWIF / KN3IWF derivation",
    "section": "A.9",
    "fc": "0x6E",
    "inputKey": "KAMF (256-bit)",
    "parameters": [
      { "id": "P0", "name": "uplink NAS COUNT", "length": "0x00 0x04" },
      { "id": "P1", "name": "access type distinguisher", "length": "0x00 0x01" }
    ],
    "outputKey": "KgNB (0x01=3GPP) or KWAGF/KTNGF/KTWIF/KN3IWF (0x02=non-3GPP)",
    "applicability": "Initial AS security establishment",
    "notes": "P1=0x01 for 3GPP access (KgNB), P1=0x02 for non-3GPP access. N5CW/AUN3 devices set uplink NAS COUNT to 0."
  },
  {
    "id": "nh",
    "name": "NH (Next Hop) derivation",
    "section": "A.10",
    "fc": "0x6F",
    "inputKey": "KAMF (256-bit)",
    "parameters": [
      { "id": "P0", "name": "SYNC-input (KgNB for initial, previous NH for subsequent)", "length": "0x00 0x20" }
    ],
    "outputKey": "NH",
    "applicability": "Handover key chaining",
    "notes": "Creates NH chain — each new NH derived from previous NH"
  },
  {
    "id": "kng-ran-star-gnb",
    "name": "KNG-RAN* derivation for target gNB",
    "section": "A.11",
    "fc": "0x70",
    "inputKey": "NH (256-bit) or current KgNB/KeNB",
    "parameters": [
      { "id": "P0", "name": "PCI (target physical cell ID)", "length": "0x00 0x02" },
      { "id": "P1", "name": "ARFCN-DL (absolute frequency of SSB)", "length": "0x00 0x03" }
    ],
    "outputKey": "KNG-RAN*",
    "applicability": "Handover to gNB, RRC_INACTIVE → RRC_CONNECTED",
    "notes": "NH used when NCC increases; current key used for horizontal derivation"
  },
  {
    "id": "kng-ran-star-ngenb",
    "name": "KNG-RAN* derivation for target ng-eNB",
    "section": "A.12",
    "fc": "0x71",
    "inputKey": "NH (256-bit) or current KgNB/KeNB",
    "parameters": [
      { "id": "P0", "name": "PCI (target physical cell ID)", "length": "0x00 0x02" },
      { "id": "P1", "name": "EARFCN-DL (target physical cell downlink frequency)", "length": "0x00 0x03" }
    ],
    "outputKey": "KNG-RAN*",
    "applicability": "Handover to ng-eNB",
    "notes": "Similar to A.11 but for ng-eNB targets (uses EARFCN-DL instead of ARFCN-DL)"
  },
  {
    "id": "kamf-prime-mobility",
    "name": "KAMF → KAMF' derivation in mobility",
    "section": "A.13",
    "fc": "0x72",
    "inputKey": "KAMF",
    "parameters": [
      { "id": "P0", "name": "DIRECTION (0x00=idle mode, 0x01=handover)", "length": "0x00 0x01" },
      { "id": "P1", "name": "COUNT (downlink NAS COUNT for HO, uplink for idle)", "length": "0x00 0x04" }
    ],
    "outputKey": "KAMF'",
    "applicability": "Handover and mobility registration updates",
    "notes": "Direction distinguishes idle mode mobility from handover"
  },
  {
    "id": "kasme-prime-idle",
    "name": "KAMF → KASME' derivation (5G→EPS idle mode)",
    "section": "A.14.1",
    "fc": "0x73",
    "inputKey": "KAMF",
    "parameters": [
      { "id": "P0", "name": "NAS uplink COUNT value", "length": "0x00 0x04" }
    ],
    "outputKey": "KASME'",
    "applicability": "5G to EPS interworking — idle mode",
    "notes": "Security context mapping from 5G to EPS during idle mode mobility"
  },
  {
    "id": "kasme-prime-ho",
    "name": "KAMF → KASME' derivation (5G→EPS handover)",
    "section": "A.14.2",
    "fc": "0x74",
    "inputKey": "KAMF",
    "parameters": [
      { "id": "P0", "name": "NAS downlink COUNT value", "length": "0x00 0x04" }
    ],
    "outputKey": "KASME'",
    "applicability": "5G to EPS interworking — handover",
    "notes": "Security context mapping from 5G to EPS during handover"
  },
  {
    "id": "kamf-prime-idle-eps",
    "name": "KASME → KAMF' derivation (EPS→5G idle mode)",
    "section": "A.15.1",
    "fc": "0x75",
    "inputKey": "KASME",
    "parameters": [
      { "id": "P0", "name": "NAS uplink COUNT of TAU in Registration Request", "length": "0x00 0x04" }
    ],
    "outputKey": "KAMF'",
    "applicability": "EPS to 5G interworking — idle mode",
    "notes": "Security context mapping from EPS to 5G during idle mode mobility"
  },
  {
    "id": "kamf-prime-ho-eps",
    "name": "KASME → KAMF' derivation (EPS→5G handover)",
    "section": "A.15.2",
    "fc": "0x76",
    "inputKey": "KASME",
    "parameters": [
      { "id": "P0", "name": "NH value", "length": "0x00 0x20" }
    ],
    "outputKey": "KAMF'",
    "applicability": "EPS to 5G interworking — handover",
    "notes": "Uses NH instead of COUNT for handover case"
  },
  {
    "id": "ksn",
    "name": "KSN derivation for dual connectivity",
    "section": "A.16",
    "fc": "0x79",
    "inputKey": "KeNB (MN=ng-eNB) or KgNB (MN=gNB)",
    "parameters": [
      { "id": "P0", "name": "SN Counter value", "length": "0x00 0x02" }
    ],
    "outputKey": "KSN",
    "applicability": "Dual connectivity and SCPAC",
    "notes": "SN Counter value must never be reused for same input KEY"
  },
  {
    "id": "sor-mac-iausf",
    "name": "SoR-MAC-IAUSF generation",
    "section": "A.17",
    "fc": "0x77",
    "inputKey": "KAUSF",
    "parameters": [
      { "id": "P0", "name": "SoR header", "length": "variable" },
      { "id": "P1", "name": "CounterSoR", "length": "variable" },
      { "id": "P2", "name": "SoR transparent container (beyond octet 22)", "length": "variable (optional)" }
    ],
    "outputKey": "SoR-MAC-IAUSF (128 least significant bits)",
    "applicability": "Steering of Roaming — AUSF side",
    "notes": "P2/L2 optional; matches Nausf_SoRProtection service operation"
  },
  {
    "id": "sor-mac-iue",
    "name": "SoR-MAC-IUE / SoR-XMAC-IUE generation",
    "section": "A.18",
    "fc": "0x78",
    "inputKey": "KAUSF",
    "parameters": [
      { "id": "P0", "name": "0x01 (SoR Acknowledgement)", "length": "0x00 0x01" },
      { "id": "P1", "name": "CounterSoR", "length": "variable" }
    ],
    "outputKey": "SoR-MAC-IUE / SoR-XMAC-IUE (128 least significant bits)",
    "applicability": "Steering of Roaming — UE side",
    "notes": "Fixed P0 value for acknowledgement"
  },
  {
    "id": "upu-mac-iausf",
    "name": "UPU-MAC-IAUSF generation",
    "section": "A.19",
    "fc": "0x7B",
    "inputKey": "KAUSF",
    "parameters": [
      { "id": "P0", "name": "UE Parameters Update Data (from octet 23 of TS 24.501 §9.11.3.53A)", "length": "variable" },
      { "id": "P1", "name": "CounterUPU", "length": "variable" }
    ],
    "outputKey": "UPU-MAC-IAUSF (128 least significant bits)",
    "applicability": "UE Parameters Update — AUSF side",
    "notes": "Parallels SoR-MAC-IAUSF for UE parameter updates"
  },
  {
    "id": "upu-mac-iue",
    "name": "UPU-MAC-IUE / UPU-XMAC-IUE generation",
    "section": "A.20",
    "fc": "0x7C",
    "inputKey": "KAUSF",
    "parameters": [
      { "id": "P0", "name": "0x01 (UPU Acknowledgement)", "length": "0x00 0x01" },
      { "id": "P1", "name": "CounterUPU", "length": "variable" }
    ],
    "outputKey": "UPU-MAC-IUE / UPU-XMAC-IUE (128 least significant bits)",
    "applicability": "UE Parameters Update — UE side",
    "notes": "Parallels SoR-MAC-IUE for UE parameter updates"
  },
  {
    "id": "kasme-srvcc",
    "name": "KAMF → KASME_SRVCC derivation",
    "section": "A.21",
    "fc": "0x7D",
    "inputKey": "KAMF",
    "parameters": [
      { "id": "P0", "name": "NAS downlink COUNT value", "length": "0x00 0x04" }
    ],
    "outputKey": "KASME_SRVCC",
    "applicability": "SRVCC from 5G to UTRAN CS",
    "notes": "Single-Radio Voice Call Continuity interworking"
  },
  {
    "id": "ktipsec-ktnap-kft",
    "name": "KTIPSec / KTNAP / KFT derivation",
    "section": "A.22",
    "fc": "0x84",
    "inputKey": "KTNGF (256-bit) or KTWIF (256-bit)",
    "parameters": [
      { "id": "P0", "name": "usage type distinguisher (0x01=IPSec, 0x02=TNAP, 0x03=FT)", "length": "0x00 0x01" }
    ],
    "outputKey": "KTIPSec (0x01) or KTNAP (0x02) or KFT (0x03)",
    "applicability": "Trusted non-3GPP access security",
    "notes": "Distinguisher determines which key is derived"
  },
  {
    "id": "kiab",
    "name": "KIAB (PSK) generation for IAB",
    "section": "A.23",
    "fc": "0x83",
    "inputKey": "KgNB (post-setup) or S-KgNB (EN-DC) or KSN (NR-DC)",
    "parameters": [
      { "id": "P0", "name": "IAB-donor-CU IP address", "length": "variable" },
      { "id": "P1", "name": "IAB-node DU IP address", "length": "variable" }
    ],
    "outputKey": "KIAB (full 256-bit KDF output used as PSK)",
    "applicability": "IAB (Integrated Access and Backhaul) F1 interface security",
    "notes": "Multiple variants for CP-UP separation (KIAB-CU-CP, KIAB-CU-UP). Full 256 bits used as PSK."
  }
]
KDFJSON

# --- 5b. Algorithm registry ---
cat > "$REPO_DIR/extracts/algorithms.json" << 'ALGJSON'
{
  "spec": "TS 33.501",
  "section": "5.11 / Annex D",
  "ciphering": [
    {
      "id": "0000",
      "name": "NEA0",
      "fullName": "Null ciphering algorithm",
      "keyLength": null,
      "description": "Generates a keystream of all zeroes; no confidentiality protection",
      "ref": "TS 33.501 Annex D.1"
    },
    {
      "id": "0001",
      "name": "128-NEA1",
      "fullName": "128-bit SNOW 3G based ciphering algorithm",
      "keyLength": 128,
      "description": "Stream cipher based on SNOW 3G",
      "ref": "TS 35.215"
    },
    {
      "id": "0010",
      "name": "128-NEA2",
      "fullName": "128-bit AES based ciphering algorithm",
      "keyLength": 128,
      "description": "AES in CTR mode",
      "ref": "TS 33.401 Annex B"
    },
    {
      "id": "0011",
      "name": "128-NEA3",
      "fullName": "128-bit ZUC based ciphering algorithm",
      "keyLength": 128,
      "description": "Stream cipher based on ZUC",
      "ref": "TS 35.221"
    }
  ],
  "integrity": [
    {
      "id": "0000",
      "name": "NIA0",
      "fullName": "Null Integrity Protection algorithm",
      "keyLength": null,
      "description": "Generates a 32-bit MAC of all zeroes; replay protection not activated",
      "ref": "TS 33.501 Annex D.1"
    },
    {
      "id": "0001",
      "name": "128-NIA1",
      "fullName": "128-bit SNOW 3G based integrity algorithm",
      "keyLength": 128,
      "description": "MAC function based on SNOW 3G",
      "ref": "TS 35.215"
    },
    {
      "id": "0010",
      "name": "128-NIA2",
      "fullName": "128-bit AES based integrity algorithm",
      "keyLength": 128,
      "description": "AES in CMAC mode",
      "ref": "TS 33.401 Annex B"
    },
    {
      "id": "0011",
      "name": "128-NIA3",
      "fullName": "128-bit ZUC based integrity algorithm",
      "keyLength": 128,
      "description": "MAC function based on ZUC",
      "ref": "TS 35.221"
    }
  ],
  "typeDistinguishers": [
    { "value": "0x01", "name": "N-NAS-enc-alg", "description": "NAS encryption algorithm" },
    { "value": "0x02", "name": "N-NAS-int-alg", "description": "NAS integrity algorithm" },
    { "value": "0x03", "name": "N-RRC-enc-alg", "description": "RRC encryption algorithm" },
    { "value": "0x04", "name": "N-RRC-int-alg", "description": "RRC integrity algorithm" },
    { "value": "0x05", "name": "N-UP-enc-alg", "description": "UP encryption algorithm" },
    { "value": "0x06", "name": "N-UP-int-alg", "description": "UP integrity algorithm" }
  ],
  "algorithmInputs": {
    "ciphering": {
      "key": "128-bit cipher key (KEY)",
      "count": "32-bit COUNT",
      "bearer": "5-bit BEARER identity",
      "direction": "1-bit DIRECTION (0=uplink, 1=downlink)",
      "length": "LENGTH of plaintext"
    },
    "integrity": {
      "key": "128-bit integrity key (KEY)",
      "count": "32-bit COUNT",
      "bearer": "5-bit BEARER identity",
      "direction": "1-bit DIRECTION (0=uplink, 1=downlink)",
      "message": "MESSAGE to protect"
    }
  }
}
ALGJSON

# --- 5c. ECIES profiles ---
cat > "$REPO_DIR/extracts/ecies-profiles.json" << 'ECIESPROF'
[
  {
    "id": "A",
    "schemeId": "0x1",
    "curve": "Curve25519",
    "dhPrimitive": "X25519 (RFC 7748 §5)",
    "pointCompression": false,
    "kdf": "ANSI-X9.63-KDF (SECG SEC 1 v2 §3.6.1)",
    "hash": "SHA-256",
    "sharedInfo1": "ephemeral public key octet string",
    "sharedInfo2": "empty string",
    "mac": "HMAC-SHA-256",
    "macKeyLen": 32,
    "macLen": 8,
    "enc": "AES-128-CTR",
    "encKeyLen": 16,
    "icbLen": 16,
    "ephPubKeySize": 32,
    "backwardsCompatibility": false,
    "schemeOutputSize": "256-bit public key + 64-bit MAC + input size"
  },
  {
    "id": "B",
    "schemeId": "0x2",
    "curve": "secp256r1",
    "dhPrimitive": "EC Cofactor Diffie-Hellman Primitive (SECG SEC 1 v2 §3.3.2)",
    "pointCompression": true,
    "kdf": "ANSI-X9.63-KDF (SECG SEC 1 v2 §3.6.1)",
    "hash": "SHA-256",
    "sharedInfo1": "ephemeral public key octet string",
    "sharedInfo2": "empty string",
    "mac": "HMAC-SHA-256",
    "macKeyLen": 32,
    "macLen": 8,
    "enc": "AES-128-CTR",
    "encKeyLen": 16,
    "icbLen": 16,
    "ephPubKeySize": 33,
    "backwardsCompatibility": false,
    "schemeOutputSize": "264-bit public key + 64-bit MAC + input size"
  }
]
ECIESPROF

# --- 5d. ECIES test vectors ---
cat > "$REPO_DIR/extracts/ecies-test-vectors.json" << 'ECIESTVJSON'
[
  {
    "id": "null-scheme-imsi",
    "profile": "null-scheme",
    "schemeId": "0x0",
    "supiType": "IMSI",
    "supi": { "mccMnc": "274012", "msin": "001002086" },
    "schemeInput": "00012080F6",
    "schemeOutput": "00012080F6"
  },
  {
    "id": "null-scheme-nai",
    "profile": "null-scheme",
    "schemeId": "0x0",
    "supiType": "NAI",
    "supi": { "nai": "verylongusername1@3gpp.com" },
    "schemeInput": "766572796C6F6E67757365726E616D6531",
    "schemeOutput": "useridverylongusername1"
  },
  {
    "id": "profile-a-imsi",
    "profile": "Profile A",
    "schemeId": "0x1",
    "supiType": "IMSI",
    "supi": { "mccMnc": "274012", "msin": "001002086" },
    "keys": {
      "homeNetworkPrivateKey": "c53c22208b61860b06c62e5406a7b330c2b577aa5558981510d128247d38bd1d",
      "homeNetworkPublicKey": "5a8d38864820197c3394b92613b20b91633cbd897119273bf8e4a6f4eec0a650",
      "ephPrivateKey": "c80949f13ebe61af4ebdbd293ea4f942696b9e815d7e8f0096bbf6ed7de62256",
      "ephPublicKey": "b2e92f836055a255837debf850b528997ce0201cb82adfe4be1f587d07d8457d",
      "ephSharedKey": "028ddf890ec83cdf163947ce45f6ec1a0e3070ea5fe57e2b1f05139f3e82422a",
      "ephEncKey": "2ba342cabd2b3b1e5e4e890da11b65f6",
      "icb": "e2622cb0cdd08204e721c8ea9b95a7c6",
      "ephMacKey": "d9846966fb7cf5fcf11266c5957dea60b83fff2b7c940690a4bfe57b1eb52bd2"
    },
    "schemeInput": "00012080f6",
    "ciphertext": "cb02352410",
    "macTag": "cddd9e730ef3fa87",
    "schemeOutput": "b2e92f836055a255837debf850b528997ce0201cb82adfe4be1f587d07d8457dcb02352410cddd9e730ef3fa87"
  },
  {
    "id": "profile-a-nai",
    "profile": "Profile A",
    "schemeId": "0x1",
    "supiType": "NAI",
    "supi": { "nai": "verylongusername1@3gpp.com" },
    "keys": {
      "homeNetworkPrivateKey": "C53C22208B61860B06C62E5406A7B330C2B577AA5558981510D128247D38BD1D",
      "homeNetworkPublicKey": "5A8D38864820197C3394B92613B20B91633CBD897119273BF8E4A6F4EEC0A650",
      "ephPrivateKey": "BE9EFF3E9F22A4B42A3D236E7A6C500B3F2E7E0C7449988BA800D664BF4FCD97",
      "ephPublicKey": "977D8B2FDAA7B64AA700D04227D5B440630EA4EC50F9082273A26BB678C92222",
      "ephSharedKey": "511C1DF473BB88317F923501F8BA944FD3B667D25699DCB552DBCEF60BBDC56D",
      "ephEncKey": "FE77B87D87F40428EDD71BCA69D79059",
      "ephMacKey": "D87B69F4FE8CD6B211264EA5E69F682F151A82252684CDB15A047E6EF0595028"
    },
    "schemeInput": "766572796C6F6E67757365726E616D6531",
    "ciphertext": "8E358A1582ADB15322C10E515141D2039A",
    "macTag": "12E1D7783A97F1AC",
    "schemeOutput": "ecckey977D8B2FDAA7B64AA700D04227D5B440630EA4EC50F9082273A26BB678C92222.cip8E358A1582ADB15322C10E515141D2039A.mac12E1D7783A97F1AC"
  },
  {
    "id": "profile-b-imsi",
    "profile": "Profile B",
    "schemeId": "0x2",
    "supiType": "IMSI",
    "supi": { "mccMnc": "274012", "msin": "001002086" },
    "keys": {
      "homeNetworkPublicKeyUncompressed": "0472DA71976234CE833A6907425867B82E074D44EF907DFB4B3E21C1C2256EBCD15A7DED52FCBB097A4ED250E036C7B9C8C7004C4EEDC4F068CD7BF8D3F900E3B4",
      "homeNetworkPublicKeyCompressed": "0272DA71976234CE833A6907425867B82E074D44EF907DFB4B3E21C1C2256EBCD1",
      "homeNetworkPrivateKey": "F1AB1074477EBCC7F554EA1C5FC368B1616730155E0041AC447D6301975FECDA",
      "ephPublicKeyCompressed": "039AAB8376597021E855679A9778EA0B67396E68C66DF32C0F41E9ACCA2DA9B9D1",
      "ephPublicKeyUncompressed": "049AAB8376597021E855679A9778EA0B67396E68C66DF32C0F41E9ACCA2DA9B9D1D1F44EA1C87AA7478B954537BDE79951E748A43294A4F4CF86EAFF1789C9C81F",
      "ephPrivateKey": "99798858A1DC6A2C68637149A4B1DBFD1FDFF5ADDD62A2142F06699ED7602529",
      "ephSharedKey": "6C7E6518980025B982FBB2FF746E3C2E85A196D252099A7AD23EA7B4C0959CAE",
      "ephEncKey": "8A65C3AED80295C12BD55087E965702A",
      "icb": "EF285B4061C3BAEE858AB6EC68487DAE",
      "ephMacKey": "A5EBAC0BC48D9CF7AE5CE39CD840AC6C761AEC04078FAB954D634F923E901C64"
    },
    "schemeInput": "00012080F6",
    "ciphertext": "46A33FC271",
    "macTag": "6AC7DAE96AA30A4D",
    "schemeOutput": "039AAB8376597021E855679A9778EA0B67396E68C66DF32C0F41E9ACCA2DA9B9D146A33FC2716AC7DAE96AA30A4D"
  },
  {
    "id": "profile-b-nai",
    "profile": "Profile B",
    "schemeId": "0x2",
    "supiType": "NAI",
    "supi": { "nai": "verylongusername1@3gpp.com" },
    "keys": {
      "homeNetworkPublicKeyUncompressed": "0472DA71976234CE833A6907425867B82E074D44EF907DFB4B3E21C1C2256EBCD15A7DED52FCBB097A4ED250E036C7B9C8C7004C4EEDC4F068CD7BF8D3F900E3B4",
      "homeNetworkPublicKeyCompressed": "0272DA71976234CE833A6907425867B82E074D44EF907DFB4B3E21C1C2256EBCD1",
      "homeNetworkPrivateKey": "F1AB1074477EBCC7F554EA1C5FC368B1616730155E0041AC447D6301975FECDA",
      "ephPublicKeyCompressed": "03759BB22C563D9F4A6B3C1419E543FC2F39D6823F02A9D71162B39399218B244B",
      "ephPrivateKey": "90A5898BD29FFA3F261E00E980067C70A2B1B992A21F5B4FEF6D4DF69FE804AD",
      "ephSharedKey": "BC3529ED79541CF8C007CE9806330F4A5FF15064D7CF4B16943EF8F007597872",
      "ephEncKey": "84F9A78995D39E6968047547ECC12C4F",
      "ephMacKey": "39D5517E965F8E1252B61345ED45226C5F1A8C69F03D6C91437591F0B8E48FA0"
    },
    "schemeInput": "766572796C6F6E67757365726E616D6531",
    "ciphertext": "BE22D8B9F856A52ED381CD7EAF4CF2D525",
    "macTag": "3CDDC61A0A7882EB",
    "schemeOutput": "ecckey03759BB22C563D9F4A6B3C1419E543FC2F39D6823F02A9D71162B39399218B244B.cipBE22D8B9F856A52ED381CD7EAF4CF2D525.mac3CDDC61A0A7882EB"
  }
]
ECIESTVJSON

# --- 5e. Protection schemes ---
cat > "$REPO_DIR/extracts/protection-schemes.json" << 'PROTJSON'
[
  { "id": "0x0", "name": "null-scheme", "description": "No concealment — SUPI transmitted in the clear" },
  { "id": "0x1", "name": "Profile A", "description": "ECIES with Curve25519 (X25519 DH, AES-128-CTR, HMAC-SHA-256)" },
  { "id": "0x2", "name": "Profile B", "description": "ECIES with secp256r1 (EC Cofactor DH, AES-128-CTR, HMAC-SHA-256)" },
  { "range": "0x3-0xB", "name": "Reserved", "description": "Reserved for future standardized protection schemes" },
  { "range": "0xC-0xF", "name": "Proprietary", "description": "Reserved for proprietary protection schemes specified by the home operator" }
]
PROTJSON

###############################################################################
# 6. TypeScript source — types
###############################################################################
echo "--- Writing TypeScript source files..."

cat > "$REPO_DIR/src/lib/types.ts" << 'TYPESTS'
export interface ParsedParagraph {
  style: string;
  text: string;
  heading_level: number | null;
}

export interface ParsedSection {
  id: string;
  filename: string;
  heading: string;
  content: string;
}

export interface ParsedTable {
  index: number;
  rows: string[][];
}

export interface SpecMetadata {
  spec: string;
  version: string;
  release: number;
  date: string;
  title: string;
  sectionCount: number;
  paragraphCount: number;
  tableCount: number;
}

export interface KdfParameter {
  id: string;
  name: string;
  length: string;
}

export interface KdfEntry {
  id: string;
  name: string;
  section: string;
  fc: string | null;
  inputKey: string | null;
  parameters: KdfParameter[];
  outputKey: string | null;
  applicability: string;
  notes: string;
}

export interface AlgorithmEntry {
  id: string;
  name: string;
  fullName: string;
  keyLength: number | null;
  description: string;
  ref: string;
}

export interface TypeDistinguisher {
  value: string;
  name: string;
  description: string;
}

export interface AlgorithmRegistry {
  spec: string;
  section: string;
  ciphering: AlgorithmEntry[];
  integrity: AlgorithmEntry[];
  typeDistinguishers: TypeDistinguisher[];
  algorithmInputs: {
    ciphering: Record<string, string>;
    integrity: Record<string, string>;
  };
}

export interface EciesProfile {
  id: string;
  schemeId: string;
  curve: string;
  dhPrimitive: string;
  pointCompression: boolean;
  kdf: string;
  hash: string;
  sharedInfo1: string;
  sharedInfo2: string;
  mac: string;
  macKeyLen: number;
  macLen: number;
  enc: string;
  encKeyLen: number;
  icbLen: number;
  ephPubKeySize: number;
  backwardsCompatibility: boolean;
  schemeOutputSize: string;
}

export interface EciesTestVector {
  id: string;
  profile: string;
  schemeId: string;
  supiType: string;
  supi: Record<string, string>;
  keys?: Record<string, string>;
  schemeInput: string;
  ciphertext?: string;
  macTag?: string;
  schemeOutput: string;
}

export interface ProtectionScheme {
  id?: string;
  range?: string;
  name: string;
  description: string;
}

export interface SearchResult {
  sectionId: string;
  heading: string;
  snippet: string;
  score: number;
}
TYPESTS

###############################################################################
# 7. TypeScript source — indexer
###############################################################################
cat > "$REPO_DIR/src/lib/indexer.ts" << 'INDEXERTS'
import { readFileSync, readdirSync, existsSync } from 'node:fs';
import { join } from 'node:path';
import type { ParsedSection, SearchResult } from './types.js';

export class SpecIndex {
  private sections: Map<string, ParsedSection> = new Map();

  constructor(private specDir: string) {}

  load(): void {
    const sectionsDir = join(this.specDir, 'sections');
    if (!existsSync(sectionsDir)) {
      throw new Error(`Sections directory not found: ${sectionsDir}`);
    }

    const files = readdirSync(sectionsDir).filter(f => f.endsWith('.md')).sort();
    for (const file of files) {
      const content = readFileSync(join(sectionsDir, file), 'utf-8');
      const heading = content.split('\n').find(l => l.startsWith('#'))?.replace(/^#+\s*/, '').trim() ?? file;
      const id = file.replace('section-', '').replace('.md', '');
      this.sections.set(id, { id, filename: file, heading, content });
    }
  }

  getSection(id: string): ParsedSection | undefined {
    // Try exact match first
    if (this.sections.has(id)) return this.sections.get(id);

    // Try case-insensitive partial match
    const normalized = id.toLowerCase().replace(/\./g, '-');
    for (const [key, section] of this.sections) {
      if (key.toLowerCase() === normalized) return section;
    }

    // Try matching by heading content
    for (const [, section] of this.sections) {
      if (section.heading.toLowerCase().includes(id.toLowerCase())) return section;
    }

    return undefined;
  }

  listSections(): ParsedSection[] {
    return Array.from(this.sections.values());
  }

  search(query: string, limit = 10): SearchResult[] {
    const terms = query.toLowerCase().split(/\s+/).filter(Boolean);
    const results: SearchResult[] = [];

    for (const [, section] of this.sections) {
      const lowerContent = section.content.toLowerCase();
      const lowerHeading = section.heading.toLowerCase();

      let score = 0;
      let allTermsFound = true;

      for (const term of terms) {
        const contentMatches = (lowerContent.match(new RegExp(escapeRegex(term), 'g')) || []).length;
        const headingMatches = (lowerHeading.match(new RegExp(escapeRegex(term), 'g')) || []).length;

        if (contentMatches === 0 && headingMatches === 0) {
          allTermsFound = false;
          break;
        }

        score += contentMatches + headingMatches * 5;
      }

      if (!allTermsFound) continue;

      // Extract snippet around first match
      const firstTermIdx = lowerContent.indexOf(terms[0]);
      const snippetStart = Math.max(0, firstTermIdx - 60);
      const snippetEnd = Math.min(section.content.length, firstTermIdx + 120);
      let snippet = section.content.slice(snippetStart, snippetEnd).replace(/\n/g, ' ').trim();
      if (snippetStart > 0) snippet = '...' + snippet;
      if (snippetEnd < section.content.length) snippet = snippet + '...';

      results.push({ sectionId: section.id, heading: section.heading, snippet, score });
    }

    return results.sort((a, b) => b.score - a.score).slice(0, limit);
  }
}

function escapeRegex(str: string): string {
  return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}
INDEXERTS

###############################################################################
# 8. TypeScript source — parser
###############################################################################
cat > "$REPO_DIR/src/lib/parser.ts" << 'PARSERTS'
import { writeFileSync, mkdirSync, existsSync } from 'node:fs';
import { join } from 'node:path';

interface Paragraph {
  style: string;
  text: string;
  heading_level: number | null;
}

export async function parseDocx(docxPath: string, outputDir: string): Promise<void> {
  // Dynamic import so mammoth is only required when actually ingesting
  const mammoth = await import('mammoth');

  if (!existsSync(outputDir)) {
    mkdirSync(outputDir, { recursive: true });
  }

  const sectionsDir = join(outputDir, 'sections');
  mkdirSync(sectionsDir, { recursive: true });

  // Convert DOCX to HTML
  const result = await mammoth.convertToHtml({ path: docxPath });

  // Also extract raw text with style info
  const rawResult = await mammoth.extractRawText({ path: docxPath });

  // Parse HTML into paragraphs
  const paragraphs = parseHtmlToParagraphs(result.value);

  // Write full.json
  writeFileSync(join(outputDir, 'full.json'), JSON.stringify(paragraphs, null, 2));

  // Build markdown
  const markdown = paragraphsToMarkdown(paragraphs);
  writeFileSync(join(outputDir, 'full.md'), markdown);

  // Extract tables
  const tables = extractTables(result.value);
  writeFileSync(join(outputDir, 'tables.json'), JSON.stringify(tables, null, 2));

  // Split into sections
  const sections = splitIntoSections(paragraphs);
  let sectionCount = 0;
  for (const [sectionId, content] of Object.entries(sections)) {
    const filename = `section-${sectionId}.md`;
    writeFileSync(join(sectionsDir, filename), content);
    sectionCount++;
  }

  // Write metadata
  const meta = {
    spec: 'Unknown',
    version: '0.0.0',
    release: 0,
    date: new Date().toISOString().slice(0, 7),
    title: 'Parsed 3GPP specification',
    sectionCount,
    paragraphCount: paragraphs.length,
    tableCount: tables.length,
  };
  writeFileSync(join(outputDir, 'meta.json'), JSON.stringify(meta, null, 2));

  console.log(`Parsed ${paragraphs.length} paragraphs into ${sectionCount} sections`);
  if (result.messages.length > 0) {
    console.log(`Warnings: ${result.messages.length}`);
  }
}

function parseHtmlToParagraphs(html: string): Paragraph[] {
  const paragraphs: Paragraph[] = [];
  // Simple regex-based HTML parsing for headings and paragraphs
  const blockRegex = /<(h[1-6]|p|li)[^>]*>([\s\S]*?)<\/\1>/gi;
  let match;
  while ((match = blockRegex.exec(html)) !== null) {
    const tag = match[1].toLowerCase();
    const text = stripHtml(match[2]).trim();
    if (!text) continue;

    let headingLevel: number | null = null;
    let style = 'Normal';
    if (tag.startsWith('h')) {
      headingLevel = parseInt(tag[1], 10);
      style = `Heading${headingLevel}`;
    } else if (tag === 'li') {
      style = 'ListParagraph';
    }

    paragraphs.push({ style, text, heading_level: headingLevel });
  }
  return paragraphs;
}

function stripHtml(html: string): string {
  return html.replace(/<[^>]+>/g, '').replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&nbsp;/g, ' ').replace(/&#\d+;/g, '');
}

function paragraphsToMarkdown(paragraphs: Paragraph[]): string {
  return paragraphs
    .map(p => {
      if (p.heading_level) return '#'.repeat(p.heading_level) + ' ' + p.text;
      return p.text;
    })
    .join('\n\n');
}

function extractTables(html: string): { index: number; rows: string[][] }[] {
  const tables: { index: number; rows: string[][] }[] = [];
  const tableRegex = /<table[^>]*>([\s\S]*?)<\/table>/gi;
  let tableMatch;
  let idx = 0;
  while ((tableMatch = tableRegex.exec(html)) !== null) {
    const rows: string[][] = [];
    const rowRegex = /<tr[^>]*>([\s\S]*?)<\/tr>/gi;
    let rowMatch;
    while ((rowMatch = rowRegex.exec(tableMatch[1])) !== null) {
      const cells: string[] = [];
      const cellRegex = /<t[dh][^>]*>([\s\S]*?)<\/t[dh]>/gi;
      let cellMatch;
      while ((cellMatch = cellRegex.exec(rowMatch[1])) !== null) {
        cells.push(stripHtml(cellMatch[1]).trim());
      }
      if (cells.length > 0) rows.push(cells);
    }
    if (rows.length > 0) tables.push({ index: idx++, rows });
  }
  return tables;
}

function splitIntoSections(paragraphs: Paragraph[]): Record<string, string> {
  const sections: Record<string, string> = {};
  let currentId = 'frontmatter';
  let currentContent: string[] = [];

  for (const p of paragraphs) {
    if (p.heading_level && p.heading_level <= 3) {
      // Save previous section
      if (currentContent.length > 0) {
        sections[currentId] = currentContent.join('\n');
      }
      // Derive section ID from heading text
      const headingMatch = p.text.match(/^([A-Z]?\d+(?:\.\d+)*|[A-Z](?:\.\d+)*|Annex\s+[A-Z]|Foreword)/i);
      if (headingMatch) {
        currentId = headingMatch[1].replace(/\./g, '-').replace(/\s+/g, '-');
      } else {
        currentId = p.text.slice(0, 30).replace(/[^a-zA-Z0-9]/g, '-').replace(/-+/g, '-').toLowerCase();
      }
      currentContent = ['#'.repeat(p.heading_level) + ' ' + p.text];
    } else {
      const line = p.heading_level ? '#'.repeat(p.heading_level) + ' ' + p.text : p.text;
      currentContent.push(line);
    }
  }

  // Save last section
  if (currentContent.length > 0) {
    sections[currentId] = currentContent.join('\n');
  }

  return sections;
}
PARSERTS

###############################################################################
# 9. TypeScript source — CLI entry point
###############################################################################
cat > "$REPO_DIR/src/cli.ts" << 'CLITS'
#!/usr/bin/env node
import { Command } from 'commander';
import { searchCommand } from './commands/search.js';
import { sectionCommand } from './commands/section.js';
import { listCommand } from './commands/list.js';
import { kdfCommand } from './commands/kdf.js';
import { algorithmsCommand } from './commands/algorithms.js';
import { eciesCommand } from './commands/ecies.js';
import { ingestCommand } from './commands/ingest.js';

const program = new Command();

program
  .name('3gpp')
  .description('CLI toolkit for querying 3GPP security specifications')
  .version('0.1.0');

program.addCommand(searchCommand);
program.addCommand(sectionCommand);
program.addCommand(listCommand);
program.addCommand(kdfCommand);
program.addCommand(algorithmsCommand);
program.addCommand(eciesCommand);
program.addCommand(ingestCommand);

program.parse();
CLITS

###############################################################################
# 10. CLI commands
###############################################################################

# --- search ---
cat > "$REPO_DIR/src/commands/search.ts" << 'SEARCHTS'
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
SEARCHTS

# --- section ---
cat > "$REPO_DIR/src/commands/section.ts" << 'SECTIONTS'
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
SECTIONTS

# --- list ---
cat > "$REPO_DIR/src/commands/list.ts" << 'LISTTS'
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
LISTTS

# --- kdf ---
cat > "$REPO_DIR/src/commands/kdf.ts" << 'KDFTS'
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
KDFTS

# --- algorithms ---
cat > "$REPO_DIR/src/commands/algorithms.ts" << 'ALGTS'
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
ALGTS

# --- ecies ---
cat > "$REPO_DIR/src/commands/ecies.ts" << 'ECIESTS'
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
ECIESTS

# --- ingest ---
cat > "$REPO_DIR/src/commands/ingest.ts" << 'INGESTTS'
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
INGESTTS

# --- helpers (shared resolver) ---
cat > "$REPO_DIR/src/commands/helpers.ts" << 'HELPERSTS'
import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));

export function resolveSpecDir(specId: string): string {
  return join(__dirname, '..', '..', 'specs', specId);
}
HELPERSTS

###############################################################################
# 11. CI workflow
###############################################################################
echo "--- Writing CI workflow..."

cat > "$REPO_DIR/.github/workflows/ci.yml" << 'CIYML'
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
        with:
          version: 9
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: pnpm
      - run: pnpm install --frozen-lockfile
      - run: pnpm build
      - name: Smoke test — CLI help
        run: node dist/cli.js --help
      - name: Smoke test — list sections
        run: node dist/cli.js list
      - name: Smoke test — KDF catalog
        run: node dist/cli.js kdf
      - name: Smoke test — algorithms
        run: node dist/cli.js algorithms
      - name: Smoke test — ECIES profiles
        run: node dist/cli.js ecies
      - name: Smoke test — search
        run: node dist/cli.js search "SUPI concealment"
      - name: Validate JSON extracts
        run: |
          for f in extracts/*.json; do
            echo "Validating $f..."
            node -e "JSON.parse(require('fs').readFileSync('$f', 'utf-8'))"
          done
CIYML

###############################################################################
# 12. README
###############################################################################
echo "--- Writing README..."

cat > "$REPO_DIR/README.md" << 'README'
# 3GPP Security Toolkit

Machine-readable extracts and CLI tools for 3GPP security specifications. Start with **TS 33.501** (5G Security Architecture).

## What's inside

- **`specs/`** — Parsed specifications broken into queryable sections (142 sections, 5885 paragraphs)
- **`extracts/`** — Machine-readable JSON for key data:
  - `kdfs.json` — All 23 KDF specifications from Annex A (FC values, parameters, keys)
  - `algorithms.json` — NEA/NIA cipher and integrity algorithm registry
  - `ecies-profiles.json` — ECIES Profile A (Curve25519) and B (secp256r1) parameters
  - `ecies-test-vectors.json` — 6 complete test vectors from Annex C.4
  - `protection-schemes.json` — SUPI concealment scheme identifiers
- **`src/`** — TypeScript CLI for searching and querying spec data

## Quick start

```bash
pnpm install
pnpm build

# Search the spec
node dist/cli.js search "SUPI concealment"

# Show a specific section
node dist/cli.js section A.2

# List all sections
node dist/cli.js list

# Query KDF catalog
node dist/cli.js kdf              # Summary table
node dist/cli.js kdf KAUSF        # Full details for KAUSF derivation

# Show algorithm registry
node dist/cli.js algorithms
node dist/cli.js algorithms --type cipher

# ECIES profiles and test vectors
node dist/cli.js ecies            # Comparison table
node dist/cli.js ecies A          # Profile A details
node dist/cli.js ecies --schemes  # Protection scheme IDs
node dist/cli.js ecies --test-vectors

# Ingest a new 3GPP DOCX
node dist/cli.js ingest path/to/spec.docx --spec ts33102 --version v18
```

## Using the extracts directly

The JSON files in `extracts/` are designed to be consumed programmatically:

```typescript
import kdfs from './extracts/kdfs.json';
import algorithms from './extracts/algorithms.json';
import profiles from './extracts/ecies-profiles.json';
import vectors from './extracts/ecies-test-vectors.json';

// Find a KDF by FC value
const kausf = kdfs.find(k => k.fc === '0x6A');

// Get all integrity algorithms
const intAlgs = algorithms.integrity;

// Get Profile A parameters
const profileA = profiles.find(p => p.id === 'A');
```

## Spec coverage

| Spec | Version | Status |
|------|---------|--------|
| TS 33.501 | V20.0.0 (2026-01) | Parsed — 142 sections |

## License

MIT — See [LICENSE](./LICENSE).

Parsed spec data is derived from 3GPP specifications which are subject to [3GPP terms](https://www.3gpp.org/specifications/specification-numbering).
README

###############################################################################
# Done
###############################################################################
echo ""
echo "==> Repo created at: $REPO_DIR"
echo "==> Next steps:"
echo "    cd $REPO_DIR"
echo "    pnpm install"
echo "    pnpm build"
echo "    node dist/cli.js --help"
echo ""
echo "==> To create GitHub repo:"
echo "    cd $REPO_DIR"
echo "    git init && git add -A && git commit -m 'feat: initial 3GPP security toolkit'"
echo "    gh repo create typhon-sec/3gpp-security-toolkit --public --source=. --push"
