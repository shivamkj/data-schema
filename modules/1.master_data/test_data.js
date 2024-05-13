import { randomInt } from '../../test_data/util.js'
import { knex } from '../../test_data/index.js'

// Generate Classes
export const generateClass = async () => {
  const classes = []
  for (let index = 1; index < 13; index++) {
    classes.push({ name: `${index}` })
  }
  await knex('_class').insert(classes)
}

export const generateSection = async () => {
  // Generate Sections
  const classes = await knex('_class').select('*')
  for (const cls of classes) {
    const sectionsCount = randomInt(1, 5)
    const sections = []
    for (let index = 0; index < sectionsCount; index++) {
      sections.push({ name: String.fromCharCode(65 + index), class_id: cls.id })
    }
    await knex('section').insert(sections)
  }
}
