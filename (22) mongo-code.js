// 🧩 Step 1: Create / Switch Database
use DYPIT
// ✅ Acknowledge change:
db


// 🧩 Step 2: Create Collections
db.createCollection("Teachers")
db.createCollection("Students")


// ✅ Acknowledge change:
show collections

// 🧩 Step 3: Insert Sample Data
db.Teachers.insertMany([
  { Tname: "Praveen", dno: 1, dname: "Computer", experience: 5, salary: 30000, date_of_joining: "2018-06-10" },
  { Tname: "Rajesh", dno: 2, dname: "IT", experience: 8, salary: 28000, date_of_joining: "2016-07-12" },
  { Tname: "Sneha", dno: 3, dname: "E&TC", experience: 6, salary: 26000, date_of_joining: "2017-09-01" },
  { Tname: "Amit", dno: 4, dname: "Computer", experience: 10, salary: 40000, date_of_joining: "2013-01-20" },
  { Tname: "Ravi", dno: 5, dname: "IT", experience: 9, salary: 22000, date_of_joining: "2014-12-15" }
])

// ✅ Acknowledge change:
db.Teachers.find().pretty()

// 1️⃣ Display department-wise average salary
db.Teachers.aggregate([
  { $group: { _id: "$dname", avg_salary: { $avg: "$salary" } } }
])

// ✅ Check: Shows each department name and its average salary.

// 2️⃣ Display number of employees working in each department
db.Teachers.aggregate([
  { $group: { _id: "$dname", employee_count: { $sum: 1 } } }
])

// ✅ Check:Displays department name with total number of teachers.

// 3️⃣ Display department-wise total salary where total ≥ 50000
db.Teachers.aggregate([
  { $group: { _id: "$dname", total_salary: { $sum: "$salary" } } },
  { $match: { total_salary: { $gte: 50000 } } }
])

// ✅ Check:Only departments with total salary ≥ 50000 will appear.

// 4️⃣ Queries using operators like $max, $min, $avg, $sum
// Maximum salary among all teachers
db.Teachers.aggregate([{ $group: { _id: null, max_salary: { $max: "$salary" } } }])

// Minimum salary among all teachers
db.Teachers.aggregate([{ $group: { _id: null, min_salary: { $min: "$salary" } } }])

// Average experience
db.Teachers.aggregate([{ $group: { _id: null, avg_experience: { $avg: "$experience" } } }])

// Total salary of all teachers
db.Teachers.aggregate([{ $group: { _id: null, total_salary: { $sum: "$salary" } } }])

// ✅ Check:Each aggregation prints a single JSON object with computed values.


// 5️⃣ Create unique index on any field (e.g., Tname)
db.Teachers.createIndex({ Tname: 1 }, { unique: true })

// ✅ Acknowledge change:
db.Teachers.getIndexes()

// If you try inserting a duplicate Tname, MongoDB will reject it.


// 6️⃣ Create compound index on multiple fields

// (Example: on dname and salary)
db.Teachers.createIndex({ dname: 1, salary: -1 })

// ✅ Acknowledge change:
db.Teachers.getIndexes()

// This index helps queries that filter/sort by department and salary.

// 7️⃣ Show all indexes created in database DYPIT
// ⚠️ MongoDB does not have a database-wide command,
// but you can check collection-wise like this:
show collections

// Then for each collection:
db.<collection_name>.getIndexes()


// Example:
db.Teachers.getIndexes()
db.Students.getIndexes()

// ✅ Acknowledge:
// It lists all index names, types, and key fields.


// 8️⃣ Show all indexes created in the above collections (individually)
db.Teachers.getIndexes()
db.Students.getIndexes()

// ✅ Check Output Example:
[
  { "v": 2, "key": { "_id": 1 }, "name": "_id_" },
  { "v": 2, "unique": true, "key": { "Tname": 1 }, "name": "Tname_1" },
  { "v": 2, "key": { "dname": 1, "salary": -1 }, "name": "dname_1_salary_-1" }
]

// 🧠 Optional Useful Commands
// show dbs                   # List all databases
// db.stats()                 # Show database statistics
// db.Teachers.stats()        # Show collection statistics
// db.dropDatabase()          # Delete current database