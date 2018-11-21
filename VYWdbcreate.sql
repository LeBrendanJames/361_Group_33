DROP TABLE IF EXISTS `tblVoterToResponse`;
DROP TABLE IF EXISTS `tblVoterToElection`;
DROP TABLE IF EXISTS `tblResponse`;
DROP TABLE IF EXISTS `tblQuestion`;
DROP TABLE IF EXISTS `tblElection`;
DROP TABLE IF EXISTS `tblUserLogin`;
DROP TABLE IF EXISTS `tblVoter`;


CREATE TABLE tblVoter (
  voterPK SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  firstName VARCHAR(255) NOT NULL,
  lastName VARCHAR(255) NOT NULL,
  PRIMARY KEY  (voterPK)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE tblUserLogin (
  voterFK SMALLINT UNSIGNED NOT NULL,
  username VARCHAR(1000) NOT NULL,
  pwd VARCHAR(65) NOT NULL,
  CONSTRAINT fk_userlogin_to_voter FOREIGN KEY (voterFK) REFERENCES tblVoter (voterPK) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE tblElection (
  electionPK SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  -- TO DO: Start Date
  -- TO DO: End Date
  PRIMARY KEY  (electionPK)
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE tblVoterToElection (
  voterFK SMALLINT UNSIGNED NOT NULL,
  electionFK SMALLINT UNSIGNED NOT NULL,
  submissionStatus SMALLINT UNSIGNED NOT NULL,
  CONSTRAINT fk_vte_to_voter FOREIGN KEY (voterFK) REFERENCES tblVoter (voterPK) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_vte_to_election FOREIGN KEY (electionFK) REFERENCES tblElection (electionPK) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE tblQuestion (
  questionPK SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  electionFK SMALLINT UNSIGNED NOT NULL,
  questionTitle VARCHAR(1000) NOT NULL,
  questionSubTitle VARCHAR(10000),
  questionURL VARCHAR(1000),
  PRIMARY KEY (questionPK),
  CONSTRAINT fk_question_to_election FOREIGN KEY (electionFK) REFERENCES tblElection (electionPK) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE tblResponse (
  responsePK SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  questionFK SMALLINT UNSIGNED NOT NULL,
  responseTitle VARCHAR(1000) NOT NULL,
  responseSubTitle VARCHAR(10000),
  PRIMARY KEY (responsePK),
  CONSTRAINT fk_response_to_question FOREIGN KEY (questionFK) REFERENCES tblQuestion (questionPK) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


CREATE TABLE tblVoterToResponse (
  voterFK SMALLINT UNSIGNED NOT NULL,
  questionFK SMALLINT UNSIGNED NOT NULL,
  responseFK SMALLINT UNSIGNED,
  writeInResponse VARCHAR(1000),
  CONSTRAINT fk_vtr_to_voter FOREIGN KEY (questionFK) REFERENCES tblQuestion (questionPK) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_vtr_to_response FOREIGN KEY (questionFK) REFERENCES tblQuestion (questionPK) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB DEFAULT CHARSET=utf8;


INSERT INTO tblVoter (firstName, lastName)
  VALUES 
  ('John', 'Smith'),
  ('Jane', 'Dover'),
  ('Matt', 'McGorp');


INSERT INTO tblUserLogin (voterFK, username, pwd)
  VALUES 
  ((SELECT voterPK FROM tblVoter WHERE firstName = 'Matt' AND lastName = 'McGorp'), 'matt', '472c3c13b550b7064153d4a407051068b4201cd51c323e9900d62a6740b84f1a');


INSERT INTO tblElection(name)
  VALUES 
  ('2018 Mid-Term Election'),
  ('2020 Presidential Election'),
  ('2022 Mid-Term Election');


INSERT INTO tblQuestion (electionFK, questionTitle, questionSubTitle, questionURL)
  VALUES
  ((SELECT electionPK FROM tblElection WHERE name = '2020 Presidential Election'), 'United States Senator\n(Vote for 1)', NULL, 'www.ballotpedia.com'),
  ((SELECT electionPK FROM tblElection WHERE name = '2020 Presidential Election'), 'Representative in Congress\nDistrict 3\n(Vote for 1)', NULL, 'www.ballotpedia.com'),
  ((SELECT electionPK FROM tblElection WHERE name = '2020 Presidential Election'), 'No. 9 Constitutional Revision Article II, Section 7, Article X, Section 20', 'Prohibits drilling for the exploration of oil and natrual gas beneath all state-owned waters between the mean high water line and the states outermost territorial boundaries. Adds use of vapor-generating electronic devices to current prohibition of tobacco smoking in enclosed indoor workplaces with exceptions; permits more restrictive local vapor ordinances.', 'www.ballotpedia.com');


INSERT INTO tblResponse (questionFK, responseTitle, responseSubTitle)
  VALUES
  ((SELECT questionPK from tblQuestion WHERE questionTitle = 'United States Senator\n(Vote for 1)'), 'Bob Ross', NULL),
  ((SELECT questionPK from tblQuestion WHERE questionTitle = 'United States Senator\n(Vote for 1)'), 'Mr. Rogers', NULL),
  ((SELECT questionPK from tblQuestion WHERE questionTitle = 'Representative in Congress\nDistrict 3\n(Vote for 1)'), 'Elvis Presely', NULL),
  ((SELECT questionPK from tblQuestion WHERE questionTitle = 'Representative in Congress\nDistrict 3\n(Vote for 1)'), 'Homer Simpson', NULL),
  ((SELECT questionPK from tblQuestion WHERE questionTitle = 'No. 9 Constitutional Revision Article II, Section 7, Article X, Section 20'), 'Yes', 'For the prohibition'),
  ((SELECT questionPK from tblQuestion WHERE questionTitle = 'No. 9 Constitutional Revision Article II, Section 7, Article X, Section 20'), 'No', 'Against the prohibition');

