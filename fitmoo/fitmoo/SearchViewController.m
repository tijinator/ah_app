//
//  SearchViewController.m
//  fitmoo
//
//  Created by hongjian lin on 4/17/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SearchViewController.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface SearchViewController ()
{
    NSNumber * contentHight;
    UIView *indicatorView;
    User * tempUser1;
    UIButton *tempButton1;
    NSString *searchPeopleName;
    BOOL sleep;
    double ticks;
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    [self initSearchValuable];
    contentHight=[NSNumber numberWithInteger:270*[[FitmooHelper sharedInstance] frameRadio]];
    _heighArray= [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithDouble: 380*[[FitmooHelper sharedInstance] frameRadio]],contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight, nil];
    _searchterm=@"";
    _searchType=@"people";
    UINib *cellNib = [UINib nibWithNibName:@"FollowCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"FollowCollectionViewCell"];
    
    
    
    _searchArrayCategory= [[NSMutableArray alloc] init];
    _searchArrayPeople= [[NSMutableArray alloc] init];
    _searchArrayPeople1= [[NSMutableArray alloc] init];
    _searchArrayPeopleName= [[NSMutableArray alloc] init];
    sleep=false;
    
    [self buildKeyWordDictionary];
    [self getAlldiscoverBulk];
    
    self.tableview.userInteractionEnabled=false;
    [self createObservers];
    // Do any additional setup after loading the view.
}

-(void)createObservers{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellAction:) name:@"cellAction" object:nil];
    
    
}

- (void) cellAction: (NSNotification * ) note
{
    _selectedKeywordId=(NSString *)[note object];
    // [self.tableview reloadData];
    [self initValuable];
    int index=0;
    for (int i=0; i<[_searchArrayKeyword count]; i++) {
        CreatedByCommunity *tempCom= [_searchArrayKeyword objectAtIndex:i];
        
        if ([_selectedKeywordId isEqualToString:tempCom.created_by_community_id]) {
            index=i;
        }
    }
    
    [self parseResponseBulk:index];
    
   
    //  [self getdiscoverBulk];
}

#pragma mark - text field delegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [_searchTermField resignFirstResponder];
        
    }
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // [self moveUpView:_buttomView];
    textField.spellCheckingType = UITextSpellCheckingTypeNo;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if (![textField.text isEqualToString:@""]) {
        [_searchArrayPeopleName addObject:searchPeopleName];
    }
    
    
    return YES;
}

- (void)callQueue
{
    if (sleep==false) {
        if ([_searchArrayPeopleName count]>0) {
            searchPeopleName= [_searchArrayPeopleName objectAtIndex:0];
            [_searchArrayPeopleName removeObjectAtIndex:0];
            
            if ([searchPeopleName isEqualToString:@""]) {
                [self initSearchValuable];
                [self.tableview reloadData];
                
            }else
            {
                [self initSearchValuable];
                [self getSearchItemForPeople];
                sleep=true;
            }
            
            
        }
        
    }
    
}

- (void)timerTick:(NSTimer *)timer
{
    
    ticks += 0.1;
    double seconds = fmod(ticks, 60.0);
    
    if (seconds>=0.5 && seconds<0.6) {
        [_searchArrayPeopleName addObject:searchPeopleName];
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [_timer invalidate];
    ticks=0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    searchPeopleName=textField.text;
    
    
}






- (void) viewWillAppear:(BOOL)animated
{
    
    _timerQueue= [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(callQueue) userInfo:nil repeats:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
}



- (void) viewWillDisappear:(BOOL)animated
{
    [_timerQueue invalidate];
    [_timer invalidate];

}


- (void) initFrames
{
    double radio= self.view.frame.size.width/320;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100*radio, 205*radio)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setSectionInset:UIEdgeInsetsMake(0, 15*radio, 0, 0)];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    _collectionView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_collectionView respectToSuperFrame:self.view];
    _leftButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftButton respectToSuperFrame:self.view];
    _headerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerView respectToSuperFrame:self.view];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    _featerLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_featerLabel respectToSuperFrame:self.view];
    _buttomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttomView respectToSuperFrame:self.view];
    _bodyView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyView respectToSuperFrame:self.view];
    
    
    
    _tableview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableview respectToSuperFrame:self.view];
    _lifestytleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_lifestytleLabel respectToSuperFrame:self.view];
    _addUser.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_addUser respectToSuperFrame:self.view];
    
    _searchTermField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_searchTermField respectToSuperFrame:self.view];
    _searchTermField.layer.cornerRadius=3.0f;
    
    UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:13];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:@"SEARCH" attributes:@{NSFontAttributeName: font}  ];
    float spacing = 1.0f;
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, @"SEARCH".length)];
    
    [_searchTermField setValue:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]
                    forKeyPath:@"_placeholderLabel.textColor"];
    [_searchTermField addTarget:self
                         action:@selector(textFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    paddingView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:paddingView respectToSuperFrame:self.view];
    UIImageView *image= [[UIImageView alloc] initWithFrame:CGRectMake(8, 4, 12, 12)];
    image.image=[UIImage imageNamed:@"greysearch.png"];
    image.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:image respectToSuperFrame:self.view];
    [paddingView addSubview:image];
    
    _searchTermField.leftView = paddingView;
    _searchTermField.leftViewMode = UITextFieldViewModeAlways;
    
    if (self.view.frame.size.height<500) {
        
        _tableview.frame= CGRectMake(_tableview.frame.origin.x,_tableview.frame.origin.y, _tableview.frame.size.width, _tableview.frame.size.height-88);
        
    }
    
    
    
    
}
#pragma mark - API CALL with parser

