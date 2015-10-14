//
//  HomePageViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "HomePageViewController.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import "FSImageViewerViewController.h"
#import <SwipeBack/SwipeBack.h>


@interface HomePageViewController ()
{
    
}
@end

@implementation HomePageViewController
{
    NSNumber * contentHight;
    bool pullDown;
    UIView *indicatorView;
    NSInteger bodyLikeAnimation;
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    contentHight=[NSNumber numberWithInteger:300];
    _heighArray= [[NSMutableArray alloc] initWithObjects:contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight, nil];
    bodyLikeAnimation=-1;
    [self initFrames];
    [self initValuable];
    [self postNotifications];
    [self getHomePageItems];
    [self createObservers];
    indicatorView=[[FitmooHelper sharedInstance] addActivityIndicatorView:indicatorView and:self.view];
    [self addtopBarView];
    
 
}

- (void) addtopBarView
{

    
    UIView *v= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    v.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:v respectToSuperFrame:self.view];
    v.backgroundColor= [UIColor whiteColor];
    [self.view addSubview:v];
}



- (void) viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
     self.navigationController.swipeBackEnabled = NO;
    
}

- (void) viewWillDisappear:(BOOL)animated
{
  //  self.navigationController.swipeBackEnabled = YES;
    [super viewWillDisappear:animated];
    
    
}

-(void)createObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didPostFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPostFinished:) name:@"didPostFinished" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateTable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable:) name:@"updateTable" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarTappedAction:)
                                                 name:@"statusBarTappedNotification"
                                               object:nil];
    
}

- (void) statusBarTappedAction: (NSNotification * ) note
{
    if ([self numberOfSectionsInTableView:self.tableView] > 0)
    {
    NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
    [self.tableView scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}


- (void) updateTable: (NSNotification * ) note
{
    
    NSString *key= (NSString *)[note object];
    
    
    for (int i=0; i<[_homeFeedArray count]; i++) {
        HomeFeed *tempFeed= [_homeFeedArray objectAtIndex:i];
        if (key==tempFeed.feed_id) {
            [_homeFeedArray removeObjectAtIndex:i];
        }
    }
    [self.tableView reloadData];
    
}

- (void) didPostFinished: (NSNotification * ) note
{
    //  [self initValuable];
    //  [self getHomePageItems];
    HomeFeed *feed= (HomeFeed *)[note object];
    
    if (feed!=nil) {
        for (int i=0; i<[_homeFeedArray count]; i++) {
            HomeFeed *tempFeed= [_homeFeedArray objectAtIndex:i];
            if (feed.feed_id==tempFeed.feed_id) {
                [_homeFeedArray replaceObjectAtIndex:i withObject:feed];
            }
        }
        [self.tableView reloadData];
        // [self.tableView setContentOffset:CGPointMake(0, -20) animated:YES];
        
    }else
    {
        [self initValuable];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        //   pullDown=true;
        [self getHomePageItems];
    }
    
}

-(void) initValuable
{
    _offset=0;
    _limit=10;
    _count=1;
    pullDown=false;
    //   _homeFeedArray= [[NSMutableArray alloc]init];
}
-(void) getHomePageItems
{
    
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *lim= [NSString stringWithFormat:@"%i", _limit];
    NSString *ofs= [NSString stringWithFormat:@"%i", _offset];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", @"true", @"mobile",
                              ofs, @"offset", lim , @"limit",@"true", @"ios_app",nil];
    
    NSString * url= [NSString stringWithFormat: @"%@%@%@", [[UserManager sharedUserManager] homeFeedUrl],localUser.user_id,@"/home_feeds.json"];
    
    
    
    [manager GET:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        [self defineFeedObjects];
        if ([_responseDic count]>0) {
            [self.tableView reloadData];
        }
        
        if (pullDown==true) {
            [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionTransitionNone animations:^{
                [_tableView setContentOffset:CGPointMake(0, -20) animated:YES];
                
            }completion:^(BOOL finished){}];
            pullDown=false;
        }
        [indicatorView removeFromSuperview];
        [_activityIndicator stopAnimating];
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             
             [_activityIndicator stopAnimating];
             NSLog(@"Error: %@", error);
         } // failure callback block
     
     ];
}

