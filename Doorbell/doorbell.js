var apn = require('apn');
const util = require('util');

var fs = require('fs')


var options = {
    token: {
        key: process.env.HOME + "/Library/Application Support/DoorbellJS/key.p8",
        keyId: "DDHY5S5889",
        teamId: "Z48RKT6B3T",
    },
    production: true,
};
var buttons = {};
var devices = {};
var apnProvider = new apn.Provider(options);
if(fs.existsSync(process.env.HOME + '/Library/Application Support/DoorbellJS/preferences.js', 'utf8')){
   var settings = JSON.parse(fs.readFileSync(process.env.HOME + '/Library/Application Support/DoorbellJS/preferences.js', 'utf8'));
   console.log(settings);

   buttons[settings["mac"]] = "Red Bull";
   devices[settings["iOSToken"]] = "com.button.Amazon-Button";
   devices[settings["MacToken"]] = "com.button.Doorbell";

   var dash_button = require('node-dash-button');
   var dash = dash_button(settings["mac"], null, null, 'all'); //address from step above
   dash.on("detected", function() {

     for (var key in devices) {
           let deviceToken = key;
           let topic = devices[key];
           var note = new apn.Notification();
           console.log("Button pressed");
           note.deviceToken = deviceToken;
           note.topic = "com.button.Amazon-Button";
           note.body = "Your " + buttons["44:65:0d:bd:ad:44"] + " button was pressed";
           note.title = "Button pressed";
           note.sound = "wilhelm.aif";
           note.topic = topic;
           apnProvider.send(note, deviceToken).then((result) => {
               console.log("Notification sent!");
               console.log(util.inspect(result, false, null));
           });
       }


   });

}else{
  console.log("No settings");
}
