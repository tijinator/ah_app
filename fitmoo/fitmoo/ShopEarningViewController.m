//
//  ShopEarningViewController.m
//  fitmoo
//
//  Created by hongjian lin on 9/17/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ShopEarningViewController.h"
#import <SwipeBack/SwipeBack.h>
#import "AFNetworking.h"
#import "Stripe.h"
@interface ShopEarningViewController ()
{
    NSNumber * contentHight;
    NSInteger selectedIndex;
      UIView *indicatorView;
}
@end

@implementation ShopEarningViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.swipeBackEnabled = NO;
    selectedIndex=0;
    contentHight=[NSNumber numberWithInteger:260*[[FitmooHelper sharedInstance] frameRadio]];
    [self initFrames];
    
    _redeemArray= [[NSMutableArray alloc] init];
    
    _tableType=@"earning";
    
    [self getEarning];
    
    // Do any additional setup after loading the view.
}


- (void) parseEarning
{
    _redeemArray= [[NSMutableArray alloc] init];
    
    _earning= [[Earning alloc] init];
    

    NSNumber *completed_endorsements=[_responseDic objectForKey:@"completed_endorsements"];
    _earning.completed_endorsements=[completed_endorsements stringValue];
    
    NSNumber *completed_sales=[_responseDic objectForKey:@"completed_sales"];
    _earning.completed_sales=[completed_sales stringValue];
    
    NSNumber *pending_endorsements=[_responseDic objectForKey:@"pending_endorsements"];
    _earning.pending_endorsements=[pending_endorsements stringValue];
    
    NSNumber *pending_sales=[_responseDic objectForKey:@"pending_sales"];
    _earning.pending_sales=[pending_sales stringValue];
    
    NSNumber *pending_total=[_responseDic objectForKey:@"pending_total"];
    _earning.pending_total=[pending_total stringValue];
    
    NSNumber *redeemable=[_responseDic objectForKey:@"redeemable"];
    _earning.redeemable=[redeemable stringValue];
    
    NSNumber *redeemed=[_responseDic objectForKey:@"redeemed"];
    _earning.redeemed=[redeemed stringValue];
    
    NSNumber *total_earnings=[_responseDic objectForKey:@"total_earnings"];
    _earning.total_earnings=[total_earnings stringValue];
    
  
    NSDictionary *redemptionsDic=[_responseDic objectForKey:@"redemptions"];
    
    for (NSDictionary *dic in redemptionsDic) {
     
        [_earning resetRedeem];
        _earning.Redeem.created_at=[dic objectForKey:@"created_at"];
        
      
        _earning.Redeem.deposited_amount=[dic objectForKey:@"deposited_amount"];
        
       
        _earning.Redeem.full_amount=[dic objectForKey:@"full_amount"];
        
      
        _earning.Redeem.withdrawal_fee=[dic objectForKey:@"withdrawal_fee"];
        
        [_earning.RedeemArray addObject:_earning.Redeem];
    }
    
    
}


- (void) getEarning
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/users/me/balance"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        _responseDic= responseObject;
        
        
        [self parseEarning];
        [self.tableView reloadData];
        
    } // success callback block
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
             
             [indicatorView removeFromSuperview];} // failure callback block
     ];
    
}



- (void) initFrames
{
    _tableView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableView respectToSuperFrame:self.view];
    _topView.frame= CGRectMake(0, 0, 320, 60);
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _leftButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftButton respectToSuperFrame:self.view];
    
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    
    _BuyNowButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_BuyNowButton respectToSuperFrame:self.view];
    
    
    
  
    
    if (self.view.frame.size.height<500) {
        
        _tableView.frame= CGRectMake(_tableView.frame.origin.x,_tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height-88);
        
    }
    
    
    
    
}



#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 45.0f;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 45)];
    [view setBackgroundColor:[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0]];
    
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(159*[[FitmooHelper sharedInstance] frameRadio], 5, 1, 35)];
    [view2 setBackgroundColor:[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0]];

    
    
    
    
    UILabel *nameLabel=[[UILabel alloc] init];
    nameLabel.frame= CGRectMake(0, 7, 159, 30);
    nameLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel respectToSuperFrame:self.view];
    UIColor *fontColor= [UIColor colorWithRed:141.0/255.0 green:154.0/255.0 blue:160.0/255.0 alpha:1.0];
    UIColor *fontColor1= [UIColor blackColor];
    UIFont *font= [UIFont fontWithName:@"BentonSans-Bold" size:(CGFloat)(11)];
    nameLabel.font=font;
    nameLabel.textColor=fontColor;
    
    UILabel *nameLabel1=[[UILabel alloc] init];
    nameLabel1.frame= CGRectMake(161, 7, 159, 30);
    nameLabel1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:nameLabel1 respectToSuperFrame:self.view];
    
    if ([_tableType isEqualToString:@"earning"]) {
        nameLabel1.textColor=fontColor;
        nameLabel.textColor=fontColor1;
    }else
    {
        nameLabel1.textColor=fontColor1;
        nameLabel.textColor=fontColor;
    }
    
    nameLabel.textAlignment=NSTextAlignmentCenter;
    nameLabel1.textAlignment=NSTextAlignmentCenter;
    
    nameLabel1.font=font;
    
    
    
    nameLabel1.text=@"REDEMPTION HISTORY";
    
    
    nameLabel.text=@"CURRENT BALANCE";
    
    
    nameLabel1.tag= section+10;
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(redemButtonClick:)];
    tapGestureRecognizer1.numberOfTapsRequired = 1;
    [nameLabel1 addGestureRecognizer:tapGestureRecognizer1];
    nameLabel1.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tapGestureRecognizer10 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(earningButtonClick:)];
    tapGestureRecognizer10.numberOfTapsRequired = 1;
    [nameLabel addGestureRecognizer:tapGestureRecognizer10];
    nameLabel.userInteractionEnabled=YES;
    
    
    [view1 addSubview:nameLabel];
    [view1 addSubview:nameLabel1];
    [view1 addSubview:view2];
    [view addSubview:view1];
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if ([_tableType isEqualToString:@"redem"]) {
        return [_earning.RedeemArray count];
    }
    
    return 1;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if ([_tableType isEqualToString:@"redem"]) {
         ShopRedemCell *cell =(ShopRedemCell *) [self.tableView cellForRowAtIndexPath:indexPath];
         if (cell == nil)
         {
             NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopRedemCell" owner:self options:nil];
             cell = [nib objectAtIndex:0];
         }
         
         cell.redeem=[_earning.RedeemArray objectAtIndex:indexPath.row];
         [cell buildCell];
         
         
         contentHight=[NSNumber numberWithInt:cell.contentView.frame.size.height];
         return cell;
         

    }
    
    
    ShopEarningCell *cell =(ShopEarningCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopEarningCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.earning=_earning;
    [cell buildCell];

    
    contentHight=[NSNumber numberWithInt:cell.contentView.frame.size.height];
    return cell;
    
    
    
    
    
    
    
    
}



- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    
}

// multy high table cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return contentHight.intValue;
}

- (IBAction)redemButtonClick:(id)sender
{
    _tableType=@"redem";
    [self.tableView reloadData];
}
- (IBAction)earningButtonClick:(id)sender
{
     _tableType=@"earning";
     [self.tableView reloadData];
}

- (IBAction)backButtonClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"back"];
}

- (IBAction)BuyNowButtonClick:(id)sender
{
    
    
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

@end
