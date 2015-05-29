//
//  SignUpViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/7/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"

#import "User.h"
#import <CoreData/CoreData.h>
#import "HomePageViewController.h"
#import "InterestViewController.h"
#import "AcountViewController.h"

@interface SignUpViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (strong, nonatomic) IBOutlet UIButton *closeButton;

@property (strong, nonatomic) IBOutlet UIButton *sighUpButton;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UILabel *dateBirthLabel;
@property (strong, nonatomic) IBOutlet UILabel *genderLabel;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIView *pickerView2;
@property (strong, nonatomic) IBOutlet UIPickerView *genderPickerView;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UILabel *changeprofileLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UIButton *clearButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton1;

@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UIImageView *userImage;
@property (strong, nonatomic) IBOutlet UIButton *userPicture;
- (IBAction)userPictureButtonClick:(id)sender;
@property (strong, nonatomic)  User *localUser;
@property (strong, nonatomic)  NSString *Email;
@property (strong, nonatomic)  NSString *Password;
- (IBAction)signUpButtonClick:(id)sender;
- (IBAction)dateBirthButtonClick:(id)sender;
- (IBAction)genderButtonClick:(id)sender;
- (IBAction)doneButtonClick:(id)sender;
- (IBAction)clearButtonClick:(id)sender;
- (IBAction)closeButtonClick:(id)sender;


@property (strong, nonatomic)  UIImagePickerController *picker;
@property (strong, nonatomic)  UIImage *chosenImage;

@end
