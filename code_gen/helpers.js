import { read, exitWithError } from 'bash-node'
import { loadAll, YAMLException } from 'js-yaml'

export function validateJoi(objList, schema) {
  for (const obj of objList) {
    const result = schema.validate(obj)
    if (result.error) {
      for (const error of result.error.details) {
        console.error('Error Message: ', error.message, '& Context: ', error.context)
      }
      return false
    }
  }
  return true
}

// return a list of objects, even if yaml has single document
export function parseYamlFile(filePath) {
  try {
    return loadAll(read(filePath))
  } catch (err) {
    if (err instanceof YAMLException) {
      exitWithError('yaml parsing error: ' + err.reason)
    } else {
      exitWithError(err)
    }
  }
}
