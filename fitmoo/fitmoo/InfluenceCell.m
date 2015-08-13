//
//  InfluenceCell.m
//  fitmoo
//
//  Created by hongjian lin on 8/13/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "InfluenceCell.h"
#import "FitmooHelper.h"
@implementation InfluenceCell

- (void)awakeFromNib {
    // Initialization code
    
    [self initFrames];
}


- (void) initFrames
{

    
    double radio= [[FitmooHelper sharedInstance] frameRadio];
    _bodyLabel1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel1 respectToSuperFrame:nil];
    _bodyLabel2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel2 respectToSuperFrame:nil];
//    _bodyLabel3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel3 respectToSuperFrame:nil];
    _bodyLabel3.frame= CGRectMake(_bodyLabel3.frame.origin.x*radio, _bodyLabel3.frame.origin.y*radio, _bodyLabel3.frame.size.width*radio, _bodyLabel3.frame.size.height);
    
    _bodyLabel4.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel4 respectToSuperFrame:nil];
    
 //   _bodyLabel5.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel5 respectToSuperFrame:nil];
    _bodyLabel5.frame= CGRectMake(_bodyLabel5.frame.origin.x*radio, _bodyLabel5.frame.origin.y*radio, _bodyLabel5.frame.size.width*radio, _bodyLabel5.frame.size.height);
    
    _bodyLabel6.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel6 respectToSuperFrame:nil];
//    _bodyLabel7.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyLabel7 respectToSuperFrame:nil];
    _bodyLabel7.frame= CGRectMake(_bodyLabel7.frame.origin.x*radio, _bodyLabel7.frame.origin.y*radio, _bodyLabel7.frame.size.width*radio, _bodyLabel7.frame.size.height);
    _bodyButton1.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyButton1 respectToSuperFrame:nil];
    _bodyButton2.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyButton2 respectToSuperFrame:nil];
    _bodyButton3.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyButton3 respectToSuperFrame:nil];
    _bodyButton4.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_bodyButton4 respectToSuperFrame:nil];
    
//    _bodyLabel3.numberOfLines=0;
//    _bodyLabel5.numberOfLines=0;
//    _bodyLabel7.numberOfLines=0;
//    [_bodyLabel3 sizeToFit];
//    [_bodyLabel5 sizeToFit];
//    [_bodyLabel7 sizeToFit];
   
  
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
