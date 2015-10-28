//
//  SpecialPageViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/12/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SpecialPageViewController.h"
#import "AFNetworking.h"
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import "FSImageViewerViewController.h"
#import "CommentViewController.h"
#import "ActionSheetViewController.h"
#import <SwipeBack/SwipeBack.h>
@interface SpecialPageViewController ()
{
    NSNumber * contentHight;
      float playerVolume;
     bool bodyLikeAnimation;
    UIView *indicatorView;
}
@end

@implementation SpecialPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    [self createObservers];
     self.navigationController.swipeBackEnabled = YES;
    

    // Do any additional setup after loading the view.
}


- (void) defineShowAttendButton
{
    if ([_homeFeed.event.is_joined isEqualToString:@"1"]) {
        if ([_homeFeed.event.price isEqualToString:@"0"]||[_homeFeed.event.bought_by_current_user isEqualToString:@"1"]||[_homeFeed.event.sold_out isEqualToString:@"over"]||[_homeFeed.event.sold_out isEqualToString:@"sold out"]) {

            _BuyNowButton.hidden=true;
        }else
        {
            [_BuyNowButton setTitle:@"BUY TICKET" forState:UIControlStateNormal];
        }
        
    }
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
    
    _BuyNowButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_BuyNowButton respectToSuperFrame:self.view];
    
    if (self.view.frame.size.height<500) {
        
        _tableView.frame= CGRectMake(_tableView.frame.origin.x,_tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height-88);
        _BuyNowButton.frame= CGRectMake(_BuyNowButton.frame.origin.x, _BuyNowButton.frame.origin.y-88, _BuyNowButton.frame.size.width, _BuyNowButton.frame.size.height);
    }
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
    if ([tempHomefeed.feed_action.action isEqualToString:@"post"]||tempHomefeed.feed_action.action==nil) {
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
        if ([tempHomefeed.feed_action.action isEqualToString:@"share"]) {
            if (!(tempHomefeed.feed_action.community_id==nil||[tempHomefeed.feed_action.community_id isEqual:[NSNull null]])) {
                [cell.heanderImage1 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                [cell.heanderImage1 addTarget:self action:@selector(CommunityHeaderImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        
        
        
        
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
        [cell.headerImage2 setTag:tempHomefeed.created_by.created_by_id.intValue];
        [cell.titleLabel setTag:tempHomefeed.created_by.created_by_id.intValue];
        
    }else
    {
        headerImage2.imageURL =[NSURL URLWithString:tempHomefeed.created_by_community.cover_photo_url];
        [cell.headerImage2 setTag:tempHomefeed.created_by_community.created_by_community_id.intValue];
        [cell.titleLabel setTag:tempHomefeed.created_by_community.created_by_community_id.intValue];
    }
    [cell.headerImage2.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [view addSubview:headerImage2];
    [cell.headerImage2 addSubview:view];
    
    if ([tempHomefeed.community_id isEqual:[NSNull null]]) {
        
        [cell.headerImage2 addTarget:self action:@selector(headerImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [cell.headerImage2 addTarget:self action:@selector(CommunityHeaderImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.titleLabel.text= tempHomefeed.title_info.avatar_title;
    [cell setTitleLabelForHeader];
    
    cell.dayLabel.frame= CGRectMake(cell.dayLabel.frame.origin.x, cell.titleLabel.frame.size.height+cell.titleLabel.frame.origin.y+3, cell.dayLabel.frame.size.width, cell.dayLabel.frame.size.height);
    NSRange range= NSMakeRange(0, tempHomefeed.created_at.length-3);
    NSString * timestring= [tempHomefeed.created_at substringWithRange:range];
    NSTimeInterval time=(NSTimeInterval ) timestring.intValue;
    NSDate *dayBegin= [[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSDate *today= [NSDate date];
    cell.dayLabel.text= [[FitmooHelper sharedInstance] daysBetweenDate:dayBegin andDate:today];
    
    [cell rebuiltHeaderViewFrame];
    
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
            }else if ([url rangeOfString:@"vimeo"].location != NSNotFound)
            {
//                [cell.bodyImage setTag:indexPath.row*100+8];
//                [self playMovie:cell.bodyImage];
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
        [cell.ShadowBuyNowButton setTag:tempHomefeed.feed_id.integerValue];
        [cell.ShadowBuyNowButton addTarget:self action:@selector(BuyNowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([tempHomefeed.type isEqualToString:@"event"])
    {
        cell.showEventDetail=_isEventDetail;
        [cell setBodyFrameForEvent];
        [cell.ShadowBuyNowButton setTag:tempHomefeed.feed_id.integerValue];
        [cell.ShadowBuyNowButton addTarget:self action:@selector(BuyNowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.titleLabel.text=_homeFeed.event.name.uppercaseString;
        self.BuyNowButton.hidden=false;
        UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bodyImageTagClick:)];
        tapGestureRecognizer1.numberOfTapsRequired = 1;
        [cell.bodyTitle addGestureRecognizer:tapGestureRecognizer1];
        cell.bodyTitle.userInteractionEnabled=YES;
        
    }
    
    [cell rebuiltBodyViewFrame];
    
    
    
    
    //built comment view
    if ([tempHomefeed.commentsArray count]!=0) {
        [cell.commentView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
         NSString *totalCommment= [NSString stringWithFormat:@" %@",[[FitmooHelper sharedInstance] getTextForNumber:tempHomefeed.total_comment]];
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
    [cell.viewAllCommentButton setTag:indexPath.row*100+5];
    [cell.bodyCommentButton setTag:indexPath.row*100+5];
    [cell.shareButton setTag:indexPath.row*100+6];
    [cell.optionButton setTag:indexPath.row*100+7];
    [cell.bodyImage setTag:indexPath.row*100+8];
    [cell.bodyLikeButton setTag:indexPath.row*100+4];
    [cell.bodyTitle setTag:indexPath.row*100+8];
    NSString *totalLike= [NSString stringWithFormat:@" %@",[[FitmooHelper sharedInstance] getTextForNumber:tempHomefeed.total_like]];
    [cell.bodyLikeButton setTitle:totalLike forState:UIControlStateNormal];
    if ([tempHomefeed.is_liked isEqualToString:@"1"]) {
        [cell.likeButton setImage:[UIImage imageNamed:@"blueheart.png"] forState:UIControlStateNormal];
        [cell.bodyLikeButton setImage:[UIImage imageNamed:@"blueheart100.png"] forState:UIControlStateNormal];
        [cell.likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (bodyLikeAnimation==true) {
            [[FitmooHelper sharedInstance] likeButtonAnimation:cell.bodyLikeButton];
            bodyLikeAnimation=false;
        }
    }else
    {
        [cell.likeButton setImage:[UIImage imageNamed:@"hearticon.png"] forState:UIControlStateNormal];
        [cell.likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell.bodyLikeButton addTarget:self action:@selector(bodyLikeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.bodyCommentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.viewAllCommentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.optionButton addTarget:self action:@selector(optionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
  //  [cell.bodyImage addTarget:self action:@selector(bodyImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapGestureRecognizer10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bodyImageTagClick:)];
    tapGestureRecognizer10.numberOfTapsRequired = 1;
    UITapGestureRecognizer *tapGestureRecognizer11 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTagClick:)];
    tapGestureRecognizer11.numberOfTapsRequired = 2;
    [tapGestureRecognizer10 requireGestureRecognizerToFail:tapGestureRecognizer11];
    
    [cell.bodyImage addGestureRecognizer:tapGestureRecognizer10];
    [cell.bodyImage addGestureRecognizer:tapGestureRecognizer11];
    cell.bodyImage.userInteractionEnabled=YES;
    
    
    contentHight=[NSNumber numberWithInteger: cell.buttomView.frame.origin.y + cell.buttomView.frame.size.height+60] ;
 

    [self defineShowAttendButton];
    return cell;
}



- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    NSString *link;
//    if ([_homeFeed.type isEqualToString:@"product"]) {
//        if (_homeFeed.feed_action.feed_action_id!=nil) {
//            link= [NSString stringWithFormat:@"%@%@%@%@%@%@",@"https://fitmoo.com/profile/",_homeFeed.feed_action.user_id,@"/feed/",_homeFeed.feed_id,@"/fa/",_homeFeed.feed_action.feed_action_id];
//        }
//        
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"shopAction" object:link];
//    }
    

    
   
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
- (IBAction)CommunityHeaderImageButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *buttontag=[NSString stringWithFormat:@"%ld",((long)button.tag)];
    NSString *key=[NSString stringWithFormat:@"%@%ld",@"com",((long)button.tag)];
    if (![buttontag isEqualToString:_searchCommunityId]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
    }else
    {
           [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)bodyLikeButtonClick:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    ComposeViewController *composePage = [mainStoryboard instantiateViewControllerWithIdentifier:@"ComposeViewController"];
    composePage.searchId= _homeFeed.feed_id;
    composePage.searchType=@"like";
    [self.navigationController pushViewController:composePage animated:YES];
    
    
}

- (IBAction)likeButtonClick:(id)sender {

    UIButton *button = (UIButton *)sender;
    if ([_homeFeed.is_liked isEqualToString:@"0"]) {
        NSNumber *totalLike=[NSNumber numberWithInt:1+_homeFeed.total_like.intValue];

        [button setImage:[UIImage imageNamed:@"blueheart.png"] forState:UIControlStateNormal];
        [[UserManager sharedUserManager] performLike:_homeFeed.feed_id];
        _homeFeed.is_liked=@"1";
        _homeFeed.total_like=totalLike.stringValue;
        
        
        [self.tableView reloadData];
        
    }else if ([_homeFeed.is_liked isEqualToString:@"1"]&&button.tag%100!=8)
    {
        NSNumber *totalLike=[NSNumber numberWithInt:_homeFeed.total_like.intValue-1];
        [button setImage:[UIImage imageNamed:@"hearticon.png"] forState:UIControlStateNormal];
        [[UserManager sharedUserManager] performUnLike:_homeFeed.feed_id];
        _homeFeed.is_liked=@"0";
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
        NSString *link;
        if (feed.feed_action.feed_action_id!=nil) {
            link= [NSString stringWithFormat:@"%@%@%@%@%@%@",@"https://fitmoo.com/profile/",feed.feed_action.user_id,@"/feed/",feed.feed_id,@"/fa/",feed.feed_action.feed_action_id];
        }
        ActionSheet.shoplink= link;
    }else if ([feed.action_sheet isEqualToString:@"report"]) {
        ActionSheet.action= @"report";
        
    }else if ([feed.action_sheet isEqualToString:@"delete"]) {
        ActionSheet.action= @"delete";
        [ActionSheet.reportButton setTitle:@"Delete" forState:UIControlStateNormal];
        
    }
    ActionSheet.postId= feed.feed_id;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openPopup" object:ActionSheet];
    
}

- (void)playMovie:(UIButton *)button
{
  
    NSString * url= _homeFeed.videos.video_url;
    
    [self playMovieWithUrl:button withUrl:url];
}

- (void)slientVoice:(NSString *)url
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:nil];
    NSArray *audioTracks = [asset tracksWithMediaType:AVMediaTypeAudio];
    
    // Mute all the audio tracks
    NSMutableArray *allAudioParams = [NSMutableArray array];
    for (AVAssetTrack *track in audioTracks) {
        AVMutableAudioMixInputParameters *audioInputParams =[AVMutableAudioMixInputParameters audioMixInputParameters];
        if (playerVolume==0.0) {
            playerVolume=0.5;
        }else
        {
            playerVolume=0.0;
        }
        
        [audioInputParams setVolume:playerVolume atTime:kCMTimeZero];
        [audioInputParams setTrackID:[track trackID]];
        [allAudioParams addObject:audioInputParams];
    }
    AVMutableAudioMix *audioZeroMix = [AVMutableAudioMix audioMix];
    [audioZeroMix setInputParameters:allAudioParams];
    
    if ([url rangeOfString:@"vimeo"].location != NSNotFound)
    {
        [[_moviePlayer currentItem] setAudioMix:audioZeroMix];
    }
    
    
    
}



- (void)playMovieWithUrl:(UIButton *)button withUrl:(NSString *) url
{
    
    if ([url rangeOfString:@"vimeo"].location != NSNotFound) {
        [YTVimeoExtractor fetchVideoURLFromURL:url quality:YTVimeoVideoQualityMedium referer:@"http://www.fitmoo.com"  completionHandler:^(NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality) {
            if (error) {
                NSLog(@"Error : %@", [error localizedDescription]);
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                                  message : @"This video cannot be played right now." delegate : nil cancelButtonTitle : @"OK"
                                                        otherButtonTitles : nil ];
                [alert show ];
                
            } else if (videoURL) {
                NSLog(@"Extracted url : %@", [videoURL absoluteString]);
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                
                dispatch_async(queue, ^{
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
                        NSArray *audioTracks = [asset tracksWithMediaType:AVMediaTypeAudio];
                        
                        // Mute all the audio tracks
                        NSMutableArray *allAudioParams = [NSMutableArray array];
                        for (AVAssetTrack *track in audioTracks) {
                            AVMutableAudioMixInputParameters *audioInputParams =[AVMutableAudioMixInputParameters audioMixInputParameters];
                            [audioInputParams setVolume:0.0 atTime:kCMTimeZero];
                            [audioInputParams setTrackID:[track trackID]];
                            [allAudioParams addObject:audioInputParams];
                        }
                        AVMutableAudioMix *audioZeroMix = [AVMutableAudioMix audioMix];
                        [audioZeroMix setInputParameters:allAudioParams];
                        
                        // Create a player item
                        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
                        [playerItem setAudioMix:audioZeroMix]; // Mute the player item
                        
                        // Create an AVPlayer
                        _moviePlayer = [AVPlayer playerWithPlayerItem: playerItem];
                        AVPlayerLayer* playerLayer = [AVPlayerLayer playerLayerWithPlayer:_moviePlayer];
                        playerLayer.frame = button.bounds;
                        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
                        playerLayer.needsDisplayOnBoundsChange = YES;
                        [button.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
                        [button setBackgroundColor:[UIColor blackColor]];
                        [button.layer addSublayer:playerLayer];
                        button.layer.needsDisplayOnBoundsChange = YES;
                        
                        [_moviePlayer play];
                        
                        playerVolume=0.0;
                        _moviePlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
                        
                        [[NSNotificationCenter defaultCenter] addObserver:self
                                                                 selector:@selector(playerItemDidReachEnd:)
                                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                                   object:[_moviePlayer currentItem]];
                        
                        
                        
                    });
                });
                
            }
        }];
        
    }
}


- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}
- (IBAction)bodyImageButtonClick:(id)sender{

    if ([_homeFeed.type isEqualToString:@"event"]&&_isEventDetail!=true) {
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SpecialPageViewController *specialPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SpecialPageViewController"];
        
        specialPage.homeFeed=_homeFeed;
        
        User *tempUser= [[UserManager sharedUserManager] localUser];
        specialPage.searchId=tempUser.user_id;
        specialPage.isEventDetail=true;
        
        [self.navigationController pushViewController:specialPage animated:YES];
        
        
        return;
    }
    
    NSString * url= _homeFeed.videos.video_url;
    
    if(url==nil)
    {
        //    UIImage *image= (UIImage *)[note object];
        NSMutableArray *imageArray= [[NSMutableArray alloc] init];
        for (int i=0; i<[_homeFeed.photoArray count]; i++) {
        
            AsyncImageView *image = [_homeFeed.AsycImageViewArray objectAtIndex:i];
            FSBasicImage *firstPhoto = [[FSBasicImage alloc] initWithImage:image.image];
            
            
            [imageArray addObject:firstPhoto];
            
        }
        
        
        FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:imageArray];
        FSImageViewerViewController *imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource];
        imageViewController.backgroundColorVisible=[UIColor blackColor];
        imageViewController.sharingDisabled=true;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imageViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
        
    }else if ([url rangeOfString:@"vimeo.com"].location != NSNotFound) {
        
        
        [YTVimeoExtractor fetchVideoURLFromURL:url quality:YTVimeoVideoQualityMedium referer:@"http://www.fitmoo.com"  completionHandler:^(NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality) {
            if (error) {
                NSLog(@"Error : %@", [error localizedDescription]);
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                                  message : @"This video cannot be played right now." delegate : nil cancelButtonTitle : @"OK"
                                                        otherButtonTitles : nil ];
                [alert show ];
                
            } else if (videoURL) {
                NSLog(@"Extracted url : %@", [videoURL absoluteString]);
              //     [self slientVoice:[videoURL absoluteString]];
                _playerView = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
                [self.playerView.moviePlayer prepareToPlay];
                [self presentViewController:self.playerView animated:YES completion:^(void) {
                    self.playerView = nil;
                }];
            }
        }];
        
        
    } else
    {
        
         if (![_homeFeed.type isEqualToString:@"event"])
        {
        self.videoURL= [NSURL URLWithString:url];
        MPMoviePlayerViewController*  movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:self.videoURL];
        [self presentMoviePlayerViewControllerAnimated:movieController];
        [movieController.moviePlayer play];
        }
    }
    
    
    
}

- (IBAction)headerImageButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *key=[NSString stringWithFormat:@"%ld", (long)button.tag];
  //  User *tempUser= [[UserManager sharedUserManager] localUser];
    
    if ([key isEqualToString:_searchId]) {
      //  [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"6"];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        key=[NSString stringWithFormat:@"%ld", ((long)button.tag+100)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
    }

}

- (IBAction)bodyImageTagClick:(id)sender {
    float tag=[(UIGestureRecognizer *)sender view].tag;
    UIButton *b= [[UIButton alloc] init];
    b.tag=tag;
    [self bodyImageButtonClick:b];
}

- (IBAction)likeTagClick:(id)sender {
    UIButton *myButton = (UIButton *)[(UIGestureRecognizer *)sender view];
    [self likeButtonClick:myButton];
    bodyLikeAnimation=true;
}


- (void) attendEvent
{
    indicatorView=[[FitmooHelper sharedInstance] addActivityIndicatorView:indicatorView and:self.view text:@"Processing..."];
    User *localUser=[[UserManager sharedUserManager] localUser];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *jsonDict;
 
    jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",_homeFeed.event.event_instance_id,@"event_instance_id",nil];
    
    
    NSString *url= [NSString stringWithFormat:@"%@%@%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/feeds/",_homeFeed.feed_id,@"/join_event" ];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSDictionary *dic= responseObject;
        NSNumber *newTotal_attendees=[dic objectForKey:@"total_attendees"];
        _homeFeed.event.total_attendees=[newTotal_attendees stringValue];
        
        NSNumber *is_joined=[dic objectForKey:@"is_joined"];
        _homeFeed.event.is_joined=[is_joined stringValue];
     
        [self.tableView reloadData];
        if (![_homeFeed.event.price isEqualToString:@"0"]) {
            [_BuyNowButton setTitle:@"BUY TICKET" forState:UIControlStateNormal];
        }else
        {
            _BuyNowButton.hidden=true;
        }
         [indicatorView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"didPostFinished" object:_homeFeed];
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
               [indicatorView removeFromSuperview];
              NSLog(@"Error: %@", error);} // failure callback block
     ];

}
- (void) openShopCartPage
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    ShopCartViewController *ShopCartPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"ShopCartViewController"];
    
    
    [self.navigationController pushViewController:ShopCartPage animated:YES];
}
- (void) buyEvent
{
    
    indicatorView=[[FitmooHelper sharedInstance] addActivityIndicatorView:indicatorView and:self.view text:@"Processing..."];
    User *localUser=[[UserManager sharedUserManager] localUser];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *jsonDict;
    
    jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"1",@"quantity",@"Event",@"type",_homeFeed.event.event_instance_id,@"event_instance_id",nil];
    
    
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/cart/add" ];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        [self openShopCartPage];
        [indicatorView removeFromSuperview];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTopImage" object:[[UserManager sharedUserManager] localUser]];
        
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
          failure:^(AFHTTPRequestOperation *operation, NSError *error){
              NSLog(@"Error: %@", error);
              [indicatorView removeFromSuperview];
          } // failure callback block
     ];

}

- (IBAction)BuyNowButtonClick:(id)sender {

    UIButton *b= (UIButton *)sender;
    if([_homeFeed.type isEqualToString:@"event"])
    {
     
        if ([b.titleLabel.text isEqualToString:@"ATTEND"]) {
            [self attendEvent];
        }else
        {
            if (![_homeFeed.event.price isEqualToString:@"0"]) {
                 [self buyEvent];
            }else
            {
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                SpecialPageViewController *specialPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SpecialPageViewController"];
                
                specialPage.homeFeed=_homeFeed;
                
                User *tempUser= [[UserManager sharedUserManager] localUser];
                specialPage.searchId=tempUser.user_id;
                specialPage.isEventDetail=true;
                
                [self.navigationController pushViewController:specialPage animated:YES];

            }
           
        }
        
            

    }else
    {
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    ShopDetailViewController *shopDetail = [mainStoryboard instantiateViewControllerWithIdentifier:@"ShopDetailViewController"];
    shopDetail.homeFeed=_homeFeed;
    [self.navigationController pushViewController:shopDetail animated:YES];
    }
    
    
}
- (IBAction)shareButtonClick:(id)sender {

      User *localUser= [[UserManager sharedUserManager] localUser];
 //      if (![localUser.user_id isEqualToString:_searchId]) {
    HomeFeed *tempFeed= _homeFeed;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActionSheetViewController *ActionSheet = [mainStoryboard instantiateViewControllerWithIdentifier:@"ActionSheetViewController"];
    ActionSheet.action= @"share";
           
           if (_searchId==nil) {
               ActionSheet.hideRepost=true;
           }
           
           if ([tempFeed.AsycImageViewArray count]!=0) {
               AsyncImageView *image = [tempFeed.AsycImageViewArray objectAtIndex:0];
               ActionSheet.shareImage= image.image;
           }
    
            if ([localUser.user_id isEqualToString:_searchId]) {
                ActionSheet.hideRepost=true;
            }
    
           if ([tempFeed.videosArray count]!=0) {
               NSString * url= tempFeed.videos.video_url;
               if ([url rangeOfString:@"vimeo.com"].location == NSNotFound)
               {
                   ActionSheet.hideInstegram= true;
               }

           }
           if ([tempFeed.type isEqualToString:@"regular"]) {
               ActionSheet.ShareTitle=tempFeed.text;
           }else if ([tempFeed.type isEqualToString:@"workout"])
           {
               ActionSheet.ShareTitle=tempFeed.workout_title;
           }else if ([tempFeed.type isEqualToString:@"nutrition"])
           {
               ActionSheet.ShareTitle=tempFeed.nutrition.title;
           }else if ([tempFeed.type isEqualToString:@"product"])
           {
               ActionSheet.ShareTitle=tempFeed.product.title;
           }
    
           ActionSheet.postType=tempFeed.type;
           ActionSheet.postId= tempFeed.feed_id;
           
           
           if (![tempFeed.feed_action.community_id isEqual:[NSNull null]]) {
               ActionSheet.communityId= tempFeed.feed_action.community_id;
               ActionSheet.profileId=tempFeed.feed_action.community_id;
           }else
           {
               ActionSheet.profileId= tempFeed.created_by.created_by_id;
               
           }
           if (tempFeed.feed_action!=nil||![tempFeed.feed_action isEqual:[NSNull null]]) {
               ActionSheet.feedActionId= tempFeed.feed_action.feed_action_id;
           }
           
           
           
           
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openPopup" object:ActionSheet];
       
// }
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
