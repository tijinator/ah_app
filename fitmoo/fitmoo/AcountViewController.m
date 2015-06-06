//
//  AcountViewController.m
//  fitmoo
//
//  Created by hongjian lin on 5/15/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "AcountViewController.h"
#import "AWSCore.h"
#import "AWSS3.h"




@interface AcountViewController ()
{
    double constentUp;
    double constentdown;
    double frameRadio;
}
@property (nonatomic, strong) AWSS3TransferManagerUploadRequest *uploadRequest;
@property (nonatomic) uint64_t filesize;
@property (nonatomic) uint64_t amountUploaded;
@end

@implementation AcountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    [self createObservers];
  //  self.tabletype=@"setting";

    double radio= [[FitmooHelper sharedInstance] frameRadio];
    
    _heightArray= [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithDouble:50*radio],[NSNumber numberWithDouble:55*radio],[NSNumber numberWithDouble:55*radio],[NSNumber numberWithDouble:140*radio],[NSNumber numberWithDouble:55*radio],[NSNumber numberWithDouble:55*radio],[NSNumber numberWithDouble:55*radio], nil];
    _privacyArray= [[NSMutableArray alloc] initWithObjects:@"Global Privacy",@"Hide Location",@"Hide Email",@"Hide Phone Info",@"Hide Website",@"Hide Facebook Info",@"Hide Twitter Info",@"Hide Linkedln Info",@"Hide Google Plus Info",@"Hide Instagram Info", nil];
  
     _privacyBoolArray= [[NSMutableArray alloc] initWithObjects:_tempUser.hide_global_privacy,_tempUser.hide_location,_tempUser.hide_email,_tempUser.hide_phone,_tempUser.hide_website,_tempUser.hide_facebook,_tempUser.hide_twitter,_tempUser.hide_linkedin, _tempUser.hide_google,_tempUser.hide_instagram, nil];

    self.tableview.tableFooterView = [[UIView alloc] init];
    // Do any additional setup after loading the view.
}

- (void)scrollViewDidScroll: (UIScrollView*)scroll {
    
    
    if(self.tableview.contentOffset.y<-75){
        
        _count++;
        //it means table view is pulled down like refresh
        return;
    }
    else if(self.tableview.contentOffset.y >= (self.tableview.contentSize.height - self.tableview.bounds.size.height+80)) {
        
        [_tableview reloadData];
        
        _count++;
        
        
    }else
    {
        _count=0;
    }
    
}



