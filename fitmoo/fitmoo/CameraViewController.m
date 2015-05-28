//
//  CameraViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/28/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "CameraViewController.h"
#import "UIImage+Filters.h"
#import "ImageFilter.h"
@interface CameraViewController ()
{
    bool takePhoto;
    bool startCapture;
    double ticks;
}
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    takePhoto= true;
    startCapture= false;
    _mediaType=@"camera";
    _postActionType=@"text";
    _postType=@"post";
    
    if (self.chosenImage!=nil) {
        [self.imageButton setBackgroundImage:_chosenImage forState:UIControlStateNormal];
        [self.imageButton setImage:_playImage forState:UIControlStateNormal];
    }
    [self createObservers];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showBlackStatusBarHandler" object:@"1"];
    // Do any additional setup after loading the view.
}




-(void)createObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hidePostView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePostView:) name:@"hidePostView" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"makePostFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makePostFinished:) name:@"makePostFinished" object:nil];
   
}
-(void) makePostFinished: (NSNotification * ) note
{
    [_picker dismissViewControllerAnimated:YES completion:nil];
   

}

-(void) hidePostView: (NSNotification * ) note
{
    [self hidePostViewAnimation];

}

-(void) initFrames
{
    _closeButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_closeButton respectToSuperFrame:self.view];
    _topView.frame= CGRectMake(0, 0, 320, 50);
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _cameraDirectionButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_cameraDirectionButton respectToSuperFrame:self.view];
    _buttomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttomView respectToSuperFrame:self.view];
    _footButtomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_footButtomView respectToSuperFrame:self.view];
    
    _imageButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_imageButton respectToSuperFrame:self.view];
    _screenShotButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_screenShotButton respectToSuperFrame:self.view];
    _changeToCameraButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_changeToCameraButton respectToSuperFrame:self.view];
    
    _nutritionButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionButton respectToSuperFrame:self.view];
    _postButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_postButton respectToSuperFrame:self.view];
    _workoutButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutButton respectToSuperFrame:self.view];
    _writePostTextField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_writePostTextField respectToSuperFrame:self.view];
    
  //  _filterView.frame= CGRectMake(0, 568, 320, 200);
    _filterView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_filterView respectToSuperFrame:self.view];
    _filterfootView.frame= CGRectMake(0, 123, 320, 53);
    _filterfootView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_filterfootView respectToSuperFrame:self.view];
    
    _filterIcon.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_filterIcon respectToSuperFrame:self.view];
    _filterScrollView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_filterScrollView respectToSuperFrame:self.view];
    
    _filterTopView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_filterTopView respectToSuperFrame:self.view];
    _filterBackButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_filterBackButton respectToSuperFrame:self.view];
    _filterOkButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_filterOkButton respectToSuperFrame:self.view];
    
    _postTopView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_postTopView respectToSuperFrame:self.view];
    _postCloseButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_postCloseButton respectToSuperFrame:self.view];
    
    _timerLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_timerLabel respectToSuperFrame:self.view];
    
    _wihteArrawImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_wihteArrawImage respectToSuperFrame:self.view];
    _textFieldButton.frame=_writePostTextField.frame;
    [self.view bringSubviewToFront:_footButtomView];
    [self.view bringSubviewToFront:_filterView];
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
     [[NSNotificationCenter defaultCenter] postNotificationName:@"showBlackStatusBarHandler" object:@"0"];
    [_timer invalidate];
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
    
    if ([_mediaType isEqualToString:@"camera"]) {
        _picker1 = [[UIImagePickerController alloc] init];
        _picker1.delegate = self;
        _picker1.allowsEditing = YES;
        _picker1.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        takePhoto= false;
        [self presentViewController:_picker1 animated:YES completion:NULL];
    }else if ([_mediaType isEqualToString:@"video"])
    {
        _picker1 = [[UIImagePickerController alloc] init];
        _picker1.delegate = self;
        _picker1.allowsEditing = NO;
        _picker1.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
        _picker1.mediaTypes = @[(NSString *)kUTTypeMovie];
        takePhoto= false;
        [self presentViewController:_picker1 animated:YES completion:NULL];
    }
    
}

- (void)timerTick:(NSTimer *)timer
{
    // Timers are not guaranteed to tick at the nominal rate specified, so this isn't technically accurate.
    // However, this is just an example to demonstrate how to stop some ongoing activity, so we can live with that inaccuracy.
    ticks += 0.1;
    double seconds = fmod(ticks, 60.0);
    double minutes = fmod(trunc(ticks / 60.0), 60.0);
    double hours = trunc(ticks / 3600.0);
    self.timerLabel.text = [NSString stringWithFormat:@"%02.0f : %02.0f : %02.0f", hours, minutes, seconds];
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
            [_screenShotButton setBackgroundImage:[UIImage imageNamed:@"recordingbtn.png"] forState:UIControlStateNormal];
            ticks=0;
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
            _buttomView.userInteractionEnabled=false;
        }else
        {
            [_picker stopVideoCapture];
            startCapture=false;
            [_screenShotButton setBackgroundImage:[UIImage imageNamed:@"recordbtn.png"] forState:UIControlStateNormal];
            [_timer invalidate];
            _buttomView.userInteractionEnabled=true;
        }
        
        
    }
    
    
}

