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
app.get('/review', function(req, res, next) {
	
	// Start by getting just the question data for the provided election	
	mysql.pool.query("SELECT questionPK, questionID, questionTitle, questionSubTitle, questionURL FROM tblQuestion WHERE electionFK IN ( SELECT electionPK FROM tblElection WHERE electionID = ? )", [req.query.electionID], function(err, rows, result){
	    
	    if(err){
	      next(err);
	      return;
	    }

		// Create the ballot object here
		var ballot = new Ballot.Ballot("newBallot", req.query['username']);

		var context = {};
		context.results = rows;
		var numQuestions = context.results.length;

		// Loop through results of the question query and create a new Voting Item for each row
		for (i = 0; i < numQuestions; i++) {

	    	// For each question, get all the responses for that question
	    	chkQuestion = context.results[i].questionPK;

	    	mysql.pool.query("SELECT t1.responsePK, t1.responseID, t1.responseTitle, t2.questionID, t2.questionTitle, t3.responseFK FROM tblResponse t1 INNER JOIN tblQuestion t2 ON t1.questionFK = t2.questionPK LEFT JOIN tblVoterToResponse t3 ON t2.questionPK = t3.questionFK AND t3.voterFK = (SELECT voterFK FROM tblUserLogin WHERE username = ?) WHERE t1.questionFK = ?", [req.query.username, chkQuestion], function(err2, rows2, result){
			    
			    if(err){
			      next(err);
			      return;
			    }

			    var context = {};
				context.results = rows2;
				numResponses = context.results.length;
				responseAry = [];

				// Populate responseAry with the results from query
				for (j = 0; j < numResponses; j++) {
					responseAry[j] = context.results[j].responseTitle;
				}

				// Create the voting item and add to ballot
				ballot.addVotingItem(new Ballot.VotingItem(context.results[0].questionTitle, responseAry, 0));


				// Do something with the data we have from tblVoterToResponse to show the selected value


		    });

		}
			
	res.render('review', ballot); 
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
