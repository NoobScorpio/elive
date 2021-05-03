const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
exports.bookingConfirmFunction = functions.firestore.document(
    "notifications/{nid}").onCreate((snapshot, context) => {
        doc = snapshot.data();
        uid=doc.uid;
        time=doc.time;
        date=doc.date;
        total=doc.total;
        contentMessage=`Your booking on ${date} at ${time} for AED ${total} has been confirmed`
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
                                        title: `Booking Confirmed`,
                                        from: `Elive Beauty Spot`,
                                        to: `${userTo.data().displayName}`,
                                        body: contentMessage,
                                        badge: '1',
                                        sound: 'default',
                                        click_action: 'FLUTTER_NOTIFICATION_CLICK',
                                        priority: "high"
                                    }
                                }
                                // const payloadIOS = {
                                //     notification: {
                                //         title: `Message from ${userFrom.data().displayName}`,
                                //         from: `${userFrom.data().displayName}`,
                                //         to: `${userTo.data().displayName}`,
                                //         body: contentMessage,
                                //         badge: '1',
                                //         sound: 'default',
                                //         cid: `${cid}`,
                                //         click_action: 'FLUTTER_NOTIFICATION_CLICK',
                                //         content_available: true.toString(),
                                //     }
                                // }
                                
                                admin
                                    .messaging()
                                    .sendToDevice(userTo.data().pushToken,payloadAndroid)
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

exports.promotionFunction = functions.firestore.document(
        "promotions/{pid}").onCreate((snapshot, context) => {
            doc = snapshot.data();
            contentMessage=doc.message;
            admin
                .firestore()
                .collection('user')
                .get()
                .then((querySnapshot) => {
                    querySnapshot.forEach(userTo => {
    
                        console.log(`Found user from: ${userTo.data().displayName}`);
                                    const payloadAndroid = {
                                        notification: {
                                            title: `Promotion`,
                                            from: `Elive Beauty Spot`,
                                            to: `${userTo.data().displayName}`,
                                            body: contentMessage,
                                            badge: '1',
                                            sound: 'default',
                                            click_action: 'FLUTTER_NOTIFICATION_CLICK',
                                            priority: "high"
                                        }
                                    }
                                    // const payloadIOS = {
                                    //     notification: {
                                    //         title: `Message from ${userFrom.data().displayName}`,
                                    //         from: `${userFrom.data().displayName}`,
                                    //         to: `${userTo.data().displayName}`,
                                    //         body: contentMessage,
                                    //         badge: '1',
                                    //         sound: 'default',
                                    //         cid: `${cid}`,
                                    //         click_action: 'FLUTTER_NOTIFICATION_CLICK',
                                    //         content_available: true.toString(),
                                    //     }
                                    // }
                                    
                                    admin
                                        .messaging()
                                        .sendToDevice(userTo.data().pushToken,payloadAndroid)
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