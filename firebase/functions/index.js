/* eslint-disable require-jsdoc */
'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

const fireStore = admin.firestore();
exports.scheduledFuction = functions.pubsub
    .schedule('every 24 hours').onRun((context) => {
      functions.logger.info('--------------function start -----------------');
      //  データの取得
      const userRef = fireStore.collection('users');
      const habitRef = fireStore.collection('habits');

      userRef.get().then((userSnapShot)=>{
        habitRef.get.then((habitSnapShot) => {
          habitSnapShot.forEach((habit) => {
            // トークンをuserSnapShotから取得
            const user = userSnapShot.find((user)=>{
              return user.uid = habit.uid;
            });
            const token = user.token;

            // 計算処理
            // メッセージ取得
            // 送信処理
            pushToDevice(token, createMessage(habit.habitName));
          });
        });
      });
    });

// eslint-disable-next-line require-jsdoc
function pushToDevice(token, payload) {
  functions.logger.info('pushToDevice:', token);

  const options = {
    priority: 'high',
  };

  admin.messaging().sendToDevice(token, payload, options)
      .then((pushResponse) => {
        functions.logger.info('Successfully sent message:', pushResponse);
      })
      .catch((error) => {
        functions.logger.info('Error sending message:', error);
      });
}

function createMessage(habit) {
  const payload = {
    notification: {
      title: 'good!',
      body: `${habit} is good!`,
      badge: '1',
      sound: 'default',
    },
  };
  return payload;
}
