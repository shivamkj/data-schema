## Data Schema

All Files related to Schema Management for the Qnify School Information System

### Commands

1. Generate SQL schema (Postgres varient) from a yaml schema document: `node scripts/cli.js gen_sql modules/4.payment_collection/schema.yaml -v 1 -o`
2. Generate SQL schema for all modules (formatted & linted): `node scripts/process_schema.js --format --lint --all`