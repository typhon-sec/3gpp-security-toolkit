import { join, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));

export function resolveSpecDir(specId: string): string {
  return join(__dirname, '..', '..', 'specs', specId);
}
