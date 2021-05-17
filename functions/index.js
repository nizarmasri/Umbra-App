const admin = require('firebase-admin');
const functions = require('firebase-functions');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions

exports.onEventCreate = functions.firestore
	.document('events/{docId}')
	.onCreate((snap, context) => {
		const newValue = snap.data();
		return sendNotifications(newValue['poster']);
	});
exports.onEventEdit = functions.firestore
	.document('events/{docId}')
	.onUpdate(async (change, context) => {
		const previousData = change.before.data();

		const tokens = previousData['tokens'];
		const notificationText =
			'Event details for ' + previousData['title'] + ' have changed.';
		await admin.messaging().sendToDevice(
			tokens, // ['token_1', 'token_2', ...]
			{
				data: {
					title: 'Event update',
					text: notificationText,
				},
			},
			{
				priority: 'high',
			},
		);
	});

async function sendNotifications(uid) {
	await admin
		.firestore()
		.collection('users')
		.doc(uid)
		.get()
		.then(async (value) => {
			const ownerNew = value.data();

			const notificationText = ownerNew['name'] + ' uploaded a new event!';
			await admin.messaging().sendToDevice(
				ownerNew['subscribers'], // ['token_1', 'token_2', ...]
				{
					data: {
						title: 'New event!',
						text: notificationText,
					},
				},
				{
					priority: 'high',
				},
			);
		});
}
