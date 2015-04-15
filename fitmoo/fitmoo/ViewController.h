//
//  ViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/7/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "SignUpViewController.h"
#import "LoginViewController.h"
#import "UserManager.h"

@interface ViewController : UIViewController
//@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (strong, nonatomic) IBOutlet UIImageView *fitmooNameImage;
@property (strong, nonatomic) IBOutlet UIImageView *allRightImage;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (strong, nonatomic)  SignUpViewController *sighUpView;
@property (strong, nonatomic)  LoginViewController *loginView;

- (IBAction)signupButtonClick:(id)sender;
- (IBAction)loginButtonClick:(id)sender;
-(void) checkLogin;

@end

