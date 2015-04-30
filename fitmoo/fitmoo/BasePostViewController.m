//
//  BasePostViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/28/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "BasePostViewController.h"
#import "AWSCore.h"
#import "AWSS3.h"
@interface BasePostViewController ()
@property (nonatomic, strong) AWSS3TransferManagerUploadRequest *uploadRequest;
@property (nonatomic) uint64_t filesize;
@property (nonatomic) uint64_t amountUploaded;
@end

@implementation BasePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    [self defineTypeOfPost];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(presentCameraView) userInfo:nil repeats:NO];
    [self createObservers];
    
    
//    AWSCognitoCredentialsProvider *credentialsProvider = [AWSCognitoCredentialsProvider
//                                                          credentialsWithRegionType:AWSRegionUSEast1
//                                                          accountId:@"271404364214"
//                                                          identityPoolId:@"us-east-1:6e327cce-01bb-44a6-99b1-1cb03b4ab870"
//                                                          unauthRoleArn:@"arn:aws:cognito-identity:us-east-1:271404364214:role/Cognito_fitmoo_appAuth_Role"
//                                                          authRoleArn:@"arn:aws:cognito-identity:us-east-1:271404364214:role/Cognito_fitmoo_appUnauth_Role"];
//    AWSCognitoCredentialsProvider *credentialsProvider = [AWSCognitoCredentialsProvider
//                                                          credentialsWithRegionType:AWSRegionUSEast1
//                                                          accountId:@"074088242106"
//                                                          identityPoolId:@"us-east-1:ac2dffe3-21e1-4c8d-b370-9466c23538dc"
//                                                          unauthRoleArn:@"arn:aws:iam::074088242106:role/Cognito_fitmoo_appAuth_Role"
//                                                          authRoleArn:@"arn:aws:iam::074088242106:role/Cognito_fitmoo_appUnauth_Role"];
//    
//    AWSServiceConfiguration *configuration = [AWSServiceConfiguration configurationWithRegion:AWSRegionUSEast1
//                                                                          credentialsProvider:credentialsProvider];
    AWSCognitoCredentialsProvider *credentialsProvider = [AWSCognitoCredentialsProvider
                                                          credentialsWithRegionType:AWSRegionUSEast1
                                                          accountId:@"074088242106"
                                                          identityPoolId:@"us-east-1:ac2dffe3-21e1-4c8d-b370-9466c23538dc"
                                                          unauthRoleArn:@"arn:aws:iam::074088242106:role/Cognito_fitmoo_appUnauth_Role"
                                                          authRoleArn:@"arn:aws:iam::074088242106:role/Cognito_fitmoo_appAuth_Role"];
    
    AWSServiceConfiguration *configuration = [AWSServiceConfiguration configurationWithRegion:AWSRegionUSEast1
                                                                          credentialsProvider:credentialsProvider];
    [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;

}


#pragma mark S3 stuff
- (void)uploadToS3{
    // get the image
    UIImage *img = _PostImage;
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
    
    __weak BasePostViewController *weakSelf = self;
    
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
            [self makePost:uploadImage];
            
        }
        
        return nil;
    }];
    
}

- (void) update{
      NSLog(@"%@", [NSString stringWithFormat:@"Uploading:%.0f%%", ((float)self.amountUploaded/ (float)self.filesize) * 100]); ;
}
-(void)createObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateImages" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImages:) name:@"updateImages" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"makePostFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makePostFinished:) name:@"makePostFinished" object:nil];
}

-(void) makePostFinished: (NSNotification * ) note
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) updateImages: (NSNotification * ) note
{
    _PostImage= (UIImage * ) [note object];
    [_normalPostImage setBackgroundImage:self.PostImage forState:UIControlStateNormal];
    [_workoutPostImage setBackgroundImage:self.PostImage forState:UIControlStateNormal];
    [_nutritionPostImage setBackgroundImage:self.PostImage forState:UIControlStateNormal];

}


- (void) defineTypeOfPost
{
    if ([self.postType isEqualToString:@"post"]) {
        [self setPostFrame];
    }else  if ([self.postType isEqualToString:@"nutrition"]) {
        [self setNutritionFrame];
    }else  if ([self.postType isEqualToString:@"workout"]) {
        [self setWorkoutFrame];
    }
}

-(void) presentCameraView
{
 
    
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
    
 
}

-(void) setPostFrame
{
    _normalPostView.frame= CGRectMake(0, 127, _normalPostView.frame.size.width, _normalPostView.frame.size.height);
    _normalPostView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_normalPostView respectToSuperFrame:self.view];
    _normalPostView.hidden=false;
    _workoutView.hidden=true;
    _nutritionView.hidden=true;
    [_normalPostImage setBackgroundImage:self.PostImage forState:UIControlStateNormal];
 //   _normalPostImage.image= self.PostImage;
  //  [_normalPostText setp]
    
}

-(void) setWorkoutFrame
{
    _workoutView.frame= CGRectMake(0, 127, _workoutView.frame.size.width, _workoutView.frame.size.height);
    _workoutView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutView respectToSuperFrame:self.view];
    [_workoutPostImage  setBackgroundImage:self.PostImage forState:UIControlStateNormal];
  //   _workoutPostImage.image= self.PostImage;
    _normalPostView.hidden=true;
    _workoutView.hidden=false;
    _nutritionView.hidden=true;
}

-(void) setNutritionFrame
{
    _nutritionView.frame= CGRectMake(0, 127, _nutritionView.frame.size.width, _nutritionView.frame.size.height);
    _nutritionView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionView respectToSuperFrame:self.view];
    _normalPostView.hidden=true;
    _workoutView.hidden=true;
    _nutritionView.hidden=false;
     [_nutritionPostImage  setBackgroundImage:self.PostImage forState:UIControlStateNormal];
  //  _nutritionPostImage.image= self.PostImage;
}

