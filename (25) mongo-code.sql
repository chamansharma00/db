// 🧩 MongoDB Practical — Q.25: Using MapReduce in MongoDB

// 🔹 Step 1: Use / Create Database
use DYPIT

// ✅ Output:
switched to db DYPIT


// 🔹 Step 2: Create a Collection called ‘employees’
db.createCollection("employees")

// ✅ Output:
{ ok: 1 }


// 🔹 Step 3: Insert Employee Records
db.employees.insertMany([
  {
    "id": 0,
    "name": "Leanne Flinn",
    "email": "leanne.flinn@unilogic.com",
    "work": "Unilogic",
    "age": 27,
    "gender": "Male",
    "Salary": 16660,
    "hobbies": "Acrobatics,Photography,Papier-Mache"
  },
  {
    "id": 1,
    "name": "Jane Doe",
    "email": "jane.doe@unilogic.com",
    "work": "Unilogic",
    "age": 25,
    "gender": "Female",
    "Salary": 20000,
    "hobbies": "Photography,Reading"
  },
  {
    "id": 2,
    "name": "John Smith",
    "email": "john.smith@cybertech.com",
    "work": "CyberTech",
    "age": 30,
    "gender": "Male",
    "Salary": 22000,
    "hobbies": "Gaming,Photography"
  }
])

// ✅ Output:
{
  acknowledged: true,
  insertedIds: [
    ObjectId("..."), ObjectId("..."), ObjectId("...")
  ]
}


// 🔹 Step 4: Verify Inserted Documents
db.employees.find().pretty()

// ✅ Output:
{
  "_id": ObjectId("..."),
  "id": 0,
  "name": "Leanne Flinn",
  "email": "leanne.flinn@unilogic.com",
  "work": "Unilogic",
  "age": 27,
  "gender": "Male",
  "Salary": 16660,
  "hobbies": "Acrobatics,Photography,Papier-Mache"
}
... (and other documents)


// 🔹 Step 5: MapReduce — Count of Males and Females

// Map Function
var mapGender = function() {
  emit(this.gender, 1);
};

// Reduce Function
var reduceGender = function(key, values) {
  return Array.sum(values);
};

// Execute MapReduce
db.employees.mapReduce(
  mapGender,
  reduceGender,
  { out: "gender_count" }
)

// ✅ Output:
{
  result: "gender_count",
  ok: 1
}


// 🔹 Step 6: View Result of Gender Count
db.gender_count.find().pretty()

// ✅ Output:
{ "_id": "Male", "value": 2 }
{ "_id": "Female", "value": 1 }


// 🔹 Step 7: MapReduce — Count of Users in Each Hobby

// Map Function
var mapHobbies = function() {
  var hobbiesList = this.hobbies.split(",");
  for (var i = 0; i < hobbiesList.length; i++) {
    emit(hobbiesList[i].trim(), 1);
  }
};

// Reduce Function
var reduceHobbies = function(key, values) {
  return Array.sum(values);
};

// Execute MapReduce
db.employees.mapReduce(
  mapHobbies,
  reduceHobbies,
  { out: "hobby_count" }
)

// ✅ Output:
{
  result: "hobby_count",
  ok: 1
}


// 🔹 Step 8: View Result of Hobby Count
db.hobby_count.find().pretty()

// ✅ Output:
{ "_id": "Photography", "value": 3 }
{ "_id": "Acrobatics", "value": 1 }
{ "_id": "Papier-Mache", "value": 1 }
{ "_id": "Reading", "value": 1 }
{ "_id": "Gaming", "value": 1 }


// 🔹 Step 9: Verify All Collections Created
show collections

// ✅ Output:
employees
gender_count
hobby_count
