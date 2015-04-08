//
//  LoginViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "AFNetworking.h"

#import "LocalUser.h"
#import <CoreData/CoreData.h>


@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *sighUpButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (strong, nonatomic)  NSDictionary * responseDic;

- (IBAction)closeButtonClick:(id)sender;
- (IBAction)facebookButtonClick:(id)sender;
- (IBAction)loginButtonClick:(id)sender;
- (IBAction)signUoButtonClick:(id)sender;
- (IBAction)forgotPasswordbuttonClick:(id)sender;



@end