- (void) buildKeyWordDictionary
{
    _searchArrayKeyword= [[NSMutableArray alloc] init];
    NSArray *textArray= [[NSArray alloc] initWithObjects:@"people",@"communities",@"workouts",@"product + brands", nil];
    
    for (int i=0; i<[textArray count]; i++) {
        CreatedByCommunity *tempCom= [[CreatedByCommunity alloc]  init];
        tempCom.name= [textArray objectAtIndex:i];
        tempCom.created_by_community_id= [NSString stringWithFormat:@"%d", i];
        tempCom.cover_photo_url=@"https://fitmoo.com/assets/group/cover-default.png";
        [_searchArrayKeyword addObject:tempCom];
    }
    CreatedByCommunity *temCom=[_searchArrayKeyword objectAtIndex:0];
    _selectedKeywordId=temCom.created_by_community_id;

}

-(void) parseResponseDic: (NSString *) category
{
    
    NSDictionary *resultArray= [_responseDic objectForKey:@"results"];
    
    
    for (NSDictionary * result in resultArray) {
        User *tempUser= [[User alloc]  init];
        NSNumber * isfollowing=[result objectForKey:@"is_following"];
        tempUser.is_following= [isfollowing stringValue];
        
        NSNumber * following=[result objectForKey:@"following"];
        tempUser.following= [following stringValue];
        NSNumber * followers=[result objectForKey:@"followers"];
        tempUser.followers= [followers stringValue];
        NSNumber * communities=[result objectForKey:@"communities"];
        tempUser.communities= [communities stringValue];
        
        NSDictionary * profile=[result objectForKey:@"profile"];
        tempUser.cover_photo_url=[profile objectForKey:@"cover_photo_url"];
        NSDictionary *avatar=[profile objectForKey:@"avatars"];
        tempUser.profile_avatar_thumb=[avatar objectForKey:@"thumb"];
        tempUser.name= [result objectForKey:@"full_name"];
        NSNumber * user_id=[result objectForKey:@"id"];
        tempUser.user_id= [user_id stringValue];
        
        [_searchArrayPeople1 addObject:tempUser];
    }
    
    
    
    [_tableview reloadData];
    
    
}


-(void) parseAllResponseBulk
{
    _searchArrayTotalKeyword= [[NSMutableArray alloc] init];
    NSDictionary *leader= [_responseDic2 objectForKey:@"leaders"];
    NSDictionary *community= [_responseDic2 objectForKey:@"communities"];
   
    NSDictionary *workout= [_responseDic2 objectForKey:@"workouts"];
    NSDictionary *product= [_responseDic2 objectForKey:@"products"];
    NSDictionary *user= [_responseDic2 objectForKey:@"users"];
    [_searchArrayTotalKeyword addObject:leader];
    [_searchArrayTotalKeyword addObject:community];
   
    [_searchArrayTotalKeyword addObject:workout];
    [_searchArrayTotalKeyword addObject:product];
    [_searchArrayTotalKeyword addObject:user];
  
    [self parseResponseBulk:0];
    
    
    
    
    
}

