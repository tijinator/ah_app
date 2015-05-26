//
//  SignUpViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/7/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SignUpViewController.h"
#import "AWSCore.h"
#import "AWSS3.h"

@interface SignUpViewController()
@property (nonatomic, strong) AWSS3TransferManagerUploadRequest *uploadRequest;
@property (nonatomic) uint64_t filesize;
@property (nonatomic) uint64_t amountUploaded;
@end

@implementation SignUpViewController

{
    @private BOOL _valEmail;
    @private BOOL _checkEmpty;
  
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
  
    _valEmail=false;

    
   
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark S3 stuff
- (void)uploadToS3{
    AWSCognitoCredentialsProvider *credentialsProvider = [AWSCognitoCredentialsProvider
                                                          credentialsWithRegionType:AWSRegionUSEast1
                                                          accountId:@"074088242106"
                                                          identityPoolId:@"us-east-1:ac2dffe3-21e1-4c8d-b370-9466c23538dc"
                                                          unauthRoleArn:@"arn:aws:iam::074088242106:role/Cognito_fitmoo_appUnauth_Role"
                                                          authRoleArn:@"arn:aws:iam::074088242106:role/Cognito_fitmoo_appAuth_Role"];
    
    AWSServiceConfiguration *configuration = [AWSServiceConfiguration configurationWithRegion:AWSRegionUSEast1
                                                                          credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
    // get the image
    UIImage *img = _chosenImage;
    // UIImage *img = [UIImage imageNamed:@"like.png"];
    // create a local image that we can use to upload to s3
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"image.png"];
    NSData *imageData = UIImagePNGRepresentation(img);
    [imageData writeToFile:path atomically:YES];
    
    // once the image is saved we can use the path to create a local fileurl
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    
    // next we set up the S3 upload request manager
    _uploadRequest = [AWSS3TransferManagerUploadRequest new];
    // set the bucket
    //   _uploadRequest.bucket = @"s3-demo-objectivec";
    //    _uploadRequest.bucket = @"fitmoo-staging";
    _uploadRequest.bucket = @"fitmoo-staging-test";
    // I want this image to be public to anyone to view it so I'm setting it to Public Read
    _uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
    // set the image's name that will be used on the s3 server. I am also creating a folder to place the image in
    NSString *uuid = [[NSUUID UUID] UUIDString];
    _uploadRequest.key = [NSString stringWithFormat:@"%@%@%@",@"photos/",uuid,@".png"];
    // set the content type
    _uploadRequest.contentType = @"image/png";
    // we will track progress through an AWSNetworkingUploadProgressBlock
    _uploadRequest.body = url;
    
    __weak SignUpViewController *weakSelf = self;
    
    _uploadRequest.uploadProgress =^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend){
        dispatch_sync(dispatch_get_main_queue(), ^{
            weakSelf.amountUploaded = totalBytesSent;
            weakSelf.filesize = totalBytesExpectedToSend;
            [weakSelf update];
            
        });
    };
    
    // now the upload request is set up we can creat the transfermanger, the credentials are already set up in the app delegate
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    // start the upload
    [[transferManager upload:_uploadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
        
        // once the uploadmanager finishes check if there were any errors
        if (task.error) {
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not Post"
                                                              message : @"Upload Image Failed" delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
            
            NSLog(@"%@", task.error);
        }else{// if there aren't any then the image is uploaded!
            // this is the url of the image we just uploaded
            NSString *uploadImage= [NSString stringWithFormat:@"%@%@%@",@"https://s3.amazonaws.com/fitmoo-staging-test/photos/",uuid,@".png"];
            NSLog(@"%@%@%@",@"https://s3.amazonaws.com/fitmoo-staging-test/photos/",uuid,@".png");
            NSLog(@"%@%@%@",@"https://fitmoo-staging.s3.amazonaws.com/fitmoo-staging-test/photos/",uuid,@".png");
            //   NSString *uploadImage= @"https://fitmoo-staging.s3.amazonaws.com/photos%2F39528c839944-4b8a-457f-a5fe-ec9f386cae8e.jpg";
            _localUser= [[User alloc] init];
            _localUser.profile_avatar_original=uploadImage;
          //  [[UserManager sharedUserManager] performUpdate:_tempUser ];
            [self requestSignUp];
        }
        
        return nil;
    }];
    
}
- (void) update{
    NSLog(@"%@", [NSString stringWithFormat:@"Uploading:%.0f%%", ((float)self.amountUploaded/ (float)self.filesize) * 100]); ;
}


