//
//  MessagesHandlerToSignaling.m
//  btxLive-ios-app
//
//  Created by Karina Betzabe Romero Ulloa on 09/10/16.
//  Copyright © 2016 Sandcode. All rights reserved.
//

#import "MessagesHandlerToSignaling.h"
#import "RTCAVFoundationVideoSource.h"

@implementation MessagesHandlerToSignaling




-(id)init:(NSString*)userName{
    self = [super init];
    if(self)
    {
        _isConnected=NO;
        if (_cases == nil) {
            _cases = [[NSMutableDictionary alloc] initWithCapacity:2];
            [_cases setObject:[NSNumber numberWithInt:login] forKey:@"login"];
            [_cases setObject:[NSNumber numberWithInt:offer] forKey:@"offer"];
            [_cases setObject:[NSNumber numberWithInt:answer] forKey:@"answer"];
            [_cases setObject:[NSNumber numberWithInt:candidate] forKey:@"candidate"];
            [_cases setObject:[NSNumber numberWithInt:leave] forKey:@"leave"];
        }
        _miName=userName;
        
        [self connectWebSocket];
        
        _iceServer=[[RTCICEServer alloc] initWithURI:[NSURL URLWithString:@"stun.l.google.com:19302"]
                                            username:@""
                                            password:@""];
        
        _arrayIceServers = [NSMutableArray array];
        [_arrayIceServers addObject:_iceServer];
        
        _constraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:
         @[
           [[RTCPair alloc] initWithKey:@"OfferToReceiveAudio" value:@"true"],
           [[RTCPair alloc] initWithKey:@"OfferToReceiveVideo" value:@"true"]
           ]
                                              optionalConstraints: nil];
        
        _peerConnections = [[NSMutableDictionary alloc]init];
        
        /*[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationChanged:)
                                                     name:@"UIDeviceOrientationDidChangeNotification"
                                                   object:nil];*/
    }
    return self;
    
}
/*
- (void)orientationChanged:(NSNotification *)notification {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(orientation) || UIDeviceOrientationIsPortrait(orientation)) {
        //Remove current video track
        RTCMediaStream *localStream = _peerConnection.localStreams[0];
        [localStream removeVideoTrack:localStream.videoTracks[0]];
        
        RTCVideoTrack *localVideoTrack = [self createLocalVideoTrack];
        if (localVideoTrack) {
            [localStream addVideoTrack:localVideoTrack];
            [_delegate didReceiveLocalVideoTrack:localVideoTrack];
        }
        [_peerConnection removeStream:localStream];
        [_peerConnection addStream:localStream];
    }
}*/

- (void)connectWebSocket {
    _webSocket.delegate = nil;
    _webSocket = nil;
    
    NSString *urlString = @"ws://162.243.206.15:8888";
    SRWebSocket *newWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    newWebSocket.delegate = self;
    
    [newWebSocket open];
    
    _isConnected = YES;
    
    NSLog(@"connectWebSocket");
    
    [self PreViewLocal];
    
}

-(void) PreViewLocal{
    [RTCPeerConnectionFactory deinitializeSSL];
    
    _factory = [[RTCPeerConnectionFactory alloc] init];
    
    RTCMediaConstraints *constraints = [self defaultPeerConnectionConstraints];
    _peerConnection = [_factory peerConnectionWithICEServers:_arrayIceServers
                                                 constraints:constraints
                                                    delegate:self];
    
    _localMediaStream = [self createLocalMediaStream];
    [_peerConnection addStream:_localMediaStream];
   
    [_peerConnection addStream:_localMediaStream];
    
    [self.peerConnections setObject:_peerConnection forKey:_miName];
    
   
    
}

- (RTCMediaStream *)createLocalMediaStream {
    RTCMediaStream* localStream = [_factory mediaStreamWithLabel:@"ARDAMS"];
    
    RTCVideoTrack *localVideoTrack = [self createLocalVideoTrack];
    if (localVideoTrack) {
        [localStream addVideoTrack:localVideoTrack];
        [_delegate didReceiveLocalVideoTrack:localVideoTrack];
    }
    
    [localStream addAudioTrack:[_factory audioTrackWithID:@"ARDAMSa0"]];
    NSLog(@"MEDIA STREAM LOCAL <----------");
    NSLog(@"%@", localStream.description);
    
    return localStream;
}

