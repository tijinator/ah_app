//
//  InviteViewController.m
//  fitmoo
//
//  Created by hongjian lin on 6/19/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "InviteViewController.h"
#import "AFNetworking.h"
#import "UserManager.h"
@interface InviteViewController ()

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    // Do any additional setup after loading the view.
}
- (void) initFrames
{
    
    _topview.frame= CGRectMake(0, 0, 320, 60);
    _topview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topview respectToSuperFrame:self.view];
    _bioLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bioLabel respectToSuperFrame:self.view];
    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:self.view];
    
    _bodyView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyView respectToSuperFrame:self.view];
    _emailView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_emailView respectToSuperFrame:self.view];
    _messageView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_messageView respectToSuperFrame:self.view];
    _emailTextView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_emailTextView respectToSuperFrame:self.view];
    _messageTextView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_messageTextView respectToSuperFrame:self.view];
    
    _sendButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_sendButton respectToSuperFrame:self.view];
    
    
    UIFont *font = [UIFont fontWithName:@"BentonSans" size:19];
    _emailTextView.font=font;
    _messageTextView.font=font;
    
    _emailTextView.placeholder=@"Email (separated by commas)";
    _messageTextView.placeholder=@"Message";
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getInviteCall
{
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSArray *emailAry = [_emailTextView.text componentsSeparatedByString:@","];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",_messageTextView.text, @"comment",emailAry, @"emails_invite",nil];
    
    
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/users/invite"];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Invited"
                                                          message : @"Your invitation has been sent." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        
        
        
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops!"
                                                               message : @"Please make sure to enter valid email addresses." delegate : nil cancelButtonTitle : @"OK"
                                                     otherButtonTitles : nil ];
             [alert show ];
             NSLog(@"Error: %@", error);} // failure callback block
     ];

}

-(BOOL) checkValidEmail: (NSString *)email
{
    
    //   BOOL valid=true;
    
    if ([email isEqualToString:@""]) {
        return false;
    }
    
    
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
    //  return valid;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES ];
    //      [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)sendButtonClick:(id)sender {
    if ([self checkValidEmail:_emailTextView.text]==true) {
        [self getInviteCall];
    }else
    {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops!"
                                                          message : @"Please make sure to enter valid email addresses." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];

    }
    
    
}
@end
