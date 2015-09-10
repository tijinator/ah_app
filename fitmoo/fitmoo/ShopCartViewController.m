//
//  ShopCartViewController.m
//  fitmoo
//
//  Created by hongjian lin on 9/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ShopCartViewController.h"
#import <SwipeBack/SwipeBack.h>
#import "AFNetworking.h"
@interface ShopCartViewController ()
{
 
    NSNumber * contentHight;
    NSString *deleteCartId;

}
@end

@implementation ShopCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initFrames];
    contentHight=[NSNumber numberWithInteger:165*[[FitmooHelper sharedInstance] frameRadio]];
    self.navigationController.swipeBackEnabled = YES;
    [self getShopCart];
    // Do any additional setup after loading the view.
}


-(void) generateShopCard: (NSDictionary *) dic
{
    
    _shopCart= [[ShopCart alloc] init];
    
    _shopCart.buyer_email= [dic objectForKey:@"buyer_email"];
    
    NSNumber *shopcart_id=[dic objectForKey:@"id"];
    _shopCart.shopcart_id=[shopcart_id stringValue];
    _shopCart.item_count=[dic objectForKey:@"item_count"];
    NSNumber *subtotal=[dic objectForKey:@"subtotal"];
    _shopCart.subtotal=[subtotal stringValue];
    NSNumber *shipping=[dic objectForKey:@"shipping"];
    _shopCart.shipping=[shipping stringValue];
    NSNumber *tax=[dic objectForKey:@"tax"];
    _shopCart.tax=[tax stringValue];
    NSNumber *total=[dic objectForKey:@"total"];
    _shopCart.total=[total stringValue];
    NSNumber *verify_for_checkout=[dic objectForKey:@"verify_for_checkout"];
    _shopCart.verify_for_checkout=[verify_for_checkout stringValue];
    
    NSDictionary *order_details= [dic objectForKey:@"order_details"];
    
    for (NSDictionary *detail in order_details) {
        [_shopCart resetshopCartDetail];
         NSNumber *cart_shipping=[detail objectForKey:@"cart_shipping"];
        _shopCart.shop_cart_detail.cart_shipping= [cart_shipping stringValue];
        
        NSNumber *cart_subtotal=[detail objectForKey:@"cart_subtotal"];
        _shopCart.shop_cart_detail.cart_subtotal= [cart_subtotal stringValue];
        
        NSNumber *cart_total=[detail objectForKey:@"cart_total"];
        _shopCart.shop_cart_detail.cart_total= [cart_total stringValue];

        _shopCart.shop_cart_detail.customer_service_email= [detail objectForKey:@"customer_service_email"];
        
        _shopCart.shop_cart_detail.customer_service_no= [detail objectForKey:@"customer_service_no"];
        
        NSNumber *endorser=[detail objectForKey:@"endorser"];
        _shopCart.shop_cart_detail.endorser= [endorser stringValue];
        
        _shopCart.shop_cart_detail.endorser_name= [detail objectForKey:@"endorser_name"];
        _shopCart.shop_cart_detail.endorser_profile_photo_url= [detail objectForKey:@"endorser_profile_photo_url"];
        
        NSNumber *shop_cart_detail_id=[detail objectForKey:@"id"];
        _shopCart.shop_cart_detail.shop_cart_detail_id= [shop_cart_detail_id stringValue];
        
        
        _shopCart.shop_cart_detail.item_count= [detail objectForKey:@"item_count"];
        _shopCart.shop_cart_detail.item_details= [detail objectForKey:@"item_details"];
        _shopCart.shop_cart_detail.item_photo_url= [detail objectForKey:@"item_photo_url"];
         NSNumber *price=[detail objectForKey:@"price"];
        _shopCart.shop_cart_detail.price= [price stringValue];
        
         NSNumber *item_price=[detail objectForKey:@"item_price"];
        _shopCart.shop_cart_detail.item_price= [item_price stringValue];
        
         NSNumber *quantity=[detail objectForKey:@"quantity"];
        _shopCart.shop_cart_detail.quantity= [quantity stringValue];
        
        _shopCart.shop_cart_detail.refund_policy= [detail objectForKey:@"refund_policy"];
        
        NSNumber *seller_id=[detail objectForKey:@"seller_id"];
        _shopCart.shop_cart_detail.seller_id= [seller_id stringValue];
        
        _shopCart.shop_cart_detail.seller_name= [detail objectForKey:@"seller_name"];
        _shopCart.shop_cart_detail.seller_profile_photo_url= [detail objectForKey:@"seller_profile_photo_url"];
        _shopCart.shop_cart_detail.title= [detail objectForKey:@"title"];
        
        
        [_shopCart.shop_cart_details addObject:_shopCart.shop_cart_detail];
        
    }
    
}