- (IBAction)changeCameraButtonClick:(id)sender {
    [_timer invalidate];
    if ([_mediaType isEqualToString:@"camera"]) {
        _picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
        _mediaType=@"video";
        [_screenShotButton setBackgroundImage:[UIImage imageNamed:@"recordbtn.png"] forState:UIControlStateNormal];
        self.timerLabel.hidden=false;
        self.timerLabel.text=@"00 : 00 : 00";
        //  _picker.allowsEditing = YES;
        //   self.picker.navigationBarHidden = NO;
        //   self.picker.toolbarHidden = NO;
        //   [self.view removeFromSuperview];
    }else
    {
        _picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        _mediaType=@"camera";
         [_screenShotButton setBackgroundImage:[UIImage imageNamed:@"cameracircleicon.png"] forState:UIControlStateNormal];
         self.timerLabel.hidden=true;
    
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

-(void) addScrollView
{
    double radio= [[FitmooHelper sharedInstance] frameRadio];
     UIView *scrollFrame= [[UIView alloc] initWithFrame:_filterScrollView.frame];
    if (_filterScrollView!=nil) {
        [_filterScrollView removeFromSuperview];
        _filterScrollView=nil;
    }
    
    _filterScrollView= [[UIScrollView alloc] initWithFrame:scrollFrame.frame];
    _filterScrollView.delegate = self;
    UIImageView *imageview=[[UIImageView alloc] initWithImage:self.selectedImageview.image];                      //original
    UIImageView *imageview1=[[UIImageView alloc] initWithImage:[self.selectedImageview.image saturateImage:1.7 withContrast:1]];        //Saturation
    UIImageView *imageview2=[[UIImageView alloc] initWithImage:[self.selectedImageview.image saturateImage:0 withContrast:1.05]];        //B&W
    UIImageView *imageview4=[[UIImageView alloc] initWithImage:[self.selectedImageview.image vignetteWithRadius:0 andIntensity:18]];       //Vignette
    UIImageView *imageview3=[[UIImageView alloc] initWithImage:[self.selectedImageview.image greyscale]];      //greyscale
    UIImageView *imageview5=[[UIImageView alloc] initWithImage:[self.selectedImageview.image curveFilter]];        //Curve
    UIImageView *imageview6=[[UIImageView alloc] initWithImage:[self.selectedImageview.image invert]];        //Invert
    UIImageView *imageview7=[[UIImageView alloc] initWithImage:[self.selectedImageview.image polaroidish]];        //polaroidish
    UIImageView *imageview8=[[UIImageView alloc] initWithImage:[self.selectedImageview.image sepia]];        //sepia
    _selectedFilterImageArray= [[NSArray alloc] initWithObjects:imageview,imageview1,imageview2,imageview3,imageview4,imageview5,imageview6,imageview7,imageview8, nil];
    _selectedFilterNameArray= [[NSArray alloc] initWithObjects:@"Original",@"Saturation",@"B&W",@"Greyscale",@"Vignette",@"Curve",@"Invert",@"Polaroidish",@"Sepia", nil];
    
    
    
    int x =0;
    for (int i=0; i<[_selectedFilterImageArray count]; i++) {
        UIImageView *imageview= (UIImageView *)[_selectedFilterImageArray objectAtIndex:i];
        UIButton *b= [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 60*radio, 60*radio)];
        [b setTag:i];
        [b addTarget:self action:@selector(filterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [b setBackgroundImage:imageview.image forState:UIControlStateNormal];
        [_filterScrollView addSubview:b];
         _filterScrollView.contentSize= CGSizeMake(b.frame.size.width+x, _filterScrollView.frame.size.height);
        
        
        
        UIFont * customFont = [UIFont fontWithName:@"BentonSans" size:11]; //custom font
        UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectMake(x, 65*radio, 60*radio, 18*radio)];
        fromLabel.text = [_selectedFilterNameArray objectAtIndex:i];
        fromLabel.font = customFont;
        fromLabel.textAlignment = NSTextAlignmentCenter;
        fromLabel.adjustsFontSizeToFitWidth = YES;
        fromLabel.minimumScaleFactor = 10.0f/12.0f;
        fromLabel.backgroundColor = [UIColor clearColor];
        fromLabel.textColor = [UIColor whiteColor];
        [_filterScrollView addSubview:fromLabel];
        
        x= x+b.frame.size.width+5;
        
    }
    
    [_filterView addSubview:_filterScrollView];

}

- (IBAction)filterButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    UIImageView *im= [_selectedFilterImageArray objectAtIndex:button.tag];
    [_imageButton setBackgroundImage:im.image forState:UIControlStateNormal];
    _selectedImageview.image=im.image;
    
}

- (void) addfilterView
{
    _selectedImageview= [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 320)];
    [[FitmooHelper sharedInstance] resizeFrameWithFrame:_selectedImageview respectToSuperFrame:self.view];
    _selectedImageview.image=_chosenImage;
   // [self.view addSubview:selectedImageview];
    [self.view insertSubview:_selectedImageview belowSubview:_filterView];
    [self addScrollView];
    
    [self showFilterViewAnimation];
    
    
    
}


