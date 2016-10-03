//
//  Peer.h
//  btxLive-ios-app
//
//  Created by Karina Betzabe Romero Ulloa on 18/09/16.
//  Copyright © 2016 Sandcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libjingle_peerconnection/RTCPeerConnectionDelegate.h>
#import <libjingle_peerconnection/RTCSessionDescriptionDelegate.h>
#import <libjingle_peerconnection/RTCPeerConnectionFactory.h>
#import <AVFoundation/AVFoundation.h>
#import <libjingle_peerconnection/RTCVideoCapturer.h>
#import <libjingle_peerconnection/RTCVideoTrack.h>
#import <libjingle_peerconnection/RTCAudioTrack.h>
#import <libjingle_peerconnection/RTCVideoSource.h>
#import <libjingle_peerconnection/RTCMediaStream.h>


@interface Peer : NSObject <RTCPeerConnectionDelegate, RTCSessionDescriptionDelegate>

@property (nonatomic, strong) RTCPeerConnection* peerConnection;
@property (nonatomic) NSMutableArray* peersConnections;
@property (nonatomic) NSString* userName;
@property (nonatomic) int endPoint;
@property (nonatomic, strong) RTCPeerConnectionFactory *factory;
@property (nonatomic) NSMutableArray *iceServers;
@property (nonatomic) RTCMediaConstraints *constraints;
@property (nonatomic) RTCMediaStream *localStream;
@property (nonatomic) NSArray* peers;
@property (nonatomic) AVCaptureDevice* device;
@property (nonatomic) RTCVideoSource *videoSource;
@property (nonatomic) RTCVideoCapturer *videoCapturer;
@property (nonatomic) RTCVideoTrack *videoTrack;
@property (nonatomic) RTCAudioTrack *audioTrack;



// Called when creating a session.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didCreateSessionDescription:(RTCSessionDescription *)sdp
                 error:(NSError *)error;

// Called when setting a local or remote description.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didSetSessionDescriptionWithError:(NSError *)error;

// Triggered when the SignalingState changed.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
 signalingStateChanged:(RTCSignalingState)stateChanged;

// Triggered when media is received on a new stream from remote peer.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
           addedStream:(RTCMediaStream *)stream;

// Triggered when a remote peer close a stream.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
         removedStream:(RTCMediaStream *)stream;

// Triggered when renegotiation is needed, for example the ICE has restarted.
- (void)peerConnectionOnRenegotiationNeeded:(RTCPeerConnection *)peerConnection;

// Called any time the ICEConnectionState changes.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
  iceConnectionChanged:(RTCICEConnectionState)newState;

// Called any time the ICEGatheringState changes.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
   iceGatheringChanged:(RTCICEGatheringState)newState;

// New Ice candidate have been found.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
       gotICECandidate:(RTCICECandidate *)candidate;

// New data channel has been opened.
- (void)peerConnection:(RTCPeerConnection*)peerConnection
    didOpenDataChannel:(RTCDataChannel*)dataChannel;

/*public Peer(String id, int endPoint) {
    Log.d(TAG, "new Peer: " + id + " " + endPoint);
    Log.d("contrains", pcConstraints.toString());
    Log.d("iceServers", localMS.toString());
    this.pc = factory.createPeerConnection(iceServers, pcConstraints, this);
    this.id = id;
    this.endPoint = endPoint;
    pc.addStream(localMS); //, new MediaConstraints()
    mListener.onStatusChanged("CONNECTING");
}
*/

- (id)initWhitNameAndEndPoint:(NSString*)userName ep:(int) endPoint  arrayIceServers:(NSMutableArray*) iceServers factory: (RTCPeerConnectionFactory*)factory constraints:(RTCMediaConstraints*)constraints localStream:(RTCMediaStream*)localStream;



-(void)setCamera;






@end