- (void) initFrames
{
    _backgroundView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backgroundView respectToSuperFrame:self.view];
    _nameField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nameField respectToSuperFrame:self.view];
   
    _dateBirthLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_dateBirthLabel respectToSuperFrame:self.view];
    _genderLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_genderLabel respectToSuperFrame:self.view];
    
    _pickerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_pickerView respectToSuperFrame:self.view];
    _pickerView2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_pickerView2 respectToSuperFrame:self.view];
    double x=(self.view.frame.size.width-_datePicker.frame.size.width)/2;
    _datePicker.frame= CGRectMake(_datePicker.frame.origin.x+x, _datePicker.frame.origin.y*[[FitmooHelper sharedInstance] frameRadio], _datePicker.frame.size.width, _datePicker.frame.size.height);

     double x1=(self.view.frame.size.width-_genderPickerView.frame.size.width)/2;
    _genderPickerView.frame= CGRectMake(_genderPickerView.frame.origin.x+x1, _genderPickerView.frame.origin.y*[[FitmooHelper sharedInstance] frameRadio], _genderPickerView.frame.size.width, _genderPickerView.frame.size.height);
    _doneButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_doneButton respectToSuperFrame:self.view];
    _doneButton1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_doneButton1 respectToSuperFrame:self.view];
    _clearButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_clearButton respectToSuperFrame:self.view];

    _userPicture.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_userPicture respectToSuperFrame:self.view];

    _closeButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_closeButton respectToSuperFrame:self.view];


    _sighUpButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_sighUpButton respectToSuperFrame:self.view];
    _nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nameLabel respectToSuperFrame:self.view];
    
    _userImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_userImage respectToSuperFrame:self.view];
    _changeprofileLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_changeprofileLabel respectToSuperFrame:self.view];

     [_datePicker setDatePickerMode:UIDatePickerModeDate];
    
    
    
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateBirthButtonClick:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [_dateBirthLabel addGestureRecognizer:tapGestureRecognizer];
    _dateBirthLabel.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(genderButtonClick:)];
    tapGestureRecognizer1.numberOfTapsRequired = 1;
    [_genderLabel addGestureRecognizer:tapGestureRecognizer1];
    _genderLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameLabelClick:)];
    tapGestureRecognizer2.numberOfTapsRequired = 1;
    [_nameLabel addGestureRecognizer:tapGestureRecognizer2];
    _nameLabel.userInteractionEnabled = YES;
    
    _userImage.userInteractionEnabled=NO;
    _userImage.exclusiveTouch=NO;
    _changeprofileLabel.userInteractionEnabled=NO;
    _changeprofileLabel.exclusiveTouch=NO;
}




-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)nameLabelClick:(id)sender {
    
    _nameLabel.hidden=true;
    [_nameField becomeFirstResponder];

}

- (void) openInterestPage
{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InterestViewController * interestpage = [mainStoryboard instantiateViewControllerWithIdentifier:@"InterestViewController"];
    interestpage.localUser=_localUser;
    [self.navigationController pushViewController:interestpage animated:YES];
}


- (void) requestSignUp
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
  //  _localUser= [[User alloc] init];
    
    NSString *date= _dateBirthLabel.text;
    NSRange range = NSMakeRange(0,2);
    NSRange range1 = NSMakeRange(3,2);
    NSRange range2 = NSMakeRange(6,4);
    NSString *month= [date substringWithRange:range];
    NSString *day= [date substringWithRange:range1];
    NSString *year= [date substringWithRange:range2];
    
    NSDictionary * userData= [[NSDictionary alloc] initWithObjectsAndKeys:_Email, @"email",_nameField.text, @"full_name",_Password, @"password",_genderLabel.text, @"gender",nil];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:month, @"dob_month",day, @"dob_day",year, @"dob_year",userData, @"user",_localUser.profile_avatar_original, @"profile_photo_url",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] homeFeedUrl], @"create_user_from_mobile"];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary * _responseDic= responseObject;
        
        _localUser.secret_id= [_responseDic objectForKey:@"secret_id"];
        _localUser.auth_token= [_responseDic objectForKey:@"auth_token"];
        NSNumber * user_id=[_responseDic objectForKey:@"user_id"];
        _localUser.user_id= [user_id stringValue];
        [[UserManager sharedUserManager] setLocalUser:_localUser];
        [[UserManager sharedUserManager] saveLocalUser:_localUser];
        //     [[UserManager sharedUserManager] getUserProfile:localUser];
        
        [self openInterestPage];
        
    } // success callback block
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];
    

}

- (IBAction)signUpButtonClick:(id)sender {

    
    if (_chosenImage!=nil) {
        _checkEmpty=[self checkEmpty];
        if (_checkEmpty==false ) {
            
            [self uploadToS3];
            
        }
    }else
    {
        [[FitmooHelper sharedInstance] showViewWithAnimation:@"Chose your profile picture." withPareView:self.view];
    }
    
}



