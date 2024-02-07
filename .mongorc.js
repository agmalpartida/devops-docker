// .mongorc.js

run("df");
print("");
print("As always sir, a great pleasure watching you work");
print("");

//function prompt() {
//var username = "";
//var user = db.runCommand({
//connectionStatus: 1,
//}).authInfo.authenticatedUsers[0];

//if (!!user) {
//username = user.user;
//} else {
//username = "anonymous";
//}

//var database = db.getName();

//return `${username}:${database} >`;
//}

prompt = function () {
  if (typeof db == "undefined") {
    return "(nodb)> ";
  } // Check the last db operation
  try {
    db.runCommand({ getLastError: 1 });
  } catch (e) {
    print(e);
  }
  return db + "> ";
};

// Create custom command shortcuts
d = function d() {
  return db._adminCommand({ listDatabases: 1 });
};
c = function c() {
  return db.getCollectionNames();
};

var no = function () {
  print("Not on my watch.");
};
// replace the dangerous commands with my own commands which will do nothing
// If I do want to drop a collection or a database, I can execute MongoDB shell using: mongo --norc
// Prevent dropping databases
db.dropDatabase = DB.prototype.dropDatabase = no;
// Prevent dropping collections
DBCollection.prototype.drop = no;
// Prevent dropping indexes
DBCollection.prototype.dropIndex = no;
