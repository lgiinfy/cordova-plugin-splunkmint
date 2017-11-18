package com.customplugin.tracking;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;

import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;

import android.util.Log;

import com.splunk.mint.Mint;

public class Cordova_SplunkMint extends CordovaPlugin {

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);

        Log.d("SPLUNK: ", "Initalize");

        Mint.initAndStartSession(cordova.getActivity().getApplication(), "be382a08");
        Mint.logEvent("APP-LAUNCHED");
    }

        @Override
        public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
            Log.d("SPLUNK Action: ", action);
            if (action.equals("logEvent")) {
                String eventName = args.getString(0);

                Log.d("SPLUNK Event: ", eventName);
                Mint.logEvent(eventName);

                return true;
            }
            return false;
        }

  
}