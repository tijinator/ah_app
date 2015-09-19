//
//  ShopPurchaseViewController.m
//  fitmoo
//
//  Created by hongjian lin on 9/17/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ShopPurchaseViewController.h"
#import <SwipeBack/SwipeBack.h>
#import "AFNetworking.h"
@interface ShopPurchaseViewController ()
{
    NSNumber * contentHight;
    NSInteger selectedIndex;
    UIView *indicatorView;
}
@end

@implementation ShopPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.swipeBackEnabled = NO;
    selectedIndex=0;
    contentHight=[NSNumber numberWithInteger:110*[[FitmooHelper sharedInstance] frameRadio]];
    [self initFrames];

    [self getOrders];
    
    // Do any additional setup after loading the view.
}

- (void) getOrders
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",@"200",@"limit",@"0",@"offset",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/order/order_details"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        _responseDic= responseObject;
        
        
        
        [self.tableView reloadData];
        
    } // success callback block
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);
         
             [indicatorView removeFromSuperview];} // failure callback block
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
    
    
    return 1;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ShopPurchaseCell *cell =(ShopPurchaseCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopPurchaseCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
//    cell.address=[_addressArray objectAtIndex:indexPath.section];
//    [cell builtCell];
//    cell.editButton.hidden=true;
//    
//    cell.useThisAddButton.hidden=false;
//    cell.useThisAddButton.tag=indexPath.section;
//    
//    [cell.useThisAddButton addTarget:self action:@selector(useThisAddButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
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




- (void) initFrames
{
    _tableView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableView respectToSuperFrame:self.view];
    _topView.frame= CGRectMake(0, 0, 320, 60);
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _leftButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftButton respectToSuperFrame:self.view];
    
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    

    
    if (self.view.frame.size.height<500) {
        
        _tableView.frame= CGRectMake(_tableView.frame.origin.x,_tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height-88);
        
    }
    
    
    
    
}

- (IBAction)backButtonClick:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSideMenuAction" object:@"back"];
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
