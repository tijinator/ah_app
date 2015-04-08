//
//  LoginViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) initFrames
{
    _loginButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_loginButton respectToSuperFrame:self.view];
    _closeButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_closeButton respectToSuperFrame:self.view];
    _emailTextField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_emailTextField respectToSuperFrame:self.view];
    _passwordTextField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_passwordTextField respectToSuperFrame:self.view];
    _sighUpButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_sighUpButton respectToSuperFrame:self.view];
    _facebookButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_facebookButton respectToSuperFrame:self.view];
    _forgotPasswordButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_forgotPasswordButton respectToSuperFrame:self.view];
    
}




- (IBAction)closeButtonClick:(id)sender {
      [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)facebookButtonClick:(id)sender {
    
}

- (IBAction)loginButtonClick:(id)sender {
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"hongjianlin1989@gmail.com", @"email", @"lin22549010", @"password", @"undefined", @"secret_id", nil];
    
    [manager POST:@"http://staging.fitmoo.com/api/tokens" parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        
        
        
        NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              
              NSLog(@"Error: %@", error);} // failure callback block
     ];
    

    
    
}

- (IBAction)signUoButtonClick:(id)sender {
}

- (IBAction)forgotPasswordbuttonClick:(id)sender {
}
@end