- (void) defineFeedObjects
{
    if (_offset==0) {
        _homeFeedArray= [[NSMutableArray alloc]init];
        //  _heighArray=[[NSMutableArray alloc]init];
        //  _heighArray= [[NSMutableArray alloc] initWithObjects:contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight, nil];
    }
    
    
    for (NSDictionary *dic in _responseDic) {
        
        @try {
            HomeFeed *feed= [[FitmooHelper sharedInstance] generateHomeFeed:dic];
            
            if (!([feed.type isEqualToString:@"service"]||[feed.type isEqualToString:@"membership"])) {
                [_homeFeedArray addObject:feed];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        

    }
    
    //remove this when event feed added
    if ([_homeFeedArray count]<4) {
        _offset +=10;
        [self getHomePageItems];
    }


}

- (void) postNotifications
{
    
    NSString * flag= @"YES";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnableSlideView" object:flag];
    
}

- (void) initFrames
{
    _tableView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableView respectToSuperFrame:self.view];
    _topView.frame= CGRectMake(0, 0, 320, 50);
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _leftButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftButton respectToSuperFrame:self.view];
    _rightButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_rightButton respectToSuperFrame:self.view];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    
    //   _tableView.estimatedRowHeight = 300.0;
    //   _tableView.rowHeight = UITableViewAutomaticDimension;
    
}


