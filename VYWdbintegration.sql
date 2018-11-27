-- Retrieve ballots and statuses
SELECT t1.name, t2.submissionStatus
FROM tblElection t1
LEFT JOIN tblVoterToElection t2 ON t1.electionPK = t2.electionFK

-- Register a new response to a question (select an option)
INSERT INTO tblVoterToResponse (voterFK, questionFK, responseFK, writeInResponse)
  VALUES
  ((SELECT voterPK FROM tblVoter WHERE voterID = '[VOTER ID HERE]'), (SELECT questionPK FROM tblQuestion WHERE questionID = '[QUESTION ID HERE]'), (SELECT responsePK FROM tblResponse WHERE responseID = 'RESPONSE ID HERE'), NULL)

-- Register a new response to a question (write in response)
INSERT INTO tblVoterToResponse (voterFK, questionFK, responseFK, writeInResponse)
  VALUES
  ((SELECT voterPK FROM tblVoter WHERE voterID = '[VOTER ID HERE]'), (SELECT questionPK FROM tblQuestion WHERE questionID = '[QUESTION ID HERE]'), NULL, '[WRITE IN RESPONSE HERE]')

-- Change vote that was already saved (select an option) 
UPDATE tblVoterToResponse
SET    voterFK = (SELECT voterPK FROM tblVoter WHERE  voterID = '[VOTER ID HERE]'), 
       questionFK = (SELECT questionPK FROM tblQuestion WHERE  questionID = '[QUESTION ID HERE]'), 
       responseID = (SELECT responsePK FROM tblResponse WHERE  responseID = 'RESPONSE ID HERE'), 
       writeInResponse = NULL 
WHERE  voterFK = (SELECT voterPK FROM tblVoter WHERE voterID = '[VOTER ID HERE]') 
       AND questionFK = (SELECT questionPK FROM tblQuestion WHERE  questionID = '[QUESTION ID HERE]') 

-- Change vote that was already saved (writeInResponse) 
UPDATE tblVoterToResponse
SET    voterFK = (SELECT voterPK FROM tblVoter WHERE  voterID = '[VOTER ID HERE]'), 
       questionFK = (SELECT questionPK FROM tblQuestion WHERE  questionID = '[QUESTION ID HERE]'), 
       responseID = NULL
       writeInResponse = '[WRITE IN RESPONSE HERE]'
WHERE  voterFK = (SELECT voterPK FROM tblVoter WHERE voterID = '[VOTER ID HERE]') 
       AND questionFK = (SELECT questionPK FROM tblQuestion WHERE  questionID = '[QUESTION ID HERE]') 

