const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
exports.messageTrigger = functions.firestore.document(
    "notifications/{nid}").onCreate((snapshot, context) => {
        doc = snapshot.data();
        uid=doc.uid;
        booking=doc.booking;
        
        admin
            .firestore()
            .collection('user')
            .where('uid', '==', uid)
            .get()
            .then((querySnapshot) => {
                querySnapshot.forEach(userTo => {

                    console.log(`Found user from: ${userTo.data().displayName}`);
                                const payloadAndroid = {
                                    notification: {
                                        title: `Message from Elive`,
                                        from: `Elive Beauty Spot`,
                                        to: `${userTo.data().displayName}`,
                                        body: contentMessage,
                                        badge: '1',
                                        sound: 'default',
                                        cid: `${cid}`,
                                        click_action: 'FLUTTER_NOTIFICATION_CLICK',
                                        priority: "high"
                                    }
                                }
                                const payloadIOS = {
                                    notification: {
                                        title: `Message from ${userFrom.data().displayName}`,
                                        from: `${userFrom.data().displayName}`,
                                        to: `${userTo.data().displayName}`,
                                        body: contentMessage,
                                        badge: '1',
                                        sound: 'default',
                                        cid: `${cid}`,
                                        click_action: 'FLUTTER_NOTIFICATION_CLICK',
                                        content_available: true.toString(),
                                    }
                                }
                                var isIos;
                                if(userTo.data().isIos==null){
                                    isIos=false;
                                }else if(userTo.data().isIos==false){
                                    isIos=false;
                                }else{
                                    isIos=true;
                                }
                                admin
                                    .messaging()
                                    .sendToDevice(userTo.data().pushToken,isIos?payloadIOS: payloadAndroid)
                                    .then(response => {
                                        console.log('Successfully sent message:', response)
                                    })
                                    .catch(error => {
                                        console.log('Error sending message:', error)
                                    });

                })
            });
        // return null;
    });