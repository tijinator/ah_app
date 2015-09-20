//
//  ShopRedemCell.m
//  fitmoo
//
//  Created by hongjian lin on 9/20/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import "ShopRedemCell.h"
#import "FitmooHelper.h"
@implementation ShopRedemCell

- (void)awakeFromNib {
    
    [self initFrames];
    // Initialization code
}

- (void) buildCell
{
    _dateLabel.text= _redeem.created_at;
    _depositedLabel.text=[NSString stringWithFormat:@"$%@", _redeem.deposited_amount ];
    _amountLabel.text=[NSString stringWithFormat:@"$%@", _redeem.full_amount ];
    _feeLabel.text=[NSString stringWithFormat:@"$%@", _redeem.withdrawal_fee ];
}

- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    
    _label1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label1 respectToSuperFrame:nil];
    _label2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label2 respectToSuperFrame:nil];
    _label3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label3 respectToSuperFrame:nil];
    _dateLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_dateLabel respectToSuperFrame:nil];
    _depositedLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_depositedLabel respectToSuperFrame:nil];
    _amountLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_amountLabel respectToSuperFrame:nil];
    _feeLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_feeLabel respectToSuperFrame:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
