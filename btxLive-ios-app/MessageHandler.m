//
//  MessageHandler.m
//  btxLive-ios-app
//
//  Created by Karina Betzabe Romero Ulloa on 16/09/16.
//  Copyright © 2016 Sandcode. All rights reserved.
//

#import "MessageHandler.h"

@implementation MessageHandler


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
        _userName=userName;
        [self connectWebSocket];
        
        _iceServer=[[RTCICEServer alloc] initWithURI:[NSURL URLWithString:@"stun.l.google.com:19302"]
                                            username:@""
                                            password:@""];
        
        
        _iceServers = [NSMutableArray array];
        [_iceServers addObject:_iceServer];
        
        _factory= [[RTCPeerConnectionFactory alloc] init];
        
        
        _mandatoryConstraints = @[
                                  [[RTCPair alloc] initWithKey:@"maxWidth" value:@"640"],
                                  [[RTCPair alloc] initWithKey:@"minWidth" value:@"640"],
                                  [[RTCPair alloc] initWithKey:@"maxHeight" value:@"480"],
                                  [[RTCPair alloc] initWithKey:@"minHeight" value:@"480"],
                                  [[RTCPair alloc] initWithKey:@"maxFrameRate" value:@"30"],
                                  [[RTCPair alloc] initWithKey:@"minFrameRate" value:@"5"],
                                  [[RTCPair alloc] initWithKey:@"googLeakyBucket" value:@"true"]
                                  ];
        _constrains= [[RTCMediaConstraints alloc] initWithMandatoryConstraints:_mandatoryConstraints optionalConstraints:nil];
        
        _offerConstraints= [[RTCMediaConstraints alloc] initWithMandatoryConstraints:
        @[
          [[RTCPair alloc] initWithKey:@"OfferToReceiveAudio" value:@"true"],
          [[RTCPair alloc] initWithKey:@"OfferToReceiveVideo" value:@"true"]
          ]
    optionalConstraints: nil];
        /*RTCConfiguration *rtc = [[RTCConfiguration alloc]init];
        [rtc setIceServers:_iceServers];*/
        
        _peerConnection = [_factory peerConnectionWithICEServers:_iceServers constraints:_constrains delegate:self];
        
        
    }
    return self;
    
}



- (void)connectWebSocket {
    _webSocket.delegate = nil;
    _webSocket = nil;
    
    NSString *urlString = @"ws://162.243.206.15:8888";
    SRWebSocket *newWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    newWebSocket.delegate = self;
    
    [newWebSocket open];
    
    _isConnected = YES;
    
}


- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    
    NSLog(@"user conected");
    _webSocket = newWebSocket;
    
    NSDictionary *formatoJson= [NSDictionary dictionaryWithObjectsAndKeys: @"login",@"type", _userName, @"name", nil];
    
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
    
    NSLog(@"%@", jsonObject);
    
    NSString *messageSDP;
    
    switch([[_cases objectForKey:JSONobject] intValue]) {
        case login:
            
            if(success){
                NSLog(@"on connection");
            }else{
                NSLog(@"Without connection");
            }
            
            break;
        case offer:
            NSLog(@"on offer--------->");

            messageSDP = [[jsonObject objectForKey:@"offer"]valueForKey:@"sdp"];
            
            NSLog(@"%@", messageSDP);

            _sdpRemote = [[RTCSessionDescription alloc] initWithType:@"offer" sdp:messageSDP];
            
            
            [self localCamera];

            [_peerConnection addStream:_localStream];
            
            [_peerConnection setRemoteDescriptionWithDelegate:self sessionDescription:_sdpRemote];
            
            
            break;
        case answer:
            NSLog(@"on answer");
            break;
        case candidate:
            NSLog(@"on candidate");
            break;
        case leave:
            NSLog(@"on leave");
            break;
        default:
            break;
    }
    
    /*self.textUserName.text = [NSString stringWithFormat:@"%@\n%@", self.textUserName.text, message];*/
    
}




-(void) localCamera{
    for (AVCaptureDevice *captureDevice in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] ) {
        if (captureDevice.position == AVCaptureDevicePositionFront) {
            _device = captureDevice;
            
            break;
        }
    }
    if (_device) {
        
        _localStream = [_factory mediaStreamWithLabel:@"ARDAMS"];
        
        NSLog(@"On local");
        
        _videoCapturer = [RTCVideoCapturer capturerWithDeviceName:_device.localizedName];
        
        _videoSource = [_factory videoSourceWithCapturer: _videoCapturer constraints:_constrains];
        
        _videoTrack = [_factory videoTrackWithID:@"ARDAMSv0" source:_videoSource];
        [_localStream addVideoTrack:_videoTrack];
        
        _audioTrack = [_factory audioTrackWithID:@"ARDAMSa0"];
        
        [_localStream addAudioTrack:_audioTrack];
    }
    
}

//----------------------------------------------------------------

// Called when creating a session.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didCreateSessionDescription:(RTCSessionDescription *)sdp
                 error:(NSError *)error{
    RTCSessionDescription* sessionDescription = [[RTCSessionDescription alloc] initWithType:sdp.type sdp:sdp.description];
    [peerConnection setLocalDescriptionWithDelegate:self sessionDescription:sessionDescription];
    
    NSLog(@"Pasando por aqui didCreateSessionDescription");
}

// Called when setting a local or remote description.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didSetSessionDescriptionWithError:(NSError *)error{}

// Triggered when the SignalingState changed.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
 signalingStateChanged:(RTCSignalingState)stateChanged{}

// Triggered when media is received on a new stream from remote peer.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
           addedStream:(RTCMediaStream *)stream{}

// Triggered when a remote peer close a stream.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
         removedStream:(RTCMediaStream *)stream{}

// Triggered when renegotiation is needed, for example the ICE has restarted.
- (void)peerConnectionOnRenegotiationNeeded:(RTCPeerConnection *)peerConnection{}

// Called any time the ICEConnectionState changes.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
  iceConnectionChanged:(RTCICEConnectionState)newState{}

// Called any time the ICEGatheringState changes.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
   iceGatheringChanged:(RTCICEGatheringState)newState{}

// New Ice candidate have been found.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
       gotICECandidate:(RTCICECandidate *)candidate{}

// New data channel has been opened.
- (void)peerConnection:(RTCPeerConnection*)peerConnection
    didOpenDataChannel:(RTCDataChannel*)dataChannel{}
@end
