//
//  PeoplePageViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/14/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "PeoplePageViewController.h"

@interface PeoplePageViewController ()

@end

@implementation PeoplePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initFrames];
    [self initValuable];
    [self postNotifications];
    [self getHomePageItems];
    [self createObservers];
}


-(void)createObservers{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"didPostFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPostFinished:) name:@"didPostFinished" object:nil];
}


- (void) didPostFinished: (NSNotification * ) note
{
    [self initValuable];
    [self getHomePageItems];
}

-(void) initValuable
{
    _offset=0;
    _limit=10;
    _count=1;
 //   _homeFeedArray= [[NSMutableArray alloc]init];
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
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", @"true", @"mobile",
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    return ([_homeFeedArray count]+1);
    
}


int contentHight2=50;
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
       
     
        cell.followCountLabel.text= temUser.following;
        cell.followerCountLabel.text=temUser.followers;
        cell.communityCountLabel.text=temUser.communities;
        
        
        [cell loadHeaderImage:imageUrl];
        [cell loadHeader1Image:temUser.profile_avatar_thumb];
        contentHight2= cell.buttomView.frame.origin.y + cell.buttomView.frame.size.height+10;
        return cell;
    }
    
    
    ShareTableViewCell *cell =(ShareTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShareTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    HomeFeed * tempHomefeed= [_homeFeedArray objectAtIndex:indexPath.row-1];
    cell.homeFeed=tempHomefeed;
    
    if ([tempHomefeed.feed_action.action isEqualToString:@"post"]) {
        cell.heanderImage1.hidden=true;
        [cell reDefineHearderViewsFrame];
    }else
    {
        cell.heanderImage1.hidden=false;
        AsyncImageView *headerImage1 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, cell.heanderImage1.frame.size.width, cell.heanderImage1.frame.size.height)];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage1];
        if ([tempHomefeed.feed_action.community_id isEqual:[NSNull null]])
        {
            headerImage1.imageURL =[NSURL URLWithString:tempHomefeed.feed_action.created_by.thumb];
        }else
        {
            headerImage1.imageURL =[NSURL URLWithString:tempHomefeed.feed_action.created_by_community.cover_photo_url];
        }
        [cell.heanderImage1.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [cell.heanderImage1 addSubview:headerImage1];
        
    }
    
    AsyncImageView *headerImage2 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, cell.headerImage2.frame.size.width, cell.headerImage2.frame.size.height)];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
    if ([tempHomefeed.community_id isEqual:[NSNull null]])
    {
        headerImage2.imageURL =[NSURL URLWithString:tempHomefeed.created_by.thumb];
    }else
    {
        headerImage2.imageURL =[NSURL URLWithString:tempHomefeed.created_by_community.cover_photo_url];
    }
    [cell.headerImage2.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [cell.headerImage2 addSubview:headerImage2];

    
    
    cell.titleLabel.text= tempHomefeed.title_info.avatar_title;
    NSTimeInterval time=(NSTimeInterval ) ([tempHomefeed.created_at integerValue]/1000);
    NSDate *dayBegin= [[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSDate *today= [NSDate date];
    cell.dayLabel.text= [[FitmooHelper sharedInstance] daysBetweenDate:dayBegin andDate:today];
    
//    if ([tempHomefeed.type isEqualToString:@"regular"]) {
        cell.bodyDetailLabel.text= tempHomefeed.text;
        cell.bodyDetailLabel.frame= [[FitmooHelper sharedInstance] caculateLabelHeight:cell.bodyDetailLabel];
        if ([tempHomefeed.photoArray count]!=0||[tempHomefeed.videosArray count]!=0) {
            [cell addScrollView];
        }else
        {
            [cell removeViewsFromBodyView:cell.bodyImage];
        }
        [cell rebuiltBodyViewFrame];
 //   }
    
    
    if ([tempHomefeed.commentsArray count]!=0) {
        [cell.commentButton setTitle:tempHomefeed.total_comment  forState:UIControlStateNormal];
        for (int i=0; i<[tempHomefeed.commentsArray count]; i++) {
            cell.homeFeed=tempHomefeed;
            [cell addCommentView:cell.commentView Atindex:i];
        }
        if ([tempHomefeed.commentsArray count]==1) {
            [cell removeCommentView2];
            [cell removeCommentView1];
        }
        if ([tempHomefeed.commentsArray count]==2) {
            [cell removeCommentView2];
        }
    }else
    {
         [cell removeCommentView2];
         [cell removeCommentView1];
         [cell removeCommentView];
    }
    
    [cell.likeButton setTag:indexPath.row*100+4];
    [cell.commentButton setTag:indexPath.row*100+5];
    [cell.shareButton setTag:indexPath.row*100+6];
    [cell.optionButton setTag:indexPath.row*100+7];
    
    [cell.likeButton setTitle:tempHomefeed.total_like forState:UIControlStateNormal];
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
    
    contentHight2=  cell.buttomView.frame.origin.y + cell.buttomView.frame.size.height+10;
    //    NSLog(@"%d",contentHight);
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return contentHight2;
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
    SpecialPageViewController *specialPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SpecialPageViewController"];
    specialPage.action=@"Post";
    specialPage.homeFeed= [_homeFeedArray objectAtIndex:index];
    
    [self.navigationController presentViewController:specialPage animated:YES completion:nil];
    
}
- (IBAction)likeButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag/100-1;
    int totalLike=1+(int) [button.titleLabel.text integerValue];
    NSString *newLikeString= [NSString stringWithFormat:@"%i", totalLike];
    [button setTitle:newLikeString forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
    
    HomeFeed *feed=[_homeFeedArray objectAtIndex:index];
    [[UserManager sharedUserManager] performLike:feed.feed_id];
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
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SpecialPageViewController *specialPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SpecialPageViewController"];
    specialPage.action=@"Share";
    specialPage.homeFeed= [_homeFeedArray objectAtIndex:index];
    
    [self.navigationController presentViewController:specialPage animated:YES completion:nil];
    
}

- (IBAction)leftButtonClick:(id)sender {
    
    
}

@end
