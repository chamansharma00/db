// 🧩 MongoDB Practical — Q.26: Using MapReduce on zip.json Collection

// 🔹 Step 1: Create a Manual zip.json File

// In Ubuntu terminal, open a new file:
nano zip.json

// Paste the following sample dataset inside:
[
  { "_id": "1001", "city": "TIMKEN",  "state": "KS", "pop": 1500 },
  { "_id": "1002", "city": "HAYS",    "state": "KS", "pop": 1800 },
  { "_id": "1003", "city": "WICHITA", "state": "KS", "pop": 389000 },
  { "_id": "1004", "city": "DENVER",  "state": "CO", "pop": 715000 },
  { "_id": "1005", "city": "BOULDER", "state": "CO", "pop": 108000 },
  { "_id": "1006", "city": "DALLAS",  "state": "TX", "pop": 1300000 },
  { "_id": "1007", "city": "AUSTIN",  "state": "TX", "pop": 950000 }
]

// Save and exit:
// Ctrl + O → Enter → Ctrl + X


// 🔹 Step 2: Import zip.json into MongoDB

mongoimport --db test --collection zipcodes --file zip.json --jsonArray

// ✅ Output:
connected to: mongodb://localhost/
imported 7 documents


// 🔹 Step 3: Verify Import in Mongo Shell

mongosh
use test
db.zipcodes.find().pretty()

// ✅ Output:
{
  "_id": "1001",
  "city": "TIMKEN",
  "state": "KS",
  "pop": 1500
}
... (and remaining documents)


// 🔹 Step 4: MapReduce — Find Total Population in Each State

// Map Function
var mapStatePop = function() {
  emit(this.state, this.pop);
};

// Reduce Function
var reduceStatePop = function(key, values) {
  return Array.sum(values);
};

// Execute MapReduce
db.zipcodes.mapReduce(
  mapStatePop,
  reduceStatePop,
  { out: "state_population" }
)

// ✅ Output:
{
  result: "state_population",
  ok: 1
}


// 🔹 Step 5: View Total Population of Each State
db.state_population.find().pretty()

// ✅ Output:
{ "_id": "KS", "value": 392300 }
{ "_id": "CO", "value": 823000 }
{ "_id": "TX", "value": 2250000 }


// 🔹 Step 6: Verify All Collections in Database
show collections

// ✅ Output:
zipcodes
state_population
