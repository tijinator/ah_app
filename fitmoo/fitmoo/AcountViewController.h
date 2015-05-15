//
//  AcountViewController.h
//  fitmoo
//
//  Created by hongjian lin on 5/15/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "UserManager.h"
#import "User.h"
#import "BaseViewController.h"
#import "AsyncImageView.h"
#import <CoreGraphics/CoreGraphics.h>
@interface AcountViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *settingLabel;
@property (strong, nonatomic) NSArray *heightArray;
@property (strong, nonatomic) NSArray *privacyArray;
@property (strong, nonatomic) NSMutableArray *privacyBoolArray;
@property (strong, nonatomic)  NSString * tabletype;
@property (strong, nonatomic)  User * tempUser;

@property (strong, nonatomic)  UIView *settingBottomView;

@property (strong, nonatomic)  UITextField * nameTextfield;
@property (strong, nonatomic)  UITextField * mailTextfield;
@property (strong, nonatomic)  UITextView * bioTextview;
@property (strong, nonatomic)  UITextField * locationTextfield;
@property (strong, nonatomic)  UITextField * phoneTextfield;
@property (strong, nonatomic)  UITextField * websiteTextfield;
@property (nonatomic, strong) UIButton *imageButton;
@property (strong, nonatomic)  UIImage *chosenImage;
@property (assign, nonatomic)  int count;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic)  UIImagePickerController *picker;

- (IBAction)backButtonClick:(id)sender;
- (IBAction)saveButtonClick:(id)sender;
@end
