//
//  PeoplePageViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/14/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "PeoplePageViewController.h"
#import "AFNetworking.h"
#import "FSBasicImage.h"
#import "FSBasicImageSource.h"
#import "FSImageViewerViewController.h"
@interface PeoplePageViewController ()
{
    NSNumber * contentHight;
    NSString *bioText;
    UIButton *tempButton1;
}
@end

@implementation PeoplePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    contentHight=[NSNumber numberWithInteger:500];
    _heighArray= [[NSMutableArray alloc] initWithObjects:contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight, nil];
     self.tableView.tableFooterView = [[UIView alloc] init];
 
    self.tableType=@"photo";
    [self initFrames];
    [self initValuable];
    [self postNotifications];
    [self createObservers];
    if (_searchId!=nil) {
        [self getUserProfile:_searchId];
    }else
    {
        User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
        [self getUserProfile:localUser.user_id];
  //  [self getHomePageItems];
    }

    
}



-(void)createObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didPostFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPostFinished:) name:@"didPostFinished" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didGetProfileFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetProfileFinished:) name:@"didGetProfileFinished" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"updateTable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable:) name:@"updateTable" object:nil];
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


- (void) getUserProfile: (NSString *) profile_id;
{
    [[UserManager sharedUserManager] getUserProfileForOtherPeople:profile_id];
}

- (void) didGetProfileFinished: (NSNotification * ) note
{
    _temSearchUser= (User *) [note object];
    if (_temSearchUser.current_user_can_view_profile.intValue==1) {
        [self getHomePageItems];
         [_tableView reloadData];
    }else
    {
        [_tableView reloadData];
    }
    
}

- (void) didPostFinished: (NSNotification * ) note
{
 //   [self initValuable];
 //   [self getHomePageItems];
    
    HomeFeed *feed= (HomeFeed *)[note object];
    
    if (feed!=nil) {
        for (int i=0; i<[_homeFeedArray count]; i++) {
            HomeFeed *tempFeed= [_homeFeedArray objectAtIndex:i];
            if (feed.feed_id==tempFeed.feed_id) {
                [_homeFeedArray replaceObjectAtIndex:i withObject:feed];
            }
        }
        [self.tableView reloadData];
    }else
    {
        [self initValuable];
        [self getHomePageItems];
    }

}

-(void) initValuable
{
    _offset=0;
    _limit=9;
    _count=1;
    

}



-(void) getHomePageItems
{
   // _tableView.userInteractionEnabled=false;
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *lim= [NSString stringWithFormat:@"%i", _limit];
    NSString *ofs= [NSString stringWithFormat:@"%i", _offset];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", @"true", @"mobile",@"true", @"ios_app",
                              ofs, @"offset", lim , @"limit",nil];
    NSString * url;
    if (_searchId!=nil) {
        url= [NSString stringWithFormat: @"%@%@%@", [[UserManager sharedUserManager] homeFeedUrl],_searchId,@"/feeds.json"];
    }else
    {
        url= [NSString stringWithFormat: @"%@%@%@", [[UserManager sharedUserManager] homeFeedUrl],localUser.user_id,@"/feeds.json"];
    }
    
    [manager GET:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        
        NSInteger count=0;
        if (_homeFeedArray!=nil ) {
            count=[_homeFeedArray count];
        }
        [self defineFeedObjects];
  
        if ([_responseDic count]>0&& count!=[_homeFeedArray count]) {
            [self.tableView reloadData];
        }
        
        
    //    NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             _tableView.userInteractionEnabled=true;
             NSLog(@"Error: %@", error);} // failure callback block
     ];
}



