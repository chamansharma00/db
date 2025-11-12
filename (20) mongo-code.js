// 🧩 Step 1: Create / Switch Database
use DYPIT

// 🧩 Step 2: Create Collections
db.createCollection("Teachers")
db.createCollection("Students")

// 🧩 Step 3: Insert Sample Documents
db.Teachers.insertMany([
  { Tname: "Praveen", dno: 1, dname: "Computer", experience: 5, salary: 30000, date_of_joining: "2018-06-10" },
  { Tname: "Rajesh", dno: 2, dname: "IT", experience: 8, salary: 28000, date_of_joining: "2016-07-12" },
  { Tname: "Sneha", dno: 3, dname: "E&TC", experience: 6, salary: 26000, date_of_joining: "2017-09-01" },
  { Tname: "Amit", dno: 4, dname: "Computer", experience: 10, salary: 40000, date_of_joining: "2013-01-20" },
  { Tname: "Ravi", dno: 5, dname: "IT", experience: 9, salary: 24000, date_of_joining: "2014-12-15" }
])

db.Students.insertMany([
  { Sname: "Rohan", roll_no: 25, class: "TYCO" },
  { Sname: "XYZ", roll_no: 10, class: "SYIT" },
  { Sname: "Priya", roll_no: 2, class: "FYETC" }
])

// 🧩 Step 4: Find the information about two teachers
db.Teachers.find().limit(2).pretty()

// 🧩 Step 5: Find all teachers of Computer department
db.Teachers.find({ dname: "Computer" }).pretty()

// 🧩 Step 6: Find teachers of Computer, IT, and E&TC department
db.Teachers.find({ dname: { $in: ["Computer", "IT", "E&TC"] } }).pretty()

// 🧩 Step 7: Find teachers of Computer, IT, and E&TC department having salary ≥ 25000
db.Teachers.find({
  dname: { $in: ["Computer", "IT", "E&TC"] },
  salary: { $gte: 25000 }
}).pretty()

// 🧩 Step 8: Find student having roll_no = 25 or Sname = "xyz"
db.Students.find({
  $or: [{ roll_no: 25 }, { Sname: "xyz" }]
}).pretty()


// ⚠️ MongoDB is case-sensitive, so make sure names match exactly as inserted.

// 🧩 Step 9: Update teacher Praveen’s experience to 10 years or insert new entry
db.Teachers.updateOne(
  { Tname: "Praveen" },
  { $set: { experience: 10 } },
  { upsert: true }
)

// 🧩 Step 10: Update department of all IT teachers to COMP
db.Teachers.updateMany(
  { dname: "IT" },
  { $set: { dname: "COMP" } }
)

// 🧩 Step 11: Find teachers’ names and experiences only
db.Teachers.find({}, { _id: 0, Tname: 1, experience: 1 }).pretty()

// 🧩 Step 12: Using save() method to insert a record in Department collection
db.createCollection("Department")

db.Department.save({ dept_no: 101, dept_name: "Computer", location: "Building A" })

// 🧩 Step 13: Using save() to change Rajesh’s department to IT
db.Teachers.save({ Tname: "Rajesh", dno: 2, dname: "IT", experience: 8, salary: 28000, date_of_joining: "2016-07-12" })


// ⚠️ Note: save() replaces the whole document if _id matches. Use carefully.

// 🧩 Step 14: Delete all documents from Teachers having IT dept
db.Teachers.deleteMany({ dname: "IT" })

// 🧩 Step 15: Display first 5 teachers in ascending order
db.Teachers.find().sort({ Tname: 1 }).limit(5).pretty()


// ✅ Final Tip:
// You can list all databases and collections anytime with:

show dbs
show collections