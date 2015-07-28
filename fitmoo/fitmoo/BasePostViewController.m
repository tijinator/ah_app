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
    bool tableIsOnTop;
    NSTimeInterval interval;
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
    tableIsOnTop=false;
    _localUser= [[UserManager sharedUserManager] localUser];
    
    _workoutTypeArray= [[UserManager sharedUserManager] workoutTypesArray];
  
    self.tableview.tableFooterView = [[UIView alloc] init];
    
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor =[UIColor colorWithRed:235.0/255.0 green:238.0/255.0 blue:240.0/255.0 alpha:1.0];
    [_tableview setBackgroundView:bview];
    
    
    contentHight=[NSNumber numberWithInteger:60];
   
    _saveToCommunity=@"0";
    [self defineTypeOfPost];
    
    [self createObservers];
    
    [self resetCommunityArray];
    
}

- (void) resetCommunityArray
{
    _communityArray = [[NSMutableArray alloc] init];
    for (CreatedByCommunity *com in _localUser.communityArray) {
        [_communityArray addObject:com];
    }
}

- (void) resetCommunityArrayWithSelected
{
    _communityArray = [[NSMutableArray alloc] init];
    for (CreatedByCommunity *com in _localUser.communityArray) {
        if ([com.is_selected isEqualToString:@"1"]) {
            [_communityArray addObject:com];
        }
        
    }
}

- (void) moveDownTableView
{
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
        _tableview.frame=CGRectMake(originalTableviewFrame.origin.x, originalTableviewFrame.origin.y, originalTableviewFrame.size.width, originalTableviewFrame.size.height);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showOKButton" object:@"no"];
        
    }completion:^(BOOL finished){
        tableIsOnTop=false;
        [self resetCommunityArrayWithSelected];
        
        if ([_communityArray count]==0) {
            _saveToCommunity=@"0";
        }
        [_tableview reloadData];
        
    }];
    [_workOutTypeView.view removeFromSuperview];
    //    tableIsOnTop=false;
    //    [self resetCommunityArrayWithSelected];
    //
    //    if ([_communityArray count]==0) {
    //        _saveToCommunity=@"0";
    //    }
    //    [_tableview reloadData];
    
    
}

- (void) moveUpTableView
{
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
    [self resetCommunityArray];
    
    tableIsOnTop=true;
    [self.tableview reloadData];
    
}

