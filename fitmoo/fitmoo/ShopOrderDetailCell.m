//
//  ShopOrderDetailCell.m
//  fitmoo
//
//  Created by hongjian lin on 9/18/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import "ShopOrderDetailCell.h"
#import "FitmooHelper.h"
@implementation ShopOrderDetailCell

- (void)awakeFromNib {
    
    [self initFrames];
    // Initialization code
}

- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
