//
//  InterestViewController.m
//  fitmoo
//
//  Created by hongjian lin on 5/26/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "InterestViewController.h"
#import "AFNetworking.h"
@interface InterestViewController ()
{
    NSNumber * contentHight;
}
@end

@implementation InterestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    contentHight=[NSNumber numberWithInteger:270*[[FitmooHelper sharedInstance] frameRadio]];
    _heighArray= [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithDouble: 380*[[FitmooHelper sharedInstance] frameRadio]],contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight,contentHight, nil];
    _searchArrayCategory= [[NSMutableArray alloc] init];
    _interestArray= [[NSMutableArray alloc] init];
    [self getCategoryAndLife];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initFrames
{
    _tableview.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableview respectToSuperFrame:self.view];
    _skipButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_skipButton respectToSuperFrame:self.view];
    
     //case iphone 4s
    if (self.view.frame.size.height<500) {

        _skipButton.frame= CGRectMake(_skipButton.frame.origin.x, self.view.frame.size.height-_skipButton.frame.size.height, _skipButton.frame.size.width, _skipButton.frame.size.height);
    }
    

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

        UILabel *label1= (UILabel *)[cell viewWithTag:1];
        label1.frame= CGRectMake(36, 29, 253, 51);
        label1.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:label1 respectToSuperFrame:self.view];
        
        
        UILabel *label2= (UILabel *)[cell viewWithTag:2];
        label2.frame= CGRectMake(36, 88, 248, 21);
        label2.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:label2 respectToSuperFrame:self.view];
        
        
        UIFont *font = [UIFont fontWithName:@"BentonSans-Light" size:label1.font.pointSize];
        NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:label1.text attributes:@{NSFontAttributeName: font}  ];
        [label1 setAttributedText:attributedString];
        
        UIFont *font1 = [UIFont fontWithName:@"BentonSans-Light" size:label2.font.pointSize];
        NSMutableAttributedString *attributedString1= [[NSMutableAttributedString alloc] initWithString:label2.text attributes:@{NSFontAttributeName: font1}  ];
        [label2 setAttributedText:attributedString1];
        
        
        contentHight=[NSNumber numberWithDouble:130* [[FitmooHelper sharedInstance] frameRadio]];
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
    [cell.button1.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [cell.button1 addSubview:headerImage2];
    
    cell.label1.text= user.name.uppercaseString;
    
    cell.button1.tag= index+10;
    [cell.button1 addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self checkExistInterest:user.user_id]) {
        cell.checkImage1.hidden=false;
    }
    
//    UIButton *b= [[UIButton alloc] initWithFrame:CGRectMake(57, 48, 44, 44)];
//    b.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:b respectToSuperFrame:nil];
//    [b setBackgroundImage:[UIImage imageNamed:@"checkmark.png"] forState:UIControlStateNormal];
//    b.exclusiveTouch=NO;
//    b.userInteractionEnabled=NO;
//    [cell.button1 addSubview:b];
    
    
    int count=(int)[_searchArrayCategory count]/2+1;
    if ([_searchArrayCategory count]%2>0) {
        count=count+1;
    }
    if ([_searchArrayCategory count]%2==0||indexPath.row!=count) {
        User *user1= [_searchArrayCategory objectAtIndex:index+1];
        cell.label2.text= user1.name.uppercaseString;
        
        cell.button2.tag= index+1+10;
        [cell.button2 addTarget:self action:@selector(categoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        AsyncImageView *headerImage2 = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0,cell.button2.frame.size.width, cell.button2.frame.size.height)];
        headerImage2.userInteractionEnabled = NO;
        headerImage2.exclusiveTouch = NO;
        headerImage2.layer.cornerRadius=headerImage2.frame.size.width/2;
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage2];
        
        headerImage2.imageURL =[NSURL URLWithString:user1.cover_photo_url];
        [cell.button2.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [cell.button2 addSubview:headerImage2];
        if ([self checkExistInterest:user1.user_id]) {
            cell.checkImage2.hidden=false;
        }
      //  [cell.button2 addSubview:b];
        
    }else
    {
        
        
        cell.button2.hidden=true;
        cell.label2.hidden=true;
        
    }
    
    
    
    contentHight=[NSNumber numberWithDouble:cell.button1.frame.size.height+2];
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


- (void) MakeExistInterest: (NSString *) interest_id
{
    if ([self checkExistInterest:interest_id]==false) {
         [_interestArray addObject:interest_id];
    }else
    {
        for (int i=0; i<[_interestArray count]; i++) {
            NSString *tem_id=[_interestArray objectAtIndex:i];
            if ([interest_id isEqualToString:tem_id]) {
                [_interestArray removeObjectAtIndex:i];
                
            }
        }

    }
}

- (BOOL) checkExistInterest: (NSString *) interest_id
{
    if ([_interestArray count]==0) {
       // [_interestArray addObject:interest_id];
        
        return false;
    }else
    {
        for (int i=0; i<[_interestArray count]; i++) {
            NSString *tem_id=[_interestArray objectAtIndex:i];
            if ([interest_id isEqualToString:tem_id]) {
          //      [_interestArray removeObjectAtIndex:i];
                return true;
            }
        }
 
    }

    
    return false;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)categoryButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger index= button.tag-10;
    User *user= [_searchArrayCategory objectAtIndex:index];
    [self MakeExistInterest:user.user_id];
    
    if ([_interestArray count]==0) {
        [_skipButton setTitle:@"SKIP" forState:UIControlStateNormal];
      //  [_skipButton setTintColor:[UIColor colorWithRed:74.0/255.0 green:80.0/255.0 blue:86.0/255.0 alpha:1]];

        [_skipButton setTitleColor:[UIColor colorWithRed:74.0/255.0 green:80.0/255.0 blue:86.0/255.0 alpha:1] forState:UIControlStateNormal];

        [_skipButton setBackgroundColor:[UIColor colorWithRed:192.0/255.0 green:200.0/255.0 blue:204.0/255.0 alpha:1]];
    }else
    {

        [_skipButton setTitle:@"GET STARTED" forState:UIControlStateNormal];
        [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [_skipButton setBackgroundColor:[UIColor colorWithRed:16.0/255.0 green:156.0/255.0 blue:251.0/255.0 alpha:1]];
    }
    
    
    [self.tableview reloadData];
    
    
    
}

- (IBAction)skipButtonClick:(id)sender {
    
     [[FitmooHelper sharedInstance] addActivityIndicator:self.view];
    
    if ([_interestArray count]==0) {
        [[UserManager sharedUserManager] getUserProfile:_localUser];
    }else
    {
        User *localUser= [[FitmooHelper sharedInstance] getUserLocally];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSString *interestKey=@"";
        for (int i=0; i<[_interestArray count]; i++) {
            NSString *s=[_interestArray objectAtIndex:i];
            
            if (i==0) {
                interestKey=s;
            }else
            {
                interestKey= [NSString stringWithFormat:@"%@,%@",interestKey, s];
            }
        }
        
    
        
        
        NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",interestKey, @"keywords",nil];
        NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl],@"/api/interests"];
        [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            _responseDic1= responseObject;
            [[UserManager sharedUserManager] getUserProfile:_localUser];
            
         
            
        } // success callback block
         
             failure:^(AFHTTPRequestOperation *operation, NSError *error){
            [[UserManager sharedUserManager] getUserProfile:_localUser];
                 NSLog(@"Error: %@", error);} // failure callback block
         ];

     
    }
}
@end
