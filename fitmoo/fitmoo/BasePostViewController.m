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
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import "FSImageViewerViewController.h"
#import "AFNetworking.h"


@interface TestView1 : UIView
@end

@implementation TestView1

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (!self.clipsToBounds && !self.hidden && self.alpha > 0) {
        for (UIView *subview in self.subviews.reverseObjectEnumerator) {
            CGPoint subPoint = [subview convertPoint:point fromView:self];
            UIView *result = [subview hitTest:subPoint withEvent:event];
            if (result != nil) {
                return result;
            }
        }
    }
    
    return nil;
}

@end

@interface BasePostViewController ()
@property (nonatomic, strong) AWSS3TransferManagerUploadRequest *uploadRequest;
@property (nonatomic) uint64_t filesize;
@property (nonatomic) uint64_t amountUploaded;

@property (strong, nonatomic)  TestView1 *textViewBackgroundView;
@end

@implementation BasePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    [self defineTypeOfPost];

    [self createObservers];
   // _postActionType=@"text";
    
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
            NSString *uploadImage= [NSString stringWithFormat:@"%@%@%@",[[UserManager sharedUserManager] amazonUploadUrl],uuid,@".png"];
         //   NSLog(@"%@%@%@",@"https://s3.amazonaws.com/fitmoo-staging-test/photos/",uuid,@".png");
       //     NSLog(@"%@%@%@",@"https://fitmoo-staging.s3.amazonaws.com/fitmoo-staging-test/photos/",uuid,@".png");
            //   NSString *uploadImage= @"https://fitmoo-staging.s3.amazonaws.com/photos%2F39528c839944-4b8a-457f-a5fe-ec9f386cae8e.jpg";
            [self makePost:uploadImage withVideoUrl:@""];
            
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
 
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateVideo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateVideo:) name:@"updateVideo" object:nil];
}
#pragma mark viemo stuff
- (void)deleteCheck
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSString *complete_uri= (NSString *)[_responseDic objectForKey:@"complete_uri"];
    //   NSString *url= [NSString stringWithFormat:@"%@%@",@"https://api.vimeo.com", complete_uri];
    //  NSString *url= [NSString stringWithFormat:@"%@%@",@"at.fitmoo.com/api/users/finish_vimeo_upload?", complete_uri];
    NSString *url= @"http://uat.fitmoo.com/api/users/finish_vimeo_upload?";
    NSString *completeUrl= [NSString stringWithFormat:@"%@%@",@"https://api.vimeo.com", complete_uri];
    //   [manager.requestSerializer setValue:@"bearer e98b9f19cbfed0fb03702cf28addb16e" forHTTPHeaderField:@"Authorization"];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:completeUrl, @"complete_url", nil];
    [manager DELETE:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary * responseDic= responseObject;
        NSString *responseString=(NSString *)[responseDic objectForKey:@"location"];
        NSRange range= [responseString rangeOfString:@"/videos/"];
        NSString *videoid= [responseString substringFromIndex:range.length+range.location];
        
        NSString *videoUrl= [NSString stringWithFormat:@"%@%@", @"https://vimeo.com/",videoid];
        [self makePost:nil withVideoUrl:videoUrl];
        NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
            failure:^(AFHTTPRequestOperation *operation, NSError *error){
                NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}

- (void) verifyCheck
{

    
    
    NSString *url= (NSString *)[_responseDic objectForKey:@"upload_link_secure"];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"bytes */*", @"Content-Range",[NSString stringWithFormat:@"%d", 0], @"Content-Length", nil];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"PUT"];
    [request setAllHTTPHeaderFields:jsonDict];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:nil progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
    
}

- (void) uploadVideo
{
    

    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:self.videoURL.path error:nil];
    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
    long long fileSize = [fileSizeNumber longLongValue];
 //   NSData *videoData = [NSData dataWithContentsOfFile:self.videoURL.path];
    NSString *url= (NSString *)[_responseDic objectForKey:@"upload_link_secure"];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"video/mp4", @"Content-Type",[NSString stringWithFormat:@"%lld", fileSize], @"Content-Length", nil];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"PUT"];
    [request setAllHTTPHeaderFields:jsonDict];
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithRequest:request fromFile:_videoURL progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            [self deleteCheck];
            NSLog(@"Success: %@ %@", response, responseObject);
        }
    }];
    [uploadTask resume];
    
    
}

