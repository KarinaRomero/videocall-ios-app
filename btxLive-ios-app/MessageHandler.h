//
//  MessageHandler.h
//  btxLive-ios-app
//
//  Created by Karina Betzabe Romero Ulloa on 16/09/16.
//  Copyright © 2016 Sandcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketRocket.h"
#import <AVFoundation/AVFoundation.h>
#import <libjingle_peerconnection/RTCSessionDescription.h>
#import <libjingle_peerconnection/RTCICEServer.h>
#import <libjingle_peerconnection/RTCICECandidate.h>
#import <libjingle_peerconnection/RTCSessionDescription.h>
#import <libjingle_peerconnection/RTCMediaConstraints.h>
#import <libjingle_peerconnection/RTCPair.h>
#import <libjingle_peerconnection/RTCMediaConstraints.h>
#import <libjingle_peerconnection/RTCPeerConnectionInterface.h>
#import <libjingle_peerconnection/RTCPeerConnectionDelegate.h>
#import <libjingle_peerconnection/RTCSessionDescriptionDelegate.h>
#import <libjingle_peerconnection/RTCPeerConnectionFactory.h>
#import <libjingle_peerconnection/RTCVideoCapturer.h>
#import <libjingle_peerconnection/RTCVideoTrack.h>
#import <libjingle_peerconnection/RTCAudioTrack.h>
#import <libjingle_peerconnection/RTCVideoSource.h>
#import <libjingle_peerconnection/RTCMediaStream.h>
#import <libjingle_peerconnection/RTCPeerConnection.h>

//#import "Peer.h"

@interface MessageHandler : NSObject  <SRWebSocketDelegate,RTCPeerConnectionDelegate, RTCSessionDescriptionDelegate>

@property (nonatomic) SRWebSocket* webSocket;
typedef enum {
    login,
    offer,
    answer,
    candidate,
    leave
} signalingMessages;
@property (nonatomic) NSMutableDictionary * cases;
@property (nonatomic) NSString *userName;
@property (nonatomic) bool isConnected;
@property (nonatomic) RTCSessionDescription* sdpRemote;
//@property (nonatomic) Peer* peerRemote;



-(id)init:(NSString*)name;


//-------------------------------------------------------------

@property (nonatomic, strong) RTCPeerConnection* peerConnection;
@property (nonatomic) NSMutableArray* peersConnections;
@property (nonatomic) int endPoint;
@property (nonatomic, strong) RTCPeerConnectionFactory *factory;
@property (nonatomic) NSMutableArray *iceServers;
@property (nonatomic) RTCICEServer *iceServer;
@property (nonatomic) RTCMediaConstraints *constraints;
@property (nonatomic) RTCMediaStream *localStream;
@property (nonatomic) RTCMediaStream *remoteStream;
//@property (nonatomic) NSArray* peers;
@property (nonatomic) AVCaptureDevice* device;
@property (nonatomic) RTCVideoSource *videoSource;
@property (nonatomic) RTCVideoCapturer *videoCapturer;
@property (nonatomic) RTCVideoTrack *videoTrack;
@property (nonatomic) RTCAudioTrack *audioTrack;

@property (nonatomic) NSArray *mandatoryConstraints;
@property (nonatomic) RTCMediaConstraints *constrains;

//-(void) onOffer: (RTCSessionDescription*)SDP;


@end
