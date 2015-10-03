//
//  ShopConfirmCell.m
//  fitmoo
//
//  Created by hongjian lin on 10/3/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import "ShopConfirmCell.h"
#import "FitmooHelper.h"
@implementation ShopConfirmCell

- (void)awakeFromNib {
    
    
    [self initFrames];
    // Initialization code
}


- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];

    _thankyouLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_thankyouLabel respectToSuperFrame:nil];
    _orderNumberLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_orderNumberLabel respectToSuperFrame:nil];
    _buttomView.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_buttomView respectToSuperFrame:nil];

    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
