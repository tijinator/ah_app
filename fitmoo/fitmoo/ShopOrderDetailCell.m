//
//  ShopOrderDetailCell.m
//  fitmoo
//
//  Created by hongjian lin on 9/18/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import "ShopOrderDetailCell.h"
#import "FitmooHelper.h"
#import "AsyncImageView.h"
@implementation ShopOrderDetailCell

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
    _label4.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label4 respectToSuperFrame:nil];
    _label5.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label5 respectToSuperFrame:nil];
    _label6.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label6 respectToSuperFrame:nil];
    _label9.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label9 respectToSuperFrame:nil];
    _label7.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label7 respectToSuperFrame:nil];
    _label8.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label8 respectToSuperFrame:nil];
    _label10.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label10 respectToSuperFrame:nil];
    
   
    
    _orderNumberLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_orderNumberLabel respectToSuperFrame:nil];
    _titleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_titleLabel respectToSuperFrame:nil];
    _sizeLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_sizeLabel respectToSuperFrame:nil];
    _lastUpdatedLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_lastUpdatedLabel respectToSuperFrame:nil];
    
    
    _placeOnLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_placeOnLabel respectToSuperFrame:nil];
    _paymentStatusLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_paymentStatusLabel respectToSuperFrame:nil];
    _fulfillStatusLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_fulfillStatusLabel respectToSuperFrame:nil];
    _upsLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_upsLabel respectToSuperFrame:nil];
    
    _billAddressLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_billAddressLabel respectToSuperFrame:nil];
    _shipAddressLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_shipAddressLabel respectToSuperFrame:nil];
    _totalLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_totalLabel respectToSuperFrame:nil];
    _shipTotalLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_shipTotalLabel respectToSuperFrame:nil];
    _totalPaidLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_totalPaidLabel respectToSuperFrame:nil];
    
    _imageButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_imageButton respectToSuperFrame:nil];

}

- (void) buildCell
{
    
    AsyncImageView *headerImage = [[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, _imageButton.frame.size.width, _imageButton.frame.size.height)];
    
    
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:headerImage];
    
    headerImage.imageURL =[NSURL URLWithString:_order.image_url];
    headerImage.userInteractionEnabled = NO;
    headerImage.exclusiveTouch = NO;
    [_imageButton.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    _imageButton.clipsToBounds=YES;
    [_imageButton addSubview:headerImage];

    
    _orderNumberLabel.text=[NSString stringWithFormat:@"#%@", _order.order_id];
    _titleLabel.text=_order.title.uppercaseString;
    _sizeLabel.text=_order.options.uppercaseString;
    
    NSArray *date= [_order.updated_at componentsSeparatedByString:@"T"];
    
    _lastUpdatedLabel.text=[date objectAtIndex:0];
    
    NSArray *date1= [_order.placed_at componentsSeparatedByString:@"T"];
    _placeOnLabel.text=[date1 objectAtIndex:0];
    
    _paymentStatusLabel.text= _order.payment_status.uppercaseString;
    
    _fulfillStatusLabel.text=_order.status.uppercaseString;
    _upsLabel.text=[NSString stringWithFormat:@"UPS: %@", _order.tracking_number];
    
    
    _rtLabel1=[[RTLabel alloc] initWithFrame:CGRectMake(_shipAddressLabel.frame.origin.x, _shipAddressLabel.frame.origin.y, _shipAddressLabel.frame.size.width,100)];
    _rtLabel1.lineSpacing=10;
    
    [_rtLabel1 setText:[NSString stringWithFormat:@"<font face=BentonSans-Bold size=12 color=#575D60>%@</font>",[NSString stringWithFormat:@"%@ \n%@ \n%@, %@ %@", _order.shippingAddress.full_name, _order.shippingAddress.address1, _order.shippingAddress.city, _order.shippingAddress.state_name, _order.shippingAddress.zipcode].uppercaseString]];
    CGSize optimumSize =[_rtLabel1 optimumSize];
    _rtLabel1.frame=CGRectMake(_rtLabel1.frame.origin.x, _rtLabel1.frame.origin.y, optimumSize.width, optimumSize.height+10);
    [self.contentView addSubview:_rtLabel1];
    
    _rtLabel=[[RTLabel alloc] initWithFrame:CGRectMake(_billAddressLabel.frame.origin.x, _billAddressLabel.frame.origin.y, _billAddressLabel.frame.size.width,100)];
    _rtLabel.lineSpacing=10;
    
    [_rtLabel setText:[NSString stringWithFormat:@"<font face=BentonSans-Bold size=12 color=#575D60>%@</font>",[NSString stringWithFormat:@"%@ \n%@ \n%@, %@ %@", _order.billingAddress.full_name, _order.billingAddress.address1, _order.billingAddress.city, _order.billingAddress.state_name, _order.billingAddress.zipcode].uppercaseString]];
    optimumSize =[_rtLabel optimumSize];
    _rtLabel.frame=CGRectMake(_rtLabel.frame.origin.x, _rtLabel.frame.origin.y, optimumSize.width, optimumSize.height+10);
    [self.contentView addSubview:_rtLabel];

    
//    _shipAddressLabel.text=[NSString stringWithFormat:@"%@ \n%@ \n%@, %@ %@", _order.shippingAddress.full_name, _order.shippingAddress.address1, _order.shippingAddress.city, _order.shippingAddress.state_name, _order.shippingAddress.zipcode].uppercaseString;
    
    
    _totalLabel.text=[NSString stringWithFormat:@"$%@", _order.total];
    _shipTotalLabel.text=[NSString stringWithFormat:@"$%@", _order.order_shipping_total];
    
    _totalPaidLabel.text=[NSString stringWithFormat:@"$%.2f", _order.total.floatValue+_order.order_shipping_total.floatValue];

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
