//
//  BaseViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "BaseViewController.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import "UserManager.h"
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
    [self createObserverszero];
    showButton=false;
   [[NSNotificationCenter defaultCenter] postNotificationName:@"checkNotification" object:Nil];
}



- (void) handleNotification: (NSNotification * ) note
{
    [self handleNotific];
}

- (void) handleNotific
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *key = [prefs stringForKey:@"fitmooNotificationStatus"];
    if (key!=nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"notifications"];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:nil forKey:@"fitmooNotificationStatus"];
    }
    
}

- (void) handleDeeplink: (NSNotification * ) note
{
    [self handlelink];
}

- (void) handlelink
{
    // NSString *key= (NSString *) [note object];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *key = [prefs stringForKey:@"fitmooDeepLinkKey"];
   
    if (!(key==nil)) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
        if (!([key rangeOfString:@"feed/"].location ==NSNotFound)) {
            NSRange firstRange = [key rangeOfString:@"feed/"];
            NSRange finalRange = NSMakeRange(firstRange.location + firstRange.length, key.length-firstRange.length);
            key= [key substringWithRange:finalRange];
           
           
          
            
            
            NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", @"179547", @"fa_id", @"true", @"mobile",@"true", @"ios_app",
                                      nil];
            
            NSString * url= [NSString stringWithFormat: @"%@%@%@", [[UserManager sharedUserManager] clientUrl],@"/api/feeds/",key];
            
            [manager GET:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
                
                NSDictionary * resDic= responseObject;
                
                HomeFeed *feed= [[FitmooHelper sharedInstance] generateHomeFeed:resDic];
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SpecialPageViewController *specialPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SpecialPageViewController"];
                specialPage.homeFeed=feed;
                [self.navigationController pushViewController:specialPage animated:YES];
                
            } // success callback block
                 failure:^(AFHTTPRequestOperation *operation, NSError *error){
                     NSLog(@"Error: %@", error);
                 } // failure callback block
             
             ];
          

        }else if (!([key rangeOfString:@"profile/"].location ==NSNotFound))
        {
            NSRange firstRange = [key rangeOfString:@"profile/"];
            NSRange finalRange = NSMakeRange(firstRange.location + firstRange.length, key.length-firstRange.length);
            key= [key substringWithRange:finalRange];
       
            
            NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
            NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:key];
            
            if ([_NumericOnly isSupersetOfSet: myStringSet])
            {
                //String entirely contains decimal numbers only.
                key=[NSString stringWithFormat:@"%d", key.intValue+100];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
                
            }else
            {
              
                NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",nil];
                NSString * url= [NSString stringWithFormat: @"%@%@%@", [[UserManager sharedUserManager] clientUrl],@"/api/users/find_user_by_vanity_url?vanity_url=",key];
                
                [manager GET:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
                    
                    NSDictionary * resDic= responseObject;
                    NSDictionary *user= [resDic objectForKey:@"user"];
                   NSString * skey= [user objectForKey:@"id"];
                      skey=[NSString stringWithFormat:@"%d", skey.intValue+100];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:skey];
                    
                } // success callback block
                     failure:^(AFHTTPRequestOperation *operation, NSError *error){
                         NSLog(@"Error: %@", error);
                     } // failure callback block
                 
                 ];

            }
            
           
            
           
            
           
            
        }
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:nil forKey:@"fitmooDeepLinkKey"];
      }
    
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Offline"
                                                          message : @"You appear to be offline. Please connect to the internet to continue." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        NSLog(@"There IS internet connection");
        
    }
    
    [self handlelink];
    [self handleNotific];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (IBAction)openSideMenu:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openSideMenu" object:Nil];
}


