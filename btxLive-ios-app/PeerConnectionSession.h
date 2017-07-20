//
//  PeerConnectionSession.h
//  videocall-ios-app
//
//  Created by Karina Betzabe Romero Ulloa on 09/10/16.
//

#import <Foundation/Foundation.h>
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

@interface PeerConnectionSession : NSObject < RTCSessionDescriptionDelegate, RTCPeerConnectionDelegate>

@property (nonatomic) RTCICEServer *iceServer;
@property (nonatomic) RTCPeerConnection *peerConnection;
@property (nonatomic) RTCPeerConnectionFactory *factory;
@property (nonatomic) NSMutableArray *arrayIceServers;
@property (nonatomic) RTCMediaStream *localStream;

@property (nonatomic) NSArray *mandatoryConstraints;
@property (nonatomic) RTCMediaConstraints *constrains;
@property (nonatomic) RTCMediaConstraints *offerConstrains;

@property (nonatomic) AVCaptureDevice* device;
@property (nonatomic) RTCVideoSource *videoSource;
@property (nonatomic) RTCVideoCapturer *videoCapturer;
@property (nonatomic) RTCVideoTrack *videoTrack;
@property (nonatomic) RTCAudioTrack *audioTrack;




//-(id)initWhitCallName:(NSString*)callName SessionDescriptionRemote: (RTCSessionDescription*)sdpRemote;

-(id)initWhitUserName:(NSString*)userName SessionDescriptionRemote: (RTCSessionDescription*)sdpRemote;

-(void)addStream:(RTCMediaStream *)lms sessionDesciption:(RTCSessionDescription*)sdpRemote;

@end
