const functions = require('firebase-functions');
const admin = require('firebase-admin');

var serviceAccount = require("./serviceAccount.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://taskit-9f5f7.firebaseio.com"
});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
exports.request = functions.database.ref('/company/{companyId}/currentTasks/{taskId}').onCreate(function (snapshot, context) {
	const companyId = context.params.companyId

	admin.database().ref(`/company/${companyId}/tokens`).once('value', function (snapshot) {
		let tokens = snapshot.val()
		console.log(tokens)


		 w
	})

	return 0
})