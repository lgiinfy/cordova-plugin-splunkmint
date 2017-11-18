#import <Cordova/CDVPluginResult.h>
#import <Cordova/CDVUserAgentUtil.h>

#import "Cordova_SplunkMint.h"
#import <SplunkMint/SplunkMint.h>

@interface Cordova_SplunkMint () {
    
}

@end

@implementation Cordova_SplunkMint

- (void)pluginInitialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

- (void)finishLaunching:(NSNotification *)notification
{
    NSLog(@"SPLUNK Initalize");
    [[Mint sharedInstance] initAndStartSessionWithAPIKey:@"415f6475"];
    
    // Put here the code that should be on the AppDelegate.m

    [[Mint sharedInstance] logEventWithName:@"APP-LAUNCHED" logLevel:InfoLogLevel];
}

- (void)logEvent:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* eventName = [command.arguments objectAtIndex:0];
    
    
    if (eventName != nil) {
        NSLog(@"SPLUNK Logging Event: %@", eventName);
        if([eventName valueForKey:@"message"] != nil ){
            @try{
                NSDictionary *message = [eventName valueForKey:@"message"];
                NSDictionary *tag =[eventName valueForKey:@"tag"];
                if([message isKindOfClass:[NSString class]]){
                    NSString *newmessage = [eventName valueForKey:@"message"];
                    if(![tag isKindOfClass:[NSString class]]){
                        MintLimitedExtraData * tagvalue = [[MintLimitedExtraData alloc] init];
                        NSString *tagStr= [eventName valueForKey:@"tag"];
                        [tagvalue setValue:newmessage forKey:tagStr];
                        [[Mint sharedInstance] logEventWithName:newmessage logLevel:InfoLogLevel extraData:tagvalue];
                    }
                    else{
                        NSLog(@"message string tag string1");
                        NSString *strtag=[eventName valueForKey:@"tag"];
                        [[Mint sharedInstance] logEventWithName:newmessage logLevel:InfoLogLevel extraDataKey:@"tag" extraDataValue:strtag];
                    }
                    [[Mint sharedInstance] flush];
                    
                }
                else{
                    NSString *aValue = @"";
                    NSString *strKeyValue = @"";
                    for(NSString *akey in [message allKeys]){
                         aValue = [message valueForKey:akey];
                         strKeyValue = [NSString stringWithFormat:@"%@" @"=" @"%@", akey, aValue];
                        if(strKeyValue.length > 255){
                        NSRange stringRange = {0, MIN([strKeyValue length], 254)};
                        stringRange = [strKeyValue rangeOfComposedCharacterSequencesForRange:stringRange];
                        NSString *shortString = [strKeyValue substringWithRange:stringRange];
                        strKeyValue = shortString;
                        }
                        if(![tag isKindOfClass:[NSString class]]){
                            MintLimitedExtraData * tagvalue = [[MintLimitedExtraData alloc] init];
                            NSString *tagStr= [eventName valueForKey:@"tag"];
                            [tagvalue setValue:strKeyValue forKey:tagStr];
                            [[Mint sharedInstance] logEventWithName:strKeyValue logLevel:InfoLogLevel extraData:tagvalue];                        }
                        else{
                            
                            NSString *strtag=[eventName valueForKey:@"tag"];
                            [[Mint sharedInstance] logEventWithName:strtag logLevel:InfoLogLevel extraDataKey:@"message" extraDataValue:strKeyValue];
                        }
                        [[Mint sharedInstance] flush];
                    }
                }
                [[Mint sharedInstance] flush];

            }
            @catch(NSException *e){
            }
            [[Mint sharedInstance] flush];
        }
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:eventName];
        //NSLog(eventName);
    } else {
        NSLog(@"SPLUNK No event name found");
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}


@end