- (void)switchValueChanged:(UISwitch *)theSwitch
{
    BOOL flag = theSwitch.on;
    
    
    if (flag==true) {
        [self moveUpTableView];
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
    
    
    
    
    double Radio= [[FitmooHelper sharedInstance] frameRadio];
    if (indexPath.row==0) {
        return 60*Radio;
    }
    return 60*Radio;
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
            
            if (tableIsOnTop==true) {
                return [_localUser.communityArray count]+1;
            }else
            {
                return [_communityArray count]+1;
            }
            
        }
        
    }
    
    return 1;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row==0) {
        
        
        UITableViewCell * cell  = [[UITableViewCell alloc] init];
        //       UITableViewCell * cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle= UITableViewCellSelectionStyleNone;
        //  [cell setSeparatorInset:UIEdgeInsetsMake(0, cell.contentView.frame.size.width/2, 0, cell.contentView.frame.size.width/2)];
        
        //    UIView *view= (UIView *) [cell viewWithTag:22];
        UIView *view= [[UIView alloc] init];
        view.frame= CGRectMake(0, 0, 320, 60);
        view.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:view respectToSuperFrame:nil];
        
        UILabel *label= [[UILabel alloc] init];
        //   UILabel *label= (UILabel *)[cell viewWithTag:20];
        label.frame= CGRectMake(28, 14, 164, 25);
        label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:label respectToSuperFrame:nil];
        UIFont *font= [UIFont fontWithName:@"BentonSans" size:(CGFloat)(14)];
        label.font=font;
        label.text= @"Post to my Communities";
        
        
        //   UISwitch *sw= (UISwitch *) [cell viewWithTag:21];
        UISwitch *sw= [[UISwitch alloc] init];
        [sw setOnTintColor:[UIColor colorWithRed:16.0/255.0 green:156.0/255.0 blue:251.0/255.0 alpha:1.0f]];
        double frameradio= [[FitmooHelper sharedInstance] frameRadio];
        sw.frame= CGRectMake(245*frameradio, 10*frameradio, 51, 31);
        sw.tag=indexPath.row+20;
        [sw addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        if ([_saveToCommunity isEqualToString:@"0"]) {
            [sw setOn:NO animated:NO];
        }else
        {
            [sw setOn:YES animated:NO];
        }
        
        [cell.contentView addSubview:view];
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:sw];
        
        return cell;
        
        
        
    }
    
    //    UITableViewCell * cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell1"];
    //   cell.contentView.frame=cell.bounds;
    UITableViewCell * cell  = [[UITableViewCell alloc] init];
    cell.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:cell.contentView respectToSuperFrame:nil];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    CreatedByCommunity *tempCommunity;
    if (tableIsOnTop==true) {
        tempCommunity=[_localUser.communityArray objectAtIndex:indexPath.row-1];
    }else
    {
        tempCommunity=[_communityArray objectAtIndex:indexPath.row-1];
    }
    
    
    
    UIButton * followButton= [[UIButton alloc] init];
    followButton.frame= CGRectMake(290, 22, 16, 12);
    followButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:followButton respectToSuperFrame:nil];
    [followButton setTag:indexPath.row*100+7];
    
    if ([tempCommunity.is_selected isEqualToString:@"1"]) {
        [followButton setBackgroundImage:[UIImage imageNamed:@"bluecheck.png"] forState:UIControlStateNormal];
    }else
    {
        [followButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
    
    
    
    
    UIButton *imageButton= [[UIButton alloc] init];
    imageButton.frame= CGRectMake(0, 0, 85, 60);
    imageButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:imageButton respectToSuperFrame:nil];
    
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
    nameLabel.frame= CGRectMake(95, 23, 185, 41);
    nameLabel.numberOfLines=2;
    nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel respectToSuperFrame:nil];
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
    
    [cell.contentView addSubview:imageButton];
    [cell.contentView addSubview:nameLabel];
    [cell.contentView addSubview:followButton];
    
    UIView *v= [[UIView alloc] initWithFrame:CGRectMake(0, imageButton.frame.size.height, cell.contentView.frame.size.width, 1)];
    v.backgroundColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:0.9f];
    [cell addSubview:v];
    

    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (indexPath.row>0) {
        CreatedByCommunity *tempCommunity;
        if (tableIsOnTop==true) {
            tempCommunity=[_localUser.communityArray objectAtIndex:indexPath.row-1];
        }else
        {
            tempCommunity=[_communityArray objectAtIndex:indexPath.row-1];
        }
        
        if ([tempCommunity.is_selected isEqualToString:@"1"]) {
            tempCommunity.is_selected=@"0";
        }else
        {
            tempCommunity.is_selected=@"1";
        }
        
        [_tableview reloadData];
    }else
    {
        if (tableIsOnTop==false&&[_saveToCommunity isEqualToString:@"1"]) {
            
            [self moveUpTableView];
        }
        
    }
    
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    double Radio= [[FitmooHelper sharedInstance] frameRadio];
    return 60*Radio;
    

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
    
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%d", 0] forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:@"1001" forHTTPHeaderField:@"Content-Range"];
    [manager.requestSerializer setValue:@"video/mp4" forHTTPHeaderField:@"Content-Type"];
    
    NSString *url= (NSString *)[_responseDic objectForKey:@"upload_link_secure"];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"bytes */*", @"Content-Range",[NSString stringWithFormat:@"%d", 0], @"Content-Length",@"video/mp4", @"Content-Type", nil];
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
            //   [self verifyCheck];
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
        _wihteArrawImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_wihteArrawImage respectToSuperFrame:nil];
        
    }else  if ([self.postType isEqualToString:@"nutrition"]) {
        [self setNutritionFrame];
        [_NutritionButton setTitleColor:[UIColor colorWithRed:146.0/255.0 green:204.0/255.0 blue:70.0/255.0 alpha:1] forState:UIControlStateNormal];
        [_NormalPostButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_WorkoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _wihteArrawImage.frame= CGRectMake(55, 45, 20, 10);
        _wihteArrawImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_wihteArrawImage respectToSuperFrame:nil];
        
        
    }else  if ([self.postType isEqualToString:@"workout"]) {
        
        [_WorkoutButton setTitleColor:[UIColor colorWithRed:205.0/255.0 green:103.0/255.0 blue:239.0/255.0 alpha:1] forState:UIControlStateNormal];
        [_NutritionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_NormalPostButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setWorkoutFrame];
        _wihteArrawImage.frame= CGRectMake(245, 45, 20, 10);
        _wihteArrawImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_wihteArrawImage respectToSuperFrame:nil];
    }
}



