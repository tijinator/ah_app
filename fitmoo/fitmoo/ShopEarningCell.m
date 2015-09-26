//
//  ShopEarningCell.m
//  fitmoo
//
//  Created by hongjian lin on 9/20/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import "ShopEarningCell.h"
#import "FitmooHelper.h"
@implementation ShopEarningCell

- (void)awakeFromNib {
    
    [self initFrames];
    // Initialization code
}
- (void) buildCell
{
    if (_earning!=nil) {
        _redeemLabel.text=[NSString stringWithFormat:@"$%0.2f", _earning.redeemable.floatValue ];
        _saleLabel.text=[NSString stringWithFormat:@"$%0.2f", _earning.completed_sales.floatValue];
        _endorsLabel.text=[NSString stringWithFormat:@"$%0.2f", _earning.completed_endorsements.floatValue];
        
        _pendingSaleLabel.text=[NSString stringWithFormat:@"$%0.2f", _earning.pending_sales.floatValue ];
        _pendingEndorseLabel.text=[NSString stringWithFormat:@"$%0.2f", _earning.pending_endorsements.floatValue];
        _previouslyReddeemLabel.text=[NSString stringWithFormat:@"$%0.2f", _earning.redeemed.floatValue];
        
        _totalEarningLabel.text=[NSString stringWithFormat:@"$%0.2f", _earning.total_earnings.floatValue];
    }
 
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
    _label7.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label7 respectToSuperFrame:nil];


    _redeemLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_redeemLabel respectToSuperFrame:nil];
    _saleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_saleLabel respectToSuperFrame:nil];
    _endorsLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_endorsLabel respectToSuperFrame:nil];
    _pendingSaleLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_pendingSaleLabel respectToSuperFrame:nil];
    _pendingEndorseLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_pendingEndorseLabel respectToSuperFrame:nil];
    _previouslyReddeemLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_previouslyReddeemLabel respectToSuperFrame:nil];
    _totalEarningLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_totalEarningLabel respectToSuperFrame:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
