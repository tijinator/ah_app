//
//  BasePostViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/28/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
#import "UserManager.h"
#import "HomeFeed.h"
#import "UITextView+Placeholder.h"
//#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "User.h"
#import "CreatedByCommunity.h"
#import "AsyncImageView.h"
#import "WorkTypeViewController.h"

@interface BasePostViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *normalPostImage;
@property (strong, nonatomic) IBOutlet UIButton *normalEditButton;

@property (strong, nonatomic) IBOutlet UIView *normalPostView;

@property (strong, nonatomic) IBOutlet UIButton *workoutPostImage;
@property (strong, nonatomic) IBOutlet UIButton *nutritionPostImage;

@property (strong, nonatomic) IBOutlet UIImageView *wihteArrawImage;
- (IBAction)postImageButtonClick:(id)sender;
@property (strong, nonatomic)  NSMutableArray * heighArray;
- (IBAction)cancelButtonClick:(id)sender;
- (IBAction)postButtonClick:(id)sender;
- (void)hideTextViewBackgroundView;
- (void) defineTypeOfPost;

@property (strong, nonatomic)  UIImage *PostImage;
@property (strong, nonatomic)  HomeFeed *homeFeed;


@property (strong, nonatomic) IBOutlet UITextView *normalPostText;
@property (strong, nonatomic) IBOutlet UIButton *workoutEditButton;

@property (strong, nonatomic) IBOutlet UIView *workoutView;
@property (strong, nonatomic) IBOutlet UITextView *workoutTitle;
@property (strong, nonatomic) IBOutlet UITextView *workoutInstruction;
@property (strong, nonatomic) IBOutlet UIView *workoutTitleView;
@property (strong, nonatomic) IBOutlet UIView *workoutInstructionView;
@property (strong, nonatomic) IBOutlet UILabel *workoutTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *workoutTimeLabel;

@property (strong, nonatomic) IBOutlet UIView *nutritionView;
@property (strong, nonatomic) IBOutlet UITextView *nutritionTitle;
@property (strong, nonatomic) IBOutlet UITextView *nutritionIngedients;
@property (strong, nonatomic) IBOutlet UITextView *nutritionPreparation;
@property (strong, nonatomic) IBOutlet UIView *nutritionTitleView;
@property (strong, nonatomic) IBOutlet UIView *nutritionPreparationView;
@property (strong, nonatomic) IBOutlet UIView *nutritionIngedientsView;

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic)  NSString *saveToCommunity;

@property (strong, nonatomic) IBOutlet UIButton *nutritionEditButton;
@property (strong, nonatomic) IBOutlet UIView *normalPostBackView;

@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UIButton *NormalPostButton;
@property (strong, nonatomic) IBOutlet UIButton *WorkoutButton;
@property (strong, nonatomic) IBOutlet UIButton *NutritionButton;


@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *SubmitButton;

@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) NSString *postType;
@property (strong, nonatomic) NSString *postActionType;
@property (strong, nonatomic)  UIImagePickerController *picker;
@property (strong, nonatomic)  BasePostViewController *postView;
@property (strong, nonatomic)  NSDictionary * responseDic;
@property (strong, nonatomic)  User * localUser;
@property (strong, nonatomic)  WorkTypeViewController * workOutTypeView;

@property (strong, nonatomic)  NSMutableArray *communityArray;


//@property (strong, nonatomic)  CameraViewController *overlay;
//@property (strong, nonatomic)  UIImagePickerController *picker;
- (IBAction)nutritionButtonClick:(id)sender;
- (IBAction)normalPostButtonClick:(id)sender;
- (IBAction)workoutButtonClick:(id)sender;
- (IBAction)editClick:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *typePickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *typePicker;
@property (strong, nonatomic) IBOutlet UIView *timePickerView;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton1;
- (IBAction)doneButtonClick:(id)sender;
@property (strong, nonatomic)  NSMutableArray *workoutTypeArray;
@property (strong, nonatomic) IBOutlet UIView *pickerBackView;
@property (strong, nonatomic) IBOutlet UIView *pickerBackView1;




@end