- (void) defineFeedObjects
{
    if (_offset==0) {
        _homeFeedArray= [[NSMutableArray alloc]init];
    }
    for (NSDictionary *dic in _responseDic) {
        
        HomeFeed *feed= [[FitmooHelper sharedInstance] generateHomeFeed:dic];
        bool samefeed=false;
        for (int i=0; i<[_homeFeedArray count]; i++) {
            HomeFeed *tempfeed= [_homeFeedArray objectAtIndex:i];
            if ([feed.feed_id isEqual:tempfeed.feed_id]) {
                samefeed=true;
            }
        }
        if (samefeed==false) {
            if (!([feed.type isEqualToString:@"event"]||[feed.type isEqualToString:@"service"]||[feed.type isEqualToString:@"membership"])) {
                [_homeFeedArray addObject:feed];
            }
         
        }
        
        
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
    _topView.frame= CGRectMake(0, 0, 320, 60);
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _leftButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftButton respectToSuperFrame:self.view];
    _rightButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_rightButton respectToSuperFrame:self.view];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    
    
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    NSNumber *height;
    if (indexPath.row<[_heighArray count]) {
        height= (NSNumber *)[_heighArray objectAtIndex:indexPath.row];
        
    }else
    {
        height=[NSNumber numberWithInt:600];
    }
  //  NSLog(@"%ld",(long)height.integerValue);
    return height.integerValue;
 //   }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if ([self.tableType isEqualToString:@"photo"]) {
        
        int count=(int)[_homeFeedArray count]/3;
        if ([_homeFeedArray count]%3!=0) {
            count=count+1;
        }
        
        return count+1;
        
        
        
    }else{
    return ([_homeFeedArray count]+1);
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
        PeopleTitleCell *cell=(PeopleTitleCell *) [self.tableView cellForRowAtIndexPath:indexPath];
        
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PeopleTitleCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        User *temUser;
        
        if (_temSearchUser !=nil&&_searchId !=nil) {
            temUser=_temSearchUser;
          
            if (temUser.is_following.intValue==1) {
                [cell.editProfileButton setBackgroundImage:[UIImage imageNamed:@"following_btn.png"] forState:UIControlStateNormal];
                [cell.editProfileButton setTag:11];
                
            }else if(temUser.is_following.intValue==0)
            {
                [cell.editProfileButton setBackgroundImage:[UIImage imageNamed:@"follow_btn.png"] forState:UIControlStateNormal];
                  [cell.editProfileButton setTag:12];
            }
            
            
        }else
        {
        temUser= [[UserManager sharedUserManager] localUser];
        }
        cell.nameLabel.text= temUser.name.uppercaseString;
        self.titleLabel.text= temUser.name.uppercaseString;
        NSString * imageUrl= @"https://fitmoo.com/assets/cover/profile-cover.png";
        if (![temUser.cover_photo_url isEqual:[NSNull null ]]) {
            imageUrl=temUser.cover_photo_url;
        }
       
         if ([self.tableType isEqualToString:@"photo"]) {
             [cell.scheduleButton setImage:[UIImage imageNamed:@"selectedsquares.png"] forState:UIControlStateNormal];
             [cell.feedButton setImage:[UIImage imageNamed:@"deselectedbars.png"] forState:UIControlStateNormal];
         }else
         {
             [cell.scheduleButton setImage:[UIImage imageNamed:@"deselectedsquares.png"] forState:UIControlStateNormal];
             [cell.feedButton setImage:[UIImage imageNamed:@"selectedbars.png"] forState:UIControlStateNormal];
         }
     
        cell.followCountLabel.text= temUser.following;
        cell.followerCountLabel.text=temUser.followers;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followLabelClick:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [cell.followCountLabel addGestureRecognizer:tapGestureRecognizer];
        cell.followCountLabel.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followerLabelClick:)];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [cell.followerCountLabel addGestureRecognizer:tapGestureRecognizer1];
        cell.followerCountLabel.userInteractionEnabled=YES;
        
        
        
        if (temUser.following.intValue>999) {
            CGFloat following=temUser.following.floatValue/1000.0f;
            
            cell.followCountLabel.text= [NSString stringWithFormat:@"%0.01f%@",following,@"K"];
        }
        
        if (temUser.followers.intValue>999) {
            CGFloat follower= temUser.followers.floatValue/1000.0f;
            cell.followerCountLabel.text= [NSString stringWithFormat:@"%0.01f%@",follower,@"K"];
        }
        
        cell.communityCountLabel.text=temUser.communities;
        bioText=temUser.bio;
        
   //     [cell loadHeaderImage:imageUrl];
        [cell loadHeader1Image:temUser.profile_avatar_original];
  
        UIFont *font = [UIFont fontWithName:@"BentonSans-Book" size:cell.bioLabel.font.pointSize];
        NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:temUser.bio attributes:@{NSFontAttributeName: font}  ];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:6];
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:style
                                 range:NSMakeRange(0, temUser.bio.length)];
        cell.bioLabel.text=temUser.bio;
        cell.bioLabel.frame=[[FitmooHelper sharedInstance] caculateLabelHeight:cell.bioLabel];
        if (cell.bioLabel.frame.size.height>(70*[[FitmooHelper sharedInstance] frameRadio])) {
            cell.bioLabel.frame=CGRectMake(cell.bioLabel.frame.origin.x, cell.bioLabel.frame.origin.y, cell.bioLabel.frame.size.width, 70*[[FitmooHelper sharedInstance] frameRadio]);
       
        }
        
        [cell.bioLabel setAttributedText:attributedString];
        cell.bioLabel.userInteractionEnabled = NO;
        cell.bioLabel.exclusiveTouch = NO;
        [cell.bioButton.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        cell.bioButton.frame=CGRectMake(cell.bioButton.frame.origin.x, cell.bioButton.frame.origin.y, cell.bioLabel.frame.size.width, cell.bioLabel.frame.size.height);
        [cell.bioButton addSubview:cell.bioLabel];
        
        
        [cell.editProfileButton addTarget:self action:@selector(editProfileButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.bioButton addTarget:self action:@selector(BioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.feedButton addTarget:self action:@selector(FeedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.scheduleButton addTarget:self action:@selector(PhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([temUser.bio isEqualToString:@""]) {
            cell.buttomView.frame=CGRectMake(cell.buttomView.frame.origin.x, cell.buttomView.frame.origin.y, cell.buttomView.frame.size.width, cell.buttonView.frame.size.height+cell.buttonView.frame.origin.y);
            [cell.bioButton removeFromSuperview];
            contentHight=[NSNumber numberWithInteger:cell.buttomView.frame.origin.y + cell.buttomView.frame.size.height] ;
        }else
        {
            cell.buttomView.frame=CGRectMake(cell.buttomView.frame.origin.x, cell.buttomView.frame.origin.y, cell.buttomView.frame.size.width, cell.bioButton.frame.size.height+cell.bioButton.frame.origin.y+15);
        contentHight=[NSNumber numberWithInteger:cell.buttomView.frame.origin.y + cell.buttomView.frame.size.height] ;
        }
        
        
      
        
        [_heighArray replaceObjectAtIndex:0 withObject:contentHight];
        return cell;
    }
    
    //  end of first cell
    
    if ([self.tableType isEqualToString:@"photo"]) {
        
        PhotoCell *cell =(PhotoCell *) [self.tableView cellForRowAtIndexPath:indexPath];

        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PhotoCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }else
        {
            return cell;
        }
        int current=(int) (indexPath.row-1)*3;
        if (current<[_homeFeedArray count]) {
             HomeFeed *temfeed=[_homeFeedArray objectAtIndex:current];
             cell.homeFeed1= temfeed;
            cell.view1Button.tag=temfeed.feed_id.integerValue;
            [cell.view1Button addTarget:self action:@selector(photoImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell setView1Item];
        }else
        {
            cell.view1.hidden=true;
        }
       
        if (current+1<[_homeFeedArray count]) {
             HomeFeed *temfeed=[_homeFeedArray objectAtIndex:current+1];
             cell.homeFeed2= temfeed;
             cell.view2Button.tag=temfeed.feed_id.integerValue;
             [cell.view2Button addTarget:self action:@selector(photoImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
             [cell setView2Item];
        }else
        {
            cell.view2.hidden=true;
        }
        
        if (current+2<[_homeFeedArray count]) {
            HomeFeed *temfeed=[_homeFeedArray objectAtIndex:current+2];
            cell.homeFeed3= temfeed;
             cell.view3Button.tag=temfeed.feed_id.integerValue;
             [cell.view3Button addTarget:self action:@selector(photoImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell setView3Item];
        }else
        {
            cell.view3.hidden=true;
        }
        
        contentHight=[NSNumber numberWithDouble:105*[[FitmooHelper sharedInstance] frameRadio]+1] ;
        int count=(int)[_homeFeedArray count]/3;
        if ([_homeFeedArray count]%3!=0) {
            count=count+1;
        }
        if(indexPath.row==count)
        {
            contentHight=[NSNumber numberWithInteger:contentHight.intValue+60];
        }
        
        if (indexPath.row>=[_heighArray count]) {
            [_heighArray addObject:contentHight];
        }else
        {
            [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
        }

        
        return cell;
        
    } //  end of photo type table
    else
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
    
    HomeFeed * tempHomefeed= [_homeFeedArray objectAtIndex:indexPath.row-1];
    cell.homeFeed=tempHomefeed;
    
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
            [cell.headerImage2 setTag:tempHomefeed.created_by.created_by_id.intValue];
        }else
        {
            headerImage2.imageURL =[NSURL URLWithString:tempHomefeed.created_by_community.cover_photo_url];
            [cell.headerImage2 setTag:tempHomefeed.created_by_community.created_by_community_id.intValue];
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
            [cell.likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }else
        {
            [cell.likeButton setImage:[UIImage imageNamed:@"hearticon.png"] forState:UIControlStateNormal];
            [cell.likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        [cell.bodyLikeButton addTarget:self action:@selector(bodyLikeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.viewAllCommentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.bodyCommentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.optionButton addTarget:self action:@selector(optionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.bodyImage addTarget:self action:@selector(bodyImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    
    if(indexPath.row==[_homeFeedArray count])
    {
        contentHight=[NSNumber numberWithInteger: cell.buttomView.frame.origin.y + cell.buttomView.frame.size.height+105];
    }else
    {
    contentHight=[NSNumber numberWithInteger: cell.buttomView.frame.origin.y + cell.buttomView.frame.size.height+15];
    }
    
    if (indexPath.row>=[_heighArray count]) {
        [_heighArray addObject:contentHight];
    }else
    {
        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
    }
    //  NSLog(@"%ld",(long)contentHight.integerValue);
    return cell;
    }
    //  end of feed type table
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row!=0) {
        HomeFeed *feed=[_homeFeedArray objectAtIndex:indexPath.row-1];
        NSString *link;
        if ([feed.type isEqualToString:@"product"]) {
            if (feed.feed_action.feed_action_id!=nil) {
                link= [NSString stringWithFormat:@"%@%@%@%@%@%@",@"https://fitmoo.com/profile/",feed.feed_action.user_id,@"/feed/",feed.feed_id,@"/fa/",feed.feed_action.feed_action_id];
            }
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"shopAction" object:link];
        }
    }
    


    
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    NSNumber *height;
    if (indexPath.row<[_heighArray count]) {
        height= (NSNumber *)[_heighArray objectAtIndex:indexPath.row];
        
    }else
    {
        height=[NSNumber numberWithInt:contentHight.intValue];
    }
  //  NSLog(@"%ld",(long)height.integerValue);
    return height.integerValue;

}


- (void)scrollViewDidScroll: (UIScrollView*)scroll {
    
    
    if(self.tableView.contentOffset.y<-75){
    //     NSLog(@"%f",self.tableView.contentOffset.y );
        if (_count==0) {
            [self initValuable];
            
            [self getHomePageItems];
        }
        _count++;
        
        //it means table view is pulled down like refresh
        return;
    }
    else if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) {

        if (_count==0) {
            if (self.tableView.contentOffset.y<0) {
                  _offset =0;
            }else
            {
            _offset +=9;
            }
            [self getHomePageItems];
        }
        _count++;
        
        
        }else
        {
        _count=0;
        }
}


- (IBAction)commentButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag/100-1;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentViewController *commentPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    commentPage.homeFeed= [_homeFeedArray objectAtIndex:index];
    //  [self.navigationController presentViewController:commentPage animated:YES completion:nil];
    
    [self.navigationController pushViewController:commentPage animated:YES];
    
}

- (IBAction)bodyLikeButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag/100-1;
    HomeFeed *feed=[_homeFeedArray objectAtIndex:index];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    ComposeViewController *composePage = [mainStoryboard instantiateViewControllerWithIdentifier:@"ComposeViewController"];
    composePage.searchId= feed.feed_id;
    composePage.searchType=@"like";
    [self.navigationController pushViewController:composePage animated:YES];
    
    
}
- (IBAction)likeButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag/100-1;

    
    HomeFeed *feed=[_homeFeedArray objectAtIndex:index];
    
    if ([feed.is_liked isEqualToString:@"0"]) {
        NSNumber *totalLike=[NSNumber numberWithInt:1+feed.total_like.intValue];
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
        
    }else if ([feed.is_liked isEqualToString:@"1"])
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
    NSInteger index=(NSInteger) button.tag/100-1;
    HomeFeed *feed= [_homeFeedArray objectAtIndex:index];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActionSheetViewController *ActionSheet = [mainStoryboard instantiateViewControllerWithIdentifier:@"ActionSheetViewController"];
    
    if ([feed.action_sheet isEqualToString:@"endorse"]) {
        ActionSheet.action= @"endorse";
       
    }else if ([feed.action_sheet isEqualToString:@"report"]) {
        ActionSheet.action= @"report";
      
    }else if ([feed.action_sheet isEqualToString:@"delete"]) {
        ActionSheet.action= @"delete";
     
    }
    ActionSheet.postId= feed.feed_id;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openPopup" object:ActionSheet];
}
- (IBAction)shareButtonClick:(id)sender {
    if (_searchId!=nil) {
        UIButton *button = (UIButton *)sender;
        NSInteger index=(NSInteger) button.tag/100-1;
        
        HomeFeed *tempFeed= [_homeFeedArray objectAtIndex:index];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ActionSheetViewController *ActionSheet = [mainStoryboard instantiateViewControllerWithIdentifier:@"ActionSheetViewController"];
        ActionSheet.action= @"share";
        ActionSheet.postType=tempFeed.type;
        ActionSheet.postId= tempFeed.feed_id;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openPopup" object:ActionSheet];
    }
  
    
}
- (IBAction)bodyImageButtonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag/100-1;
    
    
    HomeFeed *homefeed=[_homeFeedArray objectAtIndex:index];
    NSString * url= homefeed.videos.video_url;
    
    if(url==nil)
    {
        //    UIImage *image= (UIImage *)[note object];
        NSMutableArray *imageArray= [[NSMutableArray alloc] init];
        for (int i=0; i<[homefeed.photoArray count]; i++) {
            [homefeed resetPhotos];
            homefeed.photos= [homefeed.photoArray objectAtIndex:i];
            //     NSURL *imageUrl= [NSURL URLWithString:homefeed.photos.originalUrl];
            AsyncImageView *image = [homefeed.AsycImageViewArray objectAtIndex:i];
            //   image.imageURL=imageUrl;
            FSBasicImage *firstPhoto = [[FSBasicImage alloc] initWithImage:image.image];
            
            
            [imageArray addObject:firstPhoto];
            
        }
        
        
        FSBasicImageSource *photoSource = [[FSBasicImageSource alloc] initWithImages:imageArray];
        FSImageViewerViewController *imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:photoSource];
        imageViewController.backgroundColorVisible=[UIColor blackColor];
        
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

- (IBAction)followLabelClick:(id)sender {
    NSString *searchPeopleId;
    
    if (_searchId!=nil) {
        searchPeopleId=_searchId;
    }else
    {
        User *tempUser= [[UserManager sharedUserManager] localUser];
        searchPeopleId=tempUser.user_id;
    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    ComposeViewController *composePage = [mainStoryboard instantiateViewControllerWithIdentifier:@"ComposeViewController"];
    composePage.searchId= searchPeopleId;
    composePage.searchType=@"following";
    [self.navigationController pushViewController:composePage animated:YES];
    
}

- (IBAction)followerLabelClick:(id)sender {
    NSString *searchPeopleId;
    if (_searchId!=nil) {
        searchPeopleId=_searchId;
    }else
    {
        User *tempUser= [[UserManager sharedUserManager] localUser];
        searchPeopleId=tempUser.user_id;
    }
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    ComposeViewController *composePage = [mainStoryboard instantiateViewControllerWithIdentifier:@"ComposeViewController"];
    composePage.searchId= searchPeopleId;
    composePage.searchType=@"follower";
    [self.navigationController pushViewController:composePage animated:YES];

    
}

- (IBAction)FeedButtonClick:(id)sender {
    self.tableType=@"feed";
    [self.tableView reloadData];
}
- (IBAction)PhotoButtonClick:(id)sender {
   self.tableType=@"photo";
    [self.tableView reloadData];
    
}
- (IBAction)backButtonClick:(id)sender {

  //  [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"6.1"];
}

- (IBAction)photoImageButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger feed_id=(NSInteger) button.tag;
    HomeFeed *tempFeed= [[HomeFeed alloc] init];
    for (int i=0; i<[_homeFeedArray count]; i++) {
        HomeFeed *temp=[_homeFeedArray objectAtIndex:i];
        if (feed_id==temp.feed_id.integerValue) {
            tempFeed=temp;
        }
    }
    
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SpecialPageViewController *specialPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SpecialPageViewController"];
   
        specialPage.homeFeed=tempFeed;
        if(_searchId!=nil)
        {
            specialPage.searchId=_searchId;
        }
        [self.navigationController pushViewController:specialPage animated:YES];
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 1)
    {
        [[UserManager sharedUserManager] performUnFollow:_searchId];
        [tempButton1 setBackgroundImage:[UIImage imageNamed:@"follow_btn.png"] forState:UIControlStateNormal];
        _temSearchUser.is_following=@"0";
        tempButton1.tag=12;
    }
    
    
}

- (IBAction)editProfileButtonClick:(id)sender {
      tempButton1 = (UIButton *)sender;
    

    if (tempButton1.tag==11) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unfollow"
                                                       message:@"Are you sure you want to Unfollow this person?"
                                                      delegate:self
                                             cancelButtonTitle:@"No"
                                             otherButtonTitles:@"Yes",nil];
        [alert show];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"HasSeenPopup"];
       
    }else if (tempButton1.tag==12) //follow
    {
        [[UserManager sharedUserManager] performFollow:_searchId];
        [tempButton1 setBackgroundImage:[UIImage imageNamed:@"following_btn.png"] forState: UIControlStateNormal];
         _temSearchUser.is_following=@"1";
        
        
        tempButton1.tag=11;
    }else
    {

     [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"4"];
    }
    
}
- (IBAction)headerImageButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *key=[NSString stringWithFormat:@"%ld", (long)button.tag];
    User *tempUser= [[UserManager sharedUserManager] localUser];
    
    if ([key isEqualToString:tempUser.user_id]|| [key isEqualToString:_searchId]) {
      
    }else
    {
        key=[NSString stringWithFormat:@"%ld", (long)button.tag+100];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
    }

}

- (IBAction)BioButtonClick:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BioViewController *bioPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"BioViewController"];
    bioPage.bioText=bioText;
    [self.navigationController pushViewController:bioPage animated:YES];

}

@end
