import createKnex from 'knex'
import { generateAttendance, generateOffDay } from '../modules/3.attendance/test_data.js'
import { generateClass, generateSection } from '../modules/1.master_data/test_data.js'
import { generateStudent } from '../modules/2.student/test_data.js'

export const knex = createKnex({
  client: 'pg',
  connection: 'postgresql://shivam:pass@localhost/local',
  searchPath: ['public'],
  useNullAsDefault: true,
})

// const knex = createKnex({
//   client: 'sqlite3',
//   connection: {
//     filename: '/home/shivam/sqlite.db',
//   },
//   useNullAsDefault: true,
// });

// // Master Data
// await generateClass()
// await generateSection()

// // Student
// await generateStudent()

// Attendance
await generateAttendance()
// await generateOffDay()

process.exit(0)