-(void) parseResponseBulk: (int) index
{
    NSDictionary *bulk= [_searchArrayTotalKeyword objectAtIndex:index];
    
    if (index==1) {
       _searchType=@"community";
        _searchArrayCommunity= [[NSMutableArray alloc] init];
   
        for (NSDictionary * comDic in bulk) {
            CreatedByCommunity *tempCom= [[CreatedByCommunity alloc]  init];
            tempCom.cover_photo_url=[comDic objectForKey:@"cover_photo_url"];
            tempCom.name= [comDic objectForKey:@"name"];
            NSNumber * Com_id=[comDic objectForKey:@"id"];
            tempCom.created_by_community_id= [Com_id stringValue];
            
            NSNumber * member_count=[comDic objectForKey:@"members_count"];
            tempCom.joiners_count= [member_count stringValue];
            
            if ([tempCom.cover_photo_url isEqual:[NSNull null]]) {
                tempCom.cover_photo_url=@"https://fitmoo.com/assets/group/cover-default.png";
            }
            [_searchArrayCommunity addObject:tempCom];
            
        }
    }
    
    if (index==0) {
         _searchType=@"people";
         _searchArrayLeader= [[NSMutableArray alloc] init];
        
        for (NSDictionary *leader in bulk) {
            User *temUser= [[User alloc] init];
            temUser.name= [leader objectForKey:@"full_name"];
            
            NSNumber *days_a_week= [leader objectForKey:@"days_a_week"];
            temUser.days_a_week= [days_a_week stringValue];
            
            NSNumber *workout_count= [leader objectForKey:@"workout_count"];
            temUser.workout_count= [workout_count stringValue];
            NSNumber *user_id= [leader objectForKey:@"id"];
            temUser.user_id=[user_id stringValue];
            
            NSNumber *nutrition_count= [leader objectForKey:@"nutrition_count"];
            temUser.nutrition_count= [nutrition_count stringValue];
            
            NSDictionary *profile= [leader objectForKey:@"profile"];
            
            NSDictionary *avatars= [profile objectForKey:@"avatars"];
            temUser.profile_avatar_thumb= [avatars objectForKey:@"thumb"];
            [_searchArrayLeader addObject:temUser];
            
        }
        
        _searchArrayPeople= [[NSMutableArray alloc] init];
        bulk= [_searchArrayTotalKeyword objectAtIndex:4];
        for (NSDictionary * result in bulk) {
            User *tempUser= [[User alloc]  init];
            NSNumber * following=[result objectForKey:@"is_following"];
            tempUser.is_following= [following stringValue];
            NSNumber * followers=[result objectForKey:@"follower_count"];
            tempUser.followers= [followers stringValue];
            
            
            NSDictionary * profile=[result objectForKey:@"profile"];
            NSDictionary *avatar=[profile objectForKey:@"avatars"];
            tempUser.profile_avatar_thumb=[avatar objectForKey:@"medium"];
            
            tempUser.name= [result objectForKey:@"full_name"];
            NSNumber * user_id=[result objectForKey:@"id"];
            tempUser.user_id= [user_id stringValue];
            
            [_searchArrayPeople addObject:tempUser];
        }

        
        
    }
    
    if (index==2) {
         _searchType=@"workout";
         _searchArrayWorkouts= [[NSMutableArray alloc] init];
        
        for (NSDictionary *wkDic in bulk) {
            Workout *wk= [[Workout alloc] init];
            NSNumber *wk_id= [wkDic objectForKey:@"id"];
            wk.workout_id= [wk_id stringValue];
            wk.title=[wkDic objectForKey:@"text"];
            
            NSDictionary *photo= [wkDic objectForKey:@"photo"];
            if (![photo isEqual:[NSNull null]]) {
                NSDictionary *style= [photo objectForKey:@"styles"];
                NSDictionary *slider=[style objectForKey:@"slider"];
                wk.style_url= [slider objectForKey:@"photo_url"];
                
            }
            
            NSDictionary *video= [wkDic objectForKey:@"video"];
            if (![video isEqual:[NSNull null]]) {
                
                
                NSDictionary *thumbnail= [video objectForKey:@"thumbnail"];
                wk.video_style_url=[thumbnail objectForKey:@"url"];
                
                
            }
            
            [_searchArrayWorkouts addObject:wk];
            
        }
    }
    
    if (index==3) {
       _searchArrayProducts= [[NSMutableArray alloc] init];
         _searchType=@"product";
        for (NSDictionary *pdDic in bulk) {
            Product *pd= [[Product alloc] init];
            NSNumber *pd_id= [pdDic objectForKey:@"id"];
            pd.product_id= [pd_id stringValue];
            pd.title=[pdDic objectForKey:@"text"];
            if ([pd.title isEqual:[NSNull null]]) {
                pd.title=@"";
            }
            
            NSDictionary *photo= [pdDic objectForKey:@"photo"];
            if (![photo isEqual:[NSNull null]]) {
                NSDictionary *style= [photo objectForKey:@"styles"];
                NSDictionary *slider=[style objectForKey:@"slider"];
                pd.photo= [slider objectForKey:@"photo_url"];
                
            }
            
            NSDictionary *video= [pdDic objectForKey:@"video"];
            if (![video isEqual:[NSNull null]]) {
                
                NSDictionary *thumbnail= [video objectForKey:@"thumbnail"];
                pd.videos=[thumbnail objectForKey:@"url"];
                
            }
            [_searchArrayProducts addObject:pd];
            
        }
    }
  
    
    
    [self.tableview reloadData];
}




