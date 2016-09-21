//
//  ViewController.m
//  btxLive-ios-app
//
//  Created by Karina Betzabe Romero Ulloa on 05/09/16.
//  Copyright © 2016 Sandcode. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textUserName;
@property (weak, nonatomic) IBOutlet UIButton *buttonSend;
@property (nonatomic) MessageHandler *messageHandler;

@end

@implementation ViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    _textUserName.delegate=self;
}
- (IBAction)buttonSend:(id)sender {
    
    NSString *userName= self.textUserName.text;
    _messageHandler= [[MessageHandler alloc] init: userName];
    
    if(_messageHandler.isConnected){
        [self performSegueWithIdentifier:@"CallSegue" sender:self];
    }else{
        NSLog(@"Error al conectar");
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}




@end
