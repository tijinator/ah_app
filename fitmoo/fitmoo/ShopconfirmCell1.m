//
//  ShopconfirmCell1.m
//  fitmoo
//
//  Created by hongjian lin on 10/3/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import "ShopconfirmCell1.h"
#import "FitmooHelper.h"
@implementation ShopconfirmCell1

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
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
