// 🧩 MongoDB Practical — Q.24: Design and Implement Queries on ‘games’ Collection

// 🔹 Step 1: Use / Create Database
use DYPIT

// ✅ Output:
switched to db DYPIT


// 🔹 Step 2: Create a Collection called ‘games’
db.createCollection("games")

// ✅ Output:
{ ok: 1 }


// 🔹 Step 3: Insert 5 Games into the Collection
db.games.insertMany([
  { name: "Valorant", gametype: "Shooter", rating: 95 },
  { name: "Minecraft", gametype: "Sandbox", rating: 90 },
  { name: "FIFA 24", gametype: "Sports", rating: 85 },
  { name: "GTA V", gametype: "Action", rating: 98 },
  { name: "Among Us", gametype: "Strategy", rating: 80 }
])

// ✅ Output:
{
  acknowledged: true,
  insertedIds: [
    ObjectId("..."), ObjectId("..."), ObjectId("..."),
    ObjectId("..."), ObjectId("...")
  ]
}


// 🔹 Step 4: Query to Display All Games
db.games.find().pretty()

// ✅ Output:
{
  "_id": ObjectId("..."),
  "name": "Valorant",
  "gametype": "Shooter",
  "rating": 95
}
{
  "name": "Minecraft",
  "gametype": "Sandbox",
  "rating": 90
}
... (and so on for all 5 games)


// 🔹 Step 5: Query to Display Top 3 Highest Rated Games
db.games.find().sort({ rating: -1 }).limit(3)

// ✅ Output:
{ name: "GTA V", rating: 98 }
{ name: "Valorant", rating: 95 }
{ name: "Minecraft", rating: 90 }

// 📘 Analysis:
// The sort() method arranges documents in descending order of rating.
// The limit(3) ensures only the top 3 records are returned.


// 🔹 Step 6: Update Two Favourite Games with Achievements
db.games.updateOne(
  { name: "GTA V" },
  { $set: { achievements: ["Game Master", "Speed Demon"] } }
)

db.games.updateOne(
  { name: "Valorant" },
  { $set: { achievements: ["Game Master", "Speed Demon"] } }
)

// ✅ Output:
{ acknowledged: true, modifiedCount: 1 }

// 📘 Analysis:
// The $set operator adds or updates the field "achievements" in selected documents.


// 🔹 Step 7: Query to Display Games Having Both Achievements
db.games.find({ achievements: { $all: ["Game Master", "Speed Demon"] } })

// ✅ Output:
{ name: "GTA V", achievements: ["Game Master", "Speed Demon"] }
{ name: "Valorant", achievements: ["Game Master", "Speed Demon"] }

// 📘 Analysis:
// The $all operator matches arrays that contain all specified elements.


// 🔹 Step 8: Query to Display Games That Have Achievements
db.games.find({ achievements: { $exists: true } })

// ✅ Output:
{ name: "GTA V", achievements: [...] }
{ name: "Valorant", achievements: [...] }

// 📘 Analysis:
// The $exists operator checks if a field exists in a document.


// 🔹 Step 9: Verify All Games in Collection
db.games.find().pretty()


// ✅ Example Output:
{
  "name": "GTA V",
  "gametype": "Action",
  "rating": 98,
  "achievements": ["Game Master", "Speed Demon"]
}
{
  "name": "Valorant",
  "gametype": "Shooter",
  "rating": 95,
  "achievements": ["Game Master", "Speed Demon"]
}
{
  "name": "Minecraft",
  "gametype": "Sandbox",
  "rating": 90
}
{
  "name": "FIFA 24",
  "gametype": "Sports",
  "rating": 85
}
{
  "name": "Among Us",
  "gametype": "Strategy",
  "rating": 80
}