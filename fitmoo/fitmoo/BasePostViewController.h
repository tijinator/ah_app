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
#import "CameraViewController.h"


@interface BasePostViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *normalPostImage;

@property (strong, nonatomic) IBOutlet UIView *normalPostView;

@property (strong, nonatomic) IBOutlet UIButton *workoutPostImage;
@property (strong, nonatomic) IBOutlet UIButton *nutritionPostImage;
- (IBAction)postImageButtonClick:(id)sender;

- (IBAction)cancelButtonClick:(id)sender;
- (IBAction)postButtonClick:(id)sender;

@property (strong, nonatomic)  UIImage *PostImage;



@property (strong, nonatomic) IBOutlet UITextView *normalPostText;

@property (strong, nonatomic) IBOutlet UIView *workoutView;
@property (strong, nonatomic) IBOutlet UITextView *workoutTitle;
@property (strong, nonatomic) IBOutlet UITextView *workoutInstruction;

@property (strong, nonatomic) IBOutlet UIView *nutritionView;
@property (strong, nonatomic) IBOutlet UITextView *nutritionTitle;
@property (strong, nonatomic) IBOutlet UITextView *nutritionIngedients;
@property (strong, nonatomic) IBOutlet UITextView *nutritionPreparation;

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

@property (strong, nonatomic)  CameraViewController *overlay;
//@property (strong, nonatomic)  UIImagePickerController *picker;
- (IBAction)nutritionButtonClick:(id)sender;
- (IBAction)normalPostButtonClick:(id)sender;
- (IBAction)workoutButtonClick:(id)sender;


@end