-(void) setPostFrame
{
    _normalPostView.frame= CGRectMake(0, 55, 320, 142);
    _normalPostView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_normalPostView respectToSuperFrame:nil];
    
    _tableview.frame=CGRectMake(0, _normalPostView.frame.size.height+_normalPostView.frame.origin.y+10, 320*frameRadio, _SubmitButton.frame.origin.y-_normalPostView.frame.size.height-_normalPostView.frame.origin.y-10);
    originalTableviewFrame=_tableview.frame;
    _normalPostView.hidden=false;
    _workoutView.hidden=true;
    _nutritionView.hidden=true;
    [_normalPostImage setBackgroundImage:self.PostImage forState:UIControlStateNormal];
    if (self.PostImage==nil) {
       
        [_normalPostImage setBackgroundImage:[UIImage imageNamed:@"defaultprofilepic.png"] forState:UIControlStateNormal];
        
    }
 
    if ([_postActionType isEqualToString:@"video"]) {
        [_normalPostImage setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
    
    //   _normalPostImage.image= self.PostImage;
    //  [_normalPostText setp]
    
}

-(void) setWorkoutFrame
{
    _workoutView.frame= CGRectMake(0, 55, 320, 225);
    _workoutView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutView respectToSuperFrame:nil];
    
    _tableview.frame=CGRectMake(0, _workoutView.frame.size.height+_workoutView.frame.origin.y+10, 320*frameRadio, _SubmitButton.frame.origin.y-_workoutView.frame.size.height-_workoutView.frame.origin.y-10);
    originalTableviewFrame=_tableview.frame;
    [_workoutPostImage  setBackgroundImage:self.PostImage forState:UIControlStateNormal];
    if (self.PostImage==nil) {
       
        [_workoutPostImage setBackgroundImage:[UIImage imageNamed:@"defaultprofilepic.png"] forState:UIControlStateNormal];
        
    }
    
    if ([_postActionType isEqualToString:@"video"]) {
        [_workoutPostImage setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
    _normalPostView.hidden=true;
    _workoutView.hidden=false;
    _nutritionView.hidden=true;
}

-(void) setNutritionFrame
{
    _nutritionView.frame= CGRectMake(0, 55, 320, 245);
    _nutritionView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionView respectToSuperFrame:nil];
    
    _tableview.frame=CGRectMake(0, _nutritionView.frame.size.height+_nutritionView.frame.origin.y+10, 320*frameRadio, _SubmitButton.frame.origin.y-_nutritionView.frame.size.height-_nutritionView.frame.origin.y-10);
    originalTableviewFrame=_tableview.frame;
    _normalPostView.hidden=true;
    _workoutView.hidden=true;
    _nutritionView.hidden=false;
    [_nutritionPostImage  setBackgroundImage:self.PostImage forState:UIControlStateNormal];
    if (self.PostImage==nil) {
       
        [_nutritionPostImage setBackgroundImage:[UIImage imageNamed:@"defaultprofilepic.png"] forState:UIControlStateNormal];
        
    }
    
    
    if ([_postActionType isEqualToString:@"video"]) {
        [_nutritionPostImage setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
    
}

-(void) initFrames
{
    
    //    _normalPostView.frame= CGRectMake(0, 55, 320, 142);
    //    _nutritionView.frame= CGRectMake(0, 55, 320, 245);
    //    _workoutView.frame= CGRectMake(0, 55, 320, 172);
    frameRadio= [[FitmooHelper sharedInstance] frameRadio];
    _normalPostView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_normalPostView respectToSuperFrame:nil];
    _normalPostImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_normalPostImage respectToSuperFrame:nil];
    //   _normalPostText.frame= CGRectMake(96*framradio, 10*framradio, 216, 112);
    _normalPostBackView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_normalPostBackView respectToSuperFrame:nil];
    
    
    _normalEditButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_normalEditButton respectToSuperFrame:nil];
    
    _workoutView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutView respectToSuperFrame:nil];
    _workoutTitleView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutTitleView respectToSuperFrame:nil];
    _workoutEditButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutEditButton respectToSuperFrame:nil];
    
    _workoutInstructionView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutInstructionView respectToSuperFrame:nil];
    _nutritionView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionView respectToSuperFrame:nil];
    _nutritionTitleView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionTitleView respectToSuperFrame:nil];
    _nutritionIngedientsView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionIngedientsView respectToSuperFrame:nil];
    _nutritionPreparationView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionPreparationView respectToSuperFrame:nil];
    _nutritionEditButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionEditButton respectToSuperFrame:nil];
    
    //  _buttonView.frame= CGRectMake(0, 0, 320, 55);
    _buttonView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttonView respectToSuperFrame:nil];
    _NormalPostButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_NormalPostButton respectToSuperFrame:nil];
    _WorkoutButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_WorkoutButton respectToSuperFrame:nil];
    _NutritionButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_NutritionButton respectToSuperFrame:nil];
    _wihteArrawImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_wihteArrawImage respectToSuperFrame:nil];
    _nutritionPostImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nutritionPostImage respectToSuperFrame:nil];
    _workoutPostImage.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutPostImage respectToSuperFrame:nil];
  //  _topView.frame= CGRectMake(0, 0, 320, 50);
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:nil];
    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:nil];
    _SubmitButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_SubmitButton respectToSuperFrame:nil];
    
    _workoutTypeLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutTypeLabel respectToSuperFrame:nil];
    _workoutTimeLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workoutTimeLabel respectToSuperFrame:nil];
    
    _pickerBackView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_pickerBackView respectToSuperFrame:nil];
    _pickerBackView1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_pickerBackView1 respectToSuperFrame:nil];
    
    _normalEditButton.layer.cornerRadius=3;
    _workoutEditButton.layer.cornerRadius=3;
    _nutritionEditButton.layer.cornerRadius=3;
    
    //    _NormalPostButton.titleLabel.font = [UIFont fontWithName:@"BentonSans-Bold" size:_NormalPostButton.titleLabel.font.pointSize];
    //    _NutritionButton.titleLabel.font = [UIFont fontWithName:@"BentonSans-Bold" size:_NutritionButton.titleLabel.font.pointSize];
    //    _WorkoutButton.titleLabel.font = [UIFont fontWithName:@"BentonSans-Bold" size:_WorkoutButton.titleLabel.font.pointSize];
    
    _normalPostText.placeholder=@"Write a post...";
 //   _workoutTitle.placeholder=@"Title";
    _workoutInstruction.placeholder=@"Details";
    _nutritionTitle.placeholder=@"Title";
    _nutritionIngedients.placeholder=@"Ingredients";
    _nutritionPreparation.placeholder=@"Preparation";
    
    _typePickerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_typePickerView respectToSuperFrame:nil];
    _timePickerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_timePickerView respectToSuperFrame:nil];
    double x=(self.view.frame.size.width-_datePicker.frame.size.width)/2;
    _datePicker.frame= CGRectMake(_datePicker.frame.origin.x+x, _datePicker.frame.origin.y*[[FitmooHelper sharedInstance] frameRadio], _datePicker.frame.size.width, _datePicker.frame.size.height);
    
    double x1=(self.view.frame.size.width-_typePicker.frame.size.width)/2;
    _typePicker.frame= CGRectMake(_typePicker.frame.origin.x+x1, _typePicker.frame.origin.y*[[FitmooHelper sharedInstance] frameRadio], _typePicker.frame.size.width, _typePicker.frame.size.height);
    _doneButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_doneButton respectToSuperFrame:nil];
    _doneButton1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_doneButton1 respectToSuperFrame:nil];
    
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TypeButtonClick:)];
    tapGestureRecognizer1.numberOfTapsRequired = 1;
    [_workoutTypeLabel addGestureRecognizer:tapGestureRecognizer1];
    _workoutTypeLabel.userInteractionEnabled=true;
    
    
    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TimeButtonClick:)];
    tapGestureRecognizer2.numberOfTapsRequired = 1;
    [_workoutTimeLabel addGestureRecognizer:tapGestureRecognizer2];
    _workoutTimeLabel.userInteractionEnabled=true;
    
    [self.datePicker addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
  
    _hoursArray = [[NSMutableArray alloc] init];
    _minsArray = [[NSMutableArray alloc] init];
    _secsArray = [[NSMutableArray alloc] init];
    NSString *strVal = [[NSString alloc] init];
    
    for(int i=0; i<60; i++)
    {
        strVal = [NSString stringWithFormat:@"%d", i];
        
        //NSLog(@"strVal: %@", strVal);
        
        //Create array with 0-12 hours
        if (i < 24)
        {
            [_hoursArray addObject:strVal];
        }
        
        //create arrays with 0-60 secs/mins
        [_minsArray addObject:strVal];
        [_secsArray addObject:strVal];
    }
    
    UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, _typePicker.frame.size.height / 2 - 15, 75, 30)];
    hourLabel.text = @"hour";
    [_typePicker addSubview:hourLabel];
    
    UILabel *minsLabel = [[UILabel alloc] initWithFrame:CGRectMake(42 + (_typePicker.frame.size.width / 3), _typePicker.frame.size.height / 2 - 15, 75, 30)];
    minsLabel.text = @"min";
    [_typePicker addSubview:minsLabel];
    
    UILabel *secsLabel = [[UILabel alloc] initWithFrame:CGRectMake(42 + ((_typePicker.frame.size.width / 3) * 2), _typePicker.frame.size.height / 2 - 15, 75, 30)];
    secsLabel.text = @"sec";
    [_typePicker addSubview:secsLabel];

    //  self.datePicker.backgroundColor=[UIColor lightGrayColor];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        //   [self disableViews];
        
    //    [_workoutTitle resignFirstResponder];
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

