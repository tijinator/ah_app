//
//  CheckoutAdrPrefillCell.m
//  fitmoo
//
//  Created by hongjian lin on 9/11/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "CheckoutAdrPrefillCell.h"
#import "FitmooHelper.h"
@implementation CheckoutAdrPrefillCell

- (void)awakeFromNib {
    // Initialization code
    [self initFrames];
}

- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    
    self.editButton.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.editButton respectToSuperFrame:nil];
    self.useThisAddButton.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.useThisAddButton respectToSuperFrame:nil];
    
}

- (void) builtCell
{
    
    double frameRadio=[[FitmooHelper sharedInstance] frameRadio];
    
    _rtLabel=[[RTLabel alloc] initWithFrame:CGRectMake(30*frameRadio, 10*frameRadio, 270*frameRadio,100)];
    [_rtLabel setDelegate:self];
    _rtLabel.lineSpacing=10;
    
    if ([_address.address2 isEqualToString:@""]||_address.address2==nil) {
        [_rtLabel setText:[NSString stringWithFormat:@"<font face=BentonSans size=14 color=#575D60><p>%@</p><p>%@</p><p>%@ , %@ %@</p><p>%@</p></font>",_address.full_name,_address.address1,_address.city,_address.state_name,_address.zipcode,_address.phone]];
    }else
    {
        [_rtLabel setText:[NSString stringWithFormat:@"<font face=BentonSans size=14 color=#575D60><p>%@</p><p>%@</p><p>%@</p><p>%@ , %@ %@</p><p>%@</p></font>",_address.full_name,_address.address1,_address.address2,_address.city,_address.state_name,_address.zipcode,_address.phone]];
    
    }
    
    CGSize optimumSize =[_rtLabel optimumSize];
    
    _rtLabel.frame=CGRectMake(_rtLabel.frame.origin.x, _rtLabel.frame.origin.y, optimumSize.width, optimumSize.height+10);
    
    _useThisAddButton.frame=CGRectMake(_useThisAddButton.frame.origin.x, _rtLabel.frame.origin.y+_rtLabel.frame.size.height+10, _useThisAddButton.frame.size.width, _useThisAddButton.frame.size.height);
    
    
  
    [self.contentView insertSubview:_rtLabel belowSubview:_editButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
