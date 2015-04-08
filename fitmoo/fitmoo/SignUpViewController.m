//
//  SignUpViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/7/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SignUpViewController.h"

@implementation SignUpViewController

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
    _sighUpButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_sighUpButton respectToSuperFrame:self.view];
    _facebookButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_facebookButton respectToSuperFrame:self.view];
    
    
}

- (IBAction)closeButtonClick:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)facebookButtonClick:(id)sender {
}

- (IBAction)loginButtonClick:(id)sender {
}
@end