- (RTCVideoTrack *)createLocalVideoTrack {
    // The iOS simulator doesn't provide any sort of camera capture
    // support or emulation (http://goo.gl/rHAnC1) so don't bother
    // trying to open a local stream.
    // TODO(tkchin): local video capture for OSX. See
    // https://code.google.com/p/webrtc/issues/detail?id=3417.
    
    RTCVideoTrack *localVideoTrack = nil;
#if !TARGET_IPHONE_SIMULATOR && TARGET_OS_IPHONE

    
    AVCaptureDevice *device;
    for (AVCaptureDevice *captureDevice in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] ) {
        if (captureDevice.position == AVCaptureDevicePositionFront) {
            device = captureDevice;
            break;
        }
    }
    
    if(device){
        
    RTCVideoCapturer *capturer = [RTCVideoCapturer capturerWithDeviceName:device.localizedName];
    RTCMediaConstraints *mediaConstraints = [self defaultMediaStreamConstraints];
    RTCVideoSource *videoSource = [_factory videoSourceWithCapturer:capturer constraints:mediaConstraints];
    localVideoTrack = [_factory videoTrackWithID:@"ARDAMSv0" source:videoSource];
        }
#endif
    return localVideoTrack;
}
- (RTCMediaConstraints *)defaultMediaStreamConstraints {
    RTCMediaConstraints* constraints =
    [[RTCMediaConstraints alloc]
     initWithMandatoryConstraints:nil
     optionalConstraints:nil];
    return constraints;
}

- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    
    NSLog(@"user conected");
    _webSocket = newWebSocket;
    
    NSDictionary *formatoJson= [NSDictionary dictionaryWithObjectsAndKeys: @"login",@"type", _miName, @"name", nil];
    
    id jsonObject = [NSJSONSerialization dataWithJSONObject:formatoJson options:0 error:nil];
    
    [_webSocket send:jsonObject];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    
    NSString *messageString = message;
    
    NSData *messageData = [messageString dataUsingEncoding:NSUnicodeStringEncoding];
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:messageData
                                                    options:0
                                                      error:nil];
    NSString *JSONobject=[jsonObject objectForKey:@"type"];
    
    bool success=[jsonObject objectForKey:@"success"];
    
 
    NSString *messageSDP;
    NSString *messageCandidate;
    
    
 
    
    switch([[_cases objectForKey:JSONobject] intValue]) {
        case login:
            
            if(success){
                NSLog(@"on connection");
            }else{
                NSLog(@"Without connection");
            }
            
            break;
        case offer:
          
            
            messageSDP = [[jsonObject objectForKey:@"offer"]valueForKey:@"sdp"];
            
            _sdpRemote = [[RTCSessionDescription alloc] initWithType:@"offer" sdp:messageSDP];
            
            [_peerConnection setRemoteDescriptionWithDelegate:self sessionDescription:_sdpRemote];
            
            _yourName = [jsonObject objectForKey:@"name"];
            
            _peerRemote=[_factory peerConnectionWithICEServers:_arrayIceServers constraints:_constraints delegate:self];
            
            
            NSLog(@"%@", _yourName);
            
            [self.peerConnections setObject:_peerRemote forKey:_yourName];
            
            NSLog(@"%lu", (unsigned long)_peerConnections.count);
            
            
            
            
            
            
            break;
        case answer:
            NSLog(@"on answer");
            break;
        case candidate:
            NSLog(@"on candidate");
            
            if(_peerConnection.isAccessibilityElement){
                messageCandidate = [[jsonObject objectForKey:@"candidate"]valueForKey:@"candidate"];
                NSLog(@"%@", messageCandidate);
                
                _peerCandidate = [[RTCICECandidate alloc] initWithMid:[[jsonObject objectForKey:@"candidate"]valueForKey:@"sdpMid"]
                                                                index: [[[jsonObject objectForKey:@"candidate"]valueForKey:@"sdpMLineIndex"] integerValue]
                                                                  sdp:[[jsonObject objectForKey:@"candidate"]valueForKey:@"candidate"]];
                
                [self.peerConnection addICECandidate:_peerCandidate];
            }
            
            
            break;
        case leave:
            NSLog(@"on leave");
            break;
        default:
            break;
    }
}

- (RTCMediaConstraints *)defaultPeerConnectionConstraints {
    NSArray *optionalConstraints = @[
                                     [[RTCPair alloc] initWithKey:@"DtlsSrtpKeyAgreement" value:@"true"]
                                     ];
    RTCMediaConstraints* constraints =
    [[RTCMediaConstraints alloc]
     initWithMandatoryConstraints:nil
     optionalConstraints:optionalConstraints];
    return constraints;
}

- (RTCMediaConstraints *)defaultOfferConstraints {
    NSArray *mandatoryConstraints = @[
                                      [[RTCPair alloc] initWithKey:@"OfferToReceiveAudio" value:@"true"],
                                      [[RTCPair alloc] initWithKey:@"OfferToReceiveVideo" value:@"true"]
                                      ];
    RTCMediaConstraints* constraints =
    [[RTCMediaConstraints alloc]
     initWithMandatoryConstraints:mandatoryConstraints
     optionalConstraints:nil];
    return constraints;
}



