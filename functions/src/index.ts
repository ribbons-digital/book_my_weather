import axios from 'axios';
import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();


interface Trip {
  createdByUid: string
  temperature: string
  weatherIcon: string
  searchIndex: string[]
  description: string
  startDate: admin.firestore.Timestamp
  endDate: admin.firestore.Timestamp
  name: string
  heroImages: string[]
  destination: string
  location: admin.firestore.GeoPoint
  endDateInMs: number
  currencyRate: number
  currencyCode: string
}

export const sendNotification = functions.https.onCall(async (data, context) => {
  const getDailyWeatherForecast = async (lat: number, lng: number) => {
    const excludes = ['currently','minutely','hourly','alerts','flags'];
    const requestWeatherUrl = `https://api.darksky.net/forecast/${functions.config().secret.darksky_api_key}/${lat},${lng}?units=si&?exclude=${excludes}`;
    try {
      const response = await axios.get(requestWeatherUrl);
      if (response.status === 200) {
        console.log('response: ', response.data);
        return response.data.daily;
      }
    } catch(e) {
      console.log(e);
    }
  }

  const tripsSnapshot = await db.collection('trips').get();

  const trips = tripsSnapshot.docs.map(snap => {
    return snap.data() as Trip
  });


  const upcomingTrips = trips.filter(trip => {
    if (Math.round((trip.startDate.toMillis() - Date.now()) / 86400000) <= 3 && Math.round((trip.startDate.toMillis() - Date.now()) / 86400000) >= 0) {
      return trip;
    }
    return null;
  })

  console.log(upcomingTrips);

  if (upcomingTrips.length > 0) {

    await Promise.all(upcomingTrips.map(async trip => {
      const userId = trip.createdByUid;
      const querySnapshot = await admin.firestore().collection('users').doc(userId).collection('tokens').get();
      const tokens = querySnapshot.docs.map(snap => snap.id);
      if (tokens.length > 0) {
        const dailyWeatherForecast = await getDailyWeatherForecast(trip.location.latitude, trip.location.longitude);
        const index = Math.round((trip.startDate.toMillis() - Date.now()) / 86400000);
        console.log('index: ', index);

        const message = dailyWeatherForecast.data[index].temperatureLow < 20 ? 'It is a bit chill, might want to bring a jacket with you.' :
        dailyWeatherForecast.data[index].temperatureLow > 20 && dailyWeatherForecast.data[index].temperatureLow < 30 ? 'It is a bit warm, travel light!' :
        dailyWeatherForecast.data[index].temperatureLow > 30 ? 'It is hot, put on a sun screen!' : 'Bring whatever you want!'
        const payload: admin.messaging.MessagingPayload = {
          notification: {
            title: `You are going on a trip to ${trip.destination} soon!`,
            body: `Upcoming Trip temperature is ${dailyWeatherForecast.data[index].temperatureLow.toFixed(0)}º ~ ${dailyWeatherForecast.data[index].temperatureHigh.toFixed(0)}º. ${message}`
          },
          data: {
            title: `You are going on a trip to ${trip.destination} soon!`,
            body: `Upcoming Trip temperature is ${dailyWeatherForecast.data[index].temperatureLow.toFixed(0)}º ~ ${dailyWeatherForecast.data[index].temperatureHigh.toFixed(0)}º. ${message}`,
            click_action: 'FLUTTER_NOTIFICATION_CLICK',
            icon: 'https://ibin.co/2t1lLdpfS06F.png'
          }
        };

        return fcm.sendToDevice(tokens, payload);
      }
      return null;
    }))
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