- (void) deleteCart:(NSString *)cartId
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",cartId, @"cart_id",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/cart/remove"];
    [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){

        
    } // success callback block
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             NSLog(@"Error: %@", error);} // failure callback block
     ];

}

-(void) getShopCart
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",nil];
    NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/cart"];
    [manager GET: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        _responseDic= responseObject;
        NSNumber *empty=[_responseDic objectForKey:@"empty"];
        
        if (empty.intValue==1) {
            
        }else
        {
        [self generateShopCard:_responseDic];
        [self.tableView reloadData];
        }
        
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
    
    if (_shopCart != nil) {
        return [_shopCart.shop_cart_details count]+1;
    }
  
    
    
    return 1;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   // lastIndex
    if (indexPath.row==[_shopCart.shop_cart_details count]) {
        ShopInfoTotalCell *cell =(ShopInfoTotalCell *) [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopInfoTotalCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if (_shopCart!=nil) {
            
            cell.label4.text=[NSString stringWithFormat:@"$%0.2f", _shopCart.subtotal.floatValue];
            cell.label5.text=[NSString stringWithFormat:@"$%0.2f", _shopCart.shipping.floatValue];
            cell.label6.text=[NSString stringWithFormat:@"$%0.2f", _shopCart.total.floatValue];
            cell.label7.text=[NSString stringWithFormat:@"$%0.2f", _shopCart.tax.floatValue];
            [cell.checkoutButton addTarget:self action:@selector(BuyNowButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
  
        

        return cell;
    }
    
    
    
    ShopInfoCell *cell =(ShopInfoCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopInfoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.shopCart=_shopCart;
    cell.shopCartDetail=[_shopCart.shop_cart_details objectAtIndex:indexPath.row];
    
    [cell buildCell];
    

    [cell.DeleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
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
    
    _BuyNowButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_BuyNowButton respectToSuperFrame:self.view];
    
 
    
    if (self.view.frame.size.height<500) {
        
        _tableView.frame= CGRectMake(_tableView.frame.origin.x,_tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height-88);
        
    }
    
    
   
    
}


- (void) openShopCheckouPage
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
    ShopCheckoutViewController *ShopCheckout = [mainStoryboard instantiateViewControllerWithIdentifier:@"ShopCheckoutViewController"];
    
    
    [self.navigationController pushViewController:ShopCheckout animated:YES];
}


- (IBAction)BuyNowButtonClick:(id)sender
{
    [self openShopCheckouPage];
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 1)
    {
      
        [self deleteCart:deleteCartId];
        
        for (int i=0; i<[_shopCart.shop_cart_details count]; i++) {
            [_shopCart resetshopCartDetail];
            _shopCart.shop_cart_detail= [_shopCart.shop_cart_details objectAtIndex:i];
            if ([deleteCartId isEqualToString:_shopCart.shop_cart_detail.shop_cart_detail_id]) {
                [_shopCart.shop_cart_details removeObjectAtIndex:i];
            }
        }
        
        [self.tableView reloadData];
        
        
    }
    
    
}
- (IBAction)deleteButtonClick:(id)sender
{
    UIButton *b=(UIButton *)sender;
    deleteCartId= [NSString stringWithFormat:@"%ld", (long)b.tag];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete Cart"
                                                   message:@"Are you sure you want to delete this item?"
                                                  delegate:self
                                         cancelButtonTitle:@"No"
                                         otherButtonTitles:@"Yes",nil];
    [alert show];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"HasSeenPopup"];
    

    
}

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