- (void)peerConnection:(RTCPeerConnection *)peerConnection didCreateSessionDescription:(RTCSessionDescription *)sdp error:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSLog(@"didCreateSessionDescription...........");
        
        [_peerConnection setLocalDescriptionWithDelegate:self
                                      sessionDescription:sdp];
        //[_peerConnection createAnswerWithDelegate:self constraints:[self defaultOfferConstraints]];
        
        NSMutableDictionary *answerSDP = [NSMutableDictionary dictionary];
        [answerSDP setObject: @"answer" forKey:@"type"];
        [answerSDP setObject: sdp.description forKey:@"sdp"];
        
        
        NSMutableDictionary *answerSend = [NSMutableDictionary dictionary];
        [answerSend setObject: @"answer" forKey:@"type"];
        [answerSend setObject: answerSDP forKey:@"answer"];
        [answerSend setObject: _yourName forKey:@"name"];

        
        NSData *jsonAnswerSend = [NSJSONSerialization dataWithJSONObject:answerSend
                                                                options:0 error:nil];
        
        NSString* newStr = [[NSString alloc] initWithData:jsonAnswerSend encoding:NSUTF8StringEncoding];
        
        [_webSocket send:newStr];
    });}

- (void)peerConnection:(RTCPeerConnection *)peerConnection didSetSessionDescriptionWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
      
        // If we're answering and we've just set the remote offer we need to create
        // an answer and set the local description.
        NSLog(@"signalingState");
        NSLog(@"%u", _peerConnection.signalingState);
        
        NSLog(@"RTCSignalingHaveRemoteOffer");
        NSLog(@"%d", RTCSignalingHaveRemoteOffer);
        
        NSLog(@"RTCSignalingHaveLocalOffer");
        NSLog(@"%d", RTCSignalingHaveLocalOffer);
        
        NSLog(@"RTCSignalingHaveRemotePrAnswer");
        NSLog(@"%d", RTCSignalingHaveRemotePrAnswer);
        
        NSLog(@"RTCSignalingHaveLocalPrAnswer");
        NSLog(@"%d", RTCSignalingHaveLocalPrAnswer);
        
        NSLog(@"RTCSignalingStable");
        NSLog(@"%d", RTCSignalingStable);
        
        if (peerConnection.signalingState == RTCSignalingHaveRemoteOffer) {
            
            RTCMediaConstraints *constraints = [self defaultOfferConstraints];
            [_peerConnection createAnswerWithDelegate:self
                                          constraints:constraints];
            
        }
    });

    
}

// Triggered when the SignalingState changed.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
 signalingStateChanged:(RTCSignalingState)stateChanged{
    NSLog(@"Pasando signalingStateChanged");
}

// Triggered when media is received on a new stream from remote peer.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
           addedStream:(RTCMediaStream *)stream{
    NSLog(@"Pasando addedStream");
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"Received %lu video tracks and %lu audio tracks",
              (unsigned long)stream.videoTracks.count,
              (unsigned long)stream.audioTracks.count);
        if (stream.videoTracks.count) {
            RTCVideoTrack *videoTrack = stream.videoTracks[0];
            [_delegate  didReceiveRemoteVideoTrack:videoTrack];
            
            
        }
    });
}

// Triggered when a remote peer close a stream.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
         removedStream:(RTCMediaStream *)stream{}

// Triggered when renegotiation is needed, for example the ICE has restarted.
- (void)peerConnectionOnRenegotiationNeeded:(RTCPeerConnection *)peerConnection{NSLog(@"Pasando peerConnectionOnRenegotiationNeeded");
    NSLog( @"%@", _peerConnection);
}

// Called any time the ICEConnectionState changes.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
  iceConnectionChanged:(RTCICEConnectionState)newState{}

// Called any time the ICEGatheringState changes.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
   iceGatheringChanged:(RTCICEGatheringState)newState{}

// New Ice candidate have been found.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
       gotICECandidate:(RTCICECandidate *)candidate{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString *candidateString = [NSString stringWithFormat:@"%@%@%ld", candidate.sdp, candidate.sdpMid, (long)candidate.sdpMLineIndex];
        
        NSMutableDictionary *candidateSend = [NSMutableDictionary dictionary];
        [candidateSend setObject: candidateString forKey:@"candidate"];
        
        
        NSMutableDictionary *candidateSending = [NSMutableDictionary dictionary];
        [candidateSending setObject: @"candidate" forKey:@"type"];
        [candidateSending setObject: candidateSend forKey:@"candidate"];
        [candidateSending setObject: _yourName forKey:@"name"];
        
        
        NSData *jsonCandidateSend = [NSJSONSerialization dataWithJSONObject:candidateSending
                                                                 options:0 error:nil];
        
        NSString* stringCandidateSend = [[NSString alloc] initWithData:jsonCandidateSend encoding:NSUTF8StringEncoding];
        
        [_webSocket send:stringCandidateSend];
        
    });

}

// New data channel has been opened.
- (void)peerConnection:(RTCPeerConnection*)peerConnection
    didOpenDataChannel:(RTCDataChannel*)dataChannel{}

@end
