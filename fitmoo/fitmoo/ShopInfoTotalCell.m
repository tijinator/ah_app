//
//  ShopInfoTotalCell.m
//  fitmoo
//
//  Created by hongjian lin on 9/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ShopInfoTotalCell.h"
#import "FitmooHelper.h"
@implementation ShopInfoTotalCell

- (void)awakeFromNib {
    // Initialization code
       [self initFrames];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    _label0.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label0 respectToSuperFrame:nil];
    _label7.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_label7 respectToSuperFrame:nil];
    _checkoutButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_checkoutButton respectToSuperFrame:nil];
    
    
}

@end
