const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

//Initial function call:
exports.makeRandomFigures = functions.https.onRequest((req, res) => {
    //create database ref
    var rootRef = admin.database().ref();
    var doc_count_temp = 0;
    var keys = [];
    var random_num = 0;

    //get document count
    rootRef.once('value', (snapshot) => {
        doc_count_temp = snapshot.numChildren();
        //real number of member. if delete _timeStamp then minus 2 not 3!
        var doc_count = doc_count_temp - 3;

        //get num array previous generated
        var xRef = rootRef.child("_usedFigures");

        xRef.once('value', function(snap) {
            snap.forEach(function(item) {
                var itemVal = item.val();
                keys.push(itemVal);
            });
            //get non-duplicated random number
            var is_equal = true;
            while (is_equal) {
                random_num = Math.floor((Math.random() * doc_count) + 1);
                is_equal = keys.includes(random_num);
            }

            //insert new random vaule to _usedFigures collection
            rootRef.child('_usedFigures').push(random_num);
            rootRef.child('_random').set(random_num);
        });
    });

    //send back response 
    res.redirect(200);
});

exports.sendFigureNotification = functions.database.ref('_random').onWrite(event => {

    const payload = {
        notification: {
            title: 'Title',
            body: `Test`, //use _random to get figure at index key
            badge: '1',
            sound: 'default'
        }
    };
    
    const options = {
        priority: "high",
        timeToLive: 60 * 60 * 24, //24 hours
        content_available: true
    };
    console.log('Sending notifications');

    return admin.messaging().sendToDevice(Object.keys(allToken.val()), payload, options)
});