-(void) getAuth
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    //      NSString *url= [NSString stringWithFormat:@"%@%@", [[UserManager sharedUserManager] clientUrl],@"/api/users/get_upload_token_vimeo" ];
    
    NSString *url= [NSString stringWithFormat:@"%@%@", @"http://uat.fitmoo.com",@"/api/users/get_upload_token_vimeo" ];
    
    [manager POST: url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        [self uploadVideo];
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);} // failure callback block
     ];

}
#pragma mark end of viemo stuff
-(void) updateVideo: (NSNotification * ) note
{
    self.videoURL=(NSURL *)[note object];

    UIImage *thumbnail =[self thumbnailImageForVideo:self.videoURL atTime:1];
    
    [_normalPostImage setBackgroundImage:thumbnail forState:UIControlStateNormal];
    [_normalPostImage setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [_workoutPostImage setBackgroundImage:thumbnail forState:UIControlStateNormal];
    [_workoutPostImage setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [_nutritionPostImage setBackgroundImage:thumbnail forState:UIControlStateNormal];
    [_nutritionPostImage setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    _PostImage= thumbnail;
    _postActionType=@"video";
    
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



- (void) updateImages: (NSNotification * ) note
{
    _PostImage= (UIImage * ) [note object];
    [_normalPostImage setBackgroundImage:self.PostImage forState:UIControlStateNormal];
    [_normalPostImage setImage:nil forState:UIControlStateNormal];
    [_workoutPostImage setBackgroundImage:self.PostImage forState:UIControlStateNormal];
    [_workoutPostImage setImage:nil forState:UIControlStateNormal];
    [_nutritionPostImage setBackgroundImage:self.PostImage forState:UIControlStateNormal];
    [_nutritionPostImage setImage:nil forState:UIControlStateNormal];
    _postActionType=@"image";
}


- (void) defineTypeOfPost
{
    [_normalPostImage setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_workoutPostImage setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [_nutritionPostImage setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    if ([self.postType isEqualToString:@"post"]) {
        [self setPostFrame];
        
        
        [_NormalPostButton setTitleColor:[UIColor colorWithRed:16.0/255.0 green:156.0/255.0 blue:251.0/255.0 alpha:1] forState:UIControlStateNormal];
        [_NutritionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_WorkoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _wihteArrawImage.frame= CGRectMake(150, 45, 20, 10);
        _wihteArrawImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_wihteArrawImage respectToSuperFrame:self.view];
        
    }else  if ([self.postType isEqualToString:@"nutrition"]) {
        [self setNutritionFrame];
        [_NutritionButton setTitleColor:[UIColor colorWithRed:146.0/255.0 green:204.0/255.0 blue:70.0/255.0 alpha:1] forState:UIControlStateNormal];
        [_NormalPostButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_WorkoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _wihteArrawImage.frame= CGRectMake(55, 45, 20, 10);
        _wihteArrawImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_wihteArrawImage respectToSuperFrame:self.view];
       
      
    }else  if ([self.postType isEqualToString:@"workout"]) {
        
        [_WorkoutButton setTitleColor:[UIColor colorWithRed:205.0/255.0 green:103.0/255.0 blue:239.0/255.0 alpha:1] forState:UIControlStateNormal];
        [_NutritionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_NormalPostButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setWorkoutFrame];
        _wihteArrawImage.frame= CGRectMake(245, 45, 20, 10);
        _wihteArrawImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_wihteArrawImage respectToSuperFrame:self.view];
    }
}



-(void) setPostFrame
{
    _normalPostView.frame= CGRectMake(0, 55, 320, 142);
    _normalPostView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_normalPostView respectToSuperFrame:self.view];
    _normalPostView.hidden=false;
    _workoutView.hidden=true;
    _nutritionView.hidden=true;
    [_normalPostImage setBackgroundImage:self.PostImage forState:UIControlStateNormal];
    if (self.PostImage==nil) {
        [_normalPostImage setBackgroundImage:[UIImage imageNamed:@"defaultprofilepic.png"] forState:UIControlStateNormal];
    }
    
    //   _normalPostImage.image= self.PostImage;
    //  [_normalPostText setp]
    
}

-(void) setWorkoutFrame
{
    _workoutView.frame= CGRectMake(0, 55, 320, 172);
    _workoutView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutView respectToSuperFrame:self.view];
    [_workoutPostImage  setBackgroundImage:self.PostImage forState:UIControlStateNormal];
    if (self.PostImage==nil) {
        [_workoutPostImage setBackgroundImage:[UIImage imageNamed:@"defaultprofilepic.png"] forState:UIControlStateNormal];
    }
    _normalPostView.hidden=true;
    _workoutView.hidden=false;
    _nutritionView.hidden=true;
}

-(void) setNutritionFrame
{
    _nutritionView.frame= CGRectMake(0, 55, 320, 245);
    _nutritionView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionView respectToSuperFrame:self.view];
    _normalPostView.hidden=true;
    _workoutView.hidden=true;
    _nutritionView.hidden=false;
    [_nutritionPostImage  setBackgroundImage:self.PostImage forState:UIControlStateNormal];
    if (self.PostImage==nil) {
        [_nutritionPostImage setBackgroundImage:[UIImage imageNamed:@"defaultprofilepic.png"] forState:UIControlStateNormal];
    }

}

-(void) initFrames
{

    double framradio= [[FitmooHelper sharedInstance] frameRadio];
    _normalPostView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_normalPostView respectToSuperFrame:self.view];
    _normalPostImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_normalPostImage respectToSuperFrame:self.view];
 //   _normalPostText.frame= CGRectMake(96*framradio, 10*framradio, 216, 112);
    _normalPostBackView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_normalPostBackView respectToSuperFrame:self.view];
 
   
    _normalEditButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_normalEditButton respectToSuperFrame:self.view];
    
    _workoutView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutView respectToSuperFrame:self.view];
    _workoutTitleView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutTitleView respectToSuperFrame:self.view];
    _workoutEditButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutEditButton respectToSuperFrame:self.view];
    
    _workoutInstructionView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutInstructionView respectToSuperFrame:self.view];
    _nutritionView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionView respectToSuperFrame:self.view];
    _nutritionTitleView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionTitleView respectToSuperFrame:self.view];
    _nutritionIngedientsView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionIngedientsView respectToSuperFrame:self.view];
    _nutritionPreparationView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionPreparationView respectToSuperFrame:self.view];
    _nutritionEditButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionEditButton respectToSuperFrame:self.view];
    
  //  _buttonView.frame= CGRectMake(0, 0, 320, 55);
    _buttonView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttonView respectToSuperFrame:self.view];
    _NormalPostButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_NormalPostButton respectToSuperFrame:self.view];
    _WorkoutButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_WorkoutButton respectToSuperFrame:self.view];
    _NutritionButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_NutritionButton respectToSuperFrame:self.view];
    _wihteArrawImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_wihteArrawImage respectToSuperFrame:self.view];
    _nutritionPostImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionPostImage respectToSuperFrame:self.view];
    _workoutPostImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutPostImage respectToSuperFrame:self.view];
    
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:self.view];
    _SubmitButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_SubmitButton respectToSuperFrame:self.view];
    
    _normalEditButton.layer.cornerRadius=3;
    _workoutEditButton.layer.cornerRadius=3;
    _nutritionEditButton.layer.cornerRadius=3;
    
