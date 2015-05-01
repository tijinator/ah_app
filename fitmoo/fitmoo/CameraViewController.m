//
//  CameraViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/28/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()
{
    bool takePhoto;
    bool startCapture;
}
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    takePhoto= true;
    startCapture= false;
    _mediaType=@"camera";
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
    
    _picker1 = [[UIImagePickerController alloc] init];
    _picker1.delegate = self;
    _picker1.allowsEditing = YES;
    _picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    takePhoto= false;
    [self presentViewController:_picker1 animated:YES completion:NULL];
}

- (IBAction)screenShotButtonClick:(id)sender {
    
    if ([_mediaType isEqualToString:@"camera"]) {
        [_picker takePicture];
        takePhoto=true;
        
    }else
    {
        if (startCapture==false) {
            [_picker startVideoCapture];
            startCapture=true;
        }else
        {
            [_picker stopVideoCapture];
            startCapture=false;
        }
        
        
    }
    
    
}

- (IBAction)changeCameraButtonClick:(id)sender {
    //    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    //
    //        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //        picker.delegate = self;
    //        picker.allowsEditing = YES;
    //        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    //
    //        [self presentViewController:picker animated:YES completion:NULL];
    //    }
    if ([_mediaType isEqualToString:@"camera"]) {
        _picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        _mediaType=@"video";
        //  _picker.allowsEditing = YES;
        //   self.picker.navigationBarHidden = NO;
        //   self.picker.toolbarHidden = NO;
        //   [self.view removeFromSuperview];
    }else
    {
        _picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        _mediaType=@"camera";
    }
}

- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height) {
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);
    
    [image drawAtPoint:origin];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void) showFliterImages
{
    
}


//-(void) openPostView
//{
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    _postView = [mainStoryboard instantiateViewControllerWithIdentifier:@"BasePostViewController"];
//    _postView.PostImage= self.chosenImage;
//    _postView.postType= @"post";
//    [self presentViewController:_postView animated:YES completion:nil];
//
//}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    double radio= self.view.frame.size.width/320;
    
    if ([_mediaType isEqualToString:@"video"]) {
        self.videoURL = info[UIImagePickerControllerMediaURL];
        UISaveVideoAtPathToSavedPhotosAlbum([self.videoURL path], nil, nil, nil);
        [_picker dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateVideo" object:self.videoURL];
        
    }else
    {
        if (takePhoto==true) {
            _chosenImage = info[UIImagePickerControllerOriginalImage];
            _chosenImage= [self squareImageFromImage:_chosenImage scaledToSize:320*radio];
            
            [self.imageButton setBackgroundImage:_chosenImage forState:UIControlStateNormal];
            [picker dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImages" object:_chosenImage];
            NSParameterAssert(_chosenImage);
            UIImageWriteToSavedPhotosAlbum(_chosenImage, nil, nil, nil);
        }else
        {
            _chosenImage = info[UIImagePickerControllerEditedImage];
            [self.imageButton setBackgroundImage:_chosenImage forState:UIControlStateNormal];
            [_picker1 dismissViewControllerAnimated:YES completion:nil];
            [_picker dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImages" object:_chosenImage];
            
        }
        
    }
    
    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [_picker1 dismissViewControllerAnimated:YES completion:NULL];
    takePhoto= true;
    
}


@end
