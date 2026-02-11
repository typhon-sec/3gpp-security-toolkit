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