- (void) initFrames
{
    //   _tableview.frame= CGRectMake(0, -20, 320, 490);
    _tableview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableview respectToSuperFrame:self.view];
    _settingLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_settingLabel respectToSuperFrame:self.view];
    
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:self.view];
    _saveButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_saveButton respectToSuperFrame:self.view];
    _saveButton.layer.cornerRadius=3;
    
    frameRadio= [[FitmooHelper sharedInstance] frameRadio];
    constentdown= 60;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    if (self.view.frame.size.height<500) {

        _tableview.frame= CGRectMake(_tableview.frame.origin.x,_tableview.frame.origin.y, _tableview.frame.size.width, _tableview.frame.size.height-88);
        
    }

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        //    _postText= textView.text;
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
#pragma mark S3 stuff
- (void)uploadToS3{
    AWSCognitoCredentialsProvider *credentialsProvider = [AWSCognitoCredentialsProvider
                                                          credentialsWithRegionType:AWSRegionUSEast1
                                                          accountId:[[UserManager sharedUserManager] s3_accountId]
                                                          identityPoolId:[[UserManager sharedUserManager] s3_identityPoolId]
                                                          unauthRoleArn:[[UserManager sharedUserManager] s3_unauthRoleArn]
                                                          authRoleArn:[[UserManager sharedUserManager] s3_authRoleArn]];
    
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
    _uploadRequest.bucket =[[UserManager sharedUserManager] s3_bucket];
    // I want this image to be public to anyone to view it so I'm setting it to Public Read
    _uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
    // set the image's name that will be used on the s3 server. I am also creating a folder to place the image in
    NSString *uuid = [[NSUUID UUID] UUIDString];
    _uploadRequest.key = [NSString stringWithFormat:@"%@%@%@",@"photos/",uuid,@".png"];
    // set the content type
    _uploadRequest.contentType = @"image/png";
    // we will track progress through an AWSNetworkingUploadProgressBlock
    _uploadRequest.body = url;
    
    __weak AcountViewController *weakSelf = self;
    
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
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                              message : @"The image didn't upload." delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
            
            NSLog(@"%@", task.error);
        }else{// if there aren't any then the image is uploaded!
            // this is the url of the image we just uploaded
            NSString *uploadImage= [NSString stringWithFormat:@"%@%@%@",[[UserManager sharedUserManager] amazonUploadUrl],uuid,@".png"];
            _tempUser.profile_avatar_original=uploadImage;
            [[UserManager sharedUserManager] performUpdate:_tempUser ];
        }
        
        return nil;
    }];
    
}
- (void) update{
    NSLog(@"%@", [NSString stringWithFormat:@"Uploading:%.0f%%", ((float)self.amountUploaded/ (float)self.filesize) * 100]); ;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if ([self.tabletype isEqualToString:@"privacy"]) {
        return 10;
    }
    return 7;
}
- (void)switchValueChanged:(UISwitch *)theSwitch
{
    BOOL flag = theSwitch.on;
    int index=(int) theSwitch.tag-20;
    NSString *value;
    if (flag==true) {
        value=@"1";
    }else
    {
        value=@"0";
    }
    
    [_privacyBoolArray replaceObjectAtIndex:index withObject:value];
    
    switch (index) {
        case 0:
            _tempUser.hide_global_privacy=value;
            break;
        case 1:
            _tempUser.hide_location=value;
            break;
        case 2:
            _tempUser.hide_email=value;
            break;
        case 3:
            _tempUser.hide_phone=value;
            break;
        case 4:
            _tempUser.hide_website=value;
            break;
        case 5:
            _tempUser.hide_facebook=value;
            break;
        case 6:
            _tempUser.hide_twitter=value;
            break;
        case 7:
            _tempUser.hide_linkedin=value;
            break;
        case 8:
            _tempUser.hide_google=value;
            break;
        case 9:
            _tempUser.hide_instagram=value;
            break;
            
            
            
        default:
            break;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.tabletype isEqualToString:@"privacy"]) {
        UITableViewCell * cell=  [self.tableview cellForRowAtIndexPath:indexPath];
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"privacyCell"];
            UILabel *label= (UILabel *)[cell viewWithTag:20];
            label.frame= CGRectMake(28, 14, 164, 25);
            label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:label respectToSuperFrame:nil];
            label.text= [_privacyArray objectAtIndex:indexPath.row];
            UISwitch *sw= (UISwitch *) [cell viewWithTag:21];
            double frameradio= [[FitmooHelper sharedInstance] frameRadio];
            sw.frame= CGRectMake(232*frameradio, 10*frameradio, sw.frame.size.width, sw.frame.size.height);
            sw.tag=indexPath.row+20;
            [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
            NSString *on= [_privacyBoolArray objectAtIndex:indexPath.row];
            if ([on isEqualToString:@"0"]) {
                [sw setOn:NO animated:YES];
            }else
            {
                [sw setOn:YES animated:YES];
            }
            
        }
        
        
        return cell;
    }
    
    
    UITableViewCell * cell=  [self.tableview cellForRowAtIndexPath:indexPath];
    if (indexPath.row==0) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"cell1"];
            
            UILabel *label= (UILabel *)[cell viewWithTag:1];
            label.frame=CGRectMake(20, 10, 200, 30);
            label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:label respectToSuperFrame:self.view];
            
            
            
            cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width*[[FitmooHelper sharedInstance] frameRadio], 0.f, 0.f);
            
        }
    }
       else if (indexPath.row==1) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"nameCell"];
            
            UIImageView *nameImage=(UIImageView *) [cell viewWithTag:1];
            nameImage.frame=CGRectMake(20, 18, 15, 15);
            nameImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameImage respectToSuperFrame:self.view];
            
            UILabel *label= (UILabel *)[cell viewWithTag:3];
            label.frame=CGRectMake(250, 79, 40, 20);
            label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:label respectToSuperFrame:self.view];
            
            UIButton *imageview=(UIButton *) [cell viewWithTag:4];
            imageview.frame= CGRectMake(240, 14,60, 60);
            imageview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:imageview respectToSuperFrame:self.view];
            
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height)];
              view.clipsToBounds=YES;
              view.layer.cornerRadius=view.frame.size.width/2;
            view.userInteractionEnabled = NO;
            view.exclusiveTouch = NO;
            
            AsyncImageView *userImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height)];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:userImage];
            
            if (_chosenImage!=nil) {
                userImage.image=_chosenImage;
            }else
            {
            userImage.imageURL =[NSURL URLWithString:_tempUser.profile_avatar_thumb];
            }
            
            [view addSubview:userImage];
            [imageview addSubview:view];
            
            [imageview addTarget:self action:@selector(imageviewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UITextField *nameTextfield= (UITextField *)[cell viewWithTag:2];
            nameTextfield.frame=CGRectMake(50, 12, 200, 30);
            nameTextfield.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameTextfield respectToSuperFrame:self.view];
            nameTextfield.text=_tempUser.name;
            
            _nameTextfield=nameTextfield;
            cell.clipsToBounds=NO;
            cell.contentView.clipsToBounds=NO;
            
        
        }
    }else if (indexPath.row==2) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"emailCell"];
            UIImageView *nameImage=(UIImageView *) [cell viewWithTag:1];
            nameImage.frame=CGRectMake(20, 18, 15, 15);
            nameImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameImage respectToSuperFrame:self.view];
            
            UITextField *emailTextfield= (UITextField *)[cell viewWithTag:2];
            emailTextfield.frame=CGRectMake(50, 12, 200, 30);
            emailTextfield.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:emailTextfield respectToSuperFrame:self.view];
            emailTextfield.text=_tempUser.email;
            
            _mailTextfield=emailTextfield;
          
        }
        
    }else if (indexPath.row==3) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"bioCell"];
            UIImageView *nameImage=(UIImageView *) [cell viewWithTag:1];
            nameImage.frame=CGRectMake(20, 23, 15, 15);
            nameImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameImage respectToSuperFrame:self.view];
            
            
            UITextView *bioTextfield= (UITextView *)[cell viewWithTag:7];
            bioTextfield.frame=CGRectMake(45, 15, 260, 100);
            bioTextfield.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:bioTextfield respectToSuperFrame:self.view];
            bioTextfield.text=_tempUser.bio;
            
            _bioTextview=bioTextfield;
        }
        
    }else if (indexPath.row==4) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"emailCell"];
            UIImageView *nameImage=(UIImageView *) [cell viewWithTag:1];
            nameImage.image=[UIImage imageNamed:@"greylocation.png"];
            nameImage.frame=CGRectMake(20, 18, 20, 20);
            nameImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameImage respectToSuperFrame:self.view];
            
            UITextField *emailTextfield= (UITextField *)[cell viewWithTag:2];
            emailTextfield.frame=CGRectMake(50, 12, 200, 30);
            emailTextfield.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:emailTextfield respectToSuperFrame:self.view];
            emailTextfield.text=_tempUser.location;
            
            _locationTextfield=emailTextfield;
        }
        
    }else if (indexPath.row==5) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"emailCell"];
            UIImageView *nameImage=(UIImageView *) [cell viewWithTag:1];
            nameImage.image=[UIImage imageNamed:@"greyphone.png"];
            nameImage.frame=CGRectMake(20, 20, 15, 15);
            nameImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameImage respectToSuperFrame:self.view];
            
            UITextField *emailTextfield= (UITextField *)[cell viewWithTag:2];
            emailTextfield.frame=CGRectMake(50, 12, 200, 30);
            emailTextfield.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:emailTextfield respectToSuperFrame:self.view];
            emailTextfield.text=_tempUser.phone;
            
            _phoneTextfield=emailTextfield;
        }
        
    }else if (indexPath.row==6) {
        if (cell == nil)
        {
            cell=[tableView dequeueReusableCellWithIdentifier:@"emailCell"];
            UIImageView *nameImage=(UIImageView *) [cell viewWithTag:1];
            nameImage.image=[UIImage imageNamed:@"greywebsite.png"];
            nameImage.frame=CGRectMake(20, 20, 15, 15);
            nameImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameImage respectToSuperFrame:self.view];
            
            UITextField *emailTextfield= (UITextField *)[cell viewWithTag:2];
            emailTextfield.frame=CGRectMake(50, 12, 200, 30);
            emailTextfield.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:emailTextfield respectToSuperFrame:self.view];
            emailTextfield.text=_tempUser.website;
            
            _websiteTextfield=emailTextfield;
        }
        
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}




// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //  double Radio= self.view.frame.size.width / 320;
    if ([self.tabletype isEqualToString:@"privacy"]) {
        return 50*[[FitmooHelper sharedInstance] frameRadio];
    }
    NSNumber * height=(NSNumber *) [_heightArray objectAtIndex:indexPath.row];
    return  height.integerValue;
}
- (IBAction)imageviewButtonClick:(id)sender {
    //   UIButton *button = (UIButton *)sender;
    
 
    
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate=self;
    _picker.allowsEditing = YES;
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:_picker animated:YES completion:NULL];
    
   
    
}
-(BOOL) checkValidInfo
{
 
    BOOL valid=true;
    NSString *email= _mailTextfield.text;
    
    if ([email isEqualToString:@""]||[email rangeOfString:@"@"].location == NSNotFound||[email rangeOfString:@".com"].location == NSNotFound) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"This email is invalid." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        return false;
    }
    
    NSString *website=_websiteTextfield.text;
    if (![self validateUrl:website]) {
        UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                          message : @"This website is invalid." delegate : nil cancelButtonTitle : @"OK"
                                                otherButtonTitles : nil ];
        [alert show ];
        return false;
    }
    
    return valid;
}

- (BOOL) validateUrl: (NSString *) candidate {
    if ([candidate isEqual:@""]) {
        return true;
    }
    
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    
    _chosenImage = info[UIImagePickerControllerEditedImage];
    [self.imageButton setBackgroundImage:_chosenImage forState:UIControlStateNormal];
    [_picker dismissViewControllerAnimated:YES completion:nil];
    
    [self.tableview reloadData];
    
}



