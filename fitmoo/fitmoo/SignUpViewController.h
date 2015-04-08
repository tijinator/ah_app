//
//  SignUpViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/7/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
@interface SignUpViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIButton *sighUpButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)closeButtonClick:(id)sender;
- (IBAction)facebookButtonClick:(id)sender;
- (IBAction)loginButtonClick:(id)sender;


@end