-(IBAction)calculateTimeFromPicker
{
    
    NSString *hoursStr = [NSString stringWithFormat:@"%@",[_hoursArray objectAtIndex:[_typePicker selectedRowInComponent:0]]];
    
    NSString *minsStr = [NSString stringWithFormat:@"%@",[_minsArray objectAtIndex:[_typePicker selectedRowInComponent:1]]];
    
    NSString *secsStr = [NSString stringWithFormat:@"%@",[_secsArray objectAtIndex:[_typePicker selectedRowInComponent:2]]];
    
   
    int hoursInt = [hoursStr intValue];
    int minsInt = [minsStr intValue];
    int secsInt = [secsStr intValue];
    
    if (hoursInt<10) {
        hoursStr=[NSString stringWithFormat:@"%@%@",@"0", hoursStr];
    }
    
    if (minsInt<10) {
        minsStr=[NSString stringWithFormat:@"%@%@",@"0", minsStr];
    }
    if (secsInt<10) {
        secsStr=[NSString stringWithFormat:@"%@%@",@"0", secsStr];
    }
    
    interval = secsInt + (minsInt*60) + (hoursInt*3600);
    
    _workoutTimeLabel.text =  [NSString stringWithFormat:@"%@%@%@%@%@", hoursStr, @" : ", minsStr, @" : ", secsStr];
    _workoutTimeLabel.textColor= [UIColor blackColor];

    
 //   NSString *totalTimeStr = [NSString stringWithFormat:@"%1.0f",interval];
    
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component
{
    
    [self calculateTimeFromPicker];
    
//    NSString *temType= [_workoutTypeArray objectAtIndex:row];
//   
//    _workoutTypeLabel.text=temType;
//  
//    _workoutTypeLabel.textColor=[UIColor blackColor];

    // Handle the selection
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
//    NSUInteger numRows = [_workoutTypeArray count];
//    return numRows;
    
    if (component==0)
    {
        return [_hoursArray count];
    }
    else if (component==1)
    {
        return [_minsArray count];
    }
    else
    {
        return [_secsArray count];
    }
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *columnView = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.view.frame.size.width/3 - 35, 30)];
    columnView.text = [NSString stringWithFormat:@"%lu", (long) row];
    columnView.textAlignment = NSTextAlignmentLeft;
    
    return columnView;
}
// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSString *title=[_workoutTypeArray objectAtIndex:row];
//    return title;
    switch (component)
    {
        case 0:
            if (row<10) {
                 return [NSString stringWithFormat:@"%@%@",@"0", [_hoursArray objectAtIndex:row]];
            }
            return [_hoursArray objectAtIndex:row];
            break;
        case 1:
            if (row<10) {
                return [NSString stringWithFormat:@"%@%@",@"0", [_minsArray objectAtIndex:row]];
            }
            return [_minsArray objectAtIndex:row];
            break;
        case 2:
            if (row<10) {
                return [NSString stringWithFormat:@"%@%@",@"0", [_secsArray objectAtIndex:row]];
            }
            return [_secsArray objectAtIndex:row];
            break;
    }
    return nil;
    
}