-(void) initFrames
{
    _normalPostView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_normalPostView respectToSuperFrame:self.view];
    _normalPostImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_normalPostImage respectToSuperFrame:self.view];
    _normalPostText.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_normalPostText respectToSuperFrame:self.view];
    _workoutView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutView respectToSuperFrame:self.view];
    _workoutTitle.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutTitle respectToSuperFrame:self.view];

    _workoutInstruction.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutInstruction respectToSuperFrame:self.view];
    _nutritionView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionView respectToSuperFrame:self.view];
    _nutritionTitle.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionTitle respectToSuperFrame:self.view];
    _nutritionIngedients.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionIngedients respectToSuperFrame:self.view];
    _nutritionPreparation.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionPreparation respectToSuperFrame:self.view];
 
    _buttonView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttonView respectToSuperFrame:self.view];
    _NormalPostButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_NormalPostButton respectToSuperFrame:self.view];
    _WorkoutButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_WorkoutButton respectToSuperFrame:self.view];
    _NutritionButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_NutritionButton respectToSuperFrame:self.view];

    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:self.view];
    _SubmitButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_SubmitButton respectToSuperFrame:self.view];

    
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



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        //   [self disableViews];
     
        [_workoutTitle resignFirstResponder];
        [_workoutInstruction resignFirstResponder];
        [_normalPostText resignFirstResponder];
        [_nutritionTitle resignFirstResponder];
        [_nutritionIngedients resignFirstResponder];
        [_nutritionPreparation resignFirstResponder];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)postImageButtonClick:(id)sender {
    
    [self presentCameraView];
    
}

- (IBAction)cancelButtonClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) makePost: (NSString *) imageUrl
{
    if ([self.postType isEqualToString:@"post"]) {
        if ([_normalPostText.text isEqualToString:@""]) {
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not Post"
                                                              message : @"text can not be empty" delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
        }else
        {
            NSArray *photoArray;
            NSDictionary *photos_attributes;
            if ([imageUrl isEqualToString:@""]) {
                photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: nil];
            }else
            {
                
                photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys:@"320",@"height",@"320", @"width",imageUrl, @"photo_url", nil];
                photoArray = [[NSArray alloc] initWithObjects:photos_attributes, nil];
            }
           
            NSDictionary *feed= [[NSDictionary alloc] initWithObjectsAndKeys: _normalPostText.text, @"text",photoArray, @"photos_attributes", nil];
            
            [ [UserManager sharedUserManager] performPost:feed];
        }
        
    }else  if ([self.postType isEqualToString:@"nutrition"]) {
        if ([_nutritionTitle.text isEqualToString:@""]) {
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not Post"
                                                              message : @"title can not be empty" delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
        }else
        {
            if ([_nutritionPreparation.text isEqualToString:@""]&&[_nutritionIngedients.text isEqualToString:@""]) {
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not Post"
                                                                  message : @"Ingrediens and Preparation can not be both empty" delegate : nil cancelButtonTitle : @"OK"
                                                        otherButtonTitles : nil ];
                [alert show ];
            }else
            {
                NSArray *photoArray;
                NSDictionary *photos_attributes;
                if ([imageUrl isEqualToString:@""]) {
                    photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: nil];
                }else
                {
                    
                    photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys:@"320",@"height",@"320", @"width",imageUrl, @"photo_url", nil];
                    photoArray = [[NSArray alloc] initWithObjects:photos_attributes, nil];
                }

                NSDictionary *nutrition_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: _nutritionTitle.text, @"title",_nutritionIngedients.text, @"ingredients",_nutritionPreparation.text, @"preparation", nil];
                NSDictionary *feed= [[NSDictionary alloc] initWithObjectsAndKeys: nutrition_attributes, @"nutrition_attributes",photoArray, @"photos_attributes",@"", @"text", nil];
                [ [UserManager sharedUserManager] performPost:feed];
            }
        }
        
    }else  if ([self.postType isEqualToString:@"workout"]) {
        if ([_workoutTitle.text isEqualToString:@""]) {
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not Post"
                                                              message : @"title can not be empty" delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
        }else
        {
            if ([_workoutInstruction.text isEqualToString:@""]) {
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not Post"
                                                                  message : @"Instruction can not be both empty" delegate : nil cancelButtonTitle : @"OK"
                                                        otherButtonTitles : nil ];
                [alert show ];
            }else
            {
                NSArray *photoArray;
                NSDictionary *photos_attributes;
                if ([imageUrl isEqualToString:@""]) {
                    photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: nil];
                }else
                {
                    
                    photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys:@"320",@"height",@"320", @"width",imageUrl, @"photo_url", nil];
                    photoArray = [[NSArray alloc] initWithObjects:photos_attributes, nil];
                }

                NSDictionary *feed= [[NSDictionary alloc] initWithObjectsAndKeys: _workoutInstruction.text, @"text",_workoutTitle.text, @"workout_title",photoArray, @"photos_attributes", nil];
                
                [ [UserManager sharedUserManager] performPost:feed];
            }
        }

    }

}



- (IBAction)postButtonClick:(id)sender {
    
    if (self.PostImage==nil) {
        [self makePost:@""];
        
    }else
    {
        [self uploadToS3];
    }
    
  
}
- (IBAction)nutritionButtonClick:(id)sender {
    _postType=@"nutrition";
    [self defineTypeOfPost];
}

- (IBAction)normalPostButtonClick:(id)sender {
    
    _postType=@"post";
    [self defineTypeOfPost];
}

- (IBAction)workoutButtonClick:(id)sender {
    _postType=@"workout";
    [self defineTypeOfPost];
}


@end
