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
}
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];

    contentHight=[NSNumber numberWithInteger:270*[[FitmooHelper sharedInstance] frameRadio]];
    _heighArray= [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithDouble: 380*[[FitmooHelper sharedInstance] frameRadio]],contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight, nil];
    _searchterm=@"";
    UINib *cellNib = [UINib nibWithNibName:@"FollowCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"FollowCollectionViewCell"];
  //  [self.bottomView setHidden:true];
    
    
    _searchArrayCategory= [[NSMutableArray alloc] init];
 
    [self getdiscoverItemForPeople];
    [self getCategoryAndLife];
    
    // Do any additional setup after loading the view.
}

- (void) addScrollView
{
    if (_scrollView!=nil) {
        [_scrollView removeFromSuperview];
        _scrollView=nil;
    }
    

    _scrollView= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 75, 320, 140)];
    _scrollView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_scrollView respectToSuperFrame:nil];
    _scrollView.delegate = self;
    
    int x= 0;
    for (int i=0; i<[_searchArrayCategory count]; i++) {
        User *tempUser= [_searchArrayCategory objectAtIndex:i];
        UIButton *b= [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 158, 140)];
        b.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:b respectToSuperFrame:self.view];
        [b setBackgroundColor:[UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.7]];
//        AsyncImageView *headerImage2 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0,b.frame.size.width, b.frame.size.height)];
//        headerImage2.userInteractionEnabled = NO;
//        headerImage2.exclusiveTouch = NO;
//        headerImage2.layer.cornerRadius=headerImage2.frame.size.width/2;
//        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
//       
//        headerImage2.imageURL =[NSURL URLWithString:tempUser.cover_photo_url];
      
//        [b addSubview:headerImage2];
         x=x+160;
         [b setTag:tempUser.user_id.intValue];
         UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(30, b.frame.size.height/2-45, b.frame.size.width-60, 90)];
        UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:14];
        NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:[tempUser.name uppercaseString] attributes:@{NSFontAttributeName: font}  ];
        label.userInteractionEnabled = NO;
        label.exclusiveTouch = NO;
        [label setAttributedText:attributedString];
        [label setTextColor:[UIColor whiteColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setNumberOfLines:3];
    
        [b addSubview:label];
        [b setTag:i+10];
        [b addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_scrollView addSubview:b];
    }
    
    _scrollView.contentSize= CGSizeMake(x*[[FitmooHelper sharedInstance] frameRadio], _scrollView.frame.size.height);
    
    [_buttomView addSubview:_scrollView];

}



- (void) initFrames
{
    double radio= self.view.frame.size.width/320;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(120*radio, 225*radio)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    _collectionView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_collectionView respectToSuperFrame:self.view];
    _leftButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftButton respectToSuperFrame:self.view];
    _headerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerView respectToSuperFrame:self.view];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    _featerLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_featerLabel respectToSuperFrame:self.view];
    _buttomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttomView respectToSuperFrame:self.view];
    _bodyView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyView respectToSuperFrame:self.view];
    _scrollView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_scrollView respectToSuperFrame:self.view];
    _tableview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableview respectToSuperFrame:self.view];
    _lifestytleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_lifestytleLabel respectToSuperFrame:self.view];

    if (self.view.frame.size.height<500) {
        
        _tableview.frame= CGRectMake(_tableview.frame.origin.x,_tableview.frame.origin.y, _tableview.frame.size.width, _tableview.frame.size.height-88);
        
    }
}

-(void) parseResponseDicDiscover
{
     if (_offset==0) {
     _searchArrayPeople= [[NSMutableArray alloc] init];
     }
        for (NSDictionary * result in _responseDic) {
            User *tempUser= [[User alloc]  init];
            NSNumber * following=[result objectForKey:@"is_following"];
            tempUser.is_following= [following stringValue];
          //  NSNumber * followers=[result objectForKey:@"followers"];
            tempUser.followers= [result objectForKey:@"followers"];
           
            
            NSDictionary * profile=[result objectForKey:@"profile"];
            NSDictionary *avatar=[profile objectForKey:@"avatars"];
            tempUser.profile_avatar_thumb=[avatar objectForKey:@"medium"];
            
            tempUser.name= [result objectForKey:@"full_name"];
            NSNumber * user_id=[result objectForKey:@"id"];
            tempUser.user_id= [user_id stringValue];
            
            [_searchArrayPeople addObject:tempUser];
        }
    [self.collectionView reloadData];
 
}


