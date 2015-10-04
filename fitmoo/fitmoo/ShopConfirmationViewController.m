//
//  ShopConfirmationViewController.m
//  fitmoo
//
//  Created by hongjian lin on 10/3/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import "ShopConfirmationViewController.h"

@interface ShopConfirmationViewController ()
{
      NSNumber * contentHight;
}
@end

@implementation ShopConfirmationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initFrames];
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
 
    
    return 3+[_shopCart.shop_cart_details count];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row==0) {
        ShopConfirmCell *cell =(ShopConfirmCell *) [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopConfirmCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.orderNumberLabel.text=[NSString stringWithFormat:@"ORDER NUMBER IS %@", _order_id];
        
        contentHight=[NSNumber numberWithInt:cell.contentView.frame.size.height];
        return cell;

    }
    
    if (indexPath.row<=[_shopCart.shop_cart_details count]) {
        ShopconfirmCell1 *cell =(ShopconfirmCell1 *) [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopconfirmCell1" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        ShopCartDetail *cartDetail= [_shopCart.shop_cart_details objectAtIndex:indexPath.row-1];
        
        
        cell.label1.text=cartDetail.title;
        cell.label2.text=cartDetail.item_details;
        cell.label3.text=@"PLACED ON";
        
        cell.label4.text=[NSString stringWithFormat:@"$%0.2f", cartDetail.price.floatValue];
        cell.label5.text=[NSString stringWithFormat:@"QTY%@",cartDetail.quantity];
        
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM-dd--yy"];
        
        NSDate *now = [[NSDate alloc] init];
        NSString *theDate = [dateFormat stringFromDate:now];
        cell.label6.text=theDate;
        
        contentHight=[NSNumber numberWithInt:cell.contentView.frame.size.height];
        return cell;
    }
    
    if (indexPath.row==[_shopCart.shop_cart_details count]+1) {
        ShopconfirmCell1 *cell =(ShopconfirmCell1 *) [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopconfirmCell1" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
   
        
        cell.label1.text=@"TOTAL";
        cell.label2.text=@"SHIPPING TOTAL";
        cell.label3.text=@"TOTAL PAID";

        cell.label4.text=[NSString stringWithFormat:@"$%0.2f", _shopCart.subtotal.floatValue];
        cell.label5.text=[NSString stringWithFormat:@"$%0.2f", _shopCart.shipping.floatValue];
        cell.label6.text=[NSString stringWithFormat:@"$%0.2f", _shopCart.total.floatValue];
        
        cell.label1.textColor=cell.label2.textColor;
        cell.label4.textColor=cell.label2.textColor;
        cell.label3.textColor=[UIColor colorWithRed:16.0/255.0 green:156.0/255.0 blue:251.0/251.0 alpha:1.0f];
        cell.label6.textColor=[UIColor colorWithRed:16.0/255.0 green:156.0/255.0 blue:251.0/251.0 alpha:1.0f];
        
        contentHight=[NSNumber numberWithInt:cell.contentView.frame.size.height];
        return cell;
    }
    
    
    UITableViewCell *cell= [[UITableViewCell alloc] init];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    
    
    double frameRadio=[[FitmooHelper sharedInstance] frameRadio];
    
    _rtLabel=[[RTLabel alloc] initWithFrame:CGRectMake(25*frameRadio, 2*frameRadio, 280*frameRadio,100)];
 
    _rtLabel.lineSpacing=10;
    
    if ([_billingAddress.address2 isEqualToString:@""]||_billingAddress.address2==nil) {
        [_rtLabel setText:[NSString stringWithFormat:@"<font face=BentonSans size=14 color=#575D60><p>BILLING</p></font><font face=BentonSans size=14 color=#000000><p>%@</p><p>%@</p><p>%@ , %@ %@</p><p>%@</p></font>",_billingAddress.full_name,_billingAddress.address1,_billingAddress.city,_billingAddress.state_name,_billingAddress.zipcode,_billingAddress.phone]];
    }else
    {
        [_rtLabel setText:[NSString stringWithFormat:@"<font face=BentonSans size=14 color=#575D60><p>BILLING</p></font><font face=BentonSans size=14 color=#000000><p>%@</p><p>%@</p><p>%@</p><p>%@ , %@ %@</p><p>%@</p></font>",_billingAddress.full_name,_billingAddress.address1,_billingAddress.address2,_billingAddress.city,_billingAddress.state_name,_billingAddress.zipcode,_billingAddress.phone]];
        
    }
    CGSize optimumSize =[_rtLabel optimumSize];
    _rtLabel.frame=CGRectMake(_rtLabel.frame.origin.x, _rtLabel.frame.origin.y, optimumSize.width, optimumSize.height+10);
    

    
    _rtLabel1=[[RTLabel alloc] initWithFrame:CGRectMake(25*frameRadio, _rtLabel.frame.origin.y+_rtLabel.frame.size.height+5, 280*frameRadio,100)];
    
    _rtLabel1.lineSpacing=10;
    
    if ([_shippingAddress.address2 isEqualToString:@""]||_shippingAddress.address2==nil) {
        [_rtLabel1 setText:[NSString stringWithFormat:@"<font face=BentonSans size=14 color=#575D60><p>SHIPPING</p></font><font face=BentonSans size=14 color=#000000><p>%@</p><p>%@</p><p>%@ , %@ %@</p><p>%@</p></font>",_shippingAddress.full_name,_shippingAddress.address1,_shippingAddress.city,_shippingAddress.state_name,_shippingAddress.zipcode,_shippingAddress.phone]];
    }else
    {
        [_rtLabel1 setText:[NSString stringWithFormat:@"<font face=BentonSans size=14 color=#575D60><p>SHIPPING</p></font><font face=BentonSans size=14 color=#000000><p>%@</p><p>%@</p><p>%@</p><p>%@ , %@ %@</p><p>%@</p></font>",_shippingAddress.full_name,_shippingAddress.address1,_shippingAddress.address2,_shippingAddress.city,_shippingAddress.state_name,_shippingAddress.zipcode,_shippingAddress.phone]];
        
    }
    optimumSize =[_rtLabel1 optimumSize];
    _rtLabel1.frame=CGRectMake(_rtLabel1.frame.origin.x, _rtLabel1.frame.origin.y, optimumSize.width, optimumSize.height+10);


    
    
    [cell.contentView addSubview:_rtLabel];
    [cell.contentView addSubview:_rtLabel1];
    contentHight=[NSNumber numberWithInt:_rtLabel1.frame.size.height+_rtLabel1.frame.origin.y+10];
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

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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





@end
