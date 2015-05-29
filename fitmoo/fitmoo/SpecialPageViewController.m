//
//  SpecialPageViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/12/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SpecialPageViewController.h"
#import "AFNetworking.h"
@interface SpecialPageViewController ()
{
    NSNumber * contentHight;
    
}
@end

@implementation SpecialPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    [self createObservers];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initFrames
{
    _tableView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableView respectToSuperFrame:self.view];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    _backButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_backButton respectToSuperFrame:self.view];
  //  _topview.frame=CGRectMake(0, 0, 320, 73);
    _topview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topview respectToSuperFrame:self.view];
}

-(void)createObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didPostFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPostFinished:) name:@"didPostFinished" object:nil];
}


- (void) didPostFinished: (NSNotification * ) note
{

    _homeFeed= (HomeFeed *)[note object];
    
    [self.tableView reloadData];
    
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareTableViewCell *cell =(ShareTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShareTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    HomeFeed * tempHomefeed=_homeFeed;
    cell.homeFeed=_homeFeed;
    
    //case for headerview
    if ([tempHomefeed.feed_action.action isEqualToString:@"post"]) {
        cell.heanderImage1.hidden=true;
        [cell reDefineHearderViewsFrame];
    }else
    {
        cell.heanderImage1.hidden=false;
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.heanderImage1.frame.size.width, cell.heanderImage1.frame.size.height)];
        view.layer.cornerRadius=view.frame.size.width/2;
        view.clipsToBounds=YES;
        view.userInteractionEnabled = NO;
        view.exclusiveTouch = NO;
        AsyncImageView *headerImage1 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, cell.heanderImage1.frame.size.width, cell.heanderImage1.frame.size.height)];
        
        
        headerImage1.userInteractionEnabled = NO;
        headerImage1.exclusiveTouch = NO;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage1];
        if ([tempHomefeed.feed_action.community_id isEqual:[NSNull null]])
        {
            headerImage1.imageURL =[NSURL URLWithString:tempHomefeed.feed_action.created_by.thumb];
            [cell.heanderImage1 setTag:tempHomefeed.feed_action.user_id.intValue];
        }else
        {
            headerImage1.imageURL =[NSURL URLWithString:tempHomefeed.feed_action.created_by_community.cover_photo_url];
            [cell.heanderImage1 setTag:tempHomefeed.feed_action.community_id.intValue];
        }
        [cell.heanderImage1.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [view addSubview:headerImage1];
        [cell.heanderImage1 addSubview:view];
        
        [cell.heanderImage1 addTarget:self action:@selector(headerImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.headerImage2.frame.size.width, cell.headerImage2.frame.size.height)];
    view.clipsToBounds=YES;
    view.layer.cornerRadius=view.frame.size.width/2;
    view.userInteractionEnabled = NO;
    view.exclusiveTouch = NO;
    AsyncImageView *headerImage2 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, cell.headerImage2.frame.size.width, cell.headerImage2.frame.size.height)];
    headerImage2.userInteractionEnabled = NO;
    headerImage2.exclusiveTouch = NO;
    headerImage2.layer.cornerRadius=headerImage2.frame.size.width/2;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
    if ([tempHomefeed.community_id isEqual:[NSNull null]])
    {
        headerImage2.imageURL =[NSURL URLWithString:tempHomefeed.created_by.thumb];
        [cell.headerImage2 setTag:tempHomefeed.feed_action.user_id.intValue];
    }else
    {
        headerImage2.imageURL =[NSURL URLWithString:tempHomefeed.created_by_community.cover_photo_url];
        [cell.headerImage2 setTag:tempHomefeed.feed_action.community_id.intValue];
    }
    [cell.headerImage2.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [view addSubview:headerImage2];
    [cell.headerImage2 addSubview:view];
    [cell.headerImage2 addTarget:self action:@selector(headerImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.titleLabel.text= tempHomefeed.title_info.avatar_title;
    [cell setTitleLabelForHeader];
    
    cell.dayLabel.frame= CGRectMake(cell.dayLabel.frame.origin.x, cell.titleLabel.frame.size.height+cell.titleLabel.frame.origin.y+3, cell.dayLabel.frame.size.width, cell.dayLabel.frame.size.height);
    NSRange range= NSMakeRange(0, tempHomefeed.created_at.length-3);
    NSString * timestring= [tempHomefeed.created_at substringWithRange:range];
    NSTimeInterval time=(NSTimeInterval ) timestring.intValue;
    NSDate *dayBegin= [[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSDate *today= [NSDate date];
    cell.dayLabel.text= [[FitmooHelper sharedInstance] daysBetweenDate:dayBegin andDate:today];
    
    //case for photo and video exits, bodyview
    if ([tempHomefeed.photoArray count]!=0||[tempHomefeed.videosArray count]!=0) {
        if ([tempHomefeed.type isEqualToString:@"event"])
        {
            cell.scrollbelowFrame= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
        }
        
        if ([tempHomefeed.photoArray count]!=0&&[tempHomefeed.videosArray count]==0) {
            double maxHeightIndex=0;
            double radioBetweenWandH=0;
            for (int i=0; i<[tempHomefeed.photoArray count]; i++) {
                [tempHomefeed resetPhotos];
                tempHomefeed.photos= [tempHomefeed.photoArray objectAtIndex:i];
                double width= tempHomefeed.photos.stylesUrlWidth.doubleValue;
                double height= tempHomefeed.photos.stylesUrlHeight.doubleValue;
                if (width>height) {
                    if (radioBetweenWandH<(height/width)) {
                        radioBetweenWandH=height/width;
                        maxHeightIndex=i;
                    }
                }else
                {
                    radioBetweenWandH=1;
                    maxHeightIndex=i;
                }
            }
            [tempHomefeed resetPhotos];
            tempHomefeed.photos=[tempHomefeed.photoArray objectAtIndex:maxHeightIndex];
            if (radioBetweenWandH<1) {
                double width= 320;
                double height= tempHomefeed.photos.stylesUrlHeight.doubleValue*(320/tempHomefeed.photos.stylesUrlWidth.doubleValue);
                
                cell.scrollbelowFrame= [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
            }
            
        }
        
        [cell addScrollView];
        if (![tempHomefeed.type isEqualToString:@"event"])
        {
            [cell setBodyShadowFrameForImagePost];
        }
        //special case for youtube
        if ([tempHomefeed.videosArray count]!=0) {
            NSString * url= tempHomefeed.videos.video_url;
            if ([url rangeOfString:@"youtube.com"].location != NSNotFound){
                NSRange range= [url rangeOfString:@"v="];
                double ran=range.length+range.location;
                NSRange range1=NSMakeRange(ran, url.length-ran);
                NSString *video_id= [url substringWithRange:range1];
                NSString *videoString=[NSString stringWithFormat:@"%@%@%@", @"http://www.youtube.com/embed/", video_id, @"?showinfo=0&fs=0&rel=0"];
                self.videoURL =[NSURL URLWithString:videoString];
                cell.scrollbelowFrame.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:cell.scrollbelowFrame respectToSuperFrame:nil];
                UIWebView *  videoView = [[UIWebView alloc] initWithFrame:cell.scrollbelowFrame.frame];
                [cell.bodyView addSubview:videoView];
                NSURLRequest *request= [[NSURLRequest alloc] initWithURL:self.videoURL];
                [videoView loadRequest:request];
                
                [cell.bodyView bringSubviewToFront:cell.bodyShadowView];
            }
        }
        
        
        
    }else
    {
        [cell removeViewsFromBodyView:cell.scrollbelowFrame];
    }
    
    if ([tempHomefeed.type isEqualToString:@"regular"]) {
        [cell setBodyFrameForRegular];
    }else if ([tempHomefeed.type isEqualToString:@"workout"])
    {
        [cell setBodyFrameForWorkout];
    }else if ([tempHomefeed.type isEqualToString:@"nutrition"])
    {
        [cell setBodyFrameForNutrition];
    }else if ([tempHomefeed.type isEqualToString:@"product"])
    {
        [cell setBodyFrameForProduct];
    }
    else if ([tempHomefeed.type isEqualToString:@"event"])
    {
        [cell setBodyFrameForEvent];
    }
    
    [cell rebuiltBodyViewFrame];
    
    
    
    
    //built comment view
    if ([tempHomefeed.commentsArray count]!=0) {
        [cell.commentView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        NSString *totalCommment= [NSString stringWithFormat:@" %@",tempHomefeed.total_comment ];
        [cell.bodyCommentButton setTitle:totalCommment  forState:UIControlStateNormal];
        for (int i=0; i<[tempHomefeed.commentsArray count]; i++) {
            cell.homeFeed.comments=[tempHomefeed.commentsArray objectAtIndex:i];
            [cell addCommentView:cell.commentView Atindex:i];
        }
        [cell rebuiltCommentViewFrame];
    }else
    {
        [cell removeCommentView];
    }
    
    
    //built bottom view
    [cell.likeButton setTag:indexPath.row*100+4];
    [cell.commentButton setTag:indexPath.row*100+5];
    [cell.shareButton setTag:indexPath.row*100+6];
    [cell.optionButton setTag:indexPath.row*100+7];
    [cell.bodyImage setTag:indexPath.row*100+8];
    NSString *totalLike= [NSString stringWithFormat:@" %@",tempHomefeed.total_like];
    [cell.bodyLikeButton setTitle:totalLike forState:UIControlStateNormal];
    if ([tempHomefeed.is_liked isEqualToString:@"1"]) {
        [cell.likeButton setImage:[UIImage imageNamed:@"redheart.png"] forState:UIControlStateNormal];
    }else
    {
        [cell.likeButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        [cell.likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell.commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.optionButton addTarget:self action:@selector(optionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.bodyImage addTarget:self action:@selector(bodyImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    contentHight=[NSNumber numberWithInteger: cell.buttomView.frame.origin.y + cell.buttomView.frame.size.height] ;
 

    
    return cell;
}






- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return contentHight.intValue;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
    //    _postText= textView.text;
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)postButtonClick:(id)sender {
    
    if ([_action isEqualToString:@"Post"]) {
        
         [[UserManager sharedUserManager] performComment:_textView.text withId:_homeFeed.feed_id];
        
    }else if ([_action isEqualToString:@"Share"])
    {
         [[UserManager sharedUserManager] performShare:_textView.text withId:_homeFeed.feed_id];

    }
    
   
    
}

//-(void)createObservers{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"postFinished" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postFinished:) name:@"postFinished" object:nil];
//}


//- (void) postFinished: (NSNotification * ) note
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"didPostFinished" object:nil];
//    
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -buttomButton functions
- (IBAction)commentButtonClick:(id)sender {

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentViewController *commentPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    commentPage.homeFeed= _homeFeed;
 
    [self.navigationController pushViewController:commentPage animated:YES];
    
}
- (IBAction)likeButtonClick:(id)sender {

    UIButton *button = (UIButton *)sender;
    if ([_homeFeed.is_liked isEqualToString:@"0"]) {
        NSNumber *totalLike=[NSNumber numberWithInt:1+_homeFeed.total_like.intValue];

        [button setImage:[UIImage imageNamed:@"redheart.png"] forState:UIControlStateNormal];
        [[UserManager sharedUserManager] performLike:_homeFeed.feed_id];
        _homeFeed.is_liked=@"1";
        _homeFeed.total_like=totalLike.stringValue;
        
        
        [self.tableView reloadData];
        
    }
    
    
}
- (IBAction)optionButtonClick:(id)sender {

    HomeFeed *feed= _homeFeed;
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActionSheetViewController *ActionSheet = [mainStoryboard instantiateViewControllerWithIdentifier:@"ActionSheetViewController"];
    
    if ([feed.action_sheet isEqualToString:@"endorse"]) {
        ActionSheet.action= @"endorse";
        
    }else if ([feed.action_sheet isEqualToString:@"report"]) {
        ActionSheet.action= @"report";
        
    }else if ([feed.action_sheet isEqualToString:@"delete"]) {
        ActionSheet.action= @"delete";
        [ActionSheet.reportButton setTitle:@"Delete" forState:UIControlStateNormal];
        
    }
    ActionSheet.postId= feed.feed_id;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openPopup" object:ActionSheet];
    
}

- (IBAction)bodyImageButtonClick:(id)sender{

    NSString * url= _homeFeed.videos.video_url;
    
    if ([url rangeOfString:@"vimeo.com"].location != NSNotFound) {
        
        
        [YTVimeoExtractor fetchVideoURLFromURL:url quality:YTVimeoVideoQualityMedium referer:@"http://www.fitmoo.com"  completionHandler:^(NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality) {
            if (error) {
                NSLog(@"Error : %@", [error localizedDescription]);
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Could not play"
                                                                  message : @"This video cannot play at this moment." delegate : nil cancelButtonTitle : @"OK"
                                                        otherButtonTitles : nil ];
                [alert show ];
                
            } else if (videoURL) {
                NSLog(@"Extracted url : %@", [videoURL absoluteString]);
                
                _playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
                [self.playerView.moviePlayer prepareToPlay];
                [self presentViewController:self.playerView animated:YES completion:^(void) {
                    self.playerView = nil;
                }];
            }
        }];
        
        
    } else
    {
        self.videoURL= [NSURL URLWithString:url];
        MPMoviePlayerViewController*  movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:self.videoURL];
        [self presentMoviePlayerViewControllerAnimated:movieController];
        [movieController.moviePlayer play];
    }
    
    
    
}



- (IBAction)shareButtonClick:(id)sender {

    HomeFeed *tempFeed= _homeFeed;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActionSheetViewController *ActionSheet = [mainStoryboard instantiateViewControllerWithIdentifier:@"ActionSheetViewController"];
    ActionSheet.action= @"share";
    ActionSheet.postId= tempFeed.feed_id;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openPopup" object:ActionSheet];
    
    //    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    SpecialPageViewController *specialPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SpecialPageViewController"];
    //    specialPage.action=@"Share";
    //    specialPage.homeFeed= [_homeFeedArray objectAtIndex:index];
    //
    //    [self.navigationController presentViewController:specialPage animated:YES completion:nil];
    
}


- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
