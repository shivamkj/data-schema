import { fakerEN_IN as faker } from '@faker-js/faker'
import { knex } from '../../test_data/index.js'
import { randomInt } from '../../test_data/util.js'

// Generate Students for every section
export const generateStudent = async () => {
  const sections = await knex('section').select('*')
  for (const sec of sections) {
    const students = []
    // female students
    const femaleCount = randomInt(17, 23)
    for (let index = 0; index < femaleCount; index++) {
      students.push(randomStudent('female', sec.id))
    }
    // male students
    const maleCount = randomInt(17, 23)
    for (let index = 0; index < maleCount; index++) {
      students.push(randomStudent('male', sec.id))
    }
    await knex('student').insert(students)
  }
}

const randomStudent = (gender, section_id) => ({
  first_name: faker.person.firstName(gender),
  last_name: faker.person.lastName(gender),
  section_id: section_id,
})
