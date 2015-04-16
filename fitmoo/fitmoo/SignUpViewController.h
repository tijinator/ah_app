//
//  SignUpViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/7/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "AFNetworking.h"
#import "User.h"
#import <CoreData/CoreData.h>
#import "HomePageViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface SignUpViewController : UIViewController<FBLoginViewDelegate,UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIButton *sighUpButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UILabel *dateBirthLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIView *pickerView2;
@property (strong, nonatomic) IBOutlet UIPickerView *genderPickerView;
@property (strong, nonatomic) IBOutlet FBLoginView *facebookLoginView;
@property (strong, nonatomic)  id<FBGraphUser> cachedUser;

- (IBAction)signUpButtonClick:(id)sender;
- (IBAction)dateBirthButtonClick:(id)sender;
- (IBAction)genderButtonClick:(id)sender;
- (IBAction)doneButtonClick:(id)sender;
- (IBAction)clearButtonClick:(id)sender;
- (IBAction)closeButtonClick:(id)sender;
- (IBAction)loginButtonClick:(id)sender;

@end
