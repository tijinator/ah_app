//
//  BasePostViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/28/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FitmooHelper.h"
@interface BasePostViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *normalPostView;
@property (strong, nonatomic) IBOutlet UIImageView *normalPostImage;
@property (strong, nonatomic) IBOutlet UIImageView *workoutPostImage;
@property (strong, nonatomic) IBOutlet UIImageView *nutritionPostImage;

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


@property (strong, nonatomic) NSString *postType;



@end