- (void) getSpecialPage: (NSString *) key
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",  @"true", @"mobile",@"true", @"ios_app", nil];
    _tableview.userInteractionEnabled=NO;
    [self addActivityIndicator];
    NSString * url= [NSString stringWithFormat: @"%@%@%@", [[UserManager sharedUserManager] clientUrl],@"/api/feeds/",key];
    
    [manager GET:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        _tableview.userInteractionEnabled=YES;
        [indicatorView removeFromSuperview];
        
        NSDictionary * resDic= responseObject;
        
        HomeFeed *feed= [[FitmooHelper sharedInstance] generateHomeFeed:resDic];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SpecialPageViewController *specialPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SpecialPageViewController"];
        specialPage.homeFeed=feed;
        [self.navigationController pushViewController:specialPage animated:YES];
        
    } // success callback block
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
             _tableview.userInteractionEnabled=YES;
             [indicatorView removeFromSuperview];
         } // failure callback block
     
     ];
    
}

- (void) getSearchItemForPeople
{
    // [_activityIndicator startAnimating];
    [self addActivityIndicator];
    _tableview.userInteractionEnabled=NO;
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *lim= [NSString stringWithFormat:@"%i", _searchlimit];
    NSString *ofs= [NSString stringWithFormat:@"%i", _searchoffset];
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",ofs, @"offset",lim, @"limit",@"true", @"mobile",@"people", @"c",searchPeopleName, @"q",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/global/search"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        [self parseResponseDic:@"People"];
        _tableview.userInteractionEnabled=YES;
        sleep=false;
        [indicatorView removeFromSuperview];
        // [_activityIndicator stopAnimating];
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             sleep=false;
             _tableview.userInteractionEnabled=YES;
             NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}




- (void) getAlldiscoverBulk
{
    [self addActivityIndicator];
    self.tableview.userInteractionEnabled=false;
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token", nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/discover/app_search_bulk"];

  
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic2= responseObject;
        [self parseAllResponseBulk];
        
        self.tableview.userInteractionEnabled=true;
        [indicatorView removeFromSuperview];
        
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
             self.tableview.userInteractionEnabled=true;
             [indicatorView removeFromSuperview];
         } // failure callback block
     
     ];
    
}




