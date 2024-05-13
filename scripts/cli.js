#!/usr/bin/env node

import { Command } from 'commander'
import { generate as generateSql } from '../code_gen/generate_sql_schema.js'

const program = new Command()

program.name('data-schema').description('CLI to work with data schema & generate related code').version('0.0.1')

program
  .command('gen_sql')
  .description('Generate SQL Schema from the provided YAML data document files')
  .argument('string', 'file path')
  .requiredOption('-v, --varient <number>', 'SQL varient can be: 1 - Postgres, 2 - MySQL & 3 - SQLite')
  .requiredOption('-o, --output', 'weather to write the output to a file')
  .action(generateSql)

program.parse(process.argv)
