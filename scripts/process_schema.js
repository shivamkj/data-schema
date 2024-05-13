import { minimist, fg, write, $ } from 'bash-node'
import { generate as generateSql } from '../code_gen/generate_sql_schema.js'
import { sqlCopyrightHeader } from './constants.js'

// Automation script to genrate sql schema from all yaml files, format, lint them & also generate a combined schema

const args = minimist(process.argv.slice(2))

const inputFiles = fg.sync('modules/**/*.yaml')
const outputs = [{ dialect: 'postgres' }]
if (args.all) {
  outputs.push({ dialect: 'mysql' })
  outputs.push({ dialect: 'sqlite' })
}

// for (const [index, output] of outputs) {
for (let index = 0; index < outputs.length; index++) {
  const output = outputs[index]
  let combinedSql = []

  for (const filePath of inputFiles) {
    const generatedSQL = generateSql(filePath, { varient: index + 1 })

    // write individual modules schema in schema.sql inside module directory only for postgres
    if (output.dialect == 'postgres') {
      const sqlFilePath = filePath.replace('yaml', 'sql')
      write(sqlFilePath, sqlCopyrightHeader + '\n' + generatedSQL)
      console.log(sqlFilePath, filePath)
    }

    combinedSql.push(generatedSQL)
  }

  // write combined sql file for all modules inside modules directory
  write(`modules/${output.dialect}.sql`, sqlCopyrightHeader + '\n' + combinedSql.join('\n'))

  if (args.f || args.format) {
    if (output.dialect == 'postgres') {
      $('sqlfluff format --dialect postgres modules/**/schema.sql')
    }
    $(`sqlfluff format --dialect ${output.dialect} modules/${output.dialect}.sql`)
  }

  if (args.l || args.lint) {
    $(`sqlfluff lint --dialect "${output.dialect}" modules/${output.dialect}.sql`)
  }
}

console.log('Processed Successfully, Everything looks good!')
