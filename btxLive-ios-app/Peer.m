//
//  Peer.m
//  btxLive-ios-app
//
//  Created by Karina Betzabe Romero Ulloa on 18/09/16.
//  Copyright © 2016 Sandcode. All rights reserved.
//

#import "Peer.h"

@implementation Peer

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
@synthesize peerConnection = _peerConnection;

- (id)initWhitNameAndEndPoint:(NSString*)userName ep:(int) endPoint  arrayIceServers:(NSMutableArray*) iceServers factory: (RTCPeerConnectionFactory*)factory constraints:(RTCMediaConstraints*)constraints localStream:(RTCMediaStream*)localStream {
    
    _iceServers=iceServers;
    _constraints=constraints;
    
    
    _peerConnection = [_factory peerConnectionWithICEServers:_iceServers
                                                 constraints:_constraints
                                                    delegate:self];
    _userName=userName;
    _endPoint=endPoint;
    _localStream = localStream;
    

    
    return self;
    
}


-(void)setCamera{
    
    for (AVCaptureDevice *captureDevice in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] ) {
        if (captureDevice.position == AVCaptureDevicePositionFront) {
            _device = captureDevice;
            
            break;
        }
    }
    
    if (_device) {
        
        _videoCapturer = [RTCVideoCapturer capturerWithDeviceName:_device.localizedName];
        
        _videoSource = [_factory videoSourceWithCapturer: _videoCapturer constraints:nil];
        
        _videoTrack = [_factory videoTrackWithID:@"ARDAMSv0" source:_videoSource];
        [_localStream addVideoTrack:_videoTrack];
        
        _audioTrack = [_factory audioTrackWithID:@"ARDAMSa0"];
        
        [_localStream addAudioTrack:_audioTrack];
        
    }
    
    
}



// Called when creating a session.
- (void)peerConnection:(RTCPeerConnection *)peerConnection
didCreateSessionDescription:(RTCSessionDescription *)sdp
                 error:(NSError *)error{}

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
