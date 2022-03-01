/* eslint-disable max-len */
/* eslint-disable require-jsdoc */
'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

<<<<<<< HEAD
const fireStore = admin.fireStore();
=======
const fireStore = admin.firestore();
>>>>>>> 71b56a6d557b37d30d4b71d6ae105f6e331ad442
exports.scheduledFunction = functions.pubsub
    .schedule('every 24 hours').onRun((context) =>{
      functions.logger.info('--------------function start -----------------');
      //  データの取得
      const userRef = fireStore.collection('users');
      const habitRef = fireStore.collection('habits');
      const messageRef = fireStore.collection('message');
      userRef.get().then((userSnapShot)=>{
        habitRef.get().then((habitSnapShot) => {
          messageRef.get().then((msgSnapShot) => {
            let goodMsg;
            let badMsg;
            msgSnapShot.forEach((msgDoc) => {
              const msg = msgDoc.data();
              if (msg.id === 1) {
                goodMsg = msg.text;
              } else {
                badMsg = msg.text;
              }
            });

            habitSnapShot.forEach((habitDoc) => {
              const habit = habitDoc.data();
              let token;

              userSnapShot.forEach((userDoc)=>{
                const user = userDoc.data();
<<<<<<< HEAD
                functions.logger.info(`user.uid:${user.uid}`);
                functions.logger.info(`habit.uid:${habit.uid}`)
=======
>>>>>>> 71b56a6d557b37d30d4b71d6ae105f6e331ad442
                if (user.uid === habit.uid) {
                  functions.logger.info(`token:${user.token}`)
                  token = user.token;
                }
              });
              // 計算処理
              const commits = habit.commits;
              const oneWeekAgo = new Date();
              oneWeekAgo.setDate(oneWeekAgo.getDate() - 6);

              let commitCount = 0;
              Object.keys(commits).forEach((key) => {
                const day = key.split('/').join('-') + 'T00:00:00';
                const date = new Date(day);

                const diff = getDateDiff(oneWeekAgo, date);
                if (diff >= 0) {
                  commitCount++;
                }
                if (commitCount >= habit.frequency) {
                  functions.logger.info(`${habit.habitName} is good! because frequency is ${habit.frequency} and commit is ${commitCount}.`);
                  const body = createGoodMsgBody(goodMsg, habit.habitName);
                  pushToDevice(token, createMessage(body));
                } else {
                  functions.logger.info(`${habit.habitName} is bad! because frequency is ${habit.frequency} but commit is ${commitCount}.`);
                  const body = createBadMsgBody(badMsg, habit.habitName, habit.frequency);
                  pushToDevice(token, createMessage(body));
                }
              });
            });
          });
        });
      });
    });

// eslint-disable-next-line require-jsdoc
function pushToDevice(token, payload) {
  functions.logger.info(`pushToDevice:${token},message:${payload.notification.body}`);
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

function createMessage(body) {
  const payload = {
    notification: {
      title: 'Motivation Accelerator',
      body: body,
      badge: '1',
      sound: 'default',
    },
  };
  return payload;
}

function getDateDiff(start, end) {
  const time = end.getTime() - start.getTime();
  return Math.floor(time / (1000 * 60 * 60 * 24));
}

function createGoodMsgBody(template, habitName) {
  return template.replace('{habitName}', habitName);
}

function createBadMsgBody(template, habitName, frequency) {
  return template.replace('{habitName}', habitName).replace('{frequency}', frequency);
}
