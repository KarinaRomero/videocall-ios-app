//
//  CallViewController.h
//  btxLive-ios-app
//
//  Created by Karina Betzabe Romero Ulloa on 16/09/16.
//  Copyright © 2016 Sandcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libjingle_peerconnection/RTCEAGLVideoView.h>
#import <libjingle_peerconnection/RTCMediaStream.h>
#import <libjingle_peerconnection/RTCPeerConnectionFactory.h>
#import <AVFoundation/AVCaptureDevice.h>

@interface CallViewController : UIViewController <RTCEAGLVideoViewDelegate>
@property (strong, nonatomic) IBOutlet RTCEAGLVideoView *remoteView;
@property (strong, nonatomic) IBOutlet RTCEAGLVideoView *localView;
@property (nonatomic) RTCMediaStream *localStream;
@property (nonatomic) RTCPeerConnectionFactory* factory;
@property (nonatomic) RTCAudioTrack *audioTrack;
@property (nonatomic) AVCaptureDevice* device;
@property (nonatomic)
RTCVideoSource *videoSource;
@property (nonatomic) RTCVideoCapturer *capturer;
@property (nonatomic) RTCVideoTrack *videoTrack;
@end