#pragma mark - UIbutton functions

- (IBAction)valueChanged:(id)sender {
    
    NSDate *pickerDate = [_datePicker date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"HH : mm";
    _workoutTimeLabel.text =  [format stringFromDate:pickerDate];
    _workoutTimeLabel.textColor= [UIColor blackColor];
}
- (IBAction)TypeButtonClick:(id)sender {
//    _typePickerView.hidden=false;
//    _timePickerView.hidden=true;
//    
//    [self showTextViewBackgroundView];
//    [self.view bringSubviewToFront:_typePickerView];
    
    [self showTextViewBackgroundView];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    
    if (_workOutTypeView==nil) {
        _workOutTypeView = [mainStoryboard instantiateViewControllerWithIdentifier:@"WorkTypeViewController"];
    }
    
    _workOutTypeView.workoutTypeLabel=_workoutTypeLabel;
    _workOutTypeView.workoutDetailTextview=_workoutInstruction;
    _workOutTypeView.view.frame= CGRectMake(0, 0, 320, 568);
    _workOutTypeView.view.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_workOutTypeView.view respectToSuperFrame:nil];
    [self.view addSubview:_workOutTypeView.view];
 

    
}

- (IBAction)TimeButtonClick:(id)sender {
//    _typePickerView.hidden=true;
//    _timePickerView.hidden=false;
//    
//    [self showTextViewBackgroundView];
//    [self.view bringSubviewToFront:_timePickerView];
    
    
        _typePickerView.hidden=false;
        _timePickerView.hidden=true;
    
        [self showTextViewBackgroundView];
        [self.view bringSubviewToFront:_typePickerView];
}



