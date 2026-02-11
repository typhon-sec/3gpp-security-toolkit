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
