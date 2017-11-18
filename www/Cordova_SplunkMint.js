module.exports = {
    logEvent: function (eventName, successCallback, errorCallback) {
        console.log("Cordova_SplunkMint.logEvent",eventName);
        cordova.exec(successCallback,
                     errorCallback,
                     "Cordova_SplunkMint",
                     "logEvent",
                     [eventName]);
    }
};

window.logEvent = function(eventName, successCallback, errorCallback) {
        cordova.exec(successCallback,
                     errorCallback,
                     "Cordova_SplunkMint",
                     "logEvent",
                     [eventName]);
    };