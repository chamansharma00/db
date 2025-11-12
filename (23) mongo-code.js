// 🧩 MongoDB Practical — Q.23: Create Index and Fire Queries
// 🔹 Step 1: Create a sample zip.json file manually

// Run this command in your Ubuntu terminal:

nano zip.json


// Now paste this custom dataset (kept small and realistic):
// 
[
  { "_id": "1001", "city": "TIMKEN", "loc": [ -99.1234, 38.7167 ], "pop": 1500, "state": "KS" },
  { "_id": "1002", "city": "HAYS", "loc": [ -99.3268, 38.8792 ], "pop": 1800, "state": "KS" },
  { "_id": "1003", "city": "WICHITA", "loc": [ -97.3375, 37.6922 ], "pop": 389000, "state": "KS" },
  { "_id": "1004", "city": "DENVER", "loc": [ -104.9903, 39.7392 ], "pop": 715000, "state": "CO" },
  { "_id": "1005", "city": "DALLAS", "loc": [ -96.7970, 32.7767 ], "pop": 1300000, "state": "TX" }
]


// Save and exit:

// Ctrl + O → Enter → Ctrl + X

// 🔹 Step 2: Import the file into MongoDB

// Run this:

mongoimport --db test --collection zipcodes --file zip.json


// ✅ Output:

connected to: mongodb://localhost/
imported 5 documents

// 🔹 Step 3: Verify the data import
// 
// Open Mongo shell:

mongosh


// Then:

use test
db.zipcodes.find().pretty()


// ✅ You should see your 5 documents printed neatly.
// 
// 🔹 Step 4: Create Indexes
// 🟢 (a) Single Field Index

// On the field city:

db.zipcodes.createIndex({ city: 1 })


// ✅ Output:

"city_1"

// 🟢 (b) Composite Index

// On fields state and pop:

db.zipcodes.createIndex({ state: 1, pop: -1 })


// ✅ Output:

"state_1_pop_-1"

// 🟢 (c) Multikey Index

// We’ll make loc an indexed field (since it’s an array of coordinates):

db.zipcodes.createIndex({ loc: 1 })


// ✅ Output:

"loc_1"

// 🔹 Step 5: Fire Queries and Analyze
// (1) Display all cities having population above 1600
db.zipcodes.find({ pop: { $gt: 1600 } }, { city: 1, pop: 1, _id: 0 })


// ✅ Output:

{ city: "HAYS", pop: 1800 }
{ city: "WICHITA", pop: 389000 }
{ city: "DENVER", pop: 715000 }
{ city: "DALLAS", pop: 1300000 }


// 📘 Analysis:
// The $gt operator efficiently uses the index on pop (if created) to filter large populations faster.

// (2) Display all cities in state “KS”
db.zipcodes.find({ state: "KS" }, { city: 1, state: 1, _id: 0 })


// ✅ Output:

{ city: "TIMKEN", state: "KS" }
{ city: "HAYS", state: "KS" }
{ city: "WICHITA", state: "KS" }


// 📘 Analysis:
// The composite index on { state: 1, pop: -1 } improves filtering by state.

// (3) Display location of city "TIMKEN"
db.zipcodes.find({ city: "TIMKEN" }, { city: 1, loc: 1, _id: 0 })


// ✅ Output:

{ city: "TIMKEN", loc: [ -99.1234, 38.7167 ] }


// 📘 Analysis:
// The single field index on city makes this lookup very fast.

// 🔹 Step 6: View All Indexes Created
db.zipcodes.getIndexes()


// ✅ Output:

// [
//   { v: 2, key: { _id: 1 }, name: "_id_" },
//   { v: 2, key: { city: 1 }, name: "city_1" },
//   { v: 2, key: { state: 1, pop: -1 }, name: "state_1_pop_-1" },
//   { v: 2, key: { loc: 1 }, name: "loc_1" }
// ]