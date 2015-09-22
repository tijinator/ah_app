//
//  ShopOrderDetailViewController.m
//  fitmoo
//
//  Created by hongjian lin on 9/18/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import "ShopOrderDetailViewController.h"
#import <SwipeBack/SwipeBack.h>
#import "AFNetworking.h"
@interface ShopOrderDetailViewController ()
{
    NSNumber * contentHight;

    UIView *indicatorView;
}
@end

@implementation ShopOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.swipeBackEnabled = YES;
 
    contentHight=[NSNumber numberWithInteger:520*[[FitmooHelper sharedInstance] frameRadio]];
    [self initFrames];
    
  
    
    // Do any additional setup after loading the view.
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
    
    
    ShopOrderDetailCell*cell =(ShopOrderDetailCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopOrderDetailCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.order= _order;
    
    if (![_order.status.uppercaseString isEqualToString:@"PENDING"]) {
        _cancelButton.hidden=true;
    }
    
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




- (void) initFrames
{
    _tableView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_tableView respectToSuperFrame:self.view];
    _topView.frame= CGRectMake(0, 0, 320, 60);
    _topView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_topView respectToSuperFrame:self.view];
    _leftButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_leftButton respectToSuperFrame:self.view];
    
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:self.view];
    
    _cancelButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_cancelButton respectToSuperFrame:self.view];
    
    if (self.view.frame.size.height<500) {
        
        _tableView.frame= CGRectMake(_tableView.frame.origin.x,_tableView.frame.origin.y, _tableView.frame.size.width, _tableView.frame.size.height-88);
        
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

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 1)
    {
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        User *localUser= [[UserManager sharedUserManager] localUser];
        NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",@"true", @"mobile",_order.o_id, @"id",nil];
        NSString *url= [NSString stringWithFormat:@"%@%@",[[UserManager sharedUserManager] clientUrl], @"/api/orders/cancel_order_detail"];
        [manager POST: url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
            
            UIAlertView *alert = [[ UIAlertView alloc ] initWithTitle : @"Success"
                                                              message : @"" delegate : nil cancelButtonTitle : @"OK"
                                                    otherButtonTitles : nil ];
            [alert show ];
            
            
            [self.navigationController popViewControllerAnimated:YES];
        } // success callback block
              failure:^(AFHTTPRequestOperation *operation, NSError *error){
                  NSLog(@"Error: %@", error);} // failure callback block
         ];

     
        
    }
    
    
}

- (IBAction)cancelButtonClick:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Cancel"
                                                   message:@"Are you sure you want to cancel this order?"
                                                  delegate:self
                                         cancelButtonTitle:@"No"
                                         otherButtonTitles:@"Yes",nil];
    [alert show];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"HasSeenPopup"];

    

    
}
@end
