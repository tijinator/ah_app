//
//  BaseViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
 bool showButton;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self addfootButtonsForThree];
    showButton=false;
   
}

- (IBAction)openSideMenu:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openSideMenu" object:Nil];
    
    
}

-(void) addfootButtonsForThree
{
     double Radio= self.view.frame.size.width / 320;
    
    _bottomView= [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-Radio*60, 320*Radio, 60*Radio)];
    
  
    _leftButton1= [[UIButton alloc] initWithFrame:CGRectMake(16, 7, 38,38)];
    _middleButton1= [[UIButton alloc] initWithFrame:CGRectMake(138, 0, 50,50)];
    _rightButton1= [[UIButton alloc] initWithFrame:CGRectMake(270, 7, 38,38)];
    

    _leftButton1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftButton1 respectToSuperFrame:self.view];
    _middleButton1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_middleButton1 respectToSuperFrame:self.view];
    _rightButton1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_rightButton1 respectToSuperFrame:self.view];
    
    
    _leftButton1.tag=11;
    _middleButton1.tag=12;
    _rightButton1.tag=13;
    
    [_leftButton1 addTarget:self action:@selector(footbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_middleButton1 addTarget:self action:@selector(footbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton1 addTarget:self action:@selector(footbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *im= [UIImage imageNamed:@"leftmenuicon.png"];
    [_leftButton1 setBackgroundImage:im forState:UIControlStateNormal];
    UIImage *im1= [UIImage imageNamed:@"postmenuicon.png"];
    [_middleButton1 setBackgroundImage:im1 forState:UIControlStateNormal];
    UIImage *im2= [UIImage imageNamed:@"rightpeopleicon.png"];
    [_rightButton1 setBackgroundImage:im2 forState:UIControlStateNormal];
    
    [self.bottomView addSubview:_leftButton1];
    [self.bottomView addSubview:_middleButton1];
    [self.bottomView addSubview:_rightButton1];
    
    [self.view addSubview:_bottomView];
    [self.view bringSubviewToFront:_bottomView];
    
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
    
    _subBottomView= [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-Radio*60, 320*Radio, 60*Radio)];
    _postButton= [[UIButton alloc] initWithFrame:CGRectMake(160, 10, 0,0)];
    _videoButton= [[UIButton alloc] initWithFrame:CGRectMake(160, 10, 0,0)];
    _pictureButton= [[UIButton alloc] initWithFrame:CGRectMake(160, 10, 0,0)];
    
    
    _postButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_postButton respectToSuperFrame:self.view];
    _videoButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_videoButton respectToSuperFrame:self.view];
    _pictureButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_pictureButton respectToSuperFrame:self.view];
    
    
    _postButton.tag=14;
    _videoButton.tag=15;
    _pictureButton.tag=16;
    
    [_postButton addTarget:self action:@selector(footbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_videoButton addTarget:self action:@selector(footbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_pictureButton addTarget:self action:@selector(footbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    im= [UIImage imageNamed:@"posticon.png"];
    [_postButton setBackgroundImage:im forState:UIControlStateNormal];
    im1= [UIImage imageNamed:@"cameraicon.png"];
    [_videoButton setBackgroundImage:im1 forState:UIControlStateNormal];
    im2= [UIImage imageNamed:@"runningicon.png"];
    [_pictureButton setBackgroundImage:im2 forState:UIControlStateNormal];
    
    [self.subBottomView addSubview:_postButton];
    [self.subBottomView addSubview:_videoButton];
    [self.subBottomView addSubview:_pictureButton];

    [self.view insertSubview:_subBottomView belowSubview:_bottomView];
    
}

-(void) hideThreeSubButtons
{
    double Radio= self.view.frame.size.width / 320;
    
  //   _subBottomView.backgroundColor=[UIColor yellowColor];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    _subBottomView.frame= CGRectMake(0, _subBottomView.frame.origin.y+Radio*100, 320*Radio, 60*Radio);
    _postButton.frame= CGRectMake(160, 10, 0,0);
    _videoButton.frame= CGRectMake(160, 10, 0,0);
    _pictureButton.frame= CGRectMake(160, 10, 0,0);
    _postButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_postButton respectToSuperFrame:self.view];
    _videoButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_videoButton respectToSuperFrame:self.view];
    _pictureButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_pictureButton respectToSuperFrame:self.view];
    
    
    [UIView commitAnimations];

}

-(void) showThreeSubButtons
{
    double Radio= self.view.frame.size.width / 320;
    
   // _subBottomView.backgroundColor=[UIColor yellowColor];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
 //   [UIView setAnimationDidStopSelector:@selector(deletePatientInfoWithListView)];
    _subBottomView.frame= CGRectMake(0, _subBottomView.frame.origin.y-Radio*100, 320*Radio, 160*Radio);
    _postButton.frame= CGRectMake(140, 0, 43,43);
    _videoButton.frame= CGRectMake(218, 50, 43,43);
    _pictureButton.frame= CGRectMake(66, 50, 43,43);
    _postButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_postButton respectToSuperFrame:self.view];
    _videoButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_videoButton respectToSuperFrame:self.view];
    _pictureButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_pictureButton respectToSuperFrame:self.view];
   
    
    [UIView commitAnimations];
   
    
    
}

-(void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
   
  [[NSNotificationCenter defaultCenter] postNotificationName:@"swipeHandler" object:Nil];
}

-(void) presentCameraView
{
    
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    _postView = [mainStoryboard instantiateViewControllerWithIdentifier:@"BasePostViewController"];
//    _postView.postType= @"post";
//    [self presentViewController:_postView animated:YES completion:nil];
//    [self hideThreeSubButtons];
//    showButton=false;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _overlay = [mainStoryboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
    
    _picker = [[UIImagePickerController alloc] init];
    _picker.allowsEditing = YES;
    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.showsCameraControls = NO;
    self.picker.navigationBarHidden = YES;
    self.picker.toolbarHidden = YES;

    self.overlay.picker = self.picker;
    self.picker.cameraOverlayView = self.overlay.view;
    self.picker.delegate = self.overlay;
    
    [self presentViewController:_picker animated:YES completion:NULL];
    [self hideThreeSubButtons];
     showButton=false;
}

- (IBAction)footbuttonClick:(id)sender {
   

    switch (((UIButton*)sender).tag) {
        case 11:
        
       [[NSNotificationCenter defaultCenter] postNotificationName:@"swipeHandler" object:Nil];
            break;
        case 12:
            
            if (showButton==false) {
                 [self showThreeSubButtons];
                showButton=true;
            }else
            {
                [self hideThreeSubButtons];
                showButton=false;
            }
            
            break;
        case 13:
         [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"6"];
            
            break;
        case 14:
  
            [self presentCameraView];
            
            
            break;
        case 15:
            
       
            
            break;
        case 16:
            
            
            break;
        default:
            break;
            
            
    }
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

@end
