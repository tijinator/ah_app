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

- (void) openSpecialPage
{
    
    indicatorView=[[FitmooHelper sharedInstance] addActivityIndicatorView:indicatorView and:self.view text:@"Loading..."];
    _tableView.userInteractionEnabled=false;
    
    User *localUser= [[UserManager sharedUserManager] localUser];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    NSDictionary *jsonDict = [[NSDictionary alloc] initWithObjectsAndKeys:localUser.secret_id, @"secret_id", localUser.auth_token, @"auth_token",  @"true", @"mobile",@"true", @"ios_app",
                              nil];
    
    NSString * url= [NSString stringWithFormat: @"%@%@%@", [[UserManager sharedUserManager] clientUrl],@"/api/feeds/",_order.feed_id];
    
    [manager GET:url parameters:jsonDict success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSDictionary * resDic= responseObject;
        _tableView.userInteractionEnabled=true;
        [indicatorView removeFromSuperview];
        HomeFeed *feed= [[FitmooHelper sharedInstance] generateHomeFeed:resDic];
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main1" bundle:nil];
        ShopDetailViewController *detailPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"ShopDetailViewController"];
        
        detailPage.homeFeed=feed;
        [self.navigationController pushViewController:detailPage animated:YES];
        
        
        //      NSLog(@"Submit response data: %@", responseObject);
    } // success callback block
         failure:^(AFHTTPRequestOperation *operation, NSError *error){
             _tableView.userInteractionEnabled=true;
             NSLog(@"Error: %@", error);
         } // failure callback block
     
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
    if ([_order.detail_type isEqualToString:@"EventInstance"]) {
        
        ShopEventOrderCell * cell =(ShopEventOrderCell *) [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopEventOrderCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.order= _order;
        
        if (![_order.status.uppercaseString isEqualToString:@"PENDING"]) {
            _cancelButton.hidden=true;
        }
        
        [cell buildCell];
        
       
        
        
        UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageButtonClick:)];
        tapGestureRecognizer1.numberOfTapsRequired = 1;
        [cell.titleLabel addGestureRecognizer:tapGestureRecognizer1];
        cell.titleLabel.userInteractionEnabled=YES;
        
        
        
        
        contentHight=[NSNumber numberWithInt:cell.contentView.frame.size.height];
        return cell;

        
    }
    
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
    
    [cell.imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
 
    
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageButtonClick:)];
    tapGestureRecognizer1.numberOfTapsRequired = 1;
    [cell.titleLabel addGestureRecognizer:tapGestureRecognizer1];
    cell.titleLabel.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upsButtonClick:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [cell.upsLabel addGestureRecognizer:tapGestureRecognizer];
    cell.upsLabel.userInteractionEnabled=YES;
    
    
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
- (IBAction)upsButtonClick:(id)sender {
   // _order.tracking_number
    
    if (![_order.tracking_number isEqualToString:@""]) {
          UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        SettingWebViewController *webPage = [mainStoryboard instantiateViewControllerWithIdentifier:@"SettingWebViewController"];
        
        if ([_order.carrier_name isEqualToString:@"fedex"]) {
            
            NSString *upsString= [NSString stringWithFormat:@"%@%@",@"http://www.fedex.com/Tracking?action=track&tracknumbers=",_order.tracking_number];
            
         webPage.webviewLink=upsString;
            
         //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:upsString]];
            
        }
        
        if ([_order.carrier_name isEqualToString:@"usps"]) {
            
            NSString *upsString= [NSString stringWithFormat:@"%@%@",@"https://tools.usps.com/go/TrackConfirmAction_input?qtc_tLabels1=",_order.tracking_number];
         //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:upsString]];
            webPage.webviewLink=upsString;
        }
        
        if ([_order.carrier_name isEqualToString:@"ups"]) {
            
            NSString *upsString= [NSString stringWithFormat:@"%@%@",@"http://wwwapps.ups.com/WebTracking/track?track=yes&trackNums=",_order.tracking_number];
         //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:upsString]];
            webPage.webviewLink=upsString;
        }
        
        if ([_order.carrier_name isEqualToString:@"dhl"]) {
            
            NSString *upsString= [NSString stringWithFormat:@"%@%@",@"http://track.dhl-usa.com/TrackByNbr.asp?ShipmentNumber=",_order.tracking_number];
         //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:upsString]];
            webPage.webviewLink=upsString;
        }
        
        
        webPage.settingType= @"TRACKING";
        [self.navigationController pushViewController:webPage animated:YES];
      
    }
    
    

}

- (IBAction)imageButtonClick:(id)sender {
    
    [self openSpecialPage];
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
          indicatorView=[[FitmooHelper sharedInstance] addActivityIndicatorView:indicatorView and:self.view text:@"Processing..."];
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
            
            [indicatorView removeFromSuperview];
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