-(void) addfootButtonsForThree
{
     double Radio= self.view.frame.size.width / 320;
    
    _bottomView= [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-Radio*60, 320*Radio, 60*Radio)];
    _bottomImageView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _bottomView.frame.size.width, _bottomView.frame.size.height)];
    _bottomImageView.image= [UIImage imageNamed:@"menugradient.png"];
    [_bottomView addSubview:_bottomImageView];
  
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
    [_middleButton1 addTarget:self action:@selector(doubleClick:) forControlEvents:UIControlEventTouchDownRepeat];
    [_rightButton1 addTarget:self action:@selector(footbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *im= [UIImage imageNamed:@"sidemenu_icon.png"];
    [_leftButton1 setBackgroundImage:im forState:UIControlStateNormal];
    UIImage *im1= [UIImage imageNamed:@"menu_plus_icon.png"];
    [_middleButton1 setBackgroundImage:im1 forState:UIControlStateNormal];
    UIImage *im2= [UIImage imageNamed:@"profile.png"];
    [_rightButton1 setBackgroundImage:im2 forState:UIControlStateNormal];
    
    
    _notificationImageView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red.png"]];
    _notificationImageView.frame= CGRectMake(25, -10, 23, 23);
    _notificationImageView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:_notificationImageView respectToSuperFrame:self.view];
    _notificationImageView.hidden=true;
    _notificationImageView.userInteractionEnabled=NO;
    _notificationImageView.exclusiveTouch=NO;
    _leftButton1.clipsToBounds=NO;
    [_leftButton1 addSubview:_notificationImageView];
    [_leftButton1 bringSubviewToFront:_notificationImageView];
    
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
 //   _videoButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_videoButton respectToSuperFrame:self.view];
    _pictureButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_pictureButton respectToSuperFrame:self.view];
    
    
    _postButton.tag=14;
    _videoButton.tag=15;
    _pictureButton.tag=16;
    
    [_postButton addTarget:self action:@selector(footbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
 //   [_videoButton addTarget:self action:@selector(footbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_pictureButton addTarget:self action:@selector(footbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    im= [UIImage imageNamed:@"posticon.png"];
    [_postButton setBackgroundImage:im forState:UIControlStateNormal];
 //   im1= [UIImage imageNamed:@"calendar.png"];
 //   [_videoButton setBackgroundImage:im1 forState:UIControlStateNormal];
    im2= [UIImage imageNamed:@"location.png"];
    [_pictureButton setBackgroundImage:im2 forState:UIControlStateNormal];
    
    [self.subBottomView addSubview:_postButton];
 //   [self.subBottomView addSubview:_videoButton];
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
    _subBottomView.frame= CGRectMake(0, self.bottomView.frame.origin.y, 320*Radio, 60*Radio);
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
    _postButton.frame= CGRectMake(185, 25, 43,43);
  //  _videoButton.frame= CGRectMake(218, 50, 43,43);
    _pictureButton.frame= CGRectMake(95, 25, 43,43);
    _postButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_postButton respectToSuperFrame:self.view];
 //   _videoButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_videoButton respectToSuperFrame:self.view];
    _pictureButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_pictureButton respectToSuperFrame:self.view];
   
    
    [UIView commitAnimations];
   
    
    
}

-(void)hideButtonsAction:(NSNotification*)note{
    if (_postButton!=nil) {
        [self hideThreeSubButtons];
    }
}




-(void)createObserverszero{
   // [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hideButtonsAction" object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideButtonsAction:) name:@"hideButtonsAction" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"handleDeeplink" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeeplink:) name:@"handleDeeplink" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"handleNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationStatus:) name:@"updateNotificationStatus" object:nil];
}

- (void) updateNotificationStatus: (NSNotification * ) note
{
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    _notifucationStatus=[prefs stringForKey:@"fitmooNotification"];
    
    if ([_notifucationStatus isEqualToString:@"1"]) {
        _notificationImageView.hidden=false;
    }else
    {
        _notificationImageView.hidden=true;
    }
    
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
    _picker.allowsEditing = NO;

    _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.picker.showsCameraControls = NO;
    self.picker.navigationBarHidden = YES;
    self.picker.toolbarHidden = YES;
    
    self.overlay.picker = self.picker;
   // self.picker.cameraOverlayView = self.overlay.view;
    [self.picker.view addSubview:self.overlay.view];
    self.picker.delegate = self.overlay;
    
    [self presentViewController:_picker animated:YES completion:NULL];
    [self hideThreeSubButtons];
     showButton=false;
}

- (IBAction)doubleClick:(id)sender {
    [self presentCameraView];
   

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
         [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"profile"];
            
            break;
        case 14:
  
            [self presentCameraView];
            
            
            break;
        case 15:
            
       
            
            break;
        case 16:
             [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"location"];
            
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
