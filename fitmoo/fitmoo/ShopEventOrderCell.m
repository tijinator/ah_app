//
//  ShopEventOrderCell.m
//  fitmoo
//
//  Created by hongjian lin on 10/12/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import "ShopEventOrderCell.h"
#import "FitmooHelper.h"
@implementation ShopEventOrderCell

- (void)awakeFromNib {
    [self initFrames];
    // Initialization code
}
- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    
    
    _label1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label1 respectToSuperFrame:nil];
    _label2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label2 respectToSuperFrame:nil];
    _label3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label3 respectToSuperFrame:nil];
    
    _timeLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_timeLabel respectToSuperFrame:nil];
    _phoneNumberLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_phoneNumberLabel respectToSuperFrame:nil];
    _sellerLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_sellerLabel respectToSuperFrame:nil];
    
  
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:nil];
    _billAddressLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_billAddressLabel respectToSuperFrame:nil];
    _totalLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_totalLabel respectToSuperFrame:nil];
    _shipTotalLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_shipTotalLabel respectToSuperFrame:nil];
    _totalPaidLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_totalPaidLabel respectToSuperFrame:nil];
    
   
    
}

- (void) buildCell
{
    
    
   
    _titleLabel.text=_order.title.uppercaseString;
   
    
    _rtLabel=[[RTLabel alloc] initWithFrame:CGRectMake(_billAddressLabel.frame.origin.x, _billAddressLabel.frame.origin.y, _billAddressLabel.frame.size.width,100)];
    _rtLabel.lineSpacing=10;
    
    [_rtLabel setText:[NSString stringWithFormat:@"<font face=BentonSans-Bold size=12 color=#575D60>%@</font>",[NSString stringWithFormat:@"%@", _order.event_location]]];
    CGSize optimumSize =[_rtLabel optimumSize];
    _rtLabel.frame=CGRectMake(_rtLabel.frame.origin.x, _rtLabel.frame.origin.y, optimumSize.width, optimumSize.height+10);
    [self.contentView addSubview:_rtLabel];
    
    
    _phoneNumberLabel.text=_order.customer_service_no;
    _sellerLabel.text=_order.seller_name;
    
    
    NSArray *stringArray= [_order.begin_time componentsSeparatedByString:@"|"];
    
    NSString * string= [NSString stringWithFormat:@"%@%@",[stringArray objectAtIndex:0],[stringArray objectAtIndex:1]];
    string=string.uppercaseString;
    
    _timeLabel.text=string;
    
    _totalLabel.text=[NSString stringWithFormat:@"$%@", _order.total];
    _shipTotalLabel.text=[NSString stringWithFormat:@"$%@", _order.order_shipping_total];
    
    _totalPaidLabel.text=[NSString stringWithFormat:@"$%.2f", _order.total.floatValue+_order.order_shipping_total.floatValue];
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
