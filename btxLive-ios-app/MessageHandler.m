//
//  MessageHandler.m
//  btxLive-ios-app
//
//  Created by Karina Betzabe Romero Ulloa on 16/09/16.
//  Copyright © 2016 Sandcode. All rights reserved.
//

#import "MessageHandler.h"

@implementation MessageHandler


-(id)init:(NSString*)name{
    self = [super init];
    if(self)
    {
        _isConnected=NO;
        if (_cases == nil) {
            _cases = [[NSMutableDictionary alloc] initWithCapacity:2];
            [_cases setObject:[NSNumber numberWithInt:login] forKey:@"login"];
            [_cases setObject:[NSNumber numberWithInt:offer] forKey:@"offer"];
            [_cases setObject:[NSNumber numberWithInt:answer] forKey:@"answer"];
            [_cases setObject:[NSNumber numberWithInt:candidate] forKey:@"candidate"];
            [_cases setObject:[NSNumber numberWithInt:leave] forKey:@"leave"];
        }
        _userName=name;
        [self connectWebSocket];
        

    }
    return self;
    
    }

- (void)connectWebSocket {
    _webSocket.delegate = nil;
    _webSocket = nil;
    
    NSString *urlString = @"ws://172.20.10.6:8888";
    SRWebSocket *newWebSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    newWebSocket.delegate = self;
    
    [newWebSocket open];
    
    _isConnected = YES;
    
}


- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    
    NSLog(@"user conected");
    _webSocket = newWebSocket;
    
    NSDictionary *formatoJson= [NSDictionary dictionaryWithObjectsAndKeys: @"login",@"type", _userName, @"name", nil];
    
    id jsonObject = [NSJSONSerialization dataWithJSONObject:formatoJson options:0 error:nil];
    [_webSocket send:jsonObject];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    [self connectWebSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    
    NSString *messageString = message;
    
    
    
    NSData *messageData = [messageString dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:messageData
                                                    options:0
                                                      error:nil];
    NSString *JSONobject=[jsonObject objectForKey:@"type"];
   
    bool success=[jsonObject objectForKey:@"success"];
    
    switch([[_cases objectForKey:JSONobject] intValue]) {
        case login:
            
            if(success){
                NSLog(@"on connection");
            }else{
                NSLog(@"Without connection");
            }
            
            break;
        case offer:
            NSLog(@"on offer");
            
/*sdp = new SessionDescription(SessionDescription.Type.fromCanonicalForm("OFFER"),
                                         message.getJSONObject("offer").getString("sdp")
                                         );
            
                        */
            
            
            break;
        case answer:
            NSLog(@"on answer");
            break;
        case candidate:
            NSLog(@"on candidate");
            break;
        case leave:
            NSLog(@"on leave");
            break;
        default:
            break;
    }
    
    /*self.textUserName.text = [NSString stringWithFormat:@"%@\n%@", self.textUserName.text, message];*/
    
}


//Create Answer for offer
-(void) onOffer{
    
    
    
    
}


-(void) localCamera{
    
    
    
    
    
    
    
    
    
    
    
    
}



@end
