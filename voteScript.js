function chooseVote(n) {
  //first we get lists of the votes
  var votes = document.getElementsByClassName("vote-item");
  
  //then we make all the votes unselected
  for (var j = 0; j < votes.length; j++) {
      votes[j].className = votes[j].className.replace(" selected", "");
  }

  //finally, we make the appropriate votes selected
  votes[n].className += " selected";
}