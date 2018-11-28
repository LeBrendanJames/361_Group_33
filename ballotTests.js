const ballot = require('./ballot.js');


// TESTS
var choices = ["Bill Gates", "Will Gates", "William Gates"]; // Will be filled from database eventually
firstItem = new VotingItem("firstItemName", choices, 0);
secondItem = new VotingItem("secondItemName", choices, 0)

// Test 1 - Create Voting Item (name)
if (firstItem.name == "firstItemName"){
	console.log("Test 1: Create voting item (name) PASSED")
} else {
	console.log("Test 1: Create voting item (name) FAILED")
}

// Test 2 - Create Voting Item (options)
if (firstItem.options[0] == "Bill Gates" && firstItem.options[1] == "Will Gates" && firstItem.options[2] == "William Gates") {
	console.log("Test 2: Create voting item (options) PASSED")
} else {
	console.log("Test 2: Create voting item (options) FAILED")
}	

// Test 3 - Create Voting Item (choice)
if (firstItem.choice == 0) {
	console.log("Test 3: Create voting item (choice) PASSED")
} else {
	console.log("Test 3: Create voting item (choice) FAILED")
}

// Test 4 - Voting Item Make Choice
firstItem.makeChoice(1);
if (firstItem.choice == 1){
	console.log("Test 4: Voting Item Make Choice PASSED")
} else {
	console.log("Test 4: Voting Item Make Choice FAILED")
}

// Test 5 - Empty Ballot (name)
ballot = new Ballot("Test Name", "Brendan1234");
if (ballot.ballotName == "Test Name"){
	console.log("Test 5: Empty Ballot (ballotName) PASSED")
} else {
	console.log("Test 5: Empty Ballot (ballotName) FAILED")
}

// Test 6 - Empty Ballot (username)
if (ballot.username == "Brendan1234"){
	console.log("Test 6: Empty Ballot (username) PASSED")
} else {
	console.log("Test 6: Empty Ballot (username) FAILED")
}

// Test 7 - Add Voting Items (name)
ballot.addVotingItem(firstItem);
ballot.addVotingItem(secondItem);
if ((ballot.getVotingItemByNum(0)).name == "firstItemName"){
	console.log("Test 7: Add Voting Items (name) PASSED")
} else {
	console.log("Test 7: Add Voting Items (name) FAILED")
}	

// Test 8 - Add Voting Items (choices)
if ((ballot.getVotingItemByNum(0)).options[0] == "Bill Gates"){
	console.log("Test 8: Add Voting Items (choices) PASSED")
} else {
	console.log("Test 8: Add Voting Items (choices) FAILED")
}

// Test 9 - Ballot Make Choice
ballot.makeChoice(0, 1)
if ((ballot.getVotingItemByNum(0)).choice = 1){
	console.log("Test 9: Ballot Make Choice PASSED")
} else {
	console.log("Test 9: Ballot Make Choice FAILED")
}