-(void) parseResponseDic
{
  
   
    _searchArrayCategory= [[NSMutableArray alloc] init];
   
        for (NSDictionary * result in _responseDic1) {
            User *tempUser= [[User alloc]  init];
        
            tempUser.cover_photo_url=[result objectForKey:@"photo_url"];
            tempUser.name= [result objectForKey:@"text"];
            NSNumber * user_id=[result objectForKey:@"id"];
            tempUser.user_id= [user_id stringValue];
            
              [_searchArrayCategory addObject:tempUser];
        }
 //   [self addScrollView];
    [self.tableview reloadData];
}

- (void) getCategoryAndLife
{
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/interests"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic1= responseObject;
        
       
        [self parseResponseDic];
       
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}

- (void) getdiscoverItemForPeople
{
      User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
      NSString *ofs= [NSString stringWithFormat:@"%i", _offset];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",ofs, @"offset",@"10", @"limit",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/users/recommended_users_mobile"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        [self parseResponseDicDiscover];
        
       
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);} // failure callback block
     ];

}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    
    int count=(int)[_searchArrayCategory count]/2+1;
    if ([_searchArrayCategory count]%2>0) {
        count=count+1;
    }
    
    
    return count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
        
         UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        [_bodyView removeFromSuperview];
        [cell.contentView addSubview:_bodyView];
        
        
        contentHight=[NSNumber numberWithDouble:_bodyView.frame.size.height];
         [_heighArray replaceObjectAtIndex:0 withObject:contentHight];
        return cell;
    }
    
    FollowHeaderCell *cell =(FollowHeaderCell *) [self.tableview cellForRowAtIndexPath:indexPath];
    
    if (cell==nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FollowHeaderCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    int index=(int) (indexPath.row-1)*2;
    
    User *user= [_searchArrayCategory objectAtIndex:index];
    
    AsyncImageView *headerImage2 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0,cell.button1.frame.size.width, cell.button1.frame.size.height)];
    headerImage2.userInteractionEnabled = NO;
    headerImage2.exclusiveTouch = NO;
    headerImage2.layer.cornerRadius=headerImage2.frame.size.width/2;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
    
    headerImage2.imageURL =[NSURL URLWithString:user.cover_photo_url];
    
    [cell.button1 addSubview:headerImage2];
    
    cell.label1.text= user.name;
    
    cell.button1.tag= index+10;
    [cell.button1 addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    int count=(int)[_searchArrayCategory count]/2+1;
    if ([_searchArrayCategory count]%2>0) {
        count=count+1;
    }
    if ([_searchArrayCategory count]%2==0||indexPath.row!=count) {
        User *user1= [_searchArrayCategory objectAtIndex:index+1];
        cell.label2.text= user1.name;
        
        cell.button2.tag= index+1+10;
        [cell.button2 addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        AsyncImageView *headerImage2 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0,cell.button2.frame.size.width, cell.button2.frame.size.height)];
        headerImage2.userInteractionEnabled = NO;
        headerImage2.exclusiveTouch = NO;
        headerImage2.layer.cornerRadius=headerImage2.frame.size.width/2;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
        
        headerImage2.imageURL =[NSURL URLWithString:user1.cover_photo_url];
        
        [cell.button2 addSubview:headerImage2];

        
    }else
    {
       
        
        cell.button2.hidden=true;
        cell.label2.hidden=true;
        
    }
    

    
    contentHight=[NSNumber numberWithDouble:cell.button1.frame.size.height+3];
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
    
    
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        
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
    
    

        NSNumber *height;
        if (indexPath.row<[_heighArray count]) {
            height= (NSNumber *)[_heighArray objectAtIndex:indexPath.row];
            
        }else
        {
            height=[NSNumber numberWithInt:contentHight.doubleValue];
        }
   //     NSLog(@"%ld",(long)height.integerValue);
        return height.doubleValue;
    

    

}



