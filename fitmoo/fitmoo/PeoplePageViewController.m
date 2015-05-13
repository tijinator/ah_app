//
//  PeoplePageViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/14/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "PeoplePageViewController.h"

@interface PeoplePageViewController ()
{
    NSNumber * contentHight;
    NSString *bioText;
}
@end

@implementation PeoplePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    contentHight=[NSNumber numberWithInteger:400];
    _heighArray= [[NSMutableArray alloc] initWithObjects:contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight, nil];
     self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableType=@"photo";
    [self initFrames];
    [self initValuable];
    [self postNotifications];
    [self getHomePageItems];
 //   [self getGalary];
    [self createObservers];
}



-(void)createObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didPostFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPostFinished:) name:@"didPostFinished" object:nil];
}


- (void) didPostFinished: (NSNotification * ) note
{
 //   [self initValuable];
 //   [self getHomePageItems];
    
    HomeFeed *feed= (HomeFeed *)[note object];
    
    if (![feed isEqual:[NSNull null]]) {
        for (int i=0; i<[_homeFeedArray count]; i++) {
            HomeFeed *tempFeed= [_homeFeedArray objectAtIndex:i];
            if (feed.feed_id==tempFeed.feed_id) {
                [_homeFeedArray replaceObjectAtIndex:i withObject:feed];
            }
        }
        [self.tableView reloadData];
    }

}

-(void) initValuable
{
    _offset=0;
    _limit=10;
    _count=1;
    
//    _photoOffset=0;
//    _photoLimit=30;
//    _photoCount=1;
 //   _homeFeedArray= [[NSMutableArray alloc]init];
}


//-(void) getGalary
//{
//   
//    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    NSString *lim= [NSString stringWithFormat:@"%i", _photoLimit];
//    NSString *ofs= [NSString stringWithFormat:@"%i", _photoOffset];
//    
//    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", @"true", @"mobile",
//                              ofs, @"offset", lim , @"limit",nil];
//    NSString * url;
// 
//    url= [NSString stringWithFormat: @"%@%@%@", [[UserManager sharedUserManager] homeFeedUrl],localUser.user_id,@"/photos"];
//    
//    
//    [manager GET:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
//        
//        _responseDic= responseObject;
//        
//        [self definePhotoObjects];
//
//        
//      //  NSLog(@"Submit response data: %@", responseObject);
//    } // success callback block
//     
//         failure:^(AFHTTPRequestOperation *operation, NSError *error){
//             _tableView.userInteractionEnabled=true;
//             NSLog(@"Error: %@", error);} // failure callback block
//     ];
//}


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
        
        
 
        [self defineFeedObjects];
  
        if ([_responseDic count]>0) {
            [self.tableView reloadData];
        }
        
        
        NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             _tableView.userInteractionEnabled=true;
             NSLog(@"Error: %@", error);} // failure callback block
     ];
}


//- (void) definePhotoObjects
//{
//    if (_photoOffset==0) {
//        _homePhotoArray= [[NSMutableArray alloc]init];
//    }
//    
//    NSDictionary *result= [_responseDic objectForKey:@"results"];
//    for (NSDictionary *dic in result) {
//        PhotoGalary *photo= [[PhotoGalary alloc] init];
//        NSNumber *photo_id= [dic objectForKey:@"id"];
//        photo.photo_id= photo_id.stringValue;
//        NSNumber *imageable_id= [dic objectForKey:@"imageable_id"];
//        photo.imageable_id= imageable_id.stringValue;
//        photo.imageable_type= [dic objectForKey:@"imageable_type"];
//        NSDictionary *styles= [dic objectForKey:@"styles"];
//        NSDictionary *slider= [styles objectForKey:@"slider"];
//        NSNumber *height=[slider objectForKey:@"height"];
//        photo.stylesUrlHeight= height.stringValue;
//        NSNumber *width=[slider objectForKey:@"width"];
//        photo.stylesUrlWidth= width.stringValue;
//        photo.stylesUrl= [slider objectForKey:@"photo_url"];
//        NSNumber *total_comment=[dic objectForKey:@"total_comment"];
//        photo.total_comment= total_comment.stringValue;
//        NSNumber *total_like= [dic objectForKey:@"total_like"];
//        photo.total_like= total_like.stringValue;
//        
//        [_homePhotoArray addObject:photo];
//    }
//    
//}