- (IBAction)saveButtonClick:(id)sender {
    //   UIButton *button = (UIButton *)sender;
    if (_chosenImage!=nil) {
        [self uploadToS3];
        
    }else
    if ([self.tabletype isEqualToString:@"privacy"]) {
        [[UserManager sharedUserManager] performUpdatePrivacy:_tempUser ];
    }else
    {
        if ([self checkValidInfo]==true) {
            _tempUser.bio= _bioTextview.text;
            _tempUser.name=_nameTextfield.text;
            _tempUser.location=_locationTextfield.text;
            _tempUser.phone=_phoneTextfield.text;
            _tempUser.website=_websiteTextfield.text;
            _tempUser.email=_mailTextfield.text;
            [[UserManager sharedUserManager] performUpdate:_tempUser ];
        }
        
    
    }
    
}

- (void) makeUpdateFinished: (NSNotification * ) note
{
    UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Saved"
                                                      message : @"Your profile is now updated." delegate : nil cancelButtonTitle : @"OK"
                                            otherButtonTitles : nil ];
    [alert show ];
}

-(void)createObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"makeUpdateFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeUpdateFinished:) name:@"makeUpdateFinished" object:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClick:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


#pragma mark - textfield functions
- (void) moveUpView: (UIView *) moveView
{
    moveView=_tableview;
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        moveView.frame=CGRectMake(0,constentdown*frameRadio-constentUp, moveView.frame.size.width, moveView.frame.size.height);
    }completion:^(BOOL finished){}];
    
    
}

- (void) movedownView:(UIView *) moveView
{
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        moveView.frame=CGRectMake(0, constentdown*frameRadio, moveView.frame.size.width, moveView.frame.size.height);
    }completion:^(BOOL finished){}];
    
}
-(void)keyboardDidShow:(NSNotification*)notification
{
    CGFloat height = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey ] CGRectValue].size.height;
    
    constentUp = height;
  //  [self moveUpView:_tableview];
   
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    // [self moveUpView:_buttomView];
    if ([textField isEqual:_locationTextfield]||[textField isEqual:_phoneTextfield]||[textField isEqual:_websiteTextfield]) {
        
        [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(moveUpView:) userInfo:nil repeats:NO];
    }
    
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self movedownView:_tableview];
    
    return YES;
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
