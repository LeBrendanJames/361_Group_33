var mysql = require('mysql');
var pool = mysql.createPool({
  connectionLimit : 10,
  host            : 'classmysql.engr.oregonstate.edu',
  user            : 'cs361_rossmic',
  password        : '4962',
  database        : 'cs361_rossmic'
});

module.exports.pool = pool;
