var faker = require('faker');
var mysql = require('mysql');
var express = require('express');
var bodyParser = require('body-parser')
var app = express();

app.set("view engine", "ejs");
app.use(bodyParser.urlencoded({extended: true}));
app.use(express.static(__dirname + "/Public"));


var connection = mysql.createConnection({
	host: 'localhost',
	user: 'root',
	database: 'join_us'
});



/* Bulk inserting 500 users */
/*
var data = []
for (var i=0; i < 500; i++) {
	data.push([
		faker.internet.email(),
		faker.date.past()
	]);
}
var q = 'INSERT INTO users (email, created_at) VALUES ?';

connection.query(q, [data], function (error, result) {
	if (error) throw error;
	console.log(result);
});

connection.end();
*/


app.get("/", function(req, res){
	console.log("Someone requested us!");
	
	var q = "SELECT COUNT(*) AS count FROM users";
	connection.query(q, function(error, results) {
		if (error) throw error;
		count = results[0].count
		//res.send("We have " + count + " users who have joined us.");
		res.render("home", {count: count});
	})
});

app.post("/register", function(req,res){
	//console.log("POST request sent to /register " + req.body.email)
	var person = {
		email: req.body.email
	};
	
	connection.query('INSERT INTO users SET ?', person, function(error, result) {
		if (error) throw error;
		console.log(result);
		res.redirect("/");
	})
})

app.get("/joke", function(req, res){
	console.log("Requested joke");
	res.send("Knock knock...<em>wHo'S tHeRe???</em>");
});

app.get("/random_num", function(req, res){
	console.log("Requested random number");
	var random_num = Math.floor((Math.random() * 10) + 1);
	res.send("Random number generator gives you.... " + random_num);
});

app.listen(8080, function(){
	console.log("Server running on 8080")
});