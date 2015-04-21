//
//  HomePageViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "HomePageViewController.h"

@implementation HomePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initFrames];
    [self initValuable];
    [self postNotifications];
    [self getHomePageItems];
    [self createObservers];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(displayOneMoreTime:) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(displayOneMoreTime:) userInfo:nil repeats:NO];
   
}




- (void) displayOneMoreTime: (NSTimer *)timer {
    
        [self.tableView reloadData];
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
    //_tableView.userInteractionEnabled=false;
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *lim= [NSString stringWithFormat:@"%i", _limit];
    NSString *ofs= [NSString stringWithFormat:@"%i", _offset];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", @"true", @"mobile",
                              ofs, @"offset", lim , @"limit",nil];
    
    NSString * url= [NSString stringWithFormat: @"%@%@%@", [[UserManager sharedUserManager] homeFeedUrl],localUser.user_id,@"/home_feeds.json"];
    

    
    [manager GET:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
     
     //   _tableView.userInteractionEnabled=true;
        [self defineFeedObjects];
        
        
        [self.tableView reloadData];
      
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
    
    return [_homeFeedArray count];
    
}


int contentHight=50;
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
  //  ShareTableViewCell *cell = [tableView
  //                           dequeueReusableCellWithIdentifier:@"ShareTableViewCell"];
    ShareTableViewCell *cell =(ShareTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShareTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    HomeFeed * tempHomefeed= [_homeFeedArray objectAtIndex:indexPath.row];
    cell.homeFeed=tempHomefeed;
    
    
    AsyncImageView *headerImage2 = [[AsyncImageView alloc] init];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
    headerImage2.imageURL =[NSURL URLWithString:tempHomefeed.created_by.thumb];
    [cell.headerImage2 setBackgroundImage:headerImage2.image forState:UIControlStateNormal];

    
    cell.titleLabel.text= tempHomefeed.title_info.avatar_title;
    cell.bodyDetailLabel.text= tempHomefeed.text;
    
    NSTimeInterval time=(NSTimeInterval ) ([tempHomefeed.created_at integerValue]/1000);
    NSDate *dayBegin= [[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSDate *today= [NSDate date];
    
   cell.dayLabel.text= [[FitmooHelper sharedInstance] daysBetweenDate:dayBegin andDate:today];
    
    if ([tempHomefeed.commentsArray count]!=0) {
        [cell.commentButton setTitle:tempHomefeed.total_comment  forState:UIControlStateNormal];
        for (int i=0; i<[tempHomefeed.commentsArray count]; i++) {
            AsyncImageView *commentImage = [[AsyncImageView alloc] init];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:commentImage];
            tempHomefeed.Comments= [tempHomefeed.commentsArray objectAtIndex:0];
            commentImage.imageURL =[NSURL URLWithString:tempHomefeed.comments.thumb];
            [cell.commentImage setBackgroundImage:commentImage.image forState:UIControlStateNormal];
            cell.commentName.text=tempHomefeed.comments.full_name;
            cell.commentDetail.text= tempHomefeed.comments.text;
            
            if (i>0) {
                //[cell]
            }
        }
       
    }else
    {
        [cell removeCommentView];
    }
    
    if ([tempHomefeed.photoArray count]!=0) {
        tempHomefeed.photos= [tempHomefeed.photoArray objectAtIndex:0];
        
        if (![tempHomefeed.photos.stylesUrl isEqual:@""]) {
      
            AsyncImageView *bodyImage = [[AsyncImageView alloc] init];
            
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:bodyImage];
            
            bodyImage.imageURL =[NSURL URLWithString:tempHomefeed.photos.stylesUrl];
            [cell.bodyImage setBackgroundImage:bodyImage.image forState:UIControlStateNormal];
            cell.bodyImage.hidden=false;
        }else
        {
            AsyncImageView *bodyImage = [[AsyncImageView alloc] init];
           
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:bodyImage];
         
            bodyImage.imageURL =[NSURL URLWithString:tempHomefeed.photos.originalUrl];
            [cell.bodyImage setBackgroundImage:bodyImage.image forState:UIControlStateNormal];
            cell.bodyImage.hidden=false;
          //  [cell removeViewsFromBodyView:cell.bodyImage];
        }
        
    }else
    {
       [cell removeViewsFromBodyView:cell.bodyImage];
     
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
    
    contentHight=  cell.buttomView.frame.origin.y + cell.buttomView.frame.size.height+10;
 //    NSLog(@"%d",contentHight);
    return cell;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{

   return contentHight;
}


- (void)scrollViewDidScroll: (UIScrollView*)scroll {
    
    
    if(self.tableView.contentOffset.y<-75){
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
                 [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(displayOneMoreTime:) userInfo:nil repeats:NO];
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
    SpecialPageViewController *specialPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SpecialPageViewController"];
    specialPage.action=@"Post";
    specialPage.homeFeed= [_homeFeedArray objectAtIndex:index];
    
    [self.navigationController presentViewController:specialPage animated:YES completion:nil];
    
}
- (IBAction)likeButtonClick:(id)sender {
     UIButton *button = (UIButton *)sender;
     NSInteger index=(NSInteger) button.tag/100;
    int totalLike=1+(int) [button.titleLabel.text integerValue];
    NSString *newLikeString= [NSString stringWithFormat:@"%i", totalLike];
    [button setTitle:newLikeString forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"home.png"] forState:UIControlStateNormal];
   
    HomeFeed *feed=[_homeFeedArray objectAtIndex:index];
    [[UserManager sharedUserManager] performLike:feed.feed_id];
}
- (IBAction)optionButtonClick:(id)sender {
     UIButton *button = (UIButton *)sender;
     NSInteger index=(NSInteger) button.tag/100;
     HomeFeed *feed= [_homeFeedArray objectAtIndex:index];
   
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

- (IBAction)deleteButtonClick:(id)sender{
    
}

- (IBAction)cancelButtonClick:(id)sender{
    
}

- (IBAction)endorseButtonClick:(id)sender{
    
}

- (IBAction)shareButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag/100;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SpecialPageViewController *specialPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SpecialPageViewController"];
    specialPage.action=@"Share";
    specialPage.homeFeed= [_homeFeedArray objectAtIndex:index];
    
    [self.navigationController presentViewController:specialPage animated:YES completion:nil];
    
}




@end