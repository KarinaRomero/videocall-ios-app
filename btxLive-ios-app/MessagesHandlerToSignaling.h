//
//  MessagesHandlerToSignaling.h
//  btxLive-ios-app
//
//  Created by Karina Betzabe Romero Ulloa on 09/10/16.
//  Copyright © 2016 Sandcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTCAVFoundationVideoSource.h"
#import "SocketRocket.h"
#import "PeerConnectionSession.h"
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
#import <libjingle_peerconnection/RTCPeerConnectionFactory.h>

@protocol onPeer <NSObject>

- (void)didReceiveLocalVideoTrack:(RTCVideoTrack *)localVideoTrack;
- (void)didReceiveRemoteVideoTrack:(RTCVideoTrack *)remoteVideoTrack;
@end

@interface MessagesHandlerToSignaling : NSObject <SRWebSocketDelegate,RTCPeerConnectionDelegate,RTCSessionDescriptionDelegate>

@property (nonatomic) SRWebSocket* webSocket;
typedef enum {
    login,
    offer,
    answer,
    candidate,
    leave
} signalingMessages;

@property (nonatomic) id<onPeer> delegate;

@property (nonatomic) bool isConnected;
@property (nonatomic) RTCSessionDescription *sdpRemote;
@property (nonatomic) RTCMediaStream *localMediaStream;
@property (nonatomic) RTCICEServer *iceServer;
@property (nonatomic) RTCICECandidate *peerCandidate;
@property (nonatomic) RTCPeerConnectionFactory *factory;
@property (nonatomic, strong) RTCPeerConnection *peerConnection;
@property (nonatomic) RTCMediaConstraints *constraints;
@property (nonatomic) RTCPeerConnection *peerRemote;

@property (nonatomic) NSMutableDictionary *peerConnections;
@property (nonatomic) NSMutableArray *arrayIceServers;
@property (nonatomic) NSMutableDictionary * cases;
@property (nonatomic) NSString *miName;
@property (nonatomic) NSString *yourName;

@property (nonatomic, strong) AVCaptureDevice *videoDevice;
@property (nonatomic) bool allowVideo;

-(id)init:(NSString*)userName;


@end



