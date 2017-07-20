//
//  ViewController.m
//  videocall-ios-app
//
//  Created by Karina Betzabe Romero Ulloa on 05/09/16.
//

#import "ViewController.h"
#import "CallViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textUserName;
@property (weak, nonatomic) IBOutlet UIButton *buttonSend;
@property (nonatomic) MessagesHandlerToSignaling *messageHandlerToSignaling;
@property (nonatomic) NSString *userName;

@end

@implementation ViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    _textUserName.delegate=self;
}
- (IBAction)buttonSend:(id)sender {
    
    _userName= self.textUserName.text;
    [self performSegueWithIdentifier:@"CallSegue" sender:self];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"CallSegue"]) {
        CallViewController *callView = [segue destinationViewController];
        
        callView.myUserName = _userName;
    }
    
}



@end
