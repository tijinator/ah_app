//
//  CameraViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/28/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
   

    // Do any additional setup after loading the view.
}

-(void) initFrames
{
    _closeButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_closeButton respectToSuperFrame:self.view];
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _cameraDirectionButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_cameraDirectionButton respectToSuperFrame:self.view];
    _buttomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttomView respectToSuperFrame:self.view];
    _footButtomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_footButtomView respectToSuperFrame:self.view];
    
    _imageButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_imageButton respectToSuperFrame:self.view];
    _screenShotButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_screenShotButton respectToSuperFrame:self.view];
    _changeToCameraButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_changeToCameraButton respectToSuperFrame:self.view];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeButtonClick:(id)sender {
    [_picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cameraDirectionButtonClick:(id)sender {
    
    if(_picker.cameraDevice == UIImagePickerControllerCameraDeviceFront)
    {
        [UIView transitionWithView:_picker.view duration:1.0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            _picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        } completion:NULL];
    }
    else {
        [UIView transitionWithView:_picker.view duration:1.0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionTransitionFlipFromLeft animations:^{
            _picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        } completion:NULL];
    }
}

- (IBAction)imageButtonClick:(id)sender {
    
    
}

- (IBAction)screenShotButtonClick:(id)sender {
}

- (IBAction)changeCameraButtonClick:(id)sender {
}
@end
