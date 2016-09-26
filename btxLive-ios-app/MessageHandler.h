//
//  MessageHandler.h
//  btxLive-ios-app
//
//  Created by Karina Betzabe Romero Ulloa on 16/09/16.
//  Copyright © 2016 Sandcode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketRocket.h"
#import <libjingle_peerconnection/RTCSessionDescription.h>
#import "Peer.h"

@interface MessageHandler : NSObject  <SRWebSocketDelegate>
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
@property (nonatomic) Peer* peerRemote;


-(id)init:(NSString*)name;
@end
