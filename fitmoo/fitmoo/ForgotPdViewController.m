//
//  ForgotPdViewController.m
//  fitmoo
//
//  Created by hongjian lin on 5/28/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ForgotPdViewController.h"
#import "AFNetworking.h"
@interface ForgotPdViewController ()

@end

@implementation ForgotPdViewController
{
    bool validateEmail;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    
    validateEmail=false;
}

- (void) initFrames
{
    
    _closeButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_closeButton respectToSuperFrame:self.view];
    
    
    _dontWorryLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_dontWorryLabel respectToSuperFrame:self.view];
    _forgotPasswordEmail.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_forgotPasswordEmail respectToSuperFrame:self.view];
    _requestButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_requestButton respectToSuperFrame:self.view];
    
    _forgotPdlabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_forgotPdlabel respectToSuperFrame:self.view];
    
    _dontWorryLabel.textAlignment=NSTextAlignmentCenter;
    _forgotPasswordEmail.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    _forgotPasswordEmail.layer.borderWidth = 0.8;
    _forgotPasswordEmail.layer.masksToBounds = true;
    
    
    //case iphone 4s
    if (self.view.frame.size.height<500) {
        
        _requestButton.frame= CGRectMake(_requestButton.frame.origin.x, self.view.frame.size.height-_requestButton.frame.size.height, _requestButton.frame.size.width, _requestButton.frame.size.height);
    }
    
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




- (void) openHomePage
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomePageViewController * homepage = [mainStoryboard instantiateViewControllerWithIdentifier:@"HomePageViewController"];
    [self.navigationController pushViewController:homepage animated:YES];
}

- (IBAction)signUoButtonClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openNextpage" object:@"signUp"];
}




- (IBAction)editingChanged {
    
    
    if ([_forgotPasswordEmail.text length]!=0) {
        [_requestButton setEnabled:true];
    }else
    {
        [_requestButton setEnabled:false];
    }
}


- (IBAction)requestButtonClick:(id)sender {
    if ([self checkValidEmail:_forgotPasswordEmail]==true) {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSDictionary *user = [[NSDictionary alloc] initWithObjectsAndKeys:_forgotPasswordEmail.text, @"email",nil];
        
        NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:user, @"user",nil];
        NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] homeFeedUrl], @"forgot"];
        [manager PUT: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            _responseDic= responseObject;
            
            
            [[FitmooHelper sharedInstance] showViewWithAnimation:@"We've sent you an email with a link to reset your password." withPareView:self.view];
            
            validateEmail=true;
            [_requestButton setEnabled:true];
            
            //      NSLog(@"Submit response data: %@", responseObject);
        } // success callback block
         
             failure:^(AFHTTPRequestOperation *operation, NSError *error){
                 [[FitmooHelper sharedInstance] showViewWithAnimation:@"The email entered could not be found." withPareView:self.view];
                 
                 
                 NSLog(@"Error: %@", error);} // failure callback block
         ];
        
        
    }else
    {
        [[FitmooHelper sharedInstance] showViewWithAnimation:@"Enter Valid Email." withPareView:self.view];
        
        validateEmail=false;
        
    }
    
}
@end