//    _NormalPostButton.titleLabel.font = [UIFont fontWithName:@"BentonSans-Bold" size:_NormalPostButton.titleLabel.font.pointSize];
//    _NutritionButton.titleLabel.font = [UIFont fontWithName:@"BentonSans-Bold" size:_NutritionButton.titleLabel.font.pointSize];
//    _WorkoutButton.titleLabel.font = [UIFont fontWithName:@"BentonSans-Bold" size:_WorkoutButton.titleLabel.font.pointSize];
    
    _normalPostText.placeholder=@"   Write a post...";
    _workoutTitle.placeholder=@"   Workout Title";
    _workoutInstruction.placeholder=@"   Instruction";
    _nutritionTitle.placeholder=@"   Nutrition Title";
    _nutritionIngedients.placeholder=@"   Ingedients";
    _nutritionPreparation.placeholder=@"   Preparation";
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




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
    
  //  [self presentCameraView];
    if (_PostImage !=nil) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"showImageViewer" object:_PostImage];
    }
    
}

- (IBAction)cancelButtonClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void) makePost: (NSString *) imageUrl withVideoUrl: (NSString *) videoUrl
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
            NSArray *videoArray;
            NSDictionary *photos_attributes;
            NSDictionary *video_attributes;
            NSDictionary *feed;
            
            if (![videoUrl isEqualToString:@""]) {
                video_attributes= [[NSDictionary alloc] initWithObjectsAndKeys:@"Fitmoo",@"title",videoUrl, @"video_url",@"alternate", @"rel",@"Fitmoo Channel", @"description", nil];
               videoArray=[[NSArray alloc] initWithObjects:video_attributes, nil];
                 photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: nil];
                
                feed= [[NSDictionary alloc] initWithObjectsAndKeys: _normalPostText.text, @"text",photos_attributes, @"photos_attributes",videoArray, @"videos_attributes", nil];
                
            }else if ([imageUrl isEqualToString:@""]) {
                photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: nil];
                feed= [[NSDictionary alloc] initWithObjectsAndKeys: _normalPostText.text, @"text",photos_attributes, @"photos_attributes", nil];
              
            }else
            {
                
                photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys:@"320",@"height",@"320", @"width",imageUrl, @"photo_url", nil];
                photoArray = [[NSArray alloc] initWithObjects:photos_attributes, nil];
                feed= [[NSDictionary alloc] initWithObjectsAndKeys: _normalPostText.text, @"text",photoArray, @"photos_attributes", nil];
              
            }
            
           
            
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
                NSArray *videoArray;
                NSDictionary *photos_attributes;
                NSDictionary *video_attributes;
                NSDictionary *feed;
                
                if (![videoUrl isEqualToString:@""]) {
                    video_attributes= [[NSDictionary alloc] initWithObjectsAndKeys:@"Fitmoo",@"title",videoUrl, @"video_url",@"alternate", @"rel",@"Fitmoo Channel", @"description", nil];
                    videoArray=[[NSArray alloc] initWithObjects:video_attributes, nil];
                    photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: nil];
                    
                    NSDictionary *nutrition_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: _nutritionTitle.text, @"title",_nutritionIngedients.text, @"ingredients",_nutritionPreparation.text, @"preparation", nil];
                    
                    feed= [[NSDictionary alloc] initWithObjectsAndKeys: nutrition_attributes, @"nutrition_attributes",photos_attributes, @"photos_attributes",videoArray, @"videos_attributes",@"", @"text", nil];
                   
                }else if ([imageUrl isEqualToString:@""]) {
                    photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: nil];
                    NSDictionary *nutrition_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: _nutritionTitle.text, @"title",_nutritionIngedients.text, @"ingredients",_nutritionPreparation.text, @"preparation", nil];
                    feed= [[NSDictionary alloc] initWithObjectsAndKeys: nutrition_attributes, @"nutrition_attributes",photos_attributes, @"photos_attributes",@"", @"text", nil];
                   
                }else
                {
                    
                    
                    
                    
                    photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys:@"320",@"height",@"320", @"width",imageUrl, @"photo_url", nil];
                    photoArray = [[NSArray alloc] initWithObjects:photos_attributes, nil];
                    NSDictionary *nutrition_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: _nutritionTitle.text, @"title",_nutritionIngedients.text, @"ingredients",_nutritionPreparation.text, @"preparation", nil];
                    feed= [[NSDictionary alloc] initWithObjectsAndKeys: nutrition_attributes, @"nutrition_attributes",photoArray, @"photos_attributes",@"", @"text", nil];
                   
                }
                

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
                NSArray *videoArray;
                NSDictionary *photos_attributes;
                NSDictionary *video_attributes;
                NSDictionary *feed;
                
                if (![videoUrl isEqualToString:@""]) {
                    video_attributes= [[NSDictionary alloc] initWithObjectsAndKeys:@"Fitmoo",@"title",videoUrl, @"video_url",@"alternate", @"rel",@"Fitmoo Channel", @"description", nil];
                    videoArray=[[NSArray alloc] initWithObjects:video_attributes, nil];
                    photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: nil];
                    
                     feed= [[NSDictionary alloc] initWithObjectsAndKeys: _workoutInstruction.text, @"text",_workoutTitle.text, @"workout_title",photos_attributes, @"photos_attributes",videoArray, @"videos_attributes", nil];

                    
                }
               else if ([imageUrl isEqualToString:@""]) {
                    photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: nil];
                     feed= [[NSDictionary alloc] initWithObjectsAndKeys: _workoutInstruction.text, @"text",_workoutTitle.text, @"workout_title",photos_attributes, @"photos_attributes", nil];
                 
                }else
                {
                    
                    photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys:@"320",@"height",@"320", @"width",imageUrl, @"photo_url", nil];
                    photoArray = [[NSArray alloc] initWithObjects:photos_attributes, nil];
                     feed= [[NSDictionary alloc] initWithObjectsAndKeys: _workoutInstruction.text, @"text",_workoutTitle.text, @"workout_title",photoArray, @"photos_attributes", nil];
                    [self addActivityIndicator];
                }
                
               
                
                [ [UserManager sharedUserManager] performPost:feed];
            }
        }
        
    }
    
}

