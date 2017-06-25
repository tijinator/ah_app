//
//  SearchProductViewController.m
//  fitmoo
//
//  Created by hongjian lin on 6/19/17.
//  Copyright © 2017 com.fitmoo. All rights reserved.
//

#import "SearchProductViewController.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "PeoplePageService.h"
#import "PeopleRequest.h"
@interface SearchProductViewController ()
{
    NSNumber * contentHight;
    UIView *indicatorView;
    User * tempUser1;
    UIButton *tempButton1;
    NSString *searchPeopleName;
    BOOL sleep;
    double ticks;
    
    BOOL workoutHere;
    BOOL LeaderHere;
    BOOL ProductHere;
    BOOL CommunityHere;
    
    
}

@property (nonatomic, strong) PeoplePageService *service;
@end

@implementation SearchProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.service = [[PeoplePageService alloc] init];
    [self initFrames];
    _searchterm=@"people";
    [self initSearchValuable];
    [self initDiscoverValuable];
    contentHight=[NSNumber numberWithInteger:270*[[FitmooHelper sharedInstance] frameRadio]];
    _heighArray= [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithDouble: 380*[[FitmooHelper sharedInstance] frameRadio]],contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight, nil];
    
    
    UINib *cellNib = [UINib nibWithNibName:@"FollowCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"FollowCollectionViewCell"];
    
    
    
    _searchArrayCategory= [[NSMutableArray alloc] init];
    _searchArrayPeople= [[NSMutableArray alloc] init];
    _searchArrayPeople1= [[NSMutableArray alloc] init];
    _searchArrayPeople2= [[NSMutableArray alloc] init];
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
    [self initValuable];
    int index=0;
    for (int i=0; i<[_searchArrayKeyword count]; i++) {
        CreatedByCommunity *tempCom= [_searchArrayKeyword objectAtIndex:i];
        
        if ([_selectedKeywordId isEqualToString:tempCom.created_by_community_id]) {
            index=i;
        }
    }
    
    [_tableview reloadData];
    
    
    
    
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
            _searchArrayPeople2=[[NSMutableArray alloc] init];
            _searchArrayWorkout2=[[NSMutableArray alloc] init];
            _searchArrayProduct2=[[NSMutableArray alloc] init];
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
    [super viewWillAppear:animated];
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
        tempCom.cover_photo_url=@"https://actionhouse.com/assets/group/cover-default.png";
        [_searchArrayKeyword addObject:tempCom];
    }
    CreatedByCommunity *temCom=[_searchArrayKeyword objectAtIndex:0];
    _selectedKeywordId=temCom.created_by_community_id;
    
}

