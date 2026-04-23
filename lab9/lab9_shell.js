use dinara

// ======================
// PART 3 – FIND
// ======================

// 1
db.products.find({});

// 2
db.products.find(
    { category: "Electronics" },
    { name: 1, price: 1, _id: 0 }
);

// 3
db.products.find({ price: { $gt: 50 } }).sort({ price: -1 });

// ======================
// INSERT
// ======================

db.products.insertOne({
    _id: 6,
    name: "Bluetooth Speaker",
    price: 49.99,
    category: "Electronics",
    tags: ["speaker", "audio"],
    stock: 60
});

// ======================
// UPDATE
// ======================

// 5
db.products.updateMany(
    { category: "Electronics" },
    { $mul: { price: 1.1 } }
);

// 6
db.products.updateOne(
    { name: "Smart Watch" },
    { $push: { tags: "best-seller" } }
);

// ======================
// DELETE
// ======================

// 7
db.products.deleteOne({ _id: 6 });

// 8
db.products.deleteMany({ stock: { $lt: 10 } });

// ======================
// PART 4 – OPERATORS
// ======================

// 1
db.products.find({ price: { $gte: 20, $lte: 100 } });

// 2
db.orders.find({ status: { $in: ["pending", "shipped"] } });

// 3
db.products.find({ tags: "wireless" });

// 4
db.orders.find({ customer: { $ne: "Alice" } });

// ======================
// PART 5 – AGGREGATION
// ======================

// 1 Total revenue
db.orders.aggregate([
    { $group: { _id: null, totalRevenue: { $sum: "$total" } } }
]);

// 2 Avg per customer
db.orders.aggregate([
    { $group: { _id: "$customer", avgOrder: { $avg: "$total" } } }
]);

// 3 Top-selling products
db.orders.aggregate([
    { $unwind: "$items" },
    {
        $group: {
            _id: "$items.productId",
            totalSold: { $sum: "$items.quantity" }
        }
    },
    {
        $lookup: {
            from: "products",
            localField: "_id",
            foreignField: "_id",
            as: "productInfo"
        }
    }
]);

// 4 Monthly orders
db.orders.aggregate([
    {
        $group: {
            _id: { $month: "$date" },
            count: { $sum: 1 }
        }
    }
]);