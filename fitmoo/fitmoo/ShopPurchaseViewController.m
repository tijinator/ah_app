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

   
    
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
     [self getOrders];
}

- (void) parstOrders
{
    
    _orderArray= [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in _responseDic) {
        
        ShopOrder *order= [[ShopOrder alloc] init];
        
        order.title= [dic objectForKey:@"title"];
        order.endorser_name= [dic objectForKey:@"endorser_name"];
        if ([order.endorser_name isEqual:[NSNull null]]) {
            order.endorser_name=@"";
        }
        
        order.seller_name= [dic objectForKey:@"seller_name"];
        order.status= [dic objectForKey:@"status"];
        
        NSNumber *order_id= [dic objectForKey:@"order_id"];
        order.order_id= [order_id stringValue];
        
        order.placed_at= [dic objectForKey:@"placed_at"];
        order.updated_at= [dic objectForKey:@"updated_at"];
        order.payment_status= [dic objectForKey:@"payment_status"];
        order.image_url= [dic objectForKey:@"image_url"];
        order.options= [dic objectForKey:@"options"];
        
        if ([order.options isEqual:[NSNull null]]) {
            order.options=@"";
        }

        
        NSNumber *o_id= [dic objectForKey:@"id"];
        order.o_id= [o_id stringValue];
        
        NSNumber *tracking_number= [dic objectForKey:@"tracking_number"];
        if ([tracking_number isEqual:[NSNull null]]) {
         order.tracking_number=@"";
        }else
        {
        order.tracking_number=[dic objectForKey:@"tracking_number"];
        }
      
        order.total= [dic objectForKey:@"total"];
        order.order_shipping_total=  [dic objectForKey:@"order_shipping_total"];
      
        NSDictionary *shippingDictionary=[dic objectForKey:@"shipping_address"];
        order.shippingAddress.full_name=[shippingDictionary objectForKey:@"full_name"];
        order.shippingAddress.address1=[shippingDictionary objectForKey:@"address1"];
        order.shippingAddress.city=[shippingDictionary objectForKey:@"city"];
        order.shippingAddress.state_name=[shippingDictionary objectForKey:@"state_name"];
        order.shippingAddress.zipcode=[shippingDictionary objectForKey:@"zipcode"];
        
        
        NSDictionary *billingDictionary=[dic objectForKey:@"billing_address"];
        order.billingAddress.full_name=[billingDictionary objectForKey:@"full_name"];
        order.billingAddress.address1=[billingDictionary objectForKey:@"address1"];
        order.billingAddress.city=[billingDictionary objectForKey:@"city"];
        order.billingAddress.state_name=[billingDictionary objectForKey:@"state_name"];
        order.billingAddress.zipcode=[billingDictionary objectForKey:@"zipcode"];
        
        [_orderArray addObject:order];
    }
    
    
    [self.tableView reloadData];
}


- (void) getOrders
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",@"200",@"limit",@"0",@"offset",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/orders/order_details"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        _responseDic= responseObject;
        
        
        [self parstOrders];
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
    
    
    return [_orderArray count];
    
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
    
    cell.order= [_orderArray objectAtIndex:indexPath.row];
    [cell buildCell];
    
    
    
    contentHight=[NSNumber numberWithInt:cell.contentView.frame.size.height];
    return cell;
    
    
}



- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    ShopOrderDetailViewController *ordrVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ShopOrderDetailViewController"];
    
    ordrVC.order= [_orderArray objectAtIndex:indexPath.row];
    
    
    [self.navigationController pushViewController:ordrVC animated:YES];

    
    
    
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
