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


app.get('/vote', function(req, res) {
	
	
	res.render('vote', ballot);
});

app.get('/overview', function(req, res) {
	
	
	
	res.render('overview', ballot);
});


/*
* Select all voting items for review.
*/
app.get('/review', function(req, res) {
	
	//var ballot = new Ballot.Ballot("fakeBallotName", "fakeUsername");
	var options = ["Bob Ross", "Superman"];
	//ballot.addVotingItem(new Ballot.VotingItem("Governor", options, 0));
	//ballot.addVotingItem(new Ballot.VotingItem("Senator", options, 0));
	//ballot.addVotingItem(new Ballot.VotingItem("3rd District Representative", options, 0));
	
	//console.log("req.query[username] = " + req.query['username']);

	
	//mysql.pool.query('SELECT t1.questionID, t1.questionTitle, t1.questionURL, t2.responsePK, t2.responseID, t2.responseTitle, t2.responseSubTitle, t3.responseFK, t3.writeInResponse FROM tblQuestion t1 LEFT JOIN tblResponse t2 ON t1.questionPK = t2.questionFK LEFT JOIN tblVoterToResponse t3 ON t1.questionPK = t3.questionFK AND t3.voterFK = (SELECT voterFK FROM tblUserLogin WHERE username = ?)',
	
	mysql.pool.query("SELECT questionID, questionTitle, questionSubTitle, questionURL FROM tblQuestion WHERE electionFK = ( SELECT electionPK FROM tblElection WHERE electionID = ? )", [req.query.electionID], function(err, rows, result){
    if(err){
      next(err);
      return;
    }
    //context.results = JSON.stringify(rows);
    //ballot.results = rows;

	// **FILL BALLOT WITH RESPONSE IN HERE**
	var ballot = new Ballot.Ballot("newBallot", req.query['username']);

	var context = {};
	context.results = rows;
	console.log(rows);

	var arrayLength = context.results.length;
	for (var i = 0; i < arrayLength; i++) {
    	//alert(myStringArray[i]);
    	console.log("TESTAAA: " + context.results[i].questionID);
    	console.log("TESTCCC: " + typeof(context.results[i].questionID));
    	ballot.addVotingItem(new Ballot.VotingItem(context.results[i].questionID, options, 0));
	}

	arrayLength = ballot.votingItems.length;
		for (var i = 0; i < arrayLength; i++) {
    	//alert(myStringArray[i]);
    	console.log("TESTBBB: " + ballot.votingItems[i].name);
    	//ballot.addVotingItem(context.results[i].questionID, options, 0);
	}


	// Each row returned by query is a response option. 
	// They each have a 'questionID'. Every unique questionID should be made into a VotingItem:
	//ballot.addVotingItem(result.questionID, options, 0); // This creates a voting item with name = questionID, options and choice blank
		// Then, each response option (row) should be appended to the empty options array for the correct VotingItem
			// For example, the first row has questionID = '2018MID_Q1' and responseID = '2018MID_Q1R1', so that responseID should be added to the '2018MID_Q1' VotingItem
			// ballot.votingItems[0].options.append(responseID) is the idea, although there will be some work to figure out the correct index for votingItems 

		// Once that's done, we should have a full ballot object, which will be passed in res.render, below.
		
	res.render('review', ballot); //**STILL USING HARD-CODED BALLOT CREATED AT TOP OF FUNCTION FOR NOW**
	});
	
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
