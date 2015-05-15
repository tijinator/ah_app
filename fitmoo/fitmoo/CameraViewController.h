//
//  CameraViewController.h
//  fitmoo
//
//  Created by hongjian lin on 4/28/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "FitmooHelper.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "BasePostViewController.h"
#import <AVFoundation/AVFoundation.h>
//@interface CameraViewController : UIImagePickerController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@interface CameraViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>

@property (strong, nonatomic)  UIImagePickerController *picker;
@property (strong, nonatomic)  UIImagePickerController *picker1;
@property (strong, nonatomic)  BasePostViewController *postView;
@property (strong, nonatomic)  UIImage *chosenImage;
@property (strong, nonatomic)  UIImage *playImage;
@property (strong, nonatomic) UIImageView *selectedImageview;
@property (strong, nonatomic) NSArray *selectedFilterImageArray;
@property (strong, nonatomic) NSArray *selectedFilterNameArray;
@property (strong, nonatomic)  NSString *chosenMediaType;
@property (strong, nonatomic)  NSString *mediaType;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) NSString *postType;
@property (strong, nonatomic) NSString *postActionType;
@property (strong, nonatomic) NSTimer *timer;
- (IBAction)closeButtonClick:(id)sender;
- (IBAction)cameraDirectionButtonClick:(id)sender;
- (IBAction)imageButtonClick:(id)sender;
- (IBAction)screenShotButtonClick:(id)sender;
- (IBAction)changeCameraButtonClick:(id)sender;
- (IBAction)postsButtonClick:(id)sender;
- (IBAction)filterBackButtonClick:(id)sender;
- (IBAction)filterOkButtonClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *wihteArrawImage;
@property (strong, nonatomic) IBOutlet UIButton *textFieldButton;


@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIButton *cameraDirectionButton;

@property (strong, nonatomic) IBOutlet UIButton *nutritionButton;
@property (strong, nonatomic) IBOutlet UIButton *postButton;
@property (strong, nonatomic) IBOutlet UIButton *workoutButton;
@property (strong, nonatomic) IBOutlet UITextField *writePostTextField;
@property (strong, nonatomic) IBOutlet UIView *buttomView;

@property (strong, nonatomic) IBOutlet UIView *footButtomView;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UIButton *screenShotButton;
@property (strong, nonatomic) IBOutlet UIButton *changeToCameraButton;


@property (strong, nonatomic) IBOutlet UIView *filterView;
@property (strong, nonatomic) IBOutlet UIView *filterfootView;
@property (strong, nonatomic) IBOutlet UIScrollView *filterScrollView;
@property (strong, nonatomic) IBOutlet UIButton *filterIcon;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;

@property (strong, nonatomic) IBOutlet UIView *filterTopView;
@property (strong, nonatomic) IBOutlet UIButton *filterBackButton;
@property (strong, nonatomic) IBOutlet UIButton *filterOkButton;


@property (strong, nonatomic) IBOutlet UIView *postTopView;
@property (strong, nonatomic) IBOutlet UIButton *postCloseButton;


@end
