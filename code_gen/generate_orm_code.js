import { join } from 'path'
import { write, exitWithError } from 'bash-node'
import { validateJoi, parseYamlFile } from './helpers.js'
import { id, notNull, randomId, schema } from './yaml_schema.js'

const outputPath = 'test_data/models/'

export function generate(allFiles) {
  for (const filePath of allFiles) {
    const tableDetails = parseYamlFile(filePath)
    const isValid = validateJoi(tableDetails, schema)
    if (!isValid) exitWithError(`error in file: ${filePath}`)

    let ormCode = `import { DataTypes, Model } from '@sequelize/core';
import { Attribute, STRING, SMALLINT, INTEGER, BIGINT, BOOLEAN, JSON, BLOB } from '@sequelize/core/decorators-legacy';\n`

    for (const table of tableDetails) {
      ormCode += genrateOrmCode(table) + '\n'
    }

    var filename = filePath.replace(/^.*[\\/]/, '').replace('yaml', 'js')
    const outputFile = join(outputPath, filename)
    write(outputFile, ormCode)
  }

  console.log('Successfully processed !')
}

const typeMapping = {
  string: 'STRING',
  int16: 'SMALLINT',
  int32: 'INTEGER',
  int64: 'BIGINT',
  bool: 'BOOLEAN',
  json: 'JSON',
  binary: 'BLOB',
  time: 'BIGINT',
  enum: 'SMALLINT',
}

export function genrateOrmCode(tableDetails) {
  const columns = []

  for (const column of tableDetails.properties) {
    const attributes = [`@Attribute(DataTypes.${typeMapping[column.type]})`]
    if (column.tags?.includes(id) || column.tags?.includes(randomId)) {
      attributes.push('@PrimaryKey')
    }
    if (column.tags?.includes(notNull)) {
      attributes.push(`@NotNull`)
    }
    columns.push(`\t${attributes.join('\n\t')}\n\t${column._name};`)
  }

  return `
export class ${tableDetails.name} extends Model {
${columns.join('\n\n')}
}`
}