-(void) parseResponseDic: (NSString *) category
{
    NSDictionary *resultArray= [_responseDic objectForKey:@"results"];
    if ([category isEqualToString:@"people"]) {
        
        
        for (NSDictionary * result in resultArray) {
            @try {
                
                
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
                
                [_searchArrayPeople2 addObject:tempUser];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
        
        _searchArrayPeople1=[_searchArrayPeople2 mutableCopy];
        
    }else if ([category isEqualToString:@"workout"]) {
        for (NSDictionary * result in resultArray) {
            @try {
                
                
                Workout *tempWk= [[Workout alloc]  init];
                
                NSNumber * wk_id=[result objectForKey:@"id"];
                tempWk.workout_id= [wk_id stringValue];
                
                tempWk.title=[result objectForKey:@"text"];
                
                NSNumber * time=[result objectForKey:@"time"];
                
                if ([time isEqual:[NSNull null]]) {
                    tempWk.time=@"";
                }else
                {
                    tempWk.time=[time stringValue];
                }
                
                NSDictionary * photo= [result objectForKey:@"photo"];
                if (![photo isEqual:[NSNull null]]) {
                    NSDictionary * style= [photo objectForKey:@"styles"];
                    NSDictionary *thumb= [style objectForKey:@"thumb"];
                    tempWk.style_url= [thumb objectForKey:@"photo_url"];
                }
                
                
                [_searchArrayWorkout2 addObject:tempWk];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
        _searchArrayPeople1=[_searchArrayWorkout2 mutableCopy];
        
    }else if ([category isEqualToString:@"product"]) {
        for (NSDictionary * result in resultArray) {
            @try {
                
                
                Product *tempPd= [[Product alloc]  init];
                
                NSNumber * pd_id=[result objectForKey:@"id"];
                tempPd.product_id= [pd_id stringValue];
                
                tempPd.title=[result objectForKey:@"text"];
                
                NSNumber * price=[result objectForKey:@"price"];
                tempPd.original_price=[price stringValue];
                
                NSDictionary * photo= [result objectForKey:@"photo"];
                if (![photo isEqual:[NSNull null]]) {
                    NSDictionary * style= [photo objectForKey:@"styles"];
                    NSDictionary *thumb= [style objectForKey:@"thumb"];
                    tempPd.photo= [thumb objectForKey:@"photo_url"];
                }
                [_searchArrayProduct2 addObject:tempPd];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
        _searchArrayPeople1=[_searchArrayProduct2 mutableCopy];
        
    }
    
    
    
    [_tableview reloadData];
    
    
}



- (void) parseProduct:(NSDictionary *) bulk
{
    for (NSDictionary *pdDic in bulk) {
        @try {
            
            
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
                NSDictionary *slider=[style objectForKey:@"small"];
                pd.photo= [slider objectForKey:@"photo_url"];
                
            }
            
            NSDictionary *video= [pdDic objectForKey:@"video"];
            if (![video isEqual:[NSNull null]]) {
                
                NSDictionary *thumbnail= [video objectForKey:@"thumbnail"];
                pd.videos=[thumbnail objectForKey:@"url"];
                
            }
            [_searchArrayProducts addObject:pd];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    }
    
   
    [self.tableview reloadData];
    
    
}

- (void) getSearchProducts
{
    
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *lim= [NSString stringWithFormat:@"%i", _DiscoverAllLimit];
    NSString *ofs= [NSString stringWithFormat:@"%i", _DiscoverProductOffset];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",ofs, @"offset",lim, @"limit",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/discover/app_search_only_products"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDicProducts= responseObject;
        if ([_responseDicProducts count]>0) {
            [self parseProduct:_responseDicProducts];
            ProductHere=true;
        }
        
        self.tableview.userInteractionEnabled=true;
        
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             self.tableview.userInteractionEnabled=true;
             
             NSLog(@"Error: %@", error);} // failure callback block
     ];
    
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
        specialPage.searchId=@"64367575756868";
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
    
    NSString *c=@"people";
    if ([_searchterm isEqualToString:@"workout"]) {
        c=@"workouts";
    }else if ([_searchterm isEqualToString:@"product"]) {
        c=@"products";
    }
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",ofs, @"offset",lim, @"limit",@"true", @"mobile",c, @"c",searchPeopleName, @"q",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/global/search"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        [self parseResponseDic:_searchterm];
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
    
    PeopleRequest *request = [PeopleRequest requestWithPeople];
    
    [self.service getProductUserRequest:request success:^(NSArray * results) {
        self.searchArrayFeature = [[NSMutableArray alloc] init];
        self.searchArrayProducts = [[NSMutableArray alloc] init];
        [self.searchArrayFeature addObjectsFromArray:results];
        self.tableview.userInteractionEnabled=true;
        [indicatorView removeFromSuperview];
        [self getSearchProducts];
        
    } failure:^(NSError * _Nonnull error) {
        self.tableview.userInteractionEnabled=true;
        [indicatorView removeFromSuperview];
    }];
    
}




- (void) addActivityIndicator
{
    indicatorView= [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-50, 220*[[FitmooHelper sharedInstance] frameRadio], 100, 100)];
    indicatorView.backgroundColor=[UIColor colorWithRed:174.0/255.0 green:182.0/255.0 blue:186.0/255.0 alpha:1];
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
    
    
   
    int count=(int)[_searchArrayProducts count]/3;
    if ([_searchArrayProducts count]%3!=0) {
        count=count+1;
    }
    count=count+2;

    
    return count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![_searchTermField.text isEqualToString:@""]) {
        
        if (indexPath.row==0) {
            
            SearchTapCell *cell =(SearchTapCell *) [self.tableview cellForRowAtIndexPath:indexPath];
            
            if (cell==nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchTapCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            
            if ([_searchterm isEqualToString:@"people"]) {
                [cell.peopleButton setTitleColor:[UIColor colorWithRed:16.0/255.0 green:156.0/255.0 blue:251.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            }else if ([_searchterm isEqualToString:@"workout"]) {
                [cell.workoutButton setTitleColor:[UIColor colorWithRed:205.0/255.0 green:103.0/255.0 blue:239.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            }else if ([_searchterm isEqualToString:@"product"]) {
                [cell.productButton setTitleColor:[UIColor colorWithRed:247.0/255.0 green:147.0/255.0 blue:30.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
            
            [cell.peopleButton addTarget:self action:@selector(peopleTapClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.workoutButton addTarget:self action:@selector(workoutTapClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.productButton addTarget:self action:@selector(productTapClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UIView *v= [[UIView alloc] initWithFrame:CGRectMake(5, 43, 310, 1)];
            v.backgroundColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
            v.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:v respectToSuperFrame:self.view];
            v.frame= CGRectMake(v.frame.origin.x, v.frame.origin.y, v.frame.size.width, 1);
            [cell.contentView addSubview:v];
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
            
            if (![self.searchterm isEqualToString:@"people"]) {
                text.hidden=true;
                inviteButton.hidden=true;
            }else
            {
                text.hidden=false;
                inviteButton.hidden=false;
            }
            
            return Cell;
        }
        
        
        SearchCell *cell =(SearchCell *) [self.tableview cellForRowAtIndexPath:indexPath];
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        @try {
            if ([self.searchterm isEqualToString:@"people"]) {
                User *temUser= [_searchArrayPeople1 objectAtIndex:indexPath.row-1];
                cell.temUser=temUser;
                [cell builtSearchCell];
                [cell.followButton setTag:indexPath.row+100];
                [cell.followButton addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
            }else if ([self.searchterm isEqualToString:@"workout"]){
                Workout *temWk=[_searchArrayPeople1 objectAtIndex:indexPath.row-1];
                cell.temWk=temWk;
                [cell builtWkSearchCell];
            }else if ([self.searchterm isEqualToString:@"product"]){
                Product *temPd=[_searchArrayPeople1 objectAtIndex:indexPath.row-1];
                cell.temPd=temPd;
                [cell builtPdSearchCell];
            }
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
        }
        
        
        UIView *v= [[UIView alloc] initWithFrame:CGRectMake(55, 59, 270, 1)];
        if (indexPath.row==[_searchArrayPeople1 count]) {
            v= [[UIView alloc] initWithFrame:CGRectMake(5, 59, 310, 1)];
        }
        v.backgroundColor=[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
        v.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:v respectToSuperFrame:self.view];
        [cell.contentView addSubview:v];
        v.frame= CGRectMake(v.frame.origin.x, v.frame.origin.y, v.frame.size.width, 1);
        return cell;
        
        
    }
    
    
    if (indexPath.row==0 ) {
        FollowTableCell *cell =(FollowTableCell *) [self.tableview cellForRowAtIndexPath:indexPath];
        
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FollowTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.celldelegate = self;
        cell.totalArray = self.searchArrayFeature;
        cell.titleLabel.text = @"FEATURED";
        cell.cellType = @"product";
      
        [cell.collectionView reloadData];
        
        contentHight=[NSNumber numberWithDouble:cell.bodyView.frame.size.height* SCREEN_RATIO_IPHONE];
        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
        
        return cell;
    }
    
    
    if (indexPath.row==1) {
        FollowTableCell *cell =(FollowTableCell *) [self.tableview cellForRowAtIndexPath:indexPath];
        
        if (cell==nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FollowTableCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.titleLabel.text = @"TRENDING PRODUCTS";
        cell.collectionView.hidden = true;
        
        contentHight=[NSNumber numberWithDouble:45* SCREEN_RATIO_IPHONE];
        [_heighArray replaceObjectAtIndex:indexPath.row withObject:contentHight];
        
        return cell;
    }
    
    
    
        SearchPhotoCell *cell =(SearchPhotoCell *) [self.tableview cellForRowAtIndexPath:indexPath];
        
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchPhotoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.searchType=@"product";
        int current=(int) (indexPath.row-1)*3;
        if (current<[_searchArrayProducts count]) {
            Product *pd1=[_searchArrayProducts objectAtIndex:current];
            cell.pd1= pd1;
            cell.view1Button.tag=pd1.product_id.integerValue;
            [cell.view1Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell setView1Item];
        }else
        {
            cell.view1.hidden=true;
        }
        
        if (current+1<[_searchArrayProducts count]) {
            Product *pd2=[_searchArrayProducts objectAtIndex:current+1];
            cell.pd2= pd2;
            cell.view2Button.tag=pd2.product_id.integerValue;
            [cell.view2Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell setView2Item];
        }else
        {
            cell.view2.hidden=true;
        }
        
        if (current+2<[_searchArrayProducts count]) {
            Product *pd3=[_searchArrayProducts objectAtIndex:current+2];
            cell.pd3= pd3;
            cell.view3Button.tag=pd3.product_id.integerValue;
            [cell.view3Button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell setView3Item];
        }else
        {
            cell.view3.hidden=true;
        }
        
        contentHight=[NSNumber numberWithDouble:105*[[FitmooHelper sharedInstance] frameRadio]+1] ;
        int count=(int)[_searchArrayProducts count]/3;
        if ([_searchArrayProducts count]%3!=0) {
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


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([_searchTermField.text isEqualToString:@""]) {
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
        
    }else
    {
        @try {
            
            if ([_searchterm isEqualToString:@"people"]) {
                if (indexPath.row>0&&indexPath.row<=[_searchArrayPeople1 count]) {
                    User *temUser= [_searchArrayPeople1 objectAtIndex:indexPath.row-1];
                    NSString *key=[NSString stringWithFormat:@"%d", temUser.user_id.intValue+100];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
                }
                
            }else if ([_searchterm isEqualToString:@"workout"]) {
                if (indexPath.row>0&&indexPath.row<=[_searchArrayPeople1 count]) {
                    Workout *wk= [_searchArrayPeople1 objectAtIndex:indexPath.row-1];
                    [self getSpecialPage:wk.workout_id];
                }
                
            }else if ([_searchterm isEqualToString:@"product"]) {
                if (indexPath.row>0&&indexPath.row<=[_searchArrayPeople1 count]) {
                    Product *pd= [_searchArrayPeople1 objectAtIndex:indexPath.row-1];
                    [self getSpecialPage:pd.product_id];
                }
                
            }
            
            
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
        }
        [_searchTermField resignFirstResponder];
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
            
            
            return 44*Radio;
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
            
            return 44*Radio;
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


- (void) initDiscoverValuable
{
    _DiscoverAllLimit=9;
    _DiscoverCount=1;
    _DiscoverProductOffset = 0;
    
}

- (void) initSearchValuable
{
    
    if ([_searchterm isEqualToString:@"people"]) {
        _PeopleOffset=0;
        _searchoffset=_PeopleOffset;
        _searchArrayPeople2= [[NSMutableArray alloc]init];
    }else if ([_searchterm isEqualToString:@"workout"]) {
        _WorkoutOffset=0;
        _searchoffset=_WorkoutOffset;
        _searchArrayWorkout2= [[NSMutableArray alloc]init];
    }else if ([_searchterm isEqualToString:@"product"]) {
        _StoreOffset=0;
        _searchoffset=_StoreOffset;
        _searchArrayProduct2= [[NSMutableArray alloc]init];
    }
    // _searchoffset=0;
    _searchlimit=15;
    _searchcount=1;
    
    
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
        if(self.tableview.contentOffset.y >= (self.tableview.contentSize.height - self.tableview.bounds.size.height)) {
            
            if (_count==0) {
                
                _DiscoverProductOffset+=9;
                [self getSearchProducts];
                
            }
            _count++;
            
            
        }else
        {
            _count=0;
        }
        
        
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


- (IBAction)workoutTapClick:(id)sender {
    _searchterm=@"workout";
    
    if ([_searchArrayWorkout2 count]==0) {
        [self initSearchValuable];
        [self getSearchItemForPeople];
    }else
    {
        _searchArrayPeople1= [_searchArrayWorkout2 mutableCopy];
        [self.tableview reloadData];
    }
    
}

- (IBAction)productTapClick:(id)sender {
    _searchterm=@"product";
    
    if ([_searchArrayProduct2 count]==0) {
        [self initSearchValuable];
        [self getSearchItemForPeople];
    }else
    {
        _searchArrayPeople1= [_searchArrayProduct2 mutableCopy];
        [self.tableview reloadData];
    }
}

- (IBAction)peopleTapClick:(id)sender {
    _searchterm=@"people";
    if ([_searchArrayPeople2 count]==0) {
        [self initSearchValuable];
        [self getSearchItemForPeople];
    }else
    {
        _searchArrayPeople1= [_searchArrayPeople2 mutableCopy];
        [self.tableview reloadData];
    }
}


- (IBAction)productButtonClick:(id)sender {
    UIButton *tempButton = (UIButton *)sender;
    NSInteger index=(NSInteger) tempButton.tag;
    NSString * key= [NSString stringWithFormat:@"%ld",(long)index];
    [self getSpecialPage:key];
}


- (IBAction)peopleButtonClick:(id)sender {
    
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
    self.backButtonClicked=true;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"back"];
}
- (IBAction)addUserButtonClick:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InviteViewController * inviteView = [mainStoryboard instantiateViewControllerWithIdentifier:@"InviteViewController"];
    
    [self.navigationController pushViewController:inviteView animated:YES];
}

@end