#pragma mark - UITableViewDelegate
//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//
//    return 18.0f;
//}
//
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//
//
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -28, tableView.frame.size.width, 18)];
//    /* Create custom view to display section header... */
//    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [[FitmooHelper sharedInstance] resizeFrameWithFrame:_activityIndicator respectToSuperFrame:nil];
//    _activityIndicator.alpha = 1.0;
//    _activityIndicator.center = CGPointMake(160*[[FitmooHelper sharedInstance] frameRadio], 0);
//    _activityIndicator.hidesWhenStopped = YES;
//    [view addSubview:_activityIndicator];
//
//
//
//    /* Section header is in 0th index... */
//
//    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
//    return view;
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    return [_homeFeedArray count];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ShareTableViewCell *cell =(ShareTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShareTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }else
    {
        return cell;
    }
    
    if (indexPath.row==0) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [[FitmooHelper sharedInstance] resizeFrameWithFrame:_activityIndicator respectToSuperFrame:nil];
        _activityIndicator.center = CGPointMake(160*[[FitmooHelper sharedInstance] frameRadio], -20);
        _activityIndicator.hidesWhenStopped = YES;
        [cell.contentView addSubview:_activityIndicator];
        cell.clipsToBounds=false;
    }
    
    
    HomeFeed * tempHomefeed= [_homeFeedArray objectAtIndex:indexPath.row];
    cell.homeFeed=tempHomefeed;
    
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
        if ([tempHomefeed.feed_action.action isEqualToString:@"share"]||[tempHomefeed.feed_action.action isEqualToString:@"endorse"]) {
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
        //special case for youtube and vimeo
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
        [cell setBodyFrameForEvent];
        [cell.ShadowBuyNowButton setTag:tempHomefeed.feed_id.integerValue];
        [cell.ShadowBuyNowButton addTarget:self action:@selector(BuyNowButtonClick:) forControlEvents:UIControlEventTouchUpInside];

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
    
   
  
    
    NSString *totalLike= [NSString stringWithFormat:@" %@",[[FitmooHelper sharedInstance] getTextForNumber:tempHomefeed.total_like]];
    [cell.bodyLikeButton setTitle:totalLike forState:UIControlStateNormal];
    if ([tempHomefeed.is_liked isEqualToString:@"1"]) {
        [cell.likeButton setImage:[UIImage imageNamed:@"blueheart.png"] forState:UIControlStateNormal];
        [cell.bodyLikeButton setImage:[UIImage imageNamed:@"blueheart100.png"] forState:UIControlStateNormal];
        [cell.likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (bodyLikeAnimation==indexPath.row) {
             [[FitmooHelper sharedInstance] likeButtonAnimation:cell.bodyLikeButton];
             bodyLikeAnimation=-1;
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
//    [cell.bodyImage addTarget:self action:@selector(bodyImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tapGestureRecognizer10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bodyImageTagClick:)];
    tapGestureRecognizer10.numberOfTapsRequired = 1;
  
 
    
    UITapGestureRecognizer *tapGestureRecognizer11 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(likeTagClick:)];
    tapGestureRecognizer11.numberOfTapsRequired = 2;
    
    [tapGestureRecognizer10 requireGestureRecognizerToFail:tapGestureRecognizer11];
    
    [cell.bodyImage addGestureRecognizer:tapGestureRecognizer10];
    [cell.bodyImage addGestureRecognizer:tapGestureRecognizer11];
    cell.bodyImage.userInteractionEnabled=YES;

   
    // cell.comment
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        
        [cell removeConstraints:cell.constraints];
        [cell.contentView removeConstraints:cell.contentView.constraints];
    }
    
    
    contentHight=[NSNumber numberWithInteger: cell.buttomView.frame.origin.y + cell.buttomView.frame.size.height+15] ;
    if (indexPath.row>=[_heighArray count]) {
        [_heighArray addObject:contentHight];
    }else
    {
        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
    }
    //  NSLog(@"%ld",(long)contentHight.integerValue);
    return cell;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    HomeFeed *feed=[_homeFeedArray objectAtIndex:indexPath.row];
//    
//    NSString *link;
//    if ([feed.type isEqualToString:@"product"]) {
//        if (feed.feed_action.feed_action_id!=nil) {
//            link= [NSString stringWithFormat:@"%@%@%@%@%@%@",@"https://fitmoo.com/profile/",feed.feed_action.user_id,@"/feed/",feed.feed_id,@"/fa/",feed.feed_action.feed_action_id];
//        }
//        
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"shopAction" object:link];
//    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
    {
        //    return UITableViewAutomaticDimension;
        return contentHight.intValue;
        // Load resources for iOS 7 or later
    }
    
    NSNumber *height;
    if (indexPath.row<[_heighArray count]) {
        height= (NSNumber *)[_heighArray objectAtIndex:indexPath.row];
        //    NSLog(@"%@%ld",@"estimatedHeight: ",(long)height.integerValue);
        return height.integerValue;
    }else
    {
        height=[NSNumber numberWithInt:300];
        //    NSLog(@"%@%d",@"estimatedHeight: ",0);
        return height.integerValue;
    }
    
    //  NSLog(@"%ld",(long)height.integerValue);
    return height.integerValue;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    
    NSNumber *height;
    if (indexPath.row<[_heighArray count]) {
        height= (NSNumber *)[_heighArray objectAtIndex:indexPath.row];
        
    }else
    {
        height=[NSNumber numberWithInt:contentHight.intValue];
    }
    //  NSLog(@"%@%ld",@"return cell Height: ",(long)height.integerValue);
    //  NSLog(@"%ld",(long)height.integerValue);
    return height.integerValue;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView.indexPathsForVisibleRows indexOfObject:indexPath] == NSNotFound)
    {
        HomeFeed *homefeed=[_homeFeedArray objectAtIndex:indexPath.row];
        NSString * url= homefeed.videos.video_url;
        if (url!=nil) {
            if ([url rangeOfString:@"vimeo"].location != NSNotFound)
            {
                [self.moviePlayer pause];
            }else
            {
                [self.moviePlayer1 pause];
            }
            
            
            
            
        }
      
      
    }
}




- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if (pullDown==true) {
        [_tableView setContentOffset:CGPointMake(0, -60) animated:YES];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if(self.tableView.contentOffset.y<-75){
        
        [_activityIndicator startAnimating];
        
        
        
        [self initValuable];
        pullDown=true;
        [self getHomePageItems];
        
        //it means table view is pulled down like refresh
        return;
    }
    
}