- (BOOL) checkEmpty
{
//    NSString *emptyMessage;
//    NSString *emptyMessage1;
//    NSString *emptyMessage2;
    BOOL empty=false;
    if ([_nameField.text isEqualToString:@""]) {
        empty=true;
        [[FitmooHelper sharedInstance] showViewWithAnimation:@"Enter a full name." withPareView:self.view];
    }else
    if ([_dateBirthLabel.text isEqualToString:@"Date of Birth"]) {
        empty=true;
        [[FitmooHelper sharedInstance] showViewWithAnimation:@"Enter a birthday." withPareView:self.view];
    }else
    if ([_dateBirthLabel.text isEqualToString:@"Gender"]) {
        empty=true;
        [[FitmooHelper sharedInstance] showViewWithAnimation:@"Enter Gender." withPareView:self.view];
    }
    
    
//    if ([_nameField.text isEqualToString:@""]) {
//        emptyMessage=@"Enter a full name.";
//        empty=true;
//        [[FitmooHelper sharedInstance] showViewWithAnimation:@"Enter a full name." withPareView:self.view];
//    }else { emptyMessage=@""; }
//    
//    
//    if ([_dateBirthLabel.text isEqualToString:@""]) {
//        emptyMessage2=@"Enter a birthday.";
//          empty=true;
//        [[FitmooHelper sharedInstance] showViewWithAnimation:@"Enter a birthday." withPareView:self.view];
//    }else {emptyMessage2=@"";}
//    
//    if ([_dateBirthLabel.text isEqualToString:@""]) {
//        emptyMessage1=@"Enter Gender.";
//        empty=true;
//        [[FitmooHelper sharedInstance] showViewWithAnimation:@"Enter Gender." withPareView:self.view];
//    }else {emptyMessage1=@"";}
    
//    if (empty==true) {
//        NSString *totaleMessage= [NSString stringWithFormat:@"%@\n%@\n%@", emptyMessage,emptyMessage1,emptyMessage2];
//        
//        _valEmail=false;
//        
//        [[FitmooHelper sharedInstance] showViewWithAnimation:@"Chose your profile picture." withPareView:self.view];
//        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not create account."
//                                                          message : totaleMessage delegate : nil cancelButtonTitle : @"OK"
//                                                otherButtonTitles : nil ];
//        [alert show];
//    }
    
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [components setHour:10];
    NSDate *today10am = [calendar dateFromComponents:components];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy";
    NSString *thisYear=  [format stringFromDate:today10am];
    
    
    NSString *date= _dateBirthLabel.text;
    NSRange range2 = NSMakeRange(6,4);
    NSString *year= [date substringWithRange:range2];
    
    if ([thisYear integerValue]-[year integerValue]<=12) {
        
          empty=true;
        
        NSString *totaleMessage=@"You must be older than 13.";
        
        _valEmail=false;
//        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not create account."
//                                                          message : totaleMessage delegate : nil cancelButtonTitle : @"OK"
//                                                otherButtonTitles : nil ];
//        [alert show];
        
        [[FitmooHelper sharedInstance] showViewWithAnimation:totaleMessage withPareView:self.view];

    }
    
    return empty;
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    if (row==1) {
        _genderLabel.text=@"Female";
      
    }else
        if (row==0) {
            _genderLabel.text=@"Male";
            
        }
      _genderLabel.textColor=[UIColor blackColor];
    // Handle the selection
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = 2;
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    if (row==0) {
        title=@"Male";
    }else if (row==1)
    {
        title=@"Female";
    }
    
    return title;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}


#pragma mark - UIbutton functions
- (IBAction)dateBirthButtonClick:(id)sender {
    _pickerView.hidden=false;
}

- (IBAction)genderButtonClick:(id)sender {
    _pickerView2.hidden=false;
    _genderLabel.textColor=[UIColor blackColor];
    _genderLabel.text=@"Male";
}

- (IBAction)doneButtonClick:(id)sender {
    UIButton *b= (UIButton *) sender;
    if (b.tag==1) {
        NSDate *pickerDate = [_datePicker date];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"MM-dd-yyyy";
        _dateBirthLabel.text =  [format stringFromDate:pickerDate];
        _dateBirthLabel.textColor= [UIColor blackColor];
        _pickerView.hidden=true;
    }else if (b.tag==2)
    {
        _pickerView2.hidden=true;
        
    }else if (b.tag==3)
    {
     //   _emailTextField.userInteractionEnabled=true;
    }
}


- (IBAction)clearButtonClick:(id)sender {
    _dateBirthLabel.text = @"";
}

- (IBAction)closeButtonClick:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}






- (IBAction)userPictureButtonClick:(id)sender {
    
    
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate=self;
    _picker.allowsEditing = YES;
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:_picker animated:YES completion:NULL];

}



#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    _chosenImage = info[UIImagePickerControllerEditedImage];
    [self.userPicture setBackgroundImage:_chosenImage forState:UIControlStateNormal];
    [_picker dismissViewControllerAnimated:YES completion:nil];
    _userImage.hidden=true;
    _changeprofileLabel.hidden=false;
   
    
}

@end
