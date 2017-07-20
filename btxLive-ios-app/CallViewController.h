//
//  CallViewController.h
//  videocall-ios-app
//
//  Created by Karina Betzabe Romero Ulloa on 16/09/16.
//

#import <UIKit/UIKit.h>
#import <libjingle_peerconnection/RTCEAGLVideoView.h>
#import <libjingle_peerconnection/RTCMediaStream.h>
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
#import "MessagesHandlerToSignaling.h"


@interface CallViewController : UIViewController <RTCEAGLVideoViewDelegate, onPeer>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remoteRightViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remoteLeftViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remoteBottomViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remoteTopViewConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *localHeightViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *localWidthViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *localRightViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *localBottomViewConstraint;

@property (strong, nonatomic) MessagesHandlerToSignaling* messagesToSignaling;
@property (strong, nonatomic) IBOutlet RTCEAGLVideoView *remoteView;
@property (strong, nonatomic) IBOutlet RTCEAGLVideoView *localView;
@property (assign, nonatomic) CGSize localVideoSize;
@property (assign, nonatomic) CGSize remoteVideoSize;

@property (nonatomic) NSString *myUserName;

@property (strong, nonatomic) RTCVideoTrack *localVideoTrack;
@property (strong, nonatomic) RTCVideoTrack *remoteVideoTrack;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end
