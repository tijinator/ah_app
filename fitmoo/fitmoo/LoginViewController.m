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
    _cachedUser= nil;
    self.facebookLoginView.delegate = self;
    self.facebookLoginView.readPermissions = @[@"public_profile", @"email", @"user_birthday"];
    
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
    
    _dontWorryLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_dontWorryLabel respectToSuperFrame:self.view];
    _forgetPasswordView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_forgetPasswordView respectToSuperFrame:self.view];
    _emailLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_emailLabel respectToSuperFrame:self.view];
    _requestButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_requestButton respectToSuperFrame:self.view];
    _cancelButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_cancelButton respectToSuperFrame:self.view];
}


- (IBAction)closeButtonClick:(id)sender {
      [self.navigationController popToRootViewControllerAnimated:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(BOOL) checkValidEmail: (UITextField *)textfield
{
    
    BOOL valid=true;
    
    if ([textfield.text isEqualToString:@""]) {
        return false;
    }
    
    if (![textfield.text containsString:@"@"]) {
        return false;
    }
    if (![textfield.text containsString:@".com"]) {
        return false;
    }
    
    return valid;
}

#pragma mark - FBLoginView Delegate method implementation

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    
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

- (BOOL)isUser:(id<FBGraphUser>)firstUser equalToUser:(id<FBGraphUser>)secondUser {

    NSString *user_id1=firstUser[@"id"];
    NSString *user_id2=secondUser[@"id"];
    
    if (![user_id1 isEqual:user_id2]) {
        return false;
    }
    
    if (![firstUser.name isEqual:secondUser.name]) {
        return false;
    }
    
    if (![firstUser.name isEqual:secondUser.name]) {
        return false;
    }
    
    return true;
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
    NSLog(@"%@", user);
    
    if (![self isUser:_cachedUser equalToUser:user]) {
       
        User *localUser= [[User alloc] init];
        
        localUser.email= user[@"email"];
        localUser.gender=user[@"gender"];
        localUser.name= user[@"name"];
        localUser.day_of_birth= user[@"birthday"];
        localUser.facebook_uid=user[@"id"];
        
        [[UserManager sharedUserManager] checkEmailExistFromFitmoo:localUser];
         _cachedUser = user;
        
    }
    
    
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
    
        User *localUser= [[User alloc] init];
       // localUser.email=@"hongjianlin1989@gmail.com";
       // localUser.password=@"lin22549010";
    
    if (!([_emailTextField.text isEqualToString:@""]||[_passwordTextField.text isEqualToString:@""])) {
        localUser.email= _emailTextField.text;
        localUser.password=_passwordTextField.text;
        [[UserManager sharedUserManager] performLogin:localUser];
    }else
    {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not log in"
                                                          message : @"Invalid username/password." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
    }
   

}

- (void) openHomePage
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomePageViewController * homepage = [mainStoryboard instantiateViewControllerWithIdentifier:@"HomePageViewController"];
    [self.navigationController pushViewController:homepage animated:YES];
}

- (IBAction)signUoButtonClick:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"openNextpage" object:@"signUp"];
}

- (IBAction)forgotPasswordbuttonClick:(id)sender {
    UIButton *b= (UIButton *) sender;
    if (b.tag==1) {
        _forgetPasswordView.hidden=false;
    }else if (b.tag==2)
    {
        _forgetPasswordView.hidden=true;
    }
        
    
}
- (IBAction)requestButtonClick:(id)sender {
    if ([self checkValidEmail:_emailLabel]==true) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];

        NSDictionary *user = [[NSDictionary alloc] initWithObjectsAndKeys:_emailLabel.text, @"email",nil];
        
        NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:user, @"user",nil];
        NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] homeFeedUrl], @"forgot"];
        [manager PUT: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            _responseDic= responseObject;
            
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Sucess"
                                                              message : @"We've sent you an email with a link to reset your password." delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
            
            //      NSLog(@"Submit response data: %@", responseObject);
        } // success callback block
         
             failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Error"
                                                                   message : @"The email entered could not be found" delegate : nil cancelButtonTitle : @"OK"
                                                         otherButtonTitles : nil ];
                 [alert show ];

                 NSLog(@"Error: %@", error);} // failure callback block
         ];
        
        
    }else
    {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not request."
                                                          message : @"Enter Valid Email" delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
    }
    
}
@end
