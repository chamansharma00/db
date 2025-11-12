// ⚙️ Step-by-Step MongoDB Commands for Terminal
// # 1️⃣ Start Mongo Shell
mongosh


// Then inside the Mongo shell, enter these commands one by one 👇

// Create and switch to database
use DYPIT

// Create collections (optional — auto-created on first insert)
db.createCollection("Teachers")
db.createCollection("Students")

// Insert sample data
db.Teachers.insertMany([
  { Tname: "Praveen", dno: 1, dname: "COMP", experience: 5, salary: 12000, date_of_joining: "2015-06-10" },
  { Tname: "Rajesh", dno: 2, dname: "IT", experience: 7, salary: 9500, date_of_joining: "2016-07-12" },
  { Tname: "Sneha", dno: 3, dname: "E&TC", experience: 10, salary: 15000, date_of_joining: "2013-09-01" },
  { Tname: "Kiran", dno: 4, dname: "COMP", experience: 8, salary: 11000, date_of_joining: "2014-02-25" }
])

db.Students.insertMany([
  { Sname: "Vaibhav", roll_no: 1, class: "TYCOMP" },
  { Sname: "xyz", roll_no: 2, class: "SYIT" },
  { Sname: "Rahul", roll_no: 3, class: "BEENTC" }
])

// 1️⃣ Show all teachers
db.Teachers.find()

// 2️⃣ Show all teachers of Computer department
db.Teachers.find({ dname: "COMP" })

// 3️⃣ Show all teachers of Computer, IT, and E&TC
db.Teachers.find({ dname: { $in: ["COMP", "IT", "E&TC"] } })

// 4️⃣ Teachers of COMP, IT, E&TC with salary >= 10000
db.Teachers.find({
  dname: { $in: ["COMP", "IT", "E&TC"] },
  salary: { $gte: 10000 }
})

// 5️⃣ Student having roll_no = 2 OR Sname = 'xyz'
db.Students.find({
  $or: [{ roll_no: 2 }, { Sname: "xyz" }]
})

// 6️⃣ Update Praveen's experience to 10 years (insert if not exists)
db.Teachers.updateOne(
  { Tname: "Praveen" },
  { $set: { experience: 10, dname: "COMP", dno: 1, salary: 12000, date_of_joining: "2015-06-10" } },
  { upsert: true }
)

// 7️⃣ Update all IT teachers to COMP
db.Teachers.updateMany(
  { dname: "IT" },
  { $set: { dname: "COMP" } }
)

// 8️⃣ Show only Tname and experience of all teachers
db.Teachers.find({}, { _id: 0, Tname: 1, experience: 1 })

// 9️⃣ Insert one record using save()
db.Teachers.save({
  Tname: "Neha",
  dno: 5,
  dname: "IT",
  experience: 3,
  salary: 9000,
  date_of_joining: "2020-01-10"
})

// 🔟 Change Rajesh’s department to IT using save()
// First get his ID
db.Teachers.find({ Tname: "Rajesh" })


// 📌 Copy the _id shown in the output, e.g.:
// { _id: ObjectId("67321c6a83a41d12e56f4f23"), Tname: 'Rajesh', ... }


// Then run this:

db.Teachers.save({
  _id: ObjectId("67321c6a83a41d12e56f4f23"),
  Tname: "Rajesh",
  dno: 2,
  dname: "IT",
  experience: 7,
  salary: 9500,
  date_of_joining: "2016-07-12"
})


// Continue 👇
// 1️⃣1️⃣ Delete all teachers from IT dept
db.Teachers.deleteMany({ dname: "IT" })

// 1️⃣2️⃣ Show first 3 teachers sorted by name (pretty output)
db.Teachers.find().sort({ Tname: 1 }).limit(3).pretty()

// Show all documents after all operations
db.Teachers.find().pretty()
db.Students.find().pretty()

// ✅ Notes
// Concept	-- Meaning
// use DYPIT --	Switch or create database
// .insertMany() --	Add multiple records
// .find() --	Display records
// .updateOne() / .updateMany()	-- Modify existing records
// { upsert: true }	-- Insert if not exists
// .save()	-- Insert or overwrite record (old Mongo method)
// .deleteMany() --	Remove matching records
// .pretty() --	Formats JSON output cleanly
// .sort() and .limit()	-- For ordering and limiting results