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
}


-(void)createObservers{
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
    _homeFeedArray= [[NSMutableArray alloc]init];
}

-(void) getHomePageItems
{
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
 //   NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", @"true", @"mobile",
 //                             @"0", @"offset",@"10", @"limit",nil];
    

    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"83c923b62182cfda", @"secret_id", @"otEOucb5wZVrOOyh8SW3orGHmSDtSdtYdTnAmU8Ip2M", @"auth_token", @"true", @"mobile", @"0", @"offset",@"20", @"limit",nil];
    
 //   NSString * url= [NSString stringWithFormat: @"%@%@%@", [[FitmooHelper sharedInstance] homeFeedUrl],localUser.user_id,@"/home_feeds.json"];
    
    NSString * url=[[UserManager sharedUserManager] homeFeedUrl];
    
    [manager GET:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
     
        
        [self defineFeedObjects];
        
        [self.tableView reloadData];
        
        NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             
             NSLog(@"Error: %@", error);} // failure callback block
     ];
}

- (void) defineFeedObjects
{
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
    
    
    ShareTableViewCell *cell = [tableView
                             dequeueReusableCellWithIdentifier:@"ShareTableViewCell"];
   
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
   
    
    if (tempHomefeed.commentsArray!=nil) {
        int commentCount=(int)[tempHomefeed.commentsArray count];
        NSString *count= [NSString stringWithFormat:@"%i",commentCount];
        [cell.commentButton setTitle:count  forState:UIControlStateNormal];
        for (int i=0; i<[tempHomefeed.commentsArray count]; i++) {
            AsyncImageView *commentImage = [[AsyncImageView alloc] init];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:commentImage];
            tempHomefeed.Comments= [tempHomefeed.commentsArray objectAtIndex:0];
            commentImage.imageURL =[NSURL URLWithString:tempHomefeed.comments.thumb];
            [cell.commentImage setBackgroundImage:commentImage.image forState:UIControlStateNormal];
            
            cell.commentName.text=tempHomefeed.comments.full_name;
            cell.commentDetail.text= tempHomefeed.comments.text;
        }
       
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
            cell.bodyImage.hidden=true;
          //  [cell removeViewsFromBodyView:cell.bodyImage];
        }
        
    }else
    {
     //  [cell removeViewsFromBodyView:cell.bodyImage];
            cell.bodyImage.hidden=true;
    }
    
  
    [cell.likeButton setTag:indexPath.row*100+4];
    [cell.commentButton setTag:indexPath.row*100+5];
    [cell.shareButton setTag:indexPath.row*100+6];
    [cell.optionButton setTag:indexPath.row*100+7];
    
    [cell.likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.optionButton addTarget:self action:@selector(optionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    contentHight= cell.contentView.frame.size.height;
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

- (IBAction)commentButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag/100;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SpecialPageViewController *specialPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SpecialPageViewController"];
    specialPage.homeFeed= [_homeFeedArray objectAtIndex:index];
    
    [self.navigationController presentViewController:specialPage animated:YES completion:nil];
    
}
- (IBAction)likeButtonClick:(id)sender {
    
    
}
- (IBAction)optionButtonClick:(id)sender {
    
    
}
- (IBAction)shareButtonClick:(id)sender {
    
    
}

- (IBAction)leftButtonClick:(id)sender {
    
    
}


@end