#pragma mark - UICollectionCellDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_searchArrayPeople count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FollowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FollowCollectionViewCell" forIndexPath:indexPath];
 
    User *tempUser= [_searchArrayPeople objectAtIndex:indexPath.row];
    cell.userLabel.text= tempUser.followers;
    cell.nameLabel.text= tempUser.name;
    
    
    AsyncImageView *headerImage2 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0,cell.image.frame.size.width, cell.image.frame.size.height)];
    headerImage2.userInteractionEnabled = NO;
    headerImage2.exclusiveTouch = NO;
    headerImage2.layer.cornerRadius=headerImage2.frame.size.width/2;
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
    
    headerImage2.imageURL =[NSURL URLWithString:tempUser.profile_avatar_thumb];
    [cell.image.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];

    [cell.image addSubview:headerImage2];
    
    if ([tempUser.is_following isEqualToString:@"0"]) {
         [cell.followButton setBackgroundImage:[UIImage imageNamed:@"followsection_smallfollowbtn.png"] forState:UIControlStateNormal];
        
    }else
    {
         [cell.followButton setBackgroundImage:[UIImage imageNamed:@"followsection_smallfollowingbtn.png"] forState:UIControlStateNormal];
    }
    
    
    cell.followButton.tag= indexPath.row+100;
    [cell.followButton addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    

    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger  selectedImageIndex = indexPath.row;
    User *tempUser= [_searchArrayPeople objectAtIndex:selectedImageIndex];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:tempUser.user_id];
    
  //  [collectionView reloadData];
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

- (IBAction)followButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag-100;
 
        User *user= [_searchArrayPeople objectAtIndex:index];
        
        if ([user.is_following isEqualToString:@"0"]) {
               [[UserManager sharedUserManager] performFollow:user.user_id];
                user.is_following=@"1";
            [button setBackgroundImage:[UIImage imageNamed:@"followsection_smallfollowingbtn.png"] forState:UIControlStateNormal];
        }else
        {
             [[UserManager sharedUserManager] performUnFollow:user.user_id];
             user.is_following=@"0";
             [button setBackgroundImage:[UIImage imageNamed:@"followsection_smallfollowbtn.png"] forState:UIControlStateNormal];
        }


}



-(BOOL) textFieldShouldReturn:(UITextField *)textField{
   
    [textField resignFirstResponder];
    return YES;
}

-(void) initValuable
{
    _offset=0;
    _limit=10;
    _count=1;
    
    //   _homeFeedArray= [[NSMutableArray alloc]init];
}
- (void)scrollViewDidScroll: (UIScrollView*)scroll {
    
    
    if(self.collectionView.contentOffset.x<-75){
        if (_count==0) {
            [self initValuable];
            [self getdiscoverItemForPeople];
        }
        _count++;
        //it means table view is pulled down like refresh
        return;
    }
    else if(self.collectionView.contentOffset.x >= (self.collectionView.contentSize.width - self.collectionView.bounds.size.width+20)) {
        //   NSLog(@"bottom!");
        //   NSLog(@"%f",self.tableView.contentOffset.y );
        //   NSLog(@"%f",self.tableView.contentSize.height - self.tableView.bounds.size.height );
        
        if (_count==0) {
            if (self.collectionView.contentOffset.x<0) {
                _offset =0;
            }else
            {
                _offset +=10;
                
            }
            [self getdiscoverItemForPeople];
            
        }
        _count++;
        
        
    }else
    {
        _count=0;
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


- (IBAction)backButtonClick:(id)sender {
    //  [[NSNotificationCenter defaultCenter] postNotificationName:@"swipeHandler" object:Nil];
       [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"6.1"];
}
@end
