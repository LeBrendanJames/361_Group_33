/*
class VotingItem {
	variables:
		name
		array of options
		choice

	methods:
		makeChoice();
}
*/
class VotingItem {
	constructor(name, options, choiceNum){
		this.name = name;
		this.options = options;
		this._choice = choiceNum; // Variable is known as choice to anyone using the class, but is actually stored as _choice.
								  // This means that access is only through getter/setter
								  // So, VotingItem.choice actually calls the getter function and returns _choice
								  // and VotingItem.choice = "jfjfj" calls the setter for _choice with argument "jfjfj"
	}
   
	get choice(){
		return this._choice;
	}
   
	set choice(choiceNum){
		this._choice = choiceNum;
	}
   
	makeChoice(choiceNum){
		this._choice = choiceNum;
	}
			   
			   
};
 
 
/*
class Ballot {
	variables:
		ballotName
		username
		array of voting items
				   
	methods:
		addVotingItem(VotingItem);
		getVotingItemByNum();
		getAllVotingItems();
		makeChoice(votingItemNum, choiceNum);
}
*/
class Ballot {
	constructor(ballotName, username){
		this._ballotName = ballotName;
		this._username = username;
		this.votingItems = [];
	}
   
	get ballotName(){
		return this._ballotName;
	}
   
	get username() {
		return this._username;
	}
   
	addVotingItem(VotingItem){
		this.votingItems.push(VotingItem);
	}
   
	getVotingItemByNum(num){
		return this.votingItems[num];
	}
   
	// For summary where we want to show all items at once
	getAllVotingItems(){
		return this.votingItems;
	}
   
	makeChoice(votingItemNum, choiceNum){
		if (votingItemNum < this.votingItems.length){
			this.votingItems[votingItemNum].makeChoice(choiceNum);
		} else {
			return "Error: voting item " + votingItemNum + " does not exist.";
		}
	}
							
};
	
module.exports = {
	Ballot : Ballot,
	VotingItem : VotingItem
}