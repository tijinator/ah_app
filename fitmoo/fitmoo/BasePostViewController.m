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
{
     NSNumber * contentHight;
    double frameRadio;
    CGRect originalTableviewFrame;
    
}
@property (nonatomic, strong) AWSS3TransferManagerUploadRequest *uploadRequest;
@property (nonatomic) uint64_t filesize;
@property (nonatomic) uint64_t amountUploaded;

@property (strong, nonatomic)  TestView1 *textViewBackgroundView;
@end

@implementation BasePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    _localUser= [[UserManager sharedUserManager] localUser];
     self.tableview.tableFooterView = [[UIView alloc] init];

    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor =[UIColor colorWithRed:235.0/255.0 green:238.0/255.0 blue:240.0/255.0 alpha:1.0];
    [_tableview setBackgroundView:bview];
 
   
    contentHight=[NSNumber numberWithInteger:50];
    _heighArray= [[NSMutableArray alloc] initWithObjects:contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight, nil];
    _saveToCommunity=@"0";
    [self defineTypeOfPost];

    [self createObservers];

   
    
}

- (void) moveDownTableView
{
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
        _tableview.frame=CGRectMake(originalTableviewFrame.origin.x, originalTableviewFrame.origin.y, originalTableviewFrame.size.width, originalTableviewFrame.size.height);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showOKButton" object:@"no"];
        
    }completion:^(BOOL finished){}];

}

