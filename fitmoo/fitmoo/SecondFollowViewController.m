//
//  SecondFollowViewController.m
//  fitmoo
//
//  Created by hongjian lin on 5/19/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "SecondFollowViewController.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface SecondFollowViewController ()
{
    NSNumber * contentHight;
    
}
@end

@implementation SecondFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initFrames];
    [self getdiscoverItemForPeople];
    
     self.tableView.tableFooterView = [[UIView alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
   
  int count=(int)[_searchArrayPeople count]/2+1;
    if ([_searchArrayPeople count]%2>0) {
        count=count+1;
    }
    
    
    return count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (indexPath.row==0) {
        UITableViewCell *cell=  [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        UIImageView *image=(UIImageView *) [cell viewWithTag:1];
        image.frame= CGRectMake(0, 0, 320, 320);
        image.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:image respectToSuperFrame:nil];
        
        AsyncImageView *headerImage2 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0,image.frame.size.width, image.frame.size.height)];
        headerImage2.userInteractionEnabled = NO;
        headerImage2.exclusiveTouch = NO;
        headerImage2.layer.cornerRadius=headerImage2.frame.size.width/2;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
        
        headerImage2.imageURL =[NSURL URLWithString:_keyword_photo_url];
        
        [image.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [image addSubview:headerImage2];
        

      
        UILabel *label= (UILabel *) [cell viewWithTag:2];
        label.frame= CGRectMake(90, 115, 120, 90);
        label.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:label respectToSuperFrame:nil];
        UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:18];
        NSString *string= [NSString stringWithFormat:@"%@",_keyword_text];
        NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:string.uppercaseString attributes:@{NSFontAttributeName: font}  ];

        [label setAttributedText:attributedString];

        UILabel *label1= (UILabel *) [cell viewWithTag:3];
        label1.frame= CGRectMake(16, 345, 300, 21);
        label1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:label1 respectToSuperFrame:nil];
        
        
        contentHight=[NSNumber numberWithDouble:380* [[FitmooHelper sharedInstance] frameRadio]];
        
        return cell;
    }
    
    FollowCell *cell =(FollowCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FollowCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        int index=(int) (indexPath.row-1)*2;
        
        User *user= [_searchArrayPeople objectAtIndex:index];
       
        cell.nameLabel1.text= user.name;
        cell.followLabel1.text=user.followers;
      
        AsyncImageView *headerImage1 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0,cell.image1.frame.size.width, cell.image1.frame.size.height)];
        headerImage1.userInteractionEnabled = NO;
        headerImage1.exclusiveTouch = NO;
        headerImage1.layer.cornerRadius=headerImage1.frame.size.width/2;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage1];
        
        headerImage1.imageURL =[NSURL URLWithString:user.cover_photo_url];
        
        [cell.image1.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [cell.image1 addSubview:headerImage1];
        
        if ([user.is_following isEqualToString:@"0"]) {
            [cell.followButton1 setBackgroundImage:[UIImage imageNamed:@"followsection_followbtn.png"] forState:UIControlStateNormal];
            
        }else
        {
            [cell.followButton1 setBackgroundImage:[UIImage imageNamed:@"followsection_followingbtn.png"] forState:UIControlStateNormal];
        }
        
        cell.followButton1.tag= index+100;
        [cell.followButton1 addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.clickbutton1.tag=user.user_id.intValue;
        [cell.clickbutton1 addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        int count=(int)[_searchArrayPeople count]/2+1;
        if ([_searchArrayPeople count]%2>0) {
            count=count+1;
        }
        
      
        
        if ([_searchArrayPeople count]%2==0) {
            User *user1= [_searchArrayPeople objectAtIndex:index+1];
            cell.nameLabel2.text=user1.name;
            cell.followLabel2.text=user1.followers;
            AsyncImageView *headerImage2 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0,cell.image2.frame.size.width, cell.image2.frame.size.height)];
            headerImage2.userInteractionEnabled = NO;
            headerImage2.exclusiveTouch = NO;
            headerImage2.layer.cornerRadius=headerImage2.frame.size.width/2;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
            
            headerImage2.imageURL =[NSURL URLWithString:user1.cover_photo_url];
            
            [cell.image2.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
            [cell.image2 addSubview:headerImage2];
            
            if ([user1.is_following isEqualToString:@"0"]) {
                [cell.followButton2 setBackgroundImage:[UIImage imageNamed:@"followsection_followbtn.png"] forState:UIControlStateNormal];
                
            }else
            {
                [cell.followButton2 setBackgroundImage:[UIImage imageNamed:@"followsection_followingbtn.png"] forState:UIControlStateNormal];
            }
            cell.followButton2.tag= index+1+100;
            [cell.followButton2 addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];

            cell.clickbutton2.tag=user1.user_id.intValue;
            [cell.clickbutton2 addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }else
        {
            if (indexPath.row!=(count-1)) {
            
            User *user1= [_searchArrayPeople objectAtIndex:index+1];
            cell.nameLabel2.text=user1.name;
            cell.followLabel2.text=user1.followers;
            AsyncImageView *headerImage2 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0,cell.image2.frame.size.width, cell.image2.frame.size.height)];
            headerImage2.userInteractionEnabled = NO;
            headerImage2.exclusiveTouch = NO;
            headerImage2.layer.cornerRadius=headerImage2.frame.size.width/2;
            [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
            
            headerImage2.imageURL =[NSURL URLWithString:user1.cover_photo_url];
            
            [cell.image2.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
            [cell.image2 addSubview:headerImage2];
            
            if ([user1.is_following isEqualToString:@"0"]) {
                [cell.followButton2 setBackgroundImage:[UIImage imageNamed:@"followsection_followbtn.png"] forState:UIControlStateNormal];
                
            }else
            {
                [cell.followButton2 setBackgroundImage:[UIImage imageNamed:@"followsection_followingbtn.png"] forState:UIControlStateNormal];
            }
            cell.followButton2.tag= index+1+100;
            [cell.followButton2 addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.clickbutton2.tag=user1.user_id.intValue;
            [cell.clickbutton2 addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                cell.view2.hidden=true;
            }

            
        }
        
            
        
       
     
        
        contentHight=[NSNumber numberWithDouble:cell.view1.frame.size.height];
    }
    
    
 
    
    return cell;
}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

//- (CGFloat)tableView:(UITableView *)tableView
//estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSNumber *height;
// 
//    return height.integerValue;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    NSNumber *height=contentHight;

    return height.integerValue;
}


- (void) getdiscoverItemForPeople
{
    User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/interests/",_searchId,@"/associated_ambassadors"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        _responseDic= responseObject;
        
        [self parseResponseDicDiscover];
        
        
    } // success callback block
     
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);} // failure callback block
     ];
    
}

