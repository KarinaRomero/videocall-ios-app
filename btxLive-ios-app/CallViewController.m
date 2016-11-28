//
//  CallViewController.m
//  btxLive-ios-app
//
//  Created by Karina Betzabe Romero Ulloa on 16/09/16.
//  Copyright © 2016 Sandcode. All rights reserved.
//

#import "CallViewController.h"
#import <AVFoundation/AVFoundation.h>
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
#import "RTCAVFoundationVideoSource.h"

@interface CallViewController ()


@property (strong, nonatomic) MessagesHandlerToSignaling* messagesToSignaling;
@property (strong, nonatomic) IBOutlet RTCEAGLVideoView *remoteView;
@property (strong, nonatomic) IBOutlet RTCEAGLVideoView *localView;
@property (assign, nonatomic) CGSize localVideoSize;
@property (assign, nonatomic) CGSize remoteVideoSize;

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation CallViewController

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(captureSessionDidStartRunning)
                                                 name:AVCaptureSessionDidStartRunningNotification
                                               object:nil];
    [self.remoteView setDelegate:self];
    [self.localView setDelegate:self];
    
    _messagesToSignaling = [[MessagesHandlerToSignaling alloc] init:_myUserName];
    
    NSLog(@"%@", _myUserName);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)captureSessionDidStartRunning {
    NSLog(@"captureSessionDidStartRunning");
    [self videoView:self.localView didChangeVideoSize:self.localVideoSize];
    [self videoView:self.remoteView didChangeVideoSize:self.remoteVideoSize];
    
}

- (void)videoView:(RTCEAGLVideoView *)videoView didChangeVideoSize:(CGSize)size {
    NSLog(@"videoView");
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    [UIView animateWithDuration:0.4f animations:^{
        CGFloat containerWidth = self.view.frame.size.width;
        CGFloat containerHeight = self.view.frame.size.height;
        CGSize defaultAspectRatio = CGSizeMake(4, 3);
        if (videoView == self.localView) {
            //Resize the Local View depending if it is full screen or thumbnail
            self.localVideoSize = size;
            CGSize aspectRatio = CGSizeEqualToSize(size, CGSizeZero) ? defaultAspectRatio : size;
            CGRect videoRect = self.view.bounds;
            if (self.remoteVideoTrack) {
                videoRect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width/4.0f, self.view.frame.size.height/4.0f);
                if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
                    videoRect = CGRectMake(0.0f, 0.0f, self.view.frame.size.height/4.0f, self.view.frame.size.width/4.0f);
                }
            }
            CGRect videoFrame = AVMakeRectWithAspectRatioInsideRect(aspectRatio, videoRect);
            
            //Resize the localView accordingly
            [self.localWidthViewConstraint setConstant:videoFrame.size.width];
            [self.localHeightViewConstraint setConstant:videoFrame.size.height];
            if (self.remoteVideoTrack) {
                [self.remoteBottomViewConstraint setConstant:28.0f]; //bottom right corner
                [self.localRightViewConstraint setConstant:28.0f];
            } else {
                [self.remoteBottomViewConstraint setConstant:containerHeight/2.0f - videoFrame.size.height/2.0f]; //center
                [self.localRightViewConstraint setConstant:containerWidth/2.0f - videoFrame.size.width/2.0f]; //center
            }
        } else if (videoView == self.remoteView) {
            //Resize Remote View
            self.remoteVideoSize = size;
            CGSize aspectRatio = CGSizeEqualToSize(size, CGSizeZero) ? defaultAspectRatio : size;
            CGRect videoRect = self.view.bounds;
            CGRect videoFrame = AVMakeRectWithAspectRatioInsideRect(aspectRatio, videoRect);
            
            [self.remoteTopViewConstraint setConstant:containerHeight/2.0f - videoFrame.size.height/2.0f];
            [self.remoteBottomViewConstraint setConstant:containerHeight/2.0f - videoFrame.size.height/2.0f];
            [self.remoteLeftViewConstraint setConstant:containerWidth/2.0f - videoFrame.size.width/2.0f]; //center
            [self.remoteRightViewConstraint setConstant:containerWidth/2.0f - videoFrame.size.width/2.0f]; //center
            
        }
        [self.view layoutIfNeeded];
    }];
    
}



- (void)didReceiveLocalVideoTrack:(RTCVideoTrack *)localVideoTrack {
    if (self.localVideoTrack) {
        [self.localVideoTrack removeRenderer:self.localView];
        self.localVideoTrack = nil;
        [self.localView renderFrame:nil];
    }
    self.localVideoTrack = localVideoTrack;
    [self.localVideoTrack addRenderer:self.localView];
}

- (void)didReceiveRemoteVideoTrack:(RTCVideoTrack *)remoteVideoTrack {
    self.remoteVideoTrack = remoteVideoTrack;
    [self.remoteVideoTrack addRenderer:self.remoteView];
    
    [UIView animateWithDuration:0.4f animations:^{
        //Instead of using 0.4 of screen size, we re-calculate the local view and keep our aspect ratio
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        CGRect videoRect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width/4.0f, self.view.frame.size.height/4.0f);
        if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
            videoRect = CGRectMake(0.0f, 0.0f, self.view.frame.size.height/4.0f, self.view.frame.size.width/4.0f);
        }
        CGRect videoFrame = AVMakeRectWithAspectRatioInsideRect(_localView.frame.size, videoRect);
        
        [self.localWidthViewConstraint setConstant:videoFrame.size.width];
        [self.localHeightViewConstraint setConstant:videoFrame.size.height];
        
        
        [self.localBottomViewConstraint setConstant:28.0f];
        [self.localRightViewConstraint setConstant:28.0f];
        [self.view layoutIfNeeded];
    }];
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
