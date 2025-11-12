// 🧩 Step 1: Create / Switch Database
use DYPIT

// 🧩 Step 2: Create Collections
db.createCollection("Teachers")
db.createCollection("Students")

// 🧩 Step 3: Insert Sample Data
db.Teachers.insertMany([
  { Tname: "Praveen", dno: 1, dname: "Computer", experience: 5, salary: 30000, date_of_joining: "2018-06-10" },
  { Tname: "Rajesh", dno: 2, dname: "IT", experience: 8, salary: 28000, date_of_joining: "2016-07-12" },
  { Tname: "Sneha", dno: 3, dname: "E&TC", experience: 6, salary: 26000, date_of_joining: "2017-09-01" },
  { Tname: "Amit", dno: 4, dname: "Computer", experience: 10, salary: 40000, date_of_joining: "2013-01-20" },
  { Tname: "Ravi", dno: 5, dname: "IT", experience: 9, salary: 22000, date_of_joining: "2014-12-15" }
])

db.Students.insertMany([
  { Sname: "Rohan", roll_no: 2, class: "TYCO" },
  { Sname: "XYZ", roll_no: 10, class: "SYIT" },
  { Sname: "Priya", roll_no: 3, class: "FYETC" }
])

// 🧩 1️⃣ Find the information about all teachers
db.Teachers.find().pretty()

// 🧩 2️⃣ Find the average salary of Computer department teachers
db.Teachers.aggregate([
  { $match: { dname: "Computer" } },
  { $group: { _id: "Computer Department", avg_salary: { $avg: "$salary" } } }
])

// 🧩 3️⃣ Find the minimum and maximum salary of E&TC department teachers
db.Teachers.aggregate([
  { $match: { dname: "E&TC" } },
  { $group: {
      _id: "E&TC Department",
      min_salary: { $min: "$salary" },
      max_salary: { $max: "$salary" }
  }}
])

// 🧩 4️⃣ Find teachers of Computer, IT, and E&TC departments having salary ≥ 10000
db.Teachers.find({
  dname: { $in: ["Computer", "IT", "E&TC"] },
  salary: { $gte: 10000 }
}).pretty()

// 🧩 5️⃣ Find student info with roll_no = 2 or Sname = "xyz"
db.Students.find({
  $or: [{ roll_no: 2 }, { Sname: "xyz" }]
}).pretty()


// ⚠️ Remember: MongoDB is case-sensitive — so “xyz” ≠ “XYZ”.

// 🧩 6️⃣ Update Praveen’s experience to 10 years, or insert if not exists
db.Teachers.updateOne(
  { Tname: "Praveen" },
  { $set: { experience: 10 } },
  { upsert: true }
)

// 🧩 7️⃣ Update department of all IT teachers to COMP
db.Teachers.updateMany(
  { dname: "IT" },
  { $set: { dname: "COMP" } }
)

// 🧩 8️⃣ Find only teachers’ names and experiences
db.Teachers.find({}, { _id: 0, Tname: 1, experience: 1 }).pretty()

// 🧩 9️⃣ Using save() to insert an entry in Department collection
db.createCollection("Department")

db.Department.save({ dept_no: 101, dept_name: "Computer", location: "Building A" })

// 🧩 🔟 Find total salary of all teachers
db.Teachers.aggregate([
  { $group: { _id: "Total Salary", total_salary: { $sum: "$salary" } } }
])

// ✅ Useful Helper Commands
show dbs
show collections
db.Teachers.countDocuments()
db.Teachers.find().sort({ Tname: 1 }).pretty()