- (void)scrollViewDidScroll: (UIScrollView*)scroll {
    
    
    if(self.tableView.contentOffset.y<-75){
        if (_count==0) {
            //     [self initValuable];
            //      [self getHomePageItems];
            _activityIndicator.hidden=false;
        }
        _count++;
        //it means table view is pulled down like refresh
        return;
    }
    else if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height-1300)) {
        //   NSLog(@"bottom!");
        //   NSLog(@"%f",self.tableView.contentOffset.y );
        
        
        if (_count==0) {
            if (self.tableView.contentOffset.y<0) {
                _offset =0;
            }else
            {
                _offset +=10;
                
            }
            [self getHomePageItems];
            
        }
        _count++;
        
        
    }else
    {
        _count=0;
    }
    
   
    
}



// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    
    return sectionWidth;
}



#pragma mark -buttomButton functions
- (IBAction)commentButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag/100;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentViewController *commentPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    commentPage.homeFeed= [_homeFeedArray objectAtIndex:index];
    [self.navigationController pushViewController:commentPage animated:YES];
    
    
}

- (IBAction)CommunityHeaderImageButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *key=[NSString stringWithFormat:@"%@%ld",@"com",((long)button.tag)];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
    
    
}

- (IBAction)headerImageButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *key=[NSString stringWithFormat:@"%ld", (long)button.tag];
    User *tempUser= [[UserManager sharedUserManager] localUser];
    
    if ([key isEqualToString:tempUser.user_id]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"profile"];
    }else
    {
        key=[NSString stringWithFormat:@"%ld", ((long)button.tag+100)];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
    }
    
}

- (IBAction)BuyNowButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger feed_id=(NSInteger) button.tag;
    HomeFeed *tempFeed= [[HomeFeed alloc] init];
    for (int i=0; i<[_homeFeedArray count]; i++) {
        HomeFeed *temp=[_homeFeedArray objectAtIndex:i];
        if (feed_id==temp.feed_id.integerValue) {
            tempFeed=temp;
        }
    }

    if([tempFeed.type isEqualToString:@"event"])
    {
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SpecialPageViewController *specialPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SpecialPageViewController"];
        
        specialPage.homeFeed=tempFeed;
       
        User *tempUser= [[UserManager sharedUserManager] localUser];
        specialPage.searchId=tempUser.user_id;
        specialPage.isEventDetail=true;
        
        [self.navigationController pushViewController:specialPage animated:YES];
        
    }else   //product
    {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    ShopDetailViewController *shopDetail = [mainStoryboard instantiateViewControllerWithIdentifier:@"ShopDetailViewController"];
    shopDetail.homeFeed=tempFeed;
    [self.navigationController pushViewController:shopDetail animated:YES];
    
    }
}

- (IBAction)bodyLikeButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag/100;
    HomeFeed *feed=[_homeFeedArray objectAtIndex:index];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    ComposeViewController *composePage = [mainStoryboard instantiateViewControllerWithIdentifier:@"ComposeViewController"];
    composePage.searchId= feed.feed_id;
    composePage.searchType=@"like";
    [self.navigationController pushViewController:composePage animated:YES];
    
    
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
    
//  float tag=[(UIGestureRecognizer *)sender view].tag;
//    UIButton *b= [[UIButton alloc] init];
//    b.tag=tag;
//    [self likeButtonClick:b];
}