-(void) parseResponseDicDiscover
{
    _searchArrayPeople= [[NSMutableArray alloc] init];
    
      for (NSDictionary * result in _responseDic) {
          
          if ([result objectForKey:@"keyword_photo_url"]==nil ) {
              User *user= [[User alloc] init];
              NSNumber * follower=[result objectForKey:@"follower_count"];
              user.followers= [follower stringValue];
              NSNumber * user_id=[result objectForKey:@"id"];
              user.user_id= [user_id stringValue];
              user.name= [result objectForKey:@"name"];
              user.cover_photo_url=[result objectForKey:@"photo_url"];
              user.is_following=@"0";
              
              [_searchArrayPeople addObject:user];

          }else
          {
              _keyword_photo_url=[result objectForKey:@"keyword_photo_url"];
              _keyword_text=[result objectForKey:@"keyword_text"];
          }
          
      }
    
       [self.tableView reloadData];
    
}
- (void) initFrames
{
    double radio= self.view.frame.size.width/320;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(120*radio, 225*radio)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    

    _leftButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftButton respectToSuperFrame:self.view];
    _headerView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_headerView respectToSuperFrame:self.view];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];

    _tableView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableView respectToSuperFrame:self.view];

    if (self.view.frame.size.height<500) {
        
        _tableView.frame= CGRectMake(_tableView.frame.origin.x,_tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height-88);
        
    }
}

- (IBAction)cellButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *key= [NSString stringWithFormat:@"%ld",(long)button.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:key];
    
}

- (IBAction)followButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index=(NSInteger) button.tag-100;
    
    User *user= [_searchArrayPeople objectAtIndex:index];
    
    if ([user.is_following isEqualToString:@"0"]) {
        [[UserManager sharedUserManager] performFollow:user.user_id];
        user.is_following=@"1";
        [button setBackgroundImage:[UIImage imageNamed:@"followsection_followingbtn.png"] forState:UIControlStateNormal];
    }else
    {
        [[UserManager sharedUserManager] performUnFollow:user.user_id];
        user.is_following=@"0";
        [button setBackgroundImage:[UIImage imageNamed:@"followsection_followbtn.png"] forState:UIControlStateNormal];
    }
    
    
}

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
