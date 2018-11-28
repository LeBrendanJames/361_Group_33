DROP TABLE IF EXISTS `tblVoterToResponse`;
DROP TABLE IF EXISTS `tblVoterToElection`;
DROP TABLE IF EXISTS `tblResponse`;
DROP TABLE IF EXISTS `tblQuestion`;
DROP TABLE IF EXISTS `tblElection`;
DROP TABLE IF EXISTS `tblUserLogin`;
DROP TABLE IF EXISTS `tblVoter`;


CREATE TABLE tblVoter (
  voterPK SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  voterID VARCHAR(255) NOT NULL,
  firstName VARCHAR(255) NOT NULL,
  lastName VARCHAR(255) NOT NULL,
  PRIMARY KEY  (voterPK),
  CONSTRAINT unique_voterID UNIQUE(voterID)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE tblUserLogin (
  voterFK SMALLINT UNSIGNED NOT NULL,
  username VARCHAR(255) NOT NULL,
  pwd VARCHAR(65) NOT NULL,
  CONSTRAINT fk_userlogin_to_voter FOREIGN KEY (voterFK) REFERENCES tblVoter (voterPK) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT unique_username UNIQUE(username)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE tblElection (
  electionPK SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  electionID VARCHAR(255) NOT NULL,
  name VARCHAR(255) NOT NULL,
  startDate DATE NOT NULL,
  endDate DATE NOT NULL,
  PRIMARY KEY  (electionPK),
  CONSTRAINT unique_electionID UNIQUE(electionID)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE tblVoterToElection (
  voterFK SMALLINT UNSIGNED NOT NULL,
  electionFK SMALLINT UNSIGNED NOT NULL,
  submissionStatus SMALLINT UNSIGNED NOT NULL,
  CONSTRAINT fk_vte_to_voter FOREIGN KEY (voterFK) REFERENCES tblVoter (voterPK) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_vte_to_election FOREIGN KEY (electionFK) REFERENCES tblElection (electionPK) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT unique_voter_election UNIQUE(voterFK, electionFK)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE tblQuestion (
  questionPK SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  questionID VARCHAR(255) NOT NULL,
  electionFK SMALLINT UNSIGNED NOT NULL,
  questionTitle VARCHAR(1000) NOT NULL,
  questionSubTitle VARCHAR(10000),
  questionURL VARCHAR(1000),
  PRIMARY KEY (questionPK),
  CONSTRAINT fk_question_to_election FOREIGN KEY (electionFK) REFERENCES tblElection (electionPK) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT unique_questionID UNIQUE(questionID)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE tblResponse (
  responsePK SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  responseID VARCHAR(255) NOT NULL,
  questionFK SMALLINT UNSIGNED NOT NULL,
  responseTitle VARCHAR(1000) NOT NULL,
  responseSubTitle VARCHAR(10000),
  PRIMARY KEY (responsePK),
  CONSTRAINT fk_response_to_question FOREIGN KEY (questionFK) REFERENCES tblQuestion (questionPK) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT unique_responseID UNIQUE(responseID)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE tblVoterToResponse (
  voterFK SMALLINT UNSIGNED NOT NULL,
  questionFK SMALLINT UNSIGNED NOT NULL,
  responseFK SMALLINT UNSIGNED,
  writeInResponse VARCHAR(1000),
  CONSTRAINT fk_vtr_to_voter FOREIGN KEY (questionFK) REFERENCES tblQuestion (questionPK) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_vtr_to_response FOREIGN KEY (questionFK) REFERENCES tblQuestion (questionPK) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT unique_voter_question UNIQUE(voterFK, questionFK)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


INSERT INTO tblVoter (voterID, firstName, lastName)
  VALUES 
  ('12345ABCDE', 'John', 'Smith'),
  ('X5125GST42', 'Jane', 'Dover'),
  ('HDFH1351FG', 'Matt', 'McGorp');


INSERT INTO tblUserLogin (voterFK, username, pwd)
  VALUES 
  ((SELECT voterPK FROM tblVoter WHERE voterID = 'HDFH1351FG'), 'matt', '472c3c13b550b7064153d4a407051068b4201cd51c323e9900d62a6740b84f1a'),
  ((SELECT voterPK FROM tblVoter WHERE voterID = 'X5125GST42'), 'jane', '472c3c13b550b7064153d4a407051068b4201cd51c323e9900d62a6740b84f1a');


INSERT INTO tblElection(electionID, name, startDate, endDate)
  VALUES 
  ('2018MIDTERM', '2018 Mid-Term Election', '2018-10-25', '2018-11-06'),
  ('2020PRES', '2020 Presidential Election', '2018-10-25', '2020-11-06'),
  ('2022MIDTERM', '2022 Mid-Term Election', '2022-10-25', '2022-11-06');


INSERT INTO tblQuestion (questionID, electionFK, questionTitle, questionSubTitle, questionURL)
  VALUES
  ('2018MID_Q1', (SELECT electionPK FROM tblElection WHERE electionID = '2018MIDTERM'), 'United States Senator\n(Vote for 1)', NULL, 'www.ballotpedia.com'),
  ('2018MID_Q2', (SELECT electionPK FROM tblElection WHERE electionID = '2018MIDTERM'), 'Representative in Congress\nDistrict 3\n(Vote for 1)', NULL, 'www.ballotpedia.com'),
  ('2018MID_Q3', (SELECT electionPK FROM tblElection WHERE electionID = '2018MIDTERM'), 'No. 9 Constitutional Revision Article II, Section 7, Article X, Section 20', 'Prohibits drilling for the exploration of oil and natrual gas beneath all state-owned waters between the mean high water line and the states outermost territorial boundaries. Adds use of vapor-generating electronic devices to current prohibition of tobacco smoking in enclosed indoor workplaces with exceptions; permits more restrictive local vapor ordinances.', 'www.ballotpedia.com'),
  ('2020PRES_Q1', (SELECT electionPK FROM tblElection WHERE electionID = '2020PRES'), 'President of the United States\n(Vote for 1)', NULL, 'www.ballotpedia.com'),
  ('2020PRES_Q2', (SELECT electionPK FROM tblElection WHERE electionID = '2020PRES'), 'Representative in Congress\nDistrict 3\n(Vote for 1)', NULL, 'www.ballotpedia.com'),
  ('2020PRES_Q3', (SELECT electionPK FROM tblElection WHERE electionID = '2020PRES'), 'No. 9 Constitutional Revision Article II, Section 7, Article X, Section 20', 'Prohibits drilling for the exploration of oil and natrual gas beneath all state-owned waters between the mean high water line and the states outermost territorial boundaries. Adds use of vapor-generating electronic devices to current prohibition of tobacco smoking in enclosed indoor workplaces with exceptions; permits more restrictive local vapor ordinances.', 'www.ballotpedia.com');


INSERT INTO tblResponse (responseID, questionFK, responseTitle, responseSubTitle)
  VALUES
  ('2018MID_Q1R1', (SELECT questionPK from tblQuestion WHERE questionID = '2018MID_Q1'), 'Bob Ross', NULL),
  ('2018MID_Q1R2', (SELECT questionPK from tblQuestion WHERE questionID = '2018MID_Q1'), 'Mr. Rogers', NULL),
  ('2018MID_Q2R1', (SELECT questionPK from tblQuestion WHERE questionID = '2018MID_Q2'), 'Elvis Presely', NULL),
  ('2018MID_Q2R2', (SELECT questionPK from tblQuestion WHERE questionID = '2018MID_Q2'), 'Homer Simpson', NULL),
  ('2018MID_Q3R1', (SELECT questionPK from tblQuestion WHERE questionID = '2018MID_Q3'), 'Yes', 'For the prohibition'),
  ('2018MID_Q3R2', (SELECT questionPK from tblQuestion WHERE questionID = '2018MID_Q3'), 'No', 'Against the prohibition'),
  ('2020PRES_Q1R1', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q1'), 'Bob Ross', NULL),
  ('2020PRES_Q1R2', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q1'), 'Superman', NULL),
  ('2020PRES_Q2R1', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q2'), 'Elvis Presely', NULL),
  ('2020PRES_Q2R2', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q2'), 'Homer Simpson', NULL),
  ('2020PRES_Q3R1', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q3'), 'Yes', 'For the prohibition'),
  ('2020PRES_Q3R2', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q3'), 'No', 'Against the prohibition');


INSERT INTO tblVoterToElection (voterFK, electionFK, submissionStatus)
  VALUES
  ((SELECT voterPK FROM tblVoter WHERE voterID = 'HDFH1351FG'), (SELECT electionPK FROM tblElection WHERE electionID = '2018MIDTERM'), 3),
  ((SELECT voterPK FROM tblVoter WHERE voterID = 'X5125GST42'), (SELECT electionPK FROM tblElection WHERE electionID = '2018MIDTERM'), 3);