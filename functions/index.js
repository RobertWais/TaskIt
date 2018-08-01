const functions = require('firebase-functions');
const admin = require('firebase-admin');

var serviceAccount = require("./serviceAccount.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://taskit-9f5f7.firebaseio.com"
});


exports.request = functions.database.ref('/company/{companyId}/currentTasks/{taskId}').onCreate(function (snapshot, context) {
	const companyId = context.params.companyId;
	const uid = snapshot.val().userPosted;
	const title = snapshot.val().title;
	console.log(uid);

    const username = admin.database()
        .ref(`/users/${uid}/username`).once('value');

    const tokens =  admin.database().ref(`/company/${companyId}/tokens`).once('value');


	return Promise.all([username,tokens]).then(function (result){
        let allTokens = Object.keys(result[1].val()).map(function(key) {
            return result[1].val()[key]
        });

        let username = result[0].val();
        console.log(allTokens);
        console.log(username);

        const payload = {
            notification: {
                title: `${username} has entered a new task`,
                body: `${title}`
            }
        };

        admin.messaging().sendToDevice(allTokens, payload);

    });
});