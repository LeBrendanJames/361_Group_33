/* 
Course: CS361
Group: Group 33
Project: HW Assignment 6: Integration of UI, ballot structure, and database.
Notes: Server side code base sourced from various OSU CS290 homework materials.
*/

var express = require('express');
var mysql = require('./dbcon.js');
const Ballot = require('./ballot.js'); //**ADDED**

var app = express();
var handlebars = require('express-handlebars').create({defaultLayout:'main'});
var bodyParser = require('body-parser');

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

const path = require('path');
app.use(express.static(path.resolve(__dirname, 'public')));

app.engine('handlebars', handlebars.engine);
app.set('view engine', 'handlebars');
app.set('port', 20067);


/*
* Select all voting items for review.
*/
app.get('/review', function(req, res) {
	//var context = {};
	
	var ballot = new Ballot.Ballot("fakeBallotName", "fakeUsername");
	var options = ["Bob Ross", "Superman"];
	ballot.addVotingItem(new Ballot.VotingItem("Governor", options, 0));
	ballot.addVotingItem(new Ballot.VotingItem("Senator", options, 0));
	ballot.addVotingItem(new Ballot.VotingItem("3rd District Representative", options, 0));
	
	//console.log(ballot.getVotingItemByNum(1));
	
	/*
	mysql.pool.query('SELECT * FROM _____', function(err, rows, fields){
		if(err){
			next(err);
			return;
		}
		rowJSON = JSON.parse(JSON.stringify(rows));
		
		// Create ballot object 
		ballot = new ballot(req.ballotName, req.username);
		
		// Add each row from SQL SELECT as a voting item in ballot object
		for (int i = 0; i < rowJSON.size(); i++){
			ballot.addVotingItem(rowJSON[i]);
		}
    
		res.render('review', ballot);
	});
	*/
	
	res.render('review', ballot);
});


// 404
app.use(function(req,res){
  res.status(404);
  res.render('404');
});

// 500
app.use(function(err, req, res, next){
  console.error(err.stack);
  res.status(500);
  res.render('500');
});

app.listen(app.get('port'), function(){
  console.log('Express started on http://localhost:' + app.get('port') + '; press Ctrl-C to terminate.');
});
