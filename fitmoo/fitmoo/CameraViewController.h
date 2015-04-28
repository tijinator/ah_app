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
//@interface CameraViewController : UIImagePickerController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@interface CameraViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic)  UIImagePickerController *picker;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIButton *cameraDirectionButton;
@property (strong, nonatomic) IBOutlet UIView *buttomView;
@property (strong, nonatomic) IBOutlet UIView *footButtomView;
@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UIButton *screenShotButton;
@property (strong, nonatomic) IBOutlet UIButton *changeToCameraButton;

- (IBAction)closeButtonClick:(id)sender;
- (IBAction)cameraDirectionButtonClick:(id)sender;
- (IBAction)imageButtonClick:(id)sender;
- (IBAction)screenShotButtonClick:(id)sender;
- (IBAction)changeCameraButtonClick:(id)sender;


@end
