//
//  PeerConnectionSession.m
//  btxLive-ios-app
//
//  Created by Karina Betzabe Romero Ulloa on 09/10/16.
//  Copyright © 2016 Sandcode. All rights reserved.
//

#import "PeerConnectionSession.h"

@implementation PeerConnectionSession

//-(id)initWhitCallName:(NSString*)callName SessionDescriptionRemote: (RTCSessionDescription*)sdpRemote{return self;}

-(id)initWhitUserName:(NSString*)userName SessionDescriptionRemote: (RTCSessionDescription*)sdpRemote{
    
    _iceServer=[[RTCICEServer alloc] initWithURI:[NSURL URLWithString:@"stun.l.google.com:19302"]
                                        username:@""
                                        password:@""];
    
    _arrayIceServers = [NSMutableArray array];
    [_arrayIceServers addObject:_iceServer];
    
    [RTCPeerConnectionFactory initializeSSL];
    
    _factory=[[RTCPeerConnectionFactory alloc] init];
    
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
    
    _offerConstrains= [[RTCMediaConstraints alloc] initWithMandatoryConstraints:
                        @[
                          [[RTCPair alloc] initWithKey:@"OfferToReceiveAudio" value:@"true"],
                          [[RTCPair alloc] initWithKey:@"OfferToReceiveVideo" value:@"true"]
                          ]
                                                             optionalConstraints: nil];
    _peerConnection= [_factory peerConnectionWithICEServers:_arrayIceServers
                                                constraints:_offerConstrains delegate:self];
    //[self localCamera];
    
    
    /*if(_peerConnection.localStreams.count==0){
            [_peerConnection addStream:_localStream];
    }else{
        NSLog(@"No se pudo agregar LocalStream al peer");
    }*/
    
    return self;
}


-(void)addStream:(RTCMediaStream *)lms sessionDesciption:(RTCSessionDescription*)sdpRemote{
    [_peerConnection addStream:lms];
    
    [_peerConnection setRemoteDescriptionWithDelegate:self sessionDescription:sdpRemote];
    
}


// Called when creating a session.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didCreateSessionDescription:(RTCSessionDescription *)sdp
                 error:(NSError *)error{
    
    [_peerConnection setRemoteDescriptionWithDelegate:self sessionDescription:sdp];
    
    NSLog(@"Pasando peerConnection");
}

// Called when setting a local or remote description.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didSetSessionDescriptionWithError:(NSError *)error{
    if (peerConnection.signalingState == RTCSignalingHaveRemoteOffer) {
        
        if (_peerConnection.signalingState == RTCSignalingHaveRemoteOffer) {
            // If we have a remote offer we should add it to the peer connection
            [_peerConnection createAnswerWithDelegate:self constraints:_offerConstrains];
        }
        
        NSLog(@"Pasando peerConnection");
    }
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
}

// Triggered when a remote peer close a stream.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
         removedStream:(RTCMediaStream *)stream{}

// Triggered when renegotiation is needed, for example the ICE has restarted.
- (void)peerConnectionOnRenegotiationNeeded:(RTCPeerConnection *)peerConnection{NSLog(@"Pasando peerConnectionOnRenegotiationNeeded");}

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
