import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
admin.initializeApp();

// const db = admin.firestore();
const fcm = admin.messaging();

export const sendNotification = functions.https.onCall(async (data, context) => {
  if (context.auth) {

    const querySnapshot = await admin.firestore().collection('users').doc(context.auth?.uid).collection('tokens').get();
    const tokens = querySnapshot.docs.map(snap => snap.id);
    console.log(tokens);

  const payload: admin.messaging.MessagingPayload = {
    notification: {
      body: 'You are going on a trip soon!',
      title: 'Upcoming Trip'
    },
    data: {
      body: 'You are going on a trip soon!',
      title: 'Upcoming Trip',
      click_action: 'FLUTTER_NOTIFICATION_CLICK',
      icon: 'https://ibin.co/2t1lLdpfS06F.png'
    }
  };

  return fcm.sendToDevice(tokens, payload);
  }
  return null;
})

// export const sendToDevice = functions.firestore
//   .document('users/{userId}')
//   .onCreate(async snapshot => {


//     const user = snapshot.data();

//     const querySnapshot = await db
//     .collection('users')
//     .doc(user ? user.uid : null)
//     .collection('trips')
//     .get();

//   const tokens = querySnapshot.docs.map(snap => snap.id);

//   const payload: admin.messaging.MessagingPayload = {
//     notification: {
//       title: 'Upcoming Trip',
//       body: `You are going on a trip soon!`,
//       icon: 'your-icon-url',
//       click_action: 'FLUTTER_NOTIFICATION_CLICK'
//     }
//   };

//   return fcm.sendToDevice(tokens, payload);
//   });
