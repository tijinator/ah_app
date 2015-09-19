//
//  ShopPurchaseCell.m
//  fitmoo
//
//  Created by hongjian lin on 9/17/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ShopPurchaseCell.h"
#import "FitmooHelper.h"
@implementation ShopPurchaseCell

- (void)awakeFromNib {
    
    [self initFrames];
    // Initialization code
}

- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    _ImageButton.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_ImageButton respectToSuperFrame:nil];
    _itemLabel.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_itemLabel respectToSuperFrame:nil];
    
    

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