- (void)switchValueChanged:(UISwitch *)theSwitch
{
    BOOL flag = theSwitch.on;
 
 
    if (flag==true) {
        _saveToCommunity=@"1";
        
        _textViewBackgroundView= [[TestView1 alloc] initWithFrame:CGRectMake(0, -50*[[FitmooHelper sharedInstance] frameRadio], self.view.frame.size.width, self.view.frame.size.height+100)];
        _textViewBackgroundView.backgroundColor=[UIColor blackColor];
        _textViewBackgroundView.alpha=0.7;
        [self.view addSubview:_textViewBackgroundView];
        
        originalTableviewFrame=_tableview.frame;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showOKButton" object:@"yes"];
        
        [self.view bringSubviewToFront:_tableview];
       
        
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
           
            _tableview.frame=CGRectMake(0, 0, _tableview.frame.size.width, _SubmitButton.frame.size.height+_SubmitButton.frame.origin.y);
            
        }completion:^(BOOL finished){}];

        
    }else
    {
        _saveToCommunity=@"0";
        
        [_textViewBackgroundView removeFromSuperview];
        _textViewBackgroundView=nil;
        
        for (int i=0; i<[_localUser.communityArray count]; i++) {
            CreatedByCommunity *tempCom= [_localUser.communityArray objectAtIndex:i];
            tempCom.is_selected=@"0";
        }
        
        
        [self moveDownTableView];
        
        
    }
    
    [self.tableview reloadData];
    
    
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 

    
//    double Radio= self.view.frame.size.width / 320;
//    NSNumber *height;
//    if (indexPath.row<[_heighArray count]) {
//        height= (NSNumber *)[_heighArray objectAtIndex:indexPath.row];
//        
//        return height.integerValue;
//    }else
//    {
//        height=[NSNumber numberWithInt:50*Radio];
//        return height.integerValue;
//    }
//    
//    
//    return height.integerValue;
    
    
     double Radio= self.view.frame.size.width / 320;
    if (indexPath.row==0) {
        return 60*Radio;
    }
    return 50*Radio;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    if ([_saveToCommunity isEqualToString:@"1"]) {
        
        if (_localUser.communityArray!=nil) {
             return [_localUser.communityArray count]+1;
        }
       
    }
    
    return 1;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    if (indexPath.row==0) {
        
        
        UITableViewCell * cell  = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
      //  [cell setSeparatorInset:UIEdgeInsetsMake(0, cell.contentView.frame.size.width/2, 0, cell.contentView.frame.size.width/2)];
        
        UIView *view= (UIView *) [cell viewWithTag:22];
        view.frame= CGRectMake(0, 0, 320, 50);
        view.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:view respectToSuperFrame:nil];
        
        UILabel *label= (UILabel *)[cell viewWithTag:20];
        label.frame= CGRectMake(28, 14, 164, 25);
        label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:label respectToSuperFrame:nil];
        label.text= @"Post to my Communities";
        
        
        UISwitch *sw= (UISwitch *) [cell viewWithTag:21];
        double frameradio= [[FitmooHelper sharedInstance] frameRadio];
        sw.frame= CGRectMake(245*frameradio, 10*frameradio, 51, 31);
        sw.tag=indexPath.row+20;
        [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        if ([_saveToCommunity isEqualToString:@"0"]) {
            [sw setOn:NO animated:YES];
        }else
        {
            [sw setOn:YES animated:YES];
        }
        
        
      //  [cell.contentView addSubview:label];
     //   [cell.contentView addSubview:sw];
        
        return cell;
        
        
        
    }
    
     UITableViewCell * cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    
    CreatedByCommunity *tempCommunity=[_localUser.communityArray objectAtIndex:indexPath.row-1];
   
    
    UIButton * followButton= [[UIButton alloc] init];
    followButton.frame= CGRectMake(290, 15, 16, 12);
    followButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:followButton respectToSuperFrame:self.view];
    [followButton setTag:indexPath.row*100+7];
   
    if ([tempCommunity.is_selected isEqualToString:@"1"]) {
          [followButton setBackgroundImage:[UIImage imageNamed:@"bluecheck.png"] forState:UIControlStateNormal];
    }else
    {
        [followButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
  
  
  
    
    
    UIButton *imageButton= [[UIButton alloc] init];
    imageButton.frame= CGRectMake(0, 0, 75, 50);
    imageButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:imageButton respectToSuperFrame:self.view];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, imageButton.frame.size.width, imageButton.frame.size.height)];
    view.clipsToBounds=YES;
    view.userInteractionEnabled = NO;
    view.exclusiveTouch = NO;
    
    AsyncImageView *imageview=[[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, imageButton.frame.size.width, imageButton.frame.size.height)];
    imageview.userInteractionEnabled = NO;
    imageview.exclusiveTouch = NO;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageview];
    imageview.imageURL =[NSURL URLWithString:tempCommunity.cover_photo_url];
    
    [imageButton.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [view addSubview:imageview];
    [imageButton addSubview:view];
    imageButton.exclusiveTouch=NO;
    imageButton.userInteractionEnabled=NO;
    
 
    UILabel *nameLabel=[[UILabel alloc] init];
    nameLabel.frame= CGRectMake(90, 18, 190, 41);
    nameLabel.numberOfLines=2;
    nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel respectToSuperFrame:self.view];
    imageview.layer.cornerRadius=imageview.frame.size.width/2;
  
    
  
    UIFont *font= [UIFont fontWithName:@"BentonSans-Medium" size:(CGFloat)(13)];
    NSString *string=tempCommunity.name;

    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: font} ];

    nameLabel.lineBreakMode= NSLineBreakByWordWrapping;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:3];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:style
                             range:NSMakeRange(0, string.length)];
    [nameLabel setAttributedText:attributedString];
  
    nameLabel.numberOfLines=0;
    [nameLabel sizeToFit];
    contentHight=[NSNumber numberWithInteger:nameLabel.frame.size.height];
    
    [cell.contentView addSubview:imageButton];
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:followButton];

    if (indexPath.row>=[_heighArray count]) {
        [_heighArray addObject:contentHight];
    }else
    {
        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
    }
    
    UIView *v= [[UIView alloc] initWithFrame:CGRectMake(0, 50*frameRadio-1, cell.contentView.frame.size.width, 1)];
    v.backgroundColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:0.9f];
    [cell addSubview:v];
  
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row>0) {
         CreatedByCommunity *tempCommunity=[_localUser.communityArray objectAtIndex:indexPath.row-1];
        if ([tempCommunity.is_selected isEqualToString:@"1"]) {
            tempCommunity.is_selected=@"0";
        }else
        {
            tempCommunity.is_selected=@"1";
        }
        
        [_tableview reloadData];
    }
    
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
//    double Radio= self.view.frame.size.width / 320;
//    
//    NSNumber *height;
//    if (indexPath.row<[_heighArray count]) {
//        height= (NSNumber *)[_heighArray objectAtIndex:indexPath.row];
//        
//    }else
//    {
//        height=[NSNumber numberWithInt:contentHight.intValue];
//    }
//    
//    return  MAX(50*Radio, height.intValue);
    double Radio= self.view.frame.size.width / 320;
    if (indexPath.row==0) {
        return 60*Radio;
    }
    
    return 50*Radio;
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
    // create a local image that we can use to upload to s3
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"image.png"];
    NSData *imageData = UIImagePNGRepresentation(img);
    [imageData writeToFile:path atomically:YES];
    
    // once the image is saved we can use the path to create a local fileurl
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    
    // next we set up the S3 upload request manager
    _uploadRequest = [AWSS3TransferManagerUploadRequest new];
    // set the bucket

    _uploadRequest.bucket = [[UserManager sharedUserManager] s3_bucket];
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
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                              message : @"The image didn't upload." delegate : nil cancelButtonTitle : @"OK"
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
    NSLog(@"%@", [NSString stringWithFormat:@"Uploading:%.0f%%", ((float)self.amountUploaded/ (float)self.filesize) * 100]);
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

    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *url= (NSString *)[_responseDic objectForKey:@"upload_link_secure"];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"bytes */*", @"Content-Range",[NSString stringWithFormat:@"%d", 0], @"Content-Length", nil];
    [manager PUT:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){

       
        NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
            failure:^(AFHTTPRequestOperation *operation, NSError *error){
                NSLog(@"Error: %@", error);} // failure callback block
     ];
    
    
    
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
  
    _tableview.frame=CGRectMake(0, _normalPostView.frame.size.height+_normalPostView.frame.origin.y+10, 320*frameRadio, _SubmitButton.frame.origin.y-_normalPostView.frame.size.height-_normalPostView.frame.origin.y-10);
    originalTableviewFrame=_tableview.frame;
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
    
     _tableview.frame=CGRectMake(0, _workoutView.frame.size.height+_workoutView.frame.origin.y+10, 320*frameRadio, _SubmitButton.frame.origin.y-_workoutView.frame.size.height-_workoutView.frame.origin.y-10);
    originalTableviewFrame=_tableview.frame;
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
    
     _tableview.frame=CGRectMake(0, _nutritionView.frame.size.height+_nutritionView.frame.origin.y+10, 320*frameRadio, _SubmitButton.frame.origin.y-_nutritionView.frame.size.height-_nutritionView.frame.origin.y-10);
    originalTableviewFrame=_tableview.frame;
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

    frameRadio= [[FitmooHelper sharedInstance] frameRadio];
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
    
    _normalPostText.placeholder=@"Write a post...";
    _workoutTitle.placeholder=@"Title";
    _workoutInstruction.placeholder=@"Workout";
    _nutritionTitle.placeholder=@"Title";
    _nutritionIngedients.placeholder=@"Ingredients";
    _nutritionPreparation.placeholder=@"Preparation";
    

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
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                              message : @"Please write something." delegate : nil cancelButtonTitle : @"OK"
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
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                              message : @"Please write a title." delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
        }else
        {
            if ([_nutritionPreparation.text isEqualToString:@""]&&[_nutritionIngedients.text isEqualToString:@""]) {
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                                  message : @"Please fill out Ingredients or Preparation." delegate : nil cancelButtonTitle : @"OK"
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
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                              message : @"Please write a title." delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
        }else
        {
            if ([_workoutInstruction.text isEqualToString:@""]) {
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                                  message : @"Please fill out your workout." delegate : nil cancelButtonTitle : @"OK"
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
    UIView *view= [[UIView alloc] initWithFrame:CGRectMake(110*[[FitmooHelper sharedInstance] frameRadio], 200*[[FitmooHelper sharedInstance] frameRadio], 100, 100)];
    view.backgroundColor=[UIColor colorWithRed:174.0/255.0 green:182.0/255.0 blue:186.0/255.0 alpha:1];
  //  view.backgroundColor=[UIColor whiteColor];
    view.layer.cornerRadius=5;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [[FitmooHelper sharedInstance] resizeFrameWithFrame:activityIndicator respectToSuperFrame:nil];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = CGPointMake(50, 40);
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator setBackgroundColor:[UIColor clearColor]];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    
    UILabel * postingLabel= [[UILabel alloc] initWithFrame: CGRectMake(0,60, 100, 30)];
    postingLabel.text= @"POSTING...";
  //  postingLabel.textColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    postingLabel.textColor=[UIColor whiteColor];
    UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:13];
    [postingLabel setFont:font];
    postingLabel.textAlignment=NSTextAlignmentCenter;
    
    [view addSubview:activityIndicator];
    [view addSubview:postingLabel];
    [self.view addSubview:view];
    
    self.view.userInteractionEnabled=NO;
}