- (IBAction)likeButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag/100;
    HomeFeed *feed=[_homeFeedArray objectAtIndex:index];
    
    bodyLikeAnimation=index;
    if ([feed.is_liked isEqualToString:@"0"]) {
        NSNumber *totalLike=[NSNumber numberWithInt:1+feed.total_like.intValue];
        //  NSString *newLikeString= totalLike.stringValue;
        //  [button setTitle:newLikeString forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"blueheart.png"] forState:UIControlStateNormal];
        [[UserManager sharedUserManager] performLike:feed.feed_id];
        feed.is_liked=@"1";
        feed.total_like=totalLike.stringValue;
        
        for (int i=0; i<[_homeFeedArray count]; i++) {
            HomeFeed *tempFeed= [_homeFeedArray objectAtIndex:i];
            if (feed.feed_id==tempFeed.feed_id) {
                [_homeFeedArray replaceObjectAtIndex:i withObject:feed];
            }
        }
        [self.tableView reloadData];
        
    }else if ([feed.is_liked isEqualToString:@"1"]&&button.tag%100!=8)
    {
        NSNumber *totalLike=[NSNumber numberWithInt:feed.total_like.intValue-1];
        [button setImage:[UIImage imageNamed:@"hearticon.png"] forState:UIControlStateNormal];
        [[UserManager sharedUserManager] performUnLike:feed.feed_id];
        feed.is_liked=@"0";
        feed.total_like=totalLike.stringValue;
        
        for (int i=0; i<[_homeFeedArray count]; i++) {
            HomeFeed *tempFeed= [_homeFeedArray objectAtIndex:i];
            if (feed.feed_id==tempFeed.feed_id) {
                [_homeFeedArray replaceObjectAtIndex:i withObject:feed];
            }
        }
        [self.tableView reloadData];
        
    }
    
    
}







- (IBAction)optionButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag/100;
    HomeFeed *feed= [_homeFeedArray objectAtIndex:index];
    
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

- (IBAction)bodyImageButtonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag/100;
    
    HomeFeed *homefeed=[_homeFeedArray objectAtIndex:index];
    NSString * url= homefeed.videos.video_url;
    if(url==nil)
    {
        
        NSMutableArray *imageArray= [[NSMutableArray alloc] init];
        for (int i=0; i<[homefeed.photoArray count]; i++) {
            
            AsyncImageView *image = [homefeed.AsycImageViewArray objectAtIndex:i];
            FSBasicImage *firstPhoto = [[FSBasicImage alloc] initWithImage:image.image];
            
            
            [imageArray addObject:firstPhoto];
            
        }
        
        
        FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:imageArray];
        FSImageViewerViewController *imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource];
        imageViewController.backgroundColorVisible=[UIColor blackColor];
        imageViewController.sharingDisabled=true;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imageViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
        
    }else if ([url rangeOfString:@"vimeo"].location != NSNotFound) {
        
        
        [YTVimeoExtractor fetchVideoURLFromURL:url quality:YTVimeoVideoQualityMedium referer:@"http://www.fitmoo.com"  completionHandler:^(NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality) {
            if (error) {
                NSLog(@"Error : %@", [error localizedDescription]);
                UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Oops"
                                                                  message : @"This video cannot be played right now." delegate : nil cancelButtonTitle : @"OK"
                                                        otherButtonTitles : nil ];
                [alert show ];
                
            } else if (videoURL) {
                NSLog(@"Extracted url : %@", [videoURL absoluteString]);
         //       [self slientVoice:[videoURL absoluteString]];
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
    User *localUser= [[UserManager sharedUserManager] localUser];
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag/100;
    HomeFeed *tempFeed= [_homeFeedArray objectAtIndex:index];
    NSString *create_by_id=[NSString stringWithFormat:@"%@", tempFeed.created_by.created_by_id];
   
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ActionSheetViewController *ActionSheet = [mainStoryboard instantiateViewControllerWithIdentifier:@"ActionSheetViewController"];
        ActionSheet.action= @"share";
    
         if ([localUser.user_id isEqualToString:create_by_id]) {
              ActionSheet.hideRepost=true;
         }
    
        if ([tempFeed.AsycImageViewArray count]!=0) {
            AsyncImageView *image = [tempFeed.AsycImageViewArray objectAtIndex:0];
            ActionSheet.shareImage= image.image;
        }
        
        if ([tempFeed.videosArray count]!=0) {
            NSString * url= tempFeed.videos.video_url;
            if ([url rangeOfString:@"vimeo"].location == NSNotFound)
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
 
    

}

- (void)playMovie:(UIButton *)button
{
    NSInteger index=(NSInteger) button.tag/100;
    HomeFeed *homefeed=[_homeFeedArray objectAtIndex:index];
    NSString * url= homefeed.videos.video_url;
    
    [self playMovieWithUrl:button withUrl:url];
}


@end