-(void) hideFilterViewAnimation
{
  
    [self.selectedImageview removeFromSuperview];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
    }completion:^(BOOL finished){}];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0];
    
    self.filterView.frame = CGRectMake(0,self.view.frame.size.height+self.filterView.frame.size.height, self.filterView.frame.size.width, self.filterView.frame.size.height);
    self.filterView.hidden=false;
    
    self.filterTopView.frame = CGRectMake(self.filterTopView.frame.size.width,0, self.filterTopView.frame.size.width, self.filterTopView.frame.size.height);
    self.filterTopView.hidden=false;
    
    self.topView.frame = CGRectMake(0,0, self.topView.frame.size.width, self.topView.frame.size.height);
    [UIView commitAnimations];
}

-(void) showFilterViewAnimation
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0];
    //   [UIView setAnimationDidStopSelector:@selector(closeView)];
    //   [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    self.filterView.frame = CGRectMake(0, self.buttomView.frame.origin.y, self.filterView.frame.size.width, self.filterView.frame.size.height);
    self.filterView.hidden=false;
    
    self.filterTopView.frame = CGRectMake(0,0, self.filterTopView.frame.size.width, self.filterTopView.frame.size.height);
    self.filterTopView.hidden=false;
    
    self.topView.frame = CGRectMake(0-self.topView.frame.size.width,0, self.topView.frame.size.width, self.topView.frame.size.height);
    
    
    [UIView commitAnimations];
}
-(void) hidePostViewAnimation
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0];
    self.postTopView.frame = CGRectMake(self.postTopView.frame.size.width,0, self.postTopView.frame.size.width, self.postTopView.frame.size.height);
    self.postTopView.hidden=true;
    
    self.filterTopView.frame = CGRectMake(self.filterTopView.frame.size.width,0, self.filterTopView.frame.size.width, self.filterTopView.frame.size.height);
    self.filterTopView.hidden=true;
    
    self.topView.frame = CGRectMake(0,0, self.topView.frame.size.width, self.topView.frame.size.height);
    
    self.filterView.frame = CGRectMake(0,self.view.frame.size.height+self.filterView.frame.size.height, self.filterView.frame.size.width, self.filterView.frame.size.height);
    self.filterView.hidden=false;
    [UIView commitAnimations];

    [_selectedImageview removeFromSuperview];
}


-(void) showPostViewAnimation
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelay:0];
    self.postTopView.frame = CGRectMake(0,0, self.postTopView.frame.size.width, self.postTopView.frame.size.height);
    self.postTopView.hidden=false;
    self.filterTopView.frame = CGRectMake(0-self.filterTopView.frame.size.width,0, self.filterTopView.frame.size.width, self.filterTopView.frame.size.height);
  //  self.filterTopView.hidden=true;
    
    
    [UIView commitAnimations];
}

-(void) openPostView
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _postView = [mainStoryboard instantiateViewControllerWithIdentifier:@"BasePostViewController"];
    _postView.PostImage= self.selectedImageview.image;
    _postView.postType= _postType;
    _postView.postActionType=_postActionType;
    _postView.view.frame= CGRectMake(0, 50, _postView.view.frame.size.width, _postView.view.frame.size.height);
    _postView.view.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_postView.view respectToSuperFrame:self.view];
    
   // [self presentViewController:_postView animated:YES completion:nil];
   // [self.view insertSubview:_postView.view belowSubview:self.postTopView];
    [self.view addSubview:_postView.view];
}

