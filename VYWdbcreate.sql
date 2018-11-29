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
  ('2018MID_Q1', (SELECT electionPK FROM tblElection WHERE electionID = '2018MIDTERM'), 'United States Senator\n(Vote for 1)', NULL, 'https://ballotpedia.org/United_States_Senate_election_in_Florida,_2018'),
  ('2018MID_Q2', (SELECT electionPK FROM tblElection WHERE electionID = '2018MIDTERM'), 'Representative in Congress\nDistrict 3\n(Vote for 1)', NULL, 'https://ballotpedia.org/United_States_Senate_election_in_Florida,_2018'),
  ('2018MID_Q3', (SELECT electionPK FROM tblElection WHERE electionID = '2018MIDTERM'), 'No. 9 Constitutional Revision Article II, Section 7, Article X, Section 20', 'Prohibits drilling for the exploration of oil and natrual gas beneath all state-owned waters between the mean high water line and the states outermost territorial boundaries. Adds use of vapor-generating electronic devices to current prohibition of tobacco smoking in enclosed indoor workplaces with exceptions; permits more restrictive local vapor ordinances.', 'https://ballotpedia.org/Florida_Amendment_9,_Ban_Offshore_Oil_and_Gas_Drilling_and_Ban_Vaping_in_Enclosed_Indoor_Workplaces_Amendment_(2018)'),
  ('2020PRES_Q1', (SELECT electionPK FROM tblElection WHERE electionID = '2020PRES'), 'President of the United States', 'Vote for 1', 'www.ballotpedia.com'),
  ('2020PRES_Q2', (SELECT electionPK FROM tblElection WHERE electionID = '2020PRES'), 'Representative in Congress\nDistrict 3', 'Vote for 1', 'www.ballotpedia.com'),
  ('2020PRES_Q3', (SELECT electionPK FROM tblElection WHERE electionID = '2020PRES'), 'Measure 101', 'Approves temporary assessments to fund health care for low-income individuals and families, and to stabilize health insurance premiums. Temporary assessments on insurance companies, some hospitals, and other providers of insurance or health care coverage. Insurers may not increase rates on health insurance premiums by more than 1.5 percent as a result of these assessments', 'https://ballotpedia.org/Oregon_Measure_101,_Healthcare_Insurance_Premiums_Tax_for_Medicaid_Referendum_(January_2018)'),
  ('2020PRES_Q4', (SELECT electionPK FROM tblElection WHERE electionID = '2020PRES'), 'Measure 102','Amends Constitution: Allows local bonds for financing affordable housing with nongovernmental entities. Requires voter approval, annual audits', 'https://ballotpedia.org/Oregon_Measure_102,_Removes_Restriction_that_Affordable_Housing_Projects_Funded_by_Municipal_Bonds_be_Government_Owned_(2018)'),
  ('2020PRES_Q5', (SELECT electionPK FROM tblElection WHERE electionID = '2020PRES'), 'Measure 103','Amends Constitution: Prohibits taxes/fees based on transactions for “groceries” (defined) enacted or amended after September 2017', 'https://ballotpedia.org/Oregon_Measure_103,_Ban_Tax_on_Groceries_Initiative_(2018)'),
  ('2020PRES_Q6', (SELECT electionPK FROM tblElection WHERE electionID = '2020PRES'), 'Measure 104','Amends Constitution: Expands (beyond taxes) application of requirement that three-fifths legislative majority approve bills raising revenue', 'https://ballotpedia.org/Oregon_Measure_104,_Definition_of_Raising_Revenue_for_Three-Fifths_Vote_Requirement_Initiative_(2018)'),
  ('2020PRES_Q7', (SELECT electionPK FROM tblElection WHERE electionID = '2020PRES'), 'Measure 105','Repeals law limiting use of state/local law enforcement resources to enforce federal immigration laws', 'https://ballotpedia.org/Oregon_Measure_105,_Repeal_Sanctuary_State_Law_Initiative_(2018)'),
  ('2020PRES_Q8', (SELECT electionPK FROM tblElection WHERE electionID = '2020PRES'), 'Measure 106','Amends Constitution: Expands (beyond taxes) application of requirement that three-fifths legislative majority approve bills raising revenue', 'https://ballotpedia.org/Oregon_Measure_104,_Definition_of_Raising_Revenue_for_Three-Fifths_Vote_Requirement_Initiative_(2018)');

INSERT INTO tblResponse (responseID, questionFK, responseTitle, responseSubTitle)
  VALUES
  ('2018MID_Q1R1', (SELECT questionPK from tblQuestion WHERE questionID = '2018MID_Q1'), 'Bob Ross', 'Dempublican'),
  ('2018MID_Q1R2', (SELECT questionPK from tblQuestion WHERE questionID = '2018MID_Q1'), 'Mr. Rogers', 'Republicrat'),
  ('2018MID_Q2R1', (SELECT questionPK from tblQuestion WHERE questionID = '2018MID_Q2'), 'Elvis Presely', 'Dempublican'),
  ('2018MID_Q2R2', (SELECT questionPK from tblQuestion WHERE questionID = '2018MID_Q2'), 'Homer Simpson', 'Republicrat'),
  ('2018MID_Q3R1', (SELECT questionPK from tblQuestion WHERE questionID = '2018MID_Q3'), 'Yes', 'For the prohibition'),
  ('2018MID_Q3R2', (SELECT questionPK from tblQuestion WHERE questionID = '2018MID_Q3'), 'No', 'Against the prohibition'),
  ('2020PRES_Q1R1', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q1'), 'Bob Ross', 'Dempublican'),
  ('2020PRES_Q1R2', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q1'), 'Superman', 'Republicrat'),
  ('2020PRES_Q2R1', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q2'), 'Elvis Presely', 'Dempublican'),
  ('2020PRES_Q2R2', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q2'), 'Homer Simpson', 'Republicrat'),
  ('2020PRES_Q3R1', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q3'), 'Yes', 'For the measure'),
  ('2020PRES_Q3R2', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q3'), 'No', 'Against the measure'),
  ('2020PRES_Q4R1', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q4'), 'Yes', 'For the measure'),
  ('2020PRES_Q4R2', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q4'), 'No', 'Against the measure'),
  ('2020PRES_Q5R1', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q5'), 'Yes', 'For the measure'),
  ('2020PRES_Q5R2', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q5'), 'No', 'Against the measure'),
  ('2020PRES_Q6R1', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q6'), 'Yes', 'For the measure'),
  ('2020PRES_Q6R2', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q6'), 'No', 'Against the measure'),
  ('2020PRES_Q7R1', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q7'), 'Yes', 'For the measure'),
  ('2020PRES_Q7R2', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q7'), 'No', 'Against the measure'),
  ('2020PRES_Q8R1', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q8'), 'Yes', 'For the measure'),
  ('2020PRES_Q8R2', (SELECT questionPK from tblQuestion WHERE questionID = '2020PRES_Q8'), 'No', 'Against the measure');

INSERT INTO tblVoterToElection (voterFK, electionFK, submissionStatus)
  VALUES
  ((SELECT voterPK FROM tblVoter WHERE voterID = 'HDFH1351FG'), (SELECT electionPK FROM tblElection WHERE electionID = '2018MIDTERM'), 3),
  ((SELECT voterPK FROM tblVoter WHERE voterID = 'X5125GST42'), (SELECT electionPK FROM tblElection WHERE electionID = '2018MIDTERM'), 3);