-(bool) validate
{
    
    if ([self.postType isEqualToString:@"post"]) {
        if ([_normalPostText.text isEqualToString:@""]) {
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                              message : @"Please write something." delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
            return false;
        }
        
    }else  if ([self.postType isEqualToString:@"nutrition"]) {
        if ([_nutritionTitle.text isEqualToString:@""]) {
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                              message : @"Please write a title." delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
            return false;
        }else
        {
            if ([_nutritionPreparation.text isEqualToString:@""]&&[_nutritionIngedients.text isEqualToString:@""]) {
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                                  message : @"Please fill out Ingredients or Preparation." delegate : nil cancelButtonTitle : @"OK"
                                                        otherButtonTitles : nil ];
                [alert show ];
                return false;
            }
        }
        
    }else  if ([self.postType isEqualToString:@"workout"]) {
        if ([_workoutTitle.text isEqualToString:@""]) {
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                              message : @"Please fill out a title." delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
            return false;
        }else
        {
            if ([_workoutInstruction.text isEqualToString:@""]) {
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                                  message : @"Please fill out your workout." delegate : nil cancelButtonTitle : @"OK"
                                                        otherButtonTitles : nil ];
                [alert show ];
                return false;
            }
        }
    
    }



    return true;
}



- (IBAction)postButtonClick:(id)sender {
    
    if ([self validate] ==true) {
        if ([_postActionType isEqualToString:@"video"]) {
            [self getAuth];
           
            
        }else if ([_postActionType isEqualToString:@"image"]) {
                
            [self uploadToS3];
          
        }else
        {
            [self makePost:@"" withVideoUrl:@""];
           
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
    _tableview.userInteractionEnabled=NO;
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
    
    [self moveDownTableView];
    _tableview.userInteractionEnabled=YES;

}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self hideTextViewBackgroundView];
}

@end