- (void) addActivityIndicator
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [[FitmooHelper sharedInstance] resizeFrameWithFrame:activityIndicator respectToSuperFrame:nil];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = CGPointMake(160*[[FitmooHelper sharedInstance] frameRadio], 240*[[FitmooHelper sharedInstance] frameRadio]);
    activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    self.view.userInteractionEnabled=NO;
}

-(bool) validate
{
    
    if ([self.postType isEqualToString:@"post"]) {
        if ([_normalPostText.text isEqualToString:@""]) {
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not Post"
                                                              message : @"text can not be empty" delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
            return false;
        }
        
    }else  if ([self.postType isEqualToString:@"nutrition"]) {
        if ([_nutritionTitle.text isEqualToString:@""]) {
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not Post"
                                                              message : @"title can not be empty" delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
            return false;
        }else
        {
            if ([_nutritionPreparation.text isEqualToString:@""]&&[_nutritionIngedients.text isEqualToString:@""]) {
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not Post"
                                                                  message : @"Ingrediens and Preparation can not be both empty" delegate : nil cancelButtonTitle : @"OK"
                                                        otherButtonTitles : nil ];
                [alert show ];
                return false;
            }
        }
        
    }else  if ([self.postType isEqualToString:@"workout"]) {
        if ([_workoutTitle.text isEqualToString:@""]) {
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not Post"
                                                              message : @"title can not be empty" delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
            return false;
        }else
        {
            if ([_workoutInstruction.text isEqualToString:@""]) {
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not Post"
                                                                  message : @"Instruction can not be both empty" delegate : nil cancelButtonTitle : @"OK"
                                                        otherButtonTitles : nil ];
                [alert show ];
                return false;
            }
        }
    
    }



    return true;
}

- (void) generateVideoPost
{
    
}

- (void) generateImagePost
{
    
}

- (void) generateTextPost
{
    
}

- (IBAction)postButtonClick:(id)sender {
    
    if ([self validate] ==true) {
        if ([_postActionType isEqualToString:@"video"]) {
            [self getAuth];
            [self generateVideoPost];
            
        }else if ([_postActionType isEqualToString:@"image"]) {
                
            [self uploadToS3];
            [self generateImagePost];
        }else
        {
            [self makePost:@"" withVideoUrl:@""];
            [self generateTextPost];
        }
     
        [self addActivityIndicator];
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

- (IBAction)editClick:(id)sender {
    
    [self.view removeFromSuperview];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"hidePostView" object:Nil];
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    if (CGRectContainsPoint(button.frame, point)) {
//        return button;
//    }
//    return [super hitTest:point withEvent:event];
//}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    _textViewBackgroundView= [[TestView1 alloc] initWithFrame:CGRectMake(0, -50*[[FitmooHelper sharedInstance] frameRadio], self.view.frame.size.width, self.view.frame.size.height+100)];
    _textViewBackgroundView.backgroundColor=[UIColor blackColor];
    _textViewBackgroundView.alpha=0.7;
    [self.view addSubview:_textViewBackgroundView];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"showOKButton" object:@"yes"];

    
    
    [self.view bringSubviewToFront:_normalPostView];
    [self.view bringSubviewToFront:_workoutView];
    [self.view bringSubviewToFront:_nutritionView];
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        _normalPostView.frame=CGRectMake(0, 0, _normalPostView.frame.size.width, _normalPostView.frame.size.height);
        _workoutView.frame=CGRectMake(0, 0, _workoutView.frame.size.width, _workoutView.frame.size.height);
        _nutritionView.frame=CGRectMake(0, 0, _nutritionView.frame.size.width, _nutritionView.frame.size.height);
        
    }completion:^(BOOL finished){}];

}

- (void)hideTextViewBackgroundView
{
    
    [_workoutTitle resignFirstResponder];
    [_workoutInstruction resignFirstResponder];
    [_normalPostText resignFirstResponder];
    [_nutritionTitle resignFirstResponder];
    [_nutritionIngedients resignFirstResponder];
    [_nutritionPreparation resignFirstResponder];
    [_textViewBackgroundView removeFromSuperview];
    _textViewBackgroundView=nil;
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        _normalPostView.frame=CGRectMake(0, 50*[[FitmooHelper sharedInstance] frameRadio], _normalPostView.frame.size.width, _normalPostView.frame.size.height);
        _workoutView.frame=CGRectMake(0, 50*[[FitmooHelper sharedInstance] frameRadio], _workoutView.frame.size.width, _workoutView.frame.size.height);
        _nutritionView.frame=CGRectMake(0, 50*[[FitmooHelper sharedInstance] frameRadio], _nutritionView.frame.size.width, _nutritionView.frame.size.height);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showOKButton" object:@"no"];
        
    }completion:^(BOOL finished){}];

}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self hideTextViewBackgroundView];
}

@end
