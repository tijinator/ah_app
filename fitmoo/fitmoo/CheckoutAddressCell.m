//
//  CheckoutAddressCell.m
//  fitmoo
//
//  Created by hongjian lin on 9/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "CheckoutAddressCell.h"
#import "FitmooHelper.h"
@implementation CheckoutAddressCell

- (void)awakeFromNib {
    // Initialization code
    [self initFrames];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void) initFrames
{
    
    self.contentView.frame=[[FitmooHelper sharedInstance] resizeFrameWithFrame:self.contentView respectToSuperFrame:nil];
    _AddressTextField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_AddressTextField respectToSuperFrame:nil];
    _nameTextField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_nameTextField respectToSuperFrame:nil];
    _cityTextField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_cityTextField respectToSuperFrame:nil];
    _stateTextField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_stateTextField respectToSuperFrame:nil];
    _zipTextField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_zipTextField respectToSuperFrame:nil];
    _phoneTextField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_phoneTextField respectToSuperFrame:nil];
    _Address2TextField.frame= [[FitmooHelper sharedInstance] resizeFrameWithFrame:_Address2TextField respectToSuperFrame:nil];
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
