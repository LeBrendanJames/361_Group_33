
/************************************************************
                   Overview Page Queries
************************************************************/

-- TO DO: if possible, replace username with a value we pass from the login page

-- Given a username, display ballots, statuses, and availability 
SELECT t1.NAME AS 'Election Name',EXISTS(SELECT * 
                                         FROM   tblVoterToElection t2 
                                                INNER JOIN tblUserLogin t3 
                                                        ON t2.voterFK = 
                                                           t3.voterFK 
                                         WHERE  t3.username = 'matt' 
                                                AND t2.electionFK = 
                                                    t1.electionPK) AS 
                                         'Exists',( 
              CASE 
                WHEN t1.startDate < Curdate() 
                     AND t1.endDate > Curdate() THEN 1 
                ELSE 0 
              END ) AS 'Available',t4.submissionStatus 
FROM   tblElection t1 
       LEFT JOIN tblVoterToElection t4 
              ON t1.electionPK = t4.electionFK 
                 AND t4.voterFK = (SELECT voterFK 
                                   FROM   tblUserLogin 
                                   WHERE  username = 'matt') 

-- Compact version
SELECT t1.name AS 'Election Name', EXISTS( SELECT * FROM tblVoterToElection t2 INNER JOIN tblUserLogin t3 ON t2.voterFK = t3.voterFK WHERE t3.username = 'matt' AND t2.electionFK = t1.electionPK) AS 'Exists', (CASE WHEN t1.startDate < CURDATE() AND t1.endDate > CURDATE() THEN 1 ELSE 0 END) AS 'Available', t4.submissionStatusFROM tblElection t1LEFT JOIN tblVoterToElection t4 ON t1.electionPK = t4.electionFK AND t4.voterFK = (SELECT voterFK FROM tblUserLogin WHERE username = 'matt')


-- Create the voterToElection record when first opening ballot
INSERT INTO tblVoterToElection(voterFK, electionFK, submissionStatus)
  VALUES
  ((SELECT voterFK FROM tblUserLogin WHERE username = 'matt'), (SELECT electionPK FROM tblElection WHERE electionID = '2020PRES'), 1);

-- Compact version
INSERT INTO tblVoterToElection (voterFK,electionFK,submissionStatus) VALUES (( SELECT voterFK FROM tblUserLogin WHERE username = 'matt'),(SELECT electionPK FROM tblElection WHERE electionID = '2020PRES'),1);


/************************************************************
                     Ballot View Queries
************************************************************/

-- TO DO: Page should accept electionID and either voterID or username from overview page

-- Given an electionID, get all of the questions response options, and existing user responses associated with that election
SELECT t1.questionID, t1.questionTitle, t1.questionURL, t2.responsePK, t2.responseID, t2.responseTitle, t2.responseSubTitle, t3.responseFK, t3.writeInResponse
FROM tblQuestion t1
LEFT JOIN tblResponse t2 ON t1.questionPK = t2.questionFK
LEFT JOIN tblVoterToResponse t3 ON t1.questionPK = t3.questionFK AND t3.voterFK = (SELECT voterFK FROM tblUserLogin WHERE username = 'matt')
WHERE t1.electionFK = (SELECT electionPK FROM tblElection WHERE electionID = '2020PRES')

-- Compact version
SELECT t1.questionID, t1.questionTitle, t1.questionURL, t2.responsePK, t2.responseID, t2.responseTitle, t2.responseSubTitle, t3.responseFK, t3.writeInResponse FROM tblQuestion t1 LEFT JOIN tblResponse t2 ON t1.questionPK = t2.questionFK LEFT JOIN tblVoterToResponse t3 ON t1.questionPK = t3.questionFK AND t3.voterFK = (SELECT voterFK FROM tblUserLogin WHERE username = 'matt') WHERE t1.electionFK = (SELECT electionPK FROM tblElection WHERE electionID = '2020PRES')


--Given an electionID and a specific questionID, get all of the questions response options, and existing user responses associated with that question.  This should accept questionID as a parameter from the site.
SELECT t1.questionID, t1.questionTitle, t1.questionURL, t2.responsePK, t2.responseID, t2.responseTitle, t2.responseSubTitle, t3.responseFK, t3.writeInResponse
FROM tblQuestion t1
LEFT JOIN tblResponse t2 ON t1.questionPK = t2.questionFK
LEFT JOIN tblVoterToResponse t3 ON t1.questionPK = t3.questionFK AND t3.voterFK = (SELECT voterFK FROM tblUserLogin WHERE username = 'matt')
WHERE t1.electionFK = (SELECT electionPK FROM tblElection WHERE electionID = '2020PRES') AND t1.QuestionID = '2020PRES_Q1'

-- Compact version
SELECT t1.questionID, t1.questionTitle, t1.questionURL, t2.responsePK, t2.responseID, t2.responseTitle, t2.responseSubTitle, t3.responseFK, t3.writeInResponse FROM tblQuestion t1 LEFT JOIN tblResponse t2 ON t1.questionPK = t2.questionFK LEFT JOIN tblVoterToResponse t3 ON t1.questionPK = t3.questionFK AND t3.voterFK = (SELECT voterFK FROM tblUserLogin WHERE username = 'matt') WHERE t1.electionFK = (SELECT electionPK FROM tblElection WHERE electionID = '2020PRES') AND t1.QuestionID = '2020PRES_Q1'


-- Register a new response to a question (select an option).  This should accept voterID or username, questionID, and responseID as paramaters from the site.
INSERT INTO tblVoterToResponse (voterFK, questionFK, responseFK, writeInResponse)
  VALUES
  ((SELECT voterFK FROM tblUserLogin WHERE username = 'matt'), (SELECT questionPK FROM tblQuestion WHERE questionID = '2020PRES_Q1'), (SELECT responsePK FROM tblResponse WHERE responseID = '2020PRES_Q1R1'), NULL)


-- Register a new response to a question (write in response).  This should accept voterID or username, questionID, and writeInResponse as paramaters from the site.
INSERT INTO tblVoterToResponse (voterFK, questionFK, responseFK, writeInResponse)
  VALUES
  ((SELECT voterFK FROM tblUserLogin WHERE username = 'matt'), (SELECT questionPK FROM tblQuestion WHERE questionID = '2020PRES_Q2'), NULL, 'Ross Perot')


-- Change vote that was already saved (select an option) This should accept voterID or username, questionID, and responseID as paramaters from the site.
UPDATE tblVoterToResponse
SET    responseFK = (SELECT responsePK FROM tblResponse WHERE  responseID = '2020PRES_Q1R2'), 
       writeInResponse = NULL 
WHERE  voterFK = (SELECT voterFK FROM tblUserLogin WHERE username = 'matt') 
       AND questionFK = (SELECT questionPK FROM tblQuestion WHERE  questionID = '2020PRES_Q1') 


-- Change vote that was already saved (writeInResponse) 
UPDATE tblVoterToResponse
SET    responseFK = NULL,
       writeInResponse = 'Gordon Bombay'
WHERE  voterFK = (SELECT voterFK FROM tblUserLogin WHERE username = 'matt') 
       AND questionFK = (SELECT questionPK FROM tblQuestion WHERE  questionID = '2020PRES_Q2') 


/************************************************************
                    Submission Queries
************************************************************/

-- Set the status of the voterToElection record to 'Submitted'.  This should accept ElectionID, VoterID from submission page
UPDATE tblVoterToElection SET submissionStatus = 2 WHERE electionFK = (SELECT electionPK FROM tblElection WHERE electionID = '2020PRES') AND voterFK = (SELECT voterFK FROM tblUserLogin WHERE username ='matt')