- (void) defineFeedObjects
{
    if (_offset==0) {
        _homeFeedArray= [[NSMutableArray alloc]init];
    }
    for (NSDictionary *dic in _responseDic) {
        
        HomeFeed *feed= [[FitmooHelper sharedInstance] generateHomeFeed:dic];
        [_homeFeedArray addObject:feed];
        
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
    
    
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableType isEqualToString:@"photo"]) {
        
        return 105*[[FitmooHelper sharedInstance] frameRadio];

    }else
    {
    
    
    NSNumber *height;
    if (indexPath.row<[_heighArray count]) {
        height= (NSNumber *)[_heighArray objectAtIndex:indexPath.row];
        
    }else
    {
        height=[NSNumber numberWithInt:600];
    }
    NSLog(@"%ld",(long)height.integerValue);
    return height.integerValue;
    }
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
        
        if (_temSearchUser !=nil) {
            temUser=_temSearchUser;
        }else
        {
        temUser= [[UserManager sharedUserManager] localUser];
        }
        cell.nameLabel.text= temUser.name;
        self.titleLabel.text= temUser.name;
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
        cell.communityCountLabel.text=temUser.communities;
        bioText=temUser.bio;
        
        [cell loadHeaderImage:imageUrl];
        [cell loadHeader1Image:temUser.profile_avatar_original];
  
        UIFont *font = [UIFont fontWithName:@"BentonSans-Book" size:cell.bioLabel.font.pointSize];
        NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:temUser.bio attributes:@{NSFontAttributeName: font}  ];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:6];
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:style
                                 range:NSMakeRange(0, temUser.bio.length)];
        
        [cell.bioLabel setAttributedText:attributedString];

        cell.bioLabel.userInteractionEnabled = NO;
        cell.bioLabel.exclusiveTouch = NO;
        [cell.bioButton.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [cell.bioButton addSubview:cell.bioLabel];
        
        [cell.editProfileButton addTarget:self action:@selector(editProfileButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.bioButton addTarget:self action:@selector(BioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.feedButton addTarget:self action:@selector(FeedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.scheduleButton addTarget:self action:@selector(PhotoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        contentHight=[NSNumber numberWithInteger:cell.buttomView.frame.origin.y + cell.buttomView.frame.size.height+10] ;
        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
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
        AsyncImageView *headerImage1 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, cell.heanderImage1.frame.size.width, cell.heanderImage1.frame.size.height)];
        
        
        headerImage1.userInteractionEnabled = NO;
        headerImage1.exclusiveTouch = NO;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage1];
        if ([tempHomefeed.feed_action.community_id isEqual:[NSNull null]])
        {
            headerImage1.imageURL =[NSURL URLWithString:tempHomefeed.feed_action.created_by.thumb];
        }else
        {
            headerImage1.imageURL =[NSURL URLWithString:tempHomefeed.feed_action.created_by_community.cover_photo_url];
        }
        [cell.heanderImage1.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [view addSubview:headerImage1];
        [cell.heanderImage1 addSubview:view];
        
    }
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.headerImage2.frame.size.width, cell.headerImage2.frame.size.height)];
    view.clipsToBounds=YES;
    view.layer.cornerRadius=view.frame.size.width/2;
    AsyncImageView *headerImage2 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, cell.headerImage2.frame.size.width, cell.headerImage2.frame.size.height)];
    headerImage2.userInteractionEnabled = NO;
    headerImage2.exclusiveTouch = NO;
    headerImage2.layer.cornerRadius=headerImage2.frame.size.width/2;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
    if ([tempHomefeed.community_id isEqual:[NSNull null]])
    {
        headerImage2.imageURL =[NSURL URLWithString:tempHomefeed.created_by.thumb];
    }else
    {
        headerImage2.imageURL =[NSURL URLWithString:tempHomefeed.created_by_community.cover_photo_url];
    }
    [cell.headerImage2.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [view addSubview:headerImage2];
    [cell.headerImage2 addSubview:view];
    
    
    cell.titleLabel.text= tempHomefeed.title_info.avatar_title;
    [cell setTitleLabelForHeader];
    
    cell.dayLabel.frame= CGRectMake(cell.dayLabel.frame.origin.x, cell.titleLabel.frame.size.height+cell.titleLabel.frame.origin.y+3, cell.dayLabel.frame.size.width, cell.dayLabel.frame.size.height);
    NSRange range= NSMakeRange(0, tempHomefeed.created_at.length-3);
    NSString * timestring= [tempHomefeed.created_at substringWithRange:range];
    NSTimeInterval time=(NSTimeInterval ) timestring.intValue;
    NSDate *dayBegin= [[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSDate *today= [NSDate date];
    cell.dayLabel.text= [[FitmooHelper sharedInstance] daysBetweenDate:dayBegin andDate:today];
    
    //case for photo and video exits
    if ([tempHomefeed.photoArray count]!=0||[tempHomefeed.videosArray count]!=0) {
        if ([tempHomefeed.type isEqualToString:@"event"])
        {
            cell.scrollbelowFrame= [[UIView alloc] initWithFrame:CGRectMake(30, 30, 260, 60)];
        }
        
        if ([tempHomefeed.photoArray count]!=0) {
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
        [cell.bodyCommentButton setTitle:tempHomefeed.total_comment  forState:UIControlStateNormal];
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
    [cell.bodyLikeButton setTitle:tempHomefeed.total_like forState:UIControlStateNormal];
    if ([tempHomefeed.is_liked isEqualToString:@"1"]) {
        [cell.likeButton setImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    }else
    {
        [cell.likeButton setImage:[UIImage imageNamed:@"like.png"] forState:UIControlStateNormal];
        [cell.likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell.commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.optionButton addTarget:self action:@selector(optionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.bodyImage addTarget:self action:@selector(bodyImageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    contentHight=[NSNumber numberWithInteger: cell.buttomView.frame.origin.y + cell.buttomView.frame.size.height+15];
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
    
    
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
//    if (indexPath.row==0) {
//        return contentHight.integerValue;
//    }
    if ([self.tableType isEqualToString:@"photo"]) {
        if (indexPath.row==0) {
            NSNumber *height= (NSNumber *)[_heighArray objectAtIndex:indexPath.row];
            return  height.intValue;
        }
        
          return 105*[[FitmooHelper sharedInstance] frameRadio];
    }else
    {
    NSNumber *height;
    if (indexPath.row<[_heighArray count]) {
        height= (NSNumber *)[_heighArray objectAtIndex:indexPath.row];
        
    }else
    {
        height=[NSNumber numberWithInt:contentHight.intValue];
    }
    NSLog(@"%ld",(long)height.integerValue);
    return height.integerValue;
    }
}


- (void)scrollViewDidScroll: (UIScrollView*)scroll {
    
    
    if(self.tableView.contentOffset.y<-75){
         NSLog(@"%f",self.tableView.contentOffset.y );
        if (_count==0) {
            [self initValuable];
            
            [self getHomePageItems];
        }
        _count++;
        
        //it means table view is pulled down like refresh
        return;
    }
    else if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height)) {
        //   NSLog(@"bottom!");
        //   NSLog(@"%f",self.tableView.contentOffset.y );
        //   NSLog(@"%f",self.tableView.contentSize.height - self.tableView.bounds.size.height );
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


- (IBAction)commentButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag/100-1;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentViewController *commentPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"CommentViewController"];
    commentPage.homeFeed= [_homeFeedArray objectAtIndex:index];
    //  [self.navigationController presentViewController:commentPage animated:YES completion:nil];
    
    [self.navigationController pushViewController:commentPage animated:YES];
    
}
- (IBAction)likeButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag/100-1;
//    HomeFeed *feed=[_homeFeedArray objectAtIndex:index];
//    
//    if ([feed.is_liked isEqualToString:@"0"]) {
//        int totalLike=1+(int) [button.titleLabel.text integerValue];
//        NSString *newLikeString= [NSString stringWithFormat:@"%i", totalLike];
//        [button setTitle:newLikeString forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
//        [[UserManager sharedUserManager] performLike:feed.feed_id];
//        feed.is_liked=@"1";
//    }
    
    HomeFeed *feed=[_homeFeedArray objectAtIndex:index];
    
    if ([feed.is_liked isEqualToString:@"0"]) {
        NSNumber *totalLike=[NSNumber numberWithInt:1+feed.total_like.intValue];
        //  NSString *newLikeString= totalLike.stringValue;
        //  [button setTitle:newLikeString forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openPopup" object:ActionSheet];
}
- (IBAction)shareButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag/100-1;

    HomeFeed *tempFeed= [_homeFeedArray objectAtIndex:index];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ActionSheetViewController *ActionSheet = [mainStoryboard instantiateViewControllerWithIdentifier:@"ActionSheetViewController"];
    ActionSheet.action= @"share";
    ActionSheet.postId= tempFeed.feed_id;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openPopup" object:ActionSheet];
    
}
- (IBAction)bodyImageButtonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag/100-1;
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    SpecialPageViewController *specialPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SpecialPageViewController"];
//    specialPage.action=@"playVideo";
//    specialPage.homeFeed= [_homeFeedArray objectAtIndex:index];
//    
//    [self.navigationController presentViewController:specialPage animated:YES completion:nil];
    
    
    HomeFeed *homefeed=[_homeFeedArray objectAtIndex:index];
    NSString * url= homefeed.videos.video_url;
    
    if ([url rangeOfString:@"vimeo.com"].location != NSNotFound) {
        
        
        [YTVimeoExtractor fetchVideoURLFromURL:url quality:YTVimeoVideoQualityMedium referer:@"http://www.fitmoo.com"  completionHandler:^(NSURL *videoURL, NSError *error, YTVimeoVideoQuality quality) {
            if (error) {
                NSLog(@"Error : %@", [error localizedDescription]);
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
- (IBAction)FeedButtonClick:(id)sender {
    self.tableType=@"feed";
    [self.tableView reloadData];
}
- (IBAction)PhotoButtonClick:(id)sender {
   self.tableType=@"photo";
    [self.tableView reloadData];
    
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
    
        [self.navigationController pushViewController:specialPage animated:YES];
    
}
- (IBAction)editProfileButtonClick:(id)sender {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"3"];
    
}

- (IBAction)BioButtonClick:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BioViewController *bioPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"BioViewController"];
    bioPage.bioText=bioText;
    [self.navigationController pushViewController:bioPage animated:YES];
   // [self.navigationController presentViewController:bioPage animated:YES completion:nil];
   // [self.tableView reloadData];
}

@end