- (IBAction)doneButtonClick:(id)sender {
    UIButton *b= (UIButton *) sender;
    if (b.tag==1) {
        
//        NSDate *pickerDate = [_datePicker date];
//        NSDateFormatter *format = [[NSDateFormatter alloc] init];
//        format.dateFormat = @"HH : mm";
//        _workoutTimeLabel.text =  [format stringFromDate:pickerDate];
//        _workoutTimeLabel.textColor= [UIColor blackColor];
    }else if (b.tag==2)
    {
        [self calculateTimeFromPicker];
    }
    
    _typePickerView.hidden=true;
    _timePickerView.hidden=true;
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
        if ([_workoutTypeLabel.text isEqualToString:@""]) {
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                              message : @"Please write a workout." delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
        }else
        {
            if ([_workoutInstruction.text isEqualToString:@""]) {
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                                  message : @"Please fill out your workout Details." delegate : nil cancelButtonTitle : @"OK"
                                                        otherButtonTitles : nil ];
                [alert show ];
            }else
            {
                
                NSArray *photoArray;
                NSArray *videoArray;
                NSDictionary *photos_attributes;
                NSDictionary *video_attributes;
                NSDictionary *feed;
                
                NSMutableDictionary *workout_attributes= [[NSMutableDictionary alloc] initWithObjectsAndKeys: _workoutTypeLabel.text, @"title", nil];
                if (![_workoutTypeLabel.text isEqualToString:@"Workout"]) {
                    int index=-1;
                    for (int i=0; i<[_workoutTypeArray count]; i++) {
                        Workout *temworkout=[_workoutTypeArray objectAtIndex:i];
                        
                        if ([_workoutTypeLabel.text isEqualToString:temworkout.workout_type]) {
                            index=i;
                        }
                    }
                    
                    if (index!=-1) {
                          Workout *temworkout=[_workoutTypeArray objectAtIndex:index];
                         [workout_attributes setObject:temworkout.workout_id forKey:@"workout_type_id"];
                    }
                  
                }
                
                if (![_workoutTimeLabel.text isEqualToString:@"Time"]) {
                    NSArray *ary = [_workoutTimeLabel.text componentsSeparatedByString:@" : "];
                    NSString *hour= [ary objectAtIndex:0];
                    NSString *minute= [ary objectAtIndex:1];
                    NSString *second= [ary objectAtIndex:2];
                    NSNumber *time=[NSNumber numberWithInt:hour.intValue*3600+ minute.intValue*60+second.intValue];
                    [workout_attributes setObject:time.stringValue forKey:@"time"];
                }
                
                if (![videoUrl isEqualToString:@""]) {
                    video_attributes= [[NSDictionary alloc] initWithObjectsAndKeys:@"Fitmoo",@"title",videoUrl, @"video_url",@"alternate", @"rel",@"Fitmoo Channel", @"description", nil];
                    videoArray=[[NSArray alloc] initWithObjects:video_attributes, nil];
                    photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: nil];
                    
                    feed= [[NSDictionary alloc] initWithObjectsAndKeys: _workoutInstruction.text, @"text",_workoutTypeLabel.text, @"workout_title",photos_attributes, @"photos_attributes",videoArray, @"videos_attributes",workout_attributes,@"workout_attributes", nil];
                    
                    
                }
                else if ([imageUrl isEqualToString:@""]) {
                    photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys: nil];
                    feed= [[NSDictionary alloc] initWithObjectsAndKeys: _workoutInstruction.text, @"text",_workoutTypeLabel.text, @"workout_title",photos_attributes, @"photos_attributes",workout_attributes,@"workout_attributes", nil];
                    
                }else
                {
                    
                    photos_attributes= [[NSDictionary alloc] initWithObjectsAndKeys:@"320",@"height",@"320", @"width",imageUrl, @"photo_url", nil];
                    photoArray = [[NSArray alloc] initWithObjects:photos_attributes, nil];
                    feed= [[NSDictionary alloc] initWithObjectsAndKeys: _workoutInstruction.text, @"text",_workoutTypeLabel.text, @"workout_title",photoArray, @"photos_attributes",workout_attributes,@"workout_attributes", nil];
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
        if ([_workoutTypeLabel.text isEqualToString:@""]) {
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                              message : @"Please fill out a Workout." delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
            return false;
        }else
        {
            if ([_workoutInstruction.text isEqualToString:@""]) {
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                                  message : @"Please fill out your workout Details." delegate : nil cancelButtonTitle : @"OK"
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
    [self showTextViewBackgroundView];
    _timePickerView.hidden=true;
    _typePickerView.hidden=true;
    
}

- (void)showTextViewBackgroundView
{
    if (_textViewBackgroundView==nil) {
        _textViewBackgroundView= [[TestView1 alloc] initWithFrame:CGRectMake(0, -50*[[FitmooHelper sharedInstance] frameRadio], self.view.frame.size.width, self.view.frame.size.height+100)];
        _textViewBackgroundView.backgroundColor=[UIColor blackColor];
        _textViewBackgroundView.alpha=0.7;
        [self.view addSubview:_textViewBackgroundView];
    }
    
    
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
    
 
    [_workoutInstruction resignFirstResponder];
    [_normalPostText resignFirstResponder];
    [_nutritionTitle resignFirstResponder];
    [_nutritionIngedients resignFirstResponder];
    [_nutritionPreparation resignFirstResponder];
    [_textViewBackgroundView removeFromSuperview];
    _textViewBackgroundView=nil;
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        _normalPostView.frame=CGRectMake(0, 55*[[FitmooHelper sharedInstance] frameRadio], _normalPostView.frame.size.width, _normalPostView.frame.size.height);
        _workoutView.frame=CGRectMake(0, 55*[[FitmooHelper sharedInstance] frameRadio], _workoutView.frame.size.width, _workoutView.frame.size.height);
        _nutritionView.frame=CGRectMake(0, 55*[[FitmooHelper sharedInstance] frameRadio], _nutritionView.frame.size.width, _nutritionView.frame.size.height);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showOKButton" object:@"no"];
        
    }completion:^(BOOL finished){}];
    
    [self moveDownTableView];
    _tableview.userInteractionEnabled=YES;
    _timePickerView.hidden=true;
    _typePickerView.hidden=true;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self hideTextViewBackgroundView];
}

@end