- (void) addActivityIndicator
{
    indicatorView= [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 160*[[FitmooHelper sharedInstance] frameRadio], 100, 100)];
    indicatorView.backgroundColor=[UIColor colorWithRed:174.0/255.0 green:182.0/255.0 blue:186.0/255.0 alpha:1];
    //  view.backgroundColor=[UIColor whiteColor];
    indicatorView.layer.cornerRadius=5;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [[FitmooHelper sharedInstance] resizeFrameWithFrame:activityIndicator respectToSuperFrame:nil];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = CGPointMake(50, 40);
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator setBackgroundColor:[UIColor clearColor]];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    
    UILabel * postingLabel= [[UILabel alloc] initWithFrame: CGRectMake(0,60, 100, 30)];
    postingLabel.text= @"LOADING...";
    //  postingLabel.textColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    postingLabel.textColor=[UIColor whiteColor];
    UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:13];
    [postingLabel setFont:font];
    postingLabel.textAlignment=NSTextAlignmentCenter;
    
    [indicatorView addSubview:activityIndicator];
    [indicatorView addSubview:postingLabel];
    [self.view addSubview:indicatorView];
    
    // self.view.userInteractionEnabled=NO;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (![_searchTermField.text isEqualToString:@""]) {
        if ([_searchArrayPeople1 count]==0) {
            
            if (![searchPeopleName isEqualToString:@""]&&searchPeopleName!=nil) {
                return 1;
            }
            
            return 0;
        }
        return [_searchArrayPeople1 count]+2;
        
    }
    
    int count=2;
    if ([self.searchType isEqualToString:@"community"]) {
        count=(int)[_searchArrayCommunity count]/3;
        if ([_searchArrayCommunity count]%3!=0) {
            count=count+1;
        }
        count=count+1;
    }
    
   
    
    if ([self.searchType isEqualToString:@"people"]) {
        count=(int)[_searchArrayPeople count]/3;
        if ([_searchArrayPeople count]%3!=0) {
            count=count+1;
        }
        count=count+1+(int)[_searchArrayLeader count];
        
        
    }
   
    
    return count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![_searchTermField.text isEqualToString:@""]) {
        
        if (indexPath.row==0) {
            if ((![searchPeopleName isEqualToString:@""])&&[_searchArrayPeople1 count]==0) {
                UITableViewCell *Cell= [tableView dequeueReusableCellWithIdentifier:@"cell3"];
                
                UILabel *text= (UILabel *) [Cell viewWithTag:1001];
                text.frame=CGRectMake(0, 21, 320, 27);
                text.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:text respectToSuperFrame:self.view];
                
                UIButton *inviteButton= (UIButton *) [Cell viewWithTag:1];
                inviteButton.frame=CGRectMake(81, 56, 157, 30);
                inviteButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:inviteButton respectToSuperFrame:self.view];
                [inviteButton addTarget:self action:@selector(addUserButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                return Cell;
                
            }
            
            
            UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell4"];
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 60)];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, tableView.frame.size.width, 20)];
            
            NSString *string= @"PROFILES + BRANDS";
            
            [label setBackgroundColor:[UIColor clearColor]];
            [label setText:string];
            [label setTextColor:[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1]];
            UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:12];
            NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: font}  ];
            
            float spacing = 1.0f;
            [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [string length])];
            
            [label setAttributedText:attributedString];
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            
            [view addSubview:label];
            
            [view setBackgroundColor:[UIColor whiteColor]];
            [cell.contentView addSubview:view];
            return cell;
            
            
        }
        
        //last cell
        if (indexPath.row==[_searchArrayPeople1 count]+1) {
            UITableViewCell *Cell= [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            
            UILabel *text= (UILabel *) [Cell viewWithTag:1001];
            text.frame=CGRectMake(0, 21, 320, 27);
            text.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:text respectToSuperFrame:self.view];
            
            UIButton *inviteButton= (UIButton *) [Cell viewWithTag:1];
            inviteButton.frame=CGRectMake(81, 56, 157, 30);
            inviteButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:inviteButton respectToSuperFrame:self.view];
            [inviteButton addTarget:self action:@selector(addUserButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            return Cell;
        }
        
        
        UITableViewCell * cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell4"];
        @try {
            UIButton *imageview=[[UIButton alloc] init];
            imageview.frame= CGRectMake(15, 15, 35, 35);
            imageview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:imageview respectToSuperFrame:self.view];
            UILabel *nameLabel=[[UILabel alloc] init];
            nameLabel.frame= CGRectMake(63, 11, 125, 42);
            nameLabel.numberOfLines=2;
            nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel respectToSuperFrame:self.view];
            
            UIButton * followButton= [[UIButton alloc] init];
            followButton.frame= CGRectMake(210, 14, 100, 31);
            followButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:followButton respectToSuperFrame:self.view];
            
            UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height)];
            view.clipsToBounds=YES;
            view.layer.cornerRadius=view.frame.size.width/2;
            User *temUser= [_searchArrayPeople1 objectAtIndex:indexPath.row-1];
            nameLabel.text= temUser.name;
            // nameLabel.frame=[[FitmooHelper sharedInstance] caculateLabelHeight:nameLabel];
            UIFont *font = [UIFont fontWithName:@"BentonSans-Medium" size:14];
            NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:nameLabel.text attributes:@{NSFontAttributeName: font}  ];
            
            [nameLabel setAttributedText:attributedString];
            
            
            AsyncImageView *userImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height)];
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:userImage];
            userImage.imageURL =[NSURL URLWithString:temUser.profile_avatar_thumb];
            
            [view addSubview:userImage];
            [imageview addSubview:view];
            
            [followButton setTag:indexPath.row+100];
            
            
            if ([temUser.is_following isEqualToString:@"0"]) {
                
                [followButton setBackgroundImage:[UIImage imageNamed:@"searchfollowbtn.png"] forState:UIControlStateNormal];
                
            }else
            {
                [followButton setBackgroundImage:[UIImage imageNamed:@"searchfollowingbtn.png"] forState:UIControlStateNormal];
            }
            [followButton addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:imageview];
            [cell.contentView addSubview:followButton];
            [cell.contentView addSubview:nameLabel];
            cell.selectionStyle= UITableViewCellSelectionStyleNone;
            
            UIView *v= [[UIView alloc] initWithFrame:CGRectMake(55, 59, 270, 1)];
            if (indexPath.row==[_searchArrayPeople1 count]) {
                v= [[UIView alloc] initWithFrame:CGRectMake(5, 59, 310, 1)];
            }
            
            v.backgroundColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
            v.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:v respectToSuperFrame:self.view];
            [cell.contentView addSubview:v];
            v.frame= CGRectMake(v.frame.origin.x, v.frame.origin.y, v.frame.size.width, 1);
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
        }
        
        
        
        return cell;
        
        
    }
    
    
    if (indexPath.row==0) {
        SeachInterestCell *cell =(SeachInterestCell *) [self.tableview cellForRowAtIndexPath:indexPath];
        
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SeachInterestCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.searchArrayKeyword=self.searchArrayKeyword;
        cell.selectedKeywordId=self.selectedKeywordId;
        cell.searchType=@"discover";
        [cell addScrollView];
        
        
        
        contentHight=[NSNumber numberWithDouble:cell.scrollView.frame.size.height+1];
        [_heighArray replaceObjectAtIndex:0 withObject:contentHight];
        
        return cell;
    }
    

    
    if (indexPath.row==1&&[self.searchType isEqualToString:@"product"]) {
        FollowPhotoCell *cell =(FollowPhotoCell *) [self.tableview cellForRowAtIndexPath:indexPath];
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FollowPhotoCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.cellArray=self.searchArrayProducts;
        cell.cellType=@"product";
        [cell builtCells];
        
        [cell.view1Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view2Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view3Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view4Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view5Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view6Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view7Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view8Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view9Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        contentHight=[cell CaculateCellHeight];
        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
        return cell;
    }
    
    if ([self.searchType isEqualToString:@"community"]) {
        SearchPhotoCell *cell =(SearchPhotoCell *) [self.tableview cellForRowAtIndexPath:indexPath];
        
     
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchPhotoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
         cell.searchType=@"community";
        int current=(int) (indexPath.row-1)*3;
        if (current<[_searchArrayCommunity count]) {
            CreatedByCommunity *com1=[_searchArrayCommunity objectAtIndex:current];
            cell.com1= com1;
            cell.view1Button.tag=com1.created_by_community_id.integerValue;
            [cell.view1Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell setView1Item];
        }else
        {
            cell.view1.hidden=true;
        }
        
        if (current+1<[_searchArrayCommunity count]) {
           CreatedByCommunity *com2=[_searchArrayCommunity objectAtIndex:current+1];
            cell.com2= com2;
            cell.view2Button.tag=com2.created_by_community_id.integerValue;
            [cell.view2Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell setView2Item];
        }else
        {
            cell.view2.hidden=true;
        }
        
        if (current+2<[_searchArrayCommunity count]) {
            CreatedByCommunity *com3=[_searchArrayCommunity objectAtIndex:current+2];
            cell.com3= com3;
            cell.view3Button.tag=com3.created_by_community_id.integerValue;
            [cell.view3Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell setView3Item];
        }else
        {
            cell.view3.hidden=true;
        }
        
        contentHight=[NSNumber numberWithDouble:105*[[FitmooHelper sharedInstance] frameRadio]+1] ;
        int count=(int)[_searchArrayWorkouts count]/3;
        if ([_searchArrayWorkouts count]%3!=0) {
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

    }

    
    if (indexPath.row==1&&[self.searchType isEqualToString:@"workout"]) {
        FollowPhotoCell *cell =(FollowPhotoCell *) [self.tableview cellForRowAtIndexPath:indexPath];
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FollowPhotoCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.cellArray=self.searchArrayWorkouts;
        cell.cellType=@"workout";
        [cell builtCells];
        
        [cell.view1Button addTarget:self action:@selector(workoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view2Button addTarget:self action:@selector(workoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view3Button addTarget:self action:@selector(workoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view4Button addTarget:self action:@selector(workoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view5Button addTarget:self action:@selector(workoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view6Button addTarget:self action:@selector(workoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view7Button addTarget:self action:@selector(workoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view8Button addTarget:self action:@selector(workoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.view9Button addTarget:self action:@selector(workoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        contentHight=[cell CaculateCellHeight];
        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
        return cell;
    }
    
    
    int count=(int)[_searchArrayPeople count]/3;
    if ([_searchArrayPeople count]%3!=0) {
        count=count+1;
    }
    count=count+1;
    if (indexPath.row<count&&[self.searchType isEqualToString:@"people"]) {
        SearchPhotoCell *cell =(SearchPhotoCell *) [self.tableview cellForRowAtIndexPath:indexPath];
        
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchPhotoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.searchType=@"people";
        int current=(int) (indexPath.row-1)*3;
        if (current<[_searchArrayPeople count]) {
            User *user1=[_searchArrayPeople objectAtIndex:current];
            cell.user1= user1;
            cell.view1Button.tag=user1.user_id.integerValue;
            [cell.view1Button addTarget:self action:@selector(peopleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell setView1Item];
        }else
        {
            cell.view1.hidden=true;
        }
        
        if (current+1<[_searchArrayPeople count]) {
            User *user2=[_searchArrayPeople objectAtIndex:current+1];
            cell.user2= user2;
            cell.view2Button.tag=user2.user_id.integerValue;
            [cell.view2Button addTarget:self action:@selector(peopleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell setView2Item];
        }else
        {
            cell.view2.hidden=true;
        }
        
        if (current+2<[_searchArrayPeople count]) {
            User *user3=[_searchArrayPeople objectAtIndex:current+2];
            cell.user3= user3;
            cell.view3Button.tag=user3.user_id.integerValue;
            [cell.view3Button addTarget:self action:@selector(peopleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell setView3Item];
        }else
        {
            cell.view3.hidden=true;
        }
        
        contentHight=[NSNumber numberWithDouble:105*[[FitmooHelper sharedInstance] frameRadio]+1] ;
        int count=(int)[_searchArrayWorkouts count]/3;
        if ([_searchArrayWorkouts count]%3!=0) {
            count=count+1;
        }
      
        if (indexPath.row>=[_heighArray count]) {
            [_heighArray addObject:contentHight];
        }else
        {
            [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
        }
        
        
        return cell;
    }


//    if (indexPath.row==1&&[self.searchType isEqualToString:@"community"]) {
//        FollowPhotoCell *cell =(FollowPhotoCell *) [self.tableview cellForRowAtIndexPath:indexPath];
//        if (cell==nil) {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FollowPhotoCell" owner:self options:nil];
//            cell = [nib objectAtIndex:0];
//        }
//        
//        cell.cellArray=self.searchArrayCommunity;
//        cell.cellType=@"community";
//        [cell builtCells];
//        
//        [cell.view1Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.view2Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.view3Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.view4Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.view5Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.view6Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.view7Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.view8Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.view9Button addTarget:self action:@selector(communityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        contentHight=[cell CaculateCellHeight];
//        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
//        return cell;
//    }

//    if (indexPath.row==1&&[self.searchType isEqualToString:@"people"]) {
//        FollowPhotoCell *cell =(FollowPhotoCell *) [self.tableview cellForRowAtIndexPath:indexPath];
//        if (cell==nil) {
//            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FollowPhotoCell" owner:self options:nil];
//            cell = [nib objectAtIndex:0];
//        }
//        
//        cell.cellArray=self.searchArrayPeople;
//        cell.cellType=@"people";
//        [cell builtCells];
//        
//        [cell.view1Button addTarget:self action:@selector(peopleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.view2Button addTarget:self action:@selector(peopleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.view3Button addTarget:self action:@selector(peopleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.view4Button addTarget:self action:@selector(peopleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.view5Button addTarget:self action:@selector(peopleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.view6Button addTarget:self action:@selector(peopleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.view7Button addTarget:self action:@selector(peopleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.view8Button addTarget:self action:@selector(peopleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.view9Button addTarget:self action:@selector(peopleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        
//        contentHight=[cell CaculateCellHeight];
//        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
//        return cell;
//    }

    
    FollowLeaderBoardCell *cell =(FollowLeaderBoardCell *) [self.tableview cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FollowLeaderBoardCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
   

    User *tempUser= [_searchArrayLeader objectAtIndex:(indexPath.row-count)];
    cell.tempUser= tempUser;
    
    [cell buildCell];
    cell.CountLabel.text=[NSString stringWithFormat:@"%ld",indexPath.row-count+1];
    
    contentHight=[NSNumber numberWithDouble:75*[[FitmooHelper sharedInstance] frameRadio]];
    if (indexPath.row>=[_heighArray count]) {
        [_heighArray addObject:contentHight];
    }else
    {
        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
    }
    
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int count=(int)[_searchArrayPeople count]/3;
    if ([_searchArrayPeople count]%3!=0) {
        count=count+1;
    }
    if(indexPath.row>count)
    {
        
        User *tempUser= [_searchArrayLeader objectAtIndex:(indexPath.row-count-1)];
        NSString* key=[NSString stringWithFormat:@"%ld", (long)tempUser.user_id.intValue+100];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![_searchTermField.text isEqualToString:@""]) {
        double Radio= self.view.frame.size.width / 320;
        
        if (indexPath.row==[_searchArrayPeople1 count]+1) {
            return 310*Radio;
        }
        if (indexPath.row==0) {
            if ((![searchPeopleName isEqualToString:@""])&&[_searchArrayPeople1 count]==0) {
                
                return 310*Radio;
            }
        }
        return 60*Radio;
    }
    
    NSNumber *height;
    if (indexPath.row<[_heighArray count]) {
        height= (NSNumber *)[_heighArray objectAtIndex:indexPath.row];
        
    }else
    {
        height=[NSNumber numberWithDouble:270*[[FitmooHelper sharedInstance] frameRadio]];
    }
    NSLog(@"%ld",(long)height.integerValue);
    return height.integerValue;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (![_searchTermField.text isEqualToString:@""]) {
        double Radio= self.view.frame.size.width / 320;
        
        if (indexPath.row==[_searchArrayPeople1 count]+1) {
            return 310*Radio;
        }
        if (indexPath.row==0) {
            if ((![searchPeopleName isEqualToString:@""])&&[_searchArrayPeople1 count]==0) {
                
                return 310*Radio;
            }
        }
        return 60*Radio;
    }
    
    NSNumber *height;
    if (indexPath.row<[_heighArray count]) {
        height= (NSNumber *)[_heighArray objectAtIndex:indexPath.row];
        
    }else
    {
        height=[NSNumber numberWithInt:contentHight.doubleValue];
    }
    return height.doubleValue;
    
}





- (IBAction)categoryButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index= button.tag-10;
    User *user= [_searchArrayCategory objectAtIndex:index];
    NSString *key=user.user_id;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SecondFollowViewController *secondFollowPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SecondFollowViewController"];
    secondFollowPage.searchId= key;
    
    [self.navigationController pushViewController:secondFollowPage animated:YES];
    
}




- (void) initSearchValuable
{
    _searchoffset=0;
    _searchlimit=15;
    _searchcount=1;
    
    _searchArrayPeople1= [[NSMutableArray alloc]init];
}

-(void) initValuable
{
    _offset=0;
    _limit=10;
    _count=1;
    
    
    
}
- (void)scrollViewDidScroll: (UIScrollView*)scroll {
    
    if (![_searchTermField.text isEqualToString:@""]) {
        if(self.tableview.contentOffset.y<-75){
            if (_count==0) {
            }
            _count++;
            
            return;
        }
        else if(self.tableview.contentOffset.y >= (self.tableview.contentSize.height - self.tableview.bounds.size.height)) {
            
            
            if (_count==0) {
                if (self.tableview.contentOffset.y<0) {
                    _searchoffset =0;
                }else
                {
                    _searchoffset +=15;
                    
                }
                [self getSearchItemForPeople];
            }
            _count++;
            
            
        }else
        {
            _count=0;
        }
        
    }else
    {
        
        
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - Button functions

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 1)
    {
        [[UserManager sharedUserManager] performUnFollow:tempUser1.user_id];
        tempUser1.is_following=@"0";
        
        
        if (![_searchTermField.text isEqualToString:@""]) {
            [tempButton1 setBackgroundImage:[UIImage imageNamed:@"searchfollowbtn.png"] forState:UIControlStateNormal];
        }else
        {
            [tempButton1 setBackgroundImage:[UIImage imageNamed:@"followsection_smallfollowbtn.png"] forState:UIControlStateNormal];
        }
    }
    
    
}

- (IBAction)workoutButtonClick:(id)sender {
    UIButton *tempButton = (UIButton *)sender;
    NSInteger index=(NSInteger) tempButton.tag-1;
    if (index<[_searchArrayWorkouts count]) {
        Workout *wk= [_searchArrayWorkouts objectAtIndex:index];
        [self getSpecialPage:wk.workout_id];
    }
    
}

- (IBAction)productButtonClick:(id)sender {
    UIButton *tempButton = (UIButton *)sender;
    NSInteger index=(NSInteger) tempButton.tag-1;
    if (index<[_searchArrayProducts count]) {
        Product *pd= [_searchArrayProducts objectAtIndex:index];
        [self getSpecialPage:pd.product_id];
    }
}

- (IBAction)communityButtonClick:(id)sender {
//    UIButton *tempButton = (UIButton *)sender;
//    NSInteger index=(NSInteger) tempButton.tag-1;
//    if (index<[_searchArrayCommunity count]) {
//        CreatedByCommunity *com= [_searchArrayCommunity objectAtIndex:index];
//        
//        NSString * key= [NSString stringWithFormat:@"%@%@",@"com",com.created_by_community_id];
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
//    }
    
    UIButton *tempButton = (UIButton *)sender;
    NSInteger index=(NSInteger) tempButton.tag;

    NSString * key= [NSString stringWithFormat:@"%@%ld",@"com",(long)index];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
    
}

- (IBAction)peopleButtonClick:(id)sender {
//    UIButton *tempButton = (UIButton *)sender;
//    NSInteger index=(NSInteger) tempButton.tag-1;
//    if (index<[_searchArrayPeople count]) {
//        User *tempUser=[_searchArrayPeople objectAtIndex:index];
//        NSString * key= [NSString stringWithFormat:@"%d",tempUser.user_id.intValue+100];
//       [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
//    }
     UIButton *tempButton = (UIButton *)sender;
     NSInteger index=(NSInteger) tempButton.tag;
     NSString * key= [NSString stringWithFormat:@"%ld",index+100];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
}

- (IBAction)followButtonClick:(id)sender {
    tempButton1 = (UIButton *)sender;
    NSInteger index=(NSInteger) tempButton1.tag-100;
    
    if (![_searchTermField.text isEqualToString:@""]) {
        tempUser1= [_searchArrayPeople1 objectAtIndex:(index-1)];
    }else
    {
        tempUser1= [_searchArrayPeople objectAtIndex:index];
    }
    
    if ([tempUser1.is_following isEqualToString:@"0"]) {
        [[UserManager sharedUserManager] performFollow:tempUser1.user_id];
        tempUser1.is_following=@"1";
        if (![_searchTermField.text isEqualToString:@""]) {
            [tempButton1 setBackgroundImage:[UIImage imageNamed:@"searchfollowingbtn.png"] forState:UIControlStateNormal];
        }else
        {
            [tempButton1 setBackgroundImage:[UIImage imageNamed:@"followsection_smallfollowingbtn.png"] forState:UIControlStateNormal];
        }
    }else
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Unfollow"
                                                       message:@"Are you sure you want to Unfollow this person?"
                                                      delegate:self
                                             cancelButtonTitle:@"No"
                                             otherButtonTitles:@"Yes",nil];
        [alert show];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"HasSeenPopup"];
        
        
    }
    
    
}

- (IBAction)backButtonClick:(id)sender {
    //  [[NSNotificationCenter defaultCenter] postNotificationName:@"swipeHandler" object:Nil];
    self.backButtonClicked=true;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"back"];
}
- (IBAction)addUserButtonClick:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InviteViewController * inviteView = [mainStoryboard instantiateViewControllerWithIdentifier:@"InviteViewController"];
    
    [self.navigationController pushViewController:inviteView animated:YES];
}
@end
