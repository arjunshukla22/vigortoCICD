//
//  SINCallKitProvider.m
//  SinchCallingApp
//
//  Created by Arjun  on 28/05/20.
//  Copyright © 2020 Drove&Pace. All rights reserved.
//

#import "SINCallKitProvider.h"
#import "AudioControllerDelegate.h"
#import <Sinch/Sinch.h>

static CXCallEndedReason SINGetCallEndedReason(SINCallEndCause cause) {
  switch (cause) {
    case SINCallEndCauseError:
      return CXCallEndedReasonFailed;
    case SINCallEndCauseDenied:
      return CXCallEndedReasonRemoteEnded;
    case SINCallEndCauseHungUp:
      // This mapping is not really correct, as SINCallEndCauseHungUp is the end case also when the local peer ended the
      // call.
      return CXCallEndedReasonRemoteEnded;
    case SINCallEndCauseTimeout:
      return CXCallEndedReasonUnanswered;
    case SINCallEndCauseCanceled:
      return CXCallEndedReasonUnanswered;
    case SINCallEndCauseNoAnswer:
      return CXCallEndedReasonUnanswered;
    case SINCallEndCauseOtherDeviceAnswered:
      return CXCallEndedReasonUnanswered;
    default:
      break;
  }
  return CXCallEndedReasonFailed;
}

static NSUUID *UUIDCallId(NSString *callId) {
  if (!callId)
    return nil;
  return [[NSUUID alloc] initWithUUIDString:callId];
}

@interface SINCallKitProvider () {
  id<SINClient> _client;
  CXProvider *_provider;
  AudioContollerDelegate *_acDelegate;
  NSMutableDictionary<NSUUID *, id<SINCall>> *_calls;
  NSMutableSet<NSUUID *> *_incomingCallIds;
}
@end

@implementation SINCallKitProvider

- (instancetype)init {
  self = [super init];
  if (self) {
    _acDelegate = [[AudioContollerDelegate alloc] init];
    _calls = [NSMutableDictionary dictionary];
    _incomingCallIds = [NSMutableSet set];
    CXProviderConfiguration *config = [[CXProviderConfiguration alloc] initWithLocalizedName:@"SmileIndia"];
    config.maximumCallGroups = 1;
    config.maximumCallsPerCallGroup = 1;
    config.supportsVideo = YES;
    UIImage *callkitIcon = [UIImage imageNamed:@"smileindia_new"];
    config.iconTemplateImageData = UIImagePNGRepresentation(callkitIcon);

    _provider = [[CXProvider alloc] initWithConfiguration:config];
    [_provider setDelegate:self queue:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callDidEnd:)
                                                 name:SINCallDidEndNotification
                                               object:nil];
  }
  return self;
}

- (void)setClient:(id<SINClient>)client {
  if (_client.audioController.delegate == _acDelegate) {
    _client.audioController.delegate = nil;
  }
  _client = client;
  _client.audioController.delegate = _acDelegate;
}


- (void)didReceivePushWithPayload:(NSDictionary *)payload {
  id<SINNotificationResult> notification = [SINPushHelper queryPushNotificationPayload:payload];

  if ([notification isCall]) {
    id<SINCallNotificationResult> callNotification = [notification callResult];
    NSUUID *callId = UUIDCallId(callNotification.callId);

    if ([self applicationState] == UIApplicationStateActive) {
      NSLog(@"Application state is UIApplicationStateActive, skipping reporting VoIP push to CallKit");
      [self addReportedCall:callId];
      return;
    }

    if (![self hasReportedCall:callId]) {
      [self reportNewIncomingCallWithNotification:callNotification];
    }
  }
}

- (void)willReceiveIncomingCall:(id<SINCall>)call {
  [self addCall:call];
}

#pragma mark -

- (void)reportNewIncomingCallWithNotification:(id<SINCallNotificationResult>)notification {
  NSParameterAssert(_provider);

  NSUUID *callId = UUIDCallId(notification.callId);

  [self addReportedCall:callId];

  CXCallUpdate *update = [[CXCallUpdate alloc] init];
  update.remoteHandle = [[CXHandle alloc] initWithType:CXHandleTypeGeneric value:notification.remoteUserId];
  update.hasVideo = notification.isVideoOffered;

  [_provider reportNewIncomingCallWithUUID:callId
                                    update:update
                                completion:^(NSError *_Nullable error) {
                                  if (error) {
                                    // If we get an error here from the OS, it is possibly the callee's phone has "Do
                                    // Not Disturb" turned on, check CXErrorCodeIncomingCallError in CXError.h
                                    [self hangupCallWithId:callId];
                                    NSLog(@"%@", error);
                                  }
                                }];
}

