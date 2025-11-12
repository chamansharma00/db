// 🧩 MongoDB Practical — Q.27: Using MapReduce on 'books' Collection

// 🔹 Step 1: Use / Create Database
use library

// ✅ Output:
switched to db library


// 🔹 Step 2: Create Collection ‘books’
db.createCollection("books")

// ✅ Output:
{ ok: 1 }


// 🔹 Step 3: Insert Sample Book Records
db.books.insertMany([
  { _id: 1, title: "Python Basics", pages: 180 },
  { _id: 2, title: "MongoDB in Action", pages: 320 },
  { _id: 3, title: "Data Structures", pages: 240 },
  { _id: 4, title: "Web Development", pages: 410 },
  { _id: 5, title: "AI Fundamentals", pages: 150 },
  { _id: 6, title: "Cloud Computing", pages: 280 }
])

// ✅ Output:
{ acknowledged: true, insertedIds: [...] }


// 🔹 Step 4: Verify Inserted Documents
db.books.find().pretty()

// ✅ Output:
{
  "_id": 1,
  "title": "Python Basics",
  "pages": 180
}
... (and remaining books)


// 🔹 Step 5: Define Map Function
var mapBooks = function() {
  if (this.pages < 250) {
    emit("Small Book", 1);
  } else {
    emit("Big Book", 1);
  }
};


// 🔹 Step 6: Define Reduce Function
var reduceBooks = function(key, values) {
  return Array.sum(values);
};


// 🔹 Step 7: Execute MapReduce
db.books.mapReduce(
  mapBooks,
  reduceBooks,
  { out: "book_size_summary" }
)

// ✅ Output:
{
  result: "book_size_summary",
  ok: 1
}


// 🔹 Step 8: Display the Result
db.book_size_summary.find().pretty()

// ✅ Output:
{ "_id": "Small Book", "value": 3 }
{ "_id": "Big Book", "value": 3 }


// 🔹 Step 9: Verify Collections in 'library' Database
show collections

// ✅ Output:
books
book_size_summary
