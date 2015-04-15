//
//  LoginViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    
    self.facebookLoginView.delegate = self;
    self.facebookLoginView.readPermissions = @[@"public_profile", @"email"];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) initFrames
{
    _loginButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_loginButton respectToSuperFrame:self.view];
    _closeButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_closeButton respectToSuperFrame:self.view];
    _emailTextField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_emailTextField respectToSuperFrame:self.view];
    _passwordTextField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_passwordTextField respectToSuperFrame:self.view];
    _sighUpButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_sighUpButton respectToSuperFrame:self.view];
    _facebookButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_facebookButton respectToSuperFrame:self.view];
    _forgotPasswordButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_forgotPasswordButton respectToSuperFrame:self.view];
    _backgroundImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backgroundImage respectToSuperFrame:self.view];
    
}




- (IBAction)closeButtonClick:(id)sender {
      [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)facebookButtonClick:(id)sender {
    
}

#pragma mark - FBLoginView Delegate method implementation

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    
  

}


-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"%@", user);
 
}


-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    loginView.frame = CGRectMake(24, 68, 270, 37);
    loginView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:loginView respectToSuperFrame:self.view];
    for (id obj in loginView.subviews)
    {
        
       
            if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"CONTINUE WITH FACEBOOK";
            loginLabel.textAlignment = NSTextAlignmentCenter;
        //    loginLabel.frame = CGRectMake(0, 0, 271, 37);
        }
    }

}


-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
}




- (IBAction)loginButtonClick:(id)sender {
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"hongjianlin1989@gmail.com", @"email", @"lin22549010", @"password", @"undefined", @"secret_id", nil];
//    
//    [manager POST:[[UserManager sharedUserManager]  loginUrl] parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
//        
//        _responseDic= responseObject;
//        User *localUser= [[User alloc] init];
//        localUser.auth_token= [_responseDic objectForKey:@"auth_token"];
//        localUser.secret_id= [_responseDic objectForKey:@"secret_id"];
//        localUser.email=@"hongjianlin1989@gmail.com";
//        localUser.password=@"lin22549010";
//        
//        
//        
//        NSDictionary * userInfo=[_responseDic objectForKey:@"user_info"];
//        
//        NSDictionary * profile=[userInfo objectForKey:@"profile"];
//        localUser.cover_photo_url=[profile objectForKey:@"cover_photo_url"];
//        NSDictionary *avatar=[profile objectForKey:@"avatars"];
//        localUser.profile_avatar_thumb=[avatar objectForKey:@"thumb"];
//        NSNumber * user_id=[userInfo objectForKey:@"id"];
//        localUser.user_id= [user_id stringValue];
//        localUser.name= [userInfo objectForKey:@"full_name"];
//        
//      
//        
//       
//        
//        [[FitmooHelper sharedInstance] saveLocalUser:localUser];
//     
//        [self openHomePage];
//        
//  //      NSLog(@"Submit response data: %@", responseObject);
//    } // success callback block
//     
//          failure:^(AFHTTPRequestOperation *operation, NSError *error){
//              
//              NSLog(@"Error: %@", error);} // failure callback block
//     ];

        
        User *localUser= [[User alloc] init];
        localUser.email=@"hongjianlin1989@gmail.com";
        localUser.password=@"lin22549010";
    
        [[UserManager sharedUserManager] performLogin:localUser];

}

- (void) openHomePage
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomePageViewController * homepage = [mainStoryboard instantiateViewControllerWithIdentifier:@"HomePageViewController"];
    [self.navigationController pushViewController:homepage animated:YES];
}

- (IBAction)signUoButtonClick:(id)sender {
}

- (IBAction)forgotPasswordbuttonClick:(id)sender {
}
@end