- (UIImage *)thumbnailImageForVideo:(NSURL *)videoURL
                             atTime:(NSTimeInterval)time
{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetIG =
    [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetIG.appliesPreferredTrackTransform = YES;
    assetIG.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *igError = nil;
    thumbnailImageRef =
    [assetIG copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)
                    actualTime:NULL
                         error:&igError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", igError );
    
    UIImage *thumbnailImage = thumbnailImageRef
    ? [[UIImage alloc] initWithCGImage:thumbnailImageRef]
    : nil;
    
    return thumbnailImage;
}




#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    double radio= self.view.frame.size.width/320;
    
    if ([_mediaType isEqualToString:@"video"]) {
        self.videoURL = info[UIImagePickerControllerMediaURL];
        UISaveVideoAtPathToSavedPhotosAlbum([self.videoURL path], nil, nil, nil);
        [_picker1 dismissViewControllerAnimated:YES completion:nil];
        self.postType=@"post";
       //  _chosenImage =[self thumbnailImageForVideo:self.videoURL atTime:1];
        [self.imageButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [self.imageButton setBackgroundImage:[self thumbnailImageForVideo:self.videoURL atTime:1] forState:UIControlStateNormal];
        [self showPostViewAnimation];
        [self openPostView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateVideo" object:self.videoURL];
        
    }else
    {
        if (takePhoto==true) {
            _chosenImage = info[UIImagePickerControllerOriginalImage];
            NSParameterAssert(_chosenImage);
            UIImageWriteToSavedPhotosAlbum(_chosenImage, nil, nil, nil);
            _chosenImage= [self squareImageFromImage:_chosenImage scaledToSize:320*radio];
            
            [self.imageButton setBackgroundImage:_chosenImage forState:UIControlStateNormal];
           
            [self addfilterView];
        //    [picker dismissViewControllerAnimated:YES completion:nil];
       //     [[NSNotificationCenter defaultCenter] postNotificationName:@"updateImages" object:_chosenImage];
        
        }else
        {
            
                _chosenImage = info[UIImagePickerControllerEditedImage];
                [self.imageButton setBackgroundImage:_chosenImage forState:UIControlStateNormal];
                [_picker1 dismissViewControllerAnimated:YES completion:nil];
                [self addfilterView];
            
 
        }
        
    }
    
    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [_picker1 dismissViewControllerAnimated:YES completion:NULL];
    takePhoto= true;
    
}


- (IBAction)postsButtonClick:(id)sender {
    UIButton * b= (UIButton *)sender;
    if(_selectedImageview.image!=nil)
    {
        NSParameterAssert(_selectedImageview.image);
        UIImageWriteToSavedPhotosAlbum(_selectedImageview.image, nil, nil, nil);
    }
    switch (b.tag) {
        case 1:
           self.postType=@"nutrition";
            _wihteArrawImage.frame= CGRectMake(50, 30, 20, 10);
            _wihteArrawImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_wihteArrawImage respectToSuperFrame:self.view];
            _writePostTextField.placeholder=@"         Write a nutrition...";
            [_nutritionButton setTitleColor:[UIColor colorWithRed:146.0/255.0 green:204.0/255.0 blue:70.0/255.0 alpha:1] forState:UIControlStateNormal];
            [_postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_workoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       //     [self showPostViewAnimation];
       //     [self openPostView];
            
            break;
        case 2:
            self.postType=@"post";
            _wihteArrawImage.frame= CGRectMake(150, 30, 20, 10);
            _wihteArrawImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_wihteArrawImage respectToSuperFrame:self.view];
            _writePostTextField.placeholder=@"         Write a post...";
            [_nutritionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_postButton setTitleColor:[UIColor colorWithRed:16.0/255.0 green:156.0/255.0 blue:251.0/255.0 alpha:1] forState:UIControlStateNormal];
            [_workoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            
        //    [self showPostViewAnimation];
        //    [self openPostView];
            
            break;
        case 3:
            self.postType=@"workout";
            _wihteArrawImage.frame= CGRectMake(250, 30, 20, 10);
            _wihteArrawImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_wihteArrawImage respectToSuperFrame:self.view];
            _writePostTextField.placeholder=@"         Write a workout...";
            
            [_nutritionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_postButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_workoutButton setTitleColor:[UIColor colorWithRed:205.0/255.0 green:103.0/255.0 blue:239.0/255.0 alpha:1] forState:UIControlStateNormal];
         //   [self showPostViewAnimation];
        //    [self openPostView];
            
            break;
        case 4:
        
            [self showPostViewAnimation];
            [self openPostView];
            
            break;
            
        default:
            break;
    }
    
}

- (IBAction)filterBackButtonClick:(id)sender {
    [self hideFilterViewAnimation];
}

- (IBAction)filterOkButtonClick:(id)sender {
    
//    NSParameterAssert(_selectedImageview.image);
//    UIImageWriteToSavedPhotosAlbum(_selectedImageview.image, nil, nil, nil);
    self.postType=@"post";
    _postActionType=@"image";
    [self showPostViewAnimation];
    [self openPostView];
    
    
}
@end
