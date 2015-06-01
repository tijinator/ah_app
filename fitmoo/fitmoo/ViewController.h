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
#import "ForgotPdViewController.h"
#import "UserManager.h"

#import "User.h"
#import <CoreData/CoreData.h>
#import "HomePageViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController : UIViewController<FBLoginViewDelegate,UITextFieldDelegate>
//@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (strong, nonatomic) IBOutlet UIImageView *fitmooNameImage;
@property (strong, nonatomic) IBOutlet UIImageView *allRightImage;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIImageView *orImage;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (strong, nonatomic)  SignUpViewController *sighUpView;
@property (strong, nonatomic)  ForgotPdViewController *forgotPdView;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
- (IBAction)signupButtonClick:(id)sender;
- (IBAction)loginButtonClick:(id)sender;
-(void) checkLogin;
- (IBAction)forgotPasswordButtonClick:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *separateView;
@property (strong, nonatomic) IBOutlet UIView *separateView1;
@property (strong, nonatomic) IBOutlet UILabel *orLabel;
@property (strong, nonatomic) IBOutlet FBLoginView *facebookLoginView;
@property (strong, nonatomic) IBOutlet UILabel *FacebookLabel;
@property (strong, nonatomic)  id<FBGraphUser> cachedUser;
@end