- (void)addReportedCall:(NSUUID *)callId {
  @synchronized(self) {
    [_incomingCallIds addObject:callId];
  }
}

- (BOOL)hasReportedCall:(NSUUID *)callId {
  if (!callId)
    return NO;

  @synchronized(self) {
    return [_incomingCallIds containsObject:callId];
  }
}

- (void)addCall:(id<SINCall>)call {
  NSLog(@"[%@] Adding call: %@", call.callId, call.callId);
  @synchronized(self) {
    [_calls setObject:call forKey:UUIDCallId(call.callId)];
  }
}

- (void)removeCallWithId:(NSUUID *)callId {
  @synchronized(self) {
    [_calls removeObjectForKey:callId];
  }
}

- (id<SINCall>)callWithId:(NSUUID *)callId {
  @synchronized(self) {
    return [_calls objectForKey:callId];
  }
}

- (BOOL)callExists:(id)callId {
  NSString *callIdAsString = nil;
  if ([callId isKindOfClass:NSUUID.class]) {
    callIdAsString = [callId UUIDString];
  } else if ([callId isKindOfClass:NSString.class]) {
    callIdAsString = callId;
  } else {
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Unsupported callId typ" userInfo:nil];
  }
  for (id<SINCall> call in [self activeCalls]) {
    if (NSOrderedSame == [call.callId caseInsensitiveCompare:callIdAsString]) {
      return YES;
    }
  }
  return NO;
}

- (NSArray<id<SINCall>> *)activeCalls {
  @synchronized(self) {
    return [[_calls allValues] copy];
  }
}

- (id<SINCall>)currentEstablishedCall {
  NSArray *calls = [self activeCalls];
  if ([calls count] > 0 && [calls[0] state] == SINCallStateEstablished) {
    return calls[0];
  } else {
    return nil;
  }
}

- (void)hangupCallWithId:(NSUUID *)callId {
  [[self callWithId:callId] hangup];
}

// Handle cancel/hangup event initiated by either caller or callee
- (void)callDidEnd:(NSNotification *)notification {
  id<SINCall> call = [notification userInfo][SINCallKey];
  if (call) {
    [_provider reportCallWithUUID:UUIDCallId(call.callId)
                      endedAtDate:call.details.endedTime
                           reason:SINGetCallEndedReason(call.details.endCause)];
  } else {
    NSLog(@"WARNING: No Call was reported as ended on SINCallDidEndNotification");
  }

  if ([self callExists:call.callId]) {
    NSLog(@"callDidEnd, Removing call: %@", call.callId);
    [self removeCallWithId:UUIDCallId(call.callId)];
  }
}

- (UIApplicationState)applicationState {
  // Unsafe way of aquiring UIApplicationState on non-main thread / GCD queue
  // without triggering Main Thread Checker.
  if ([NSThread isMainThread]) {
    return UIApplication.sharedApplication.applicationState;
  } else {
    __block UIApplicationState state;
    dispatch_sync(dispatch_get_main_queue(), ^{
      state = UIApplication.sharedApplication.applicationState;
    });
    return state;
  }
}

#pragma mark - CXProviderDelegate

- (void)provider:(CXProvider *)provider didActivateAudioSession:(AVAudioSession *)audioSession {
  if (nil == _client) {
    NSLog(@"WARNING: SINClient not assigned when audio session is activating (provider:didActivateAudioSession:)");
  }
  [_client.callClient provider:provider didActivateAudioSession:audioSession];
}

- (void)provider:(CXProvider *)provider didDeactivateAudioSession:(AVAudioSession *)audioSession {
  [_client.callClient provider:provider didDeactivateAudioSession:audioSession];
}

- (id<SINCall>)callForAction:(CXCallAction *)action {
  id<SINCall> call = [self callWithId:action.callUUID];
  if (!call) {
    NSLog(@"WARNING: No call found for (%@)", action.callUUID);
  }
  return call;
}

- (void)provider:(CXProvider *)provider performAnswerCallAction:(CXAnswerCallAction *)action {
  [[self callForAction:action] answer];
  [[_client audioController] configureAudioSessionForCallKitCall];
  [action fulfill];
}

- (void)provider:(CXProvider *)provider performEndCallAction:(CXEndCallAction *)action {
  [[self callForAction:action] hangup];
  [action fulfill];
}

- (void)provider:(CXProvider *)provider performSetMutedCallAction:(CXSetMutedCallAction *)action {
  NSLog(@"-[CXProviderDelegate performSetMutedCallAction:]");

  if (_acDelegate.muted) {
    [[_client audioController] unmute];
  } else {
    [[_client audioController] mute];
  }

  [action fulfill];
}

- (void)providerDidReset:(CXProvider *)provider {
  NSLog(@"-[CXProviderDelegate providerDidReset:]");
}

@end
