//
//  SINCallKitProvider.h
//  SinchCallingApp
//
//  Created by Arjun  on 28/05/20.
//  Copyright © 2020 Drove&Pace. All rights reserved.
//

#import <CallKit/CallKit.h>
#import <Foundation/Foundation.h>

@protocol SINClient;
@protocol SINCall;
@protocol SINCallNotificationResult;

@interface SINCallKitProvider : NSObject <CXProviderDelegate>

@property (strong, nonatomic) id<SINClient> client;

// This method can be used should be used since iOS 13 to comply with iOS 13 changes w.r.t VoIP push and requirement to
// report an incoming call to CallKit within the scope of the delegate method -[PKPushRegistryDelegte
// pushRegistry:didReceiveIncomingPushWith:forType:]. See
// https://developer.apple.com/documentation/pushkit/pkpushregistrydelegate/2875784-pushregistry for details.
- (void)didReceivePushWithPayload:(NSDictionary*)payload;

- (void)willReceiveIncomingCall:(id<SINCall>)call;

- (BOOL)callExists:(NSString*)callId;

- (id<SINCall>)currentEstablishedCall;

@end
