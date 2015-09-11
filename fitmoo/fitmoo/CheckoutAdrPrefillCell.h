//
//  CheckoutAdrPrefillCell.h
//  fitmoo
//
//  Created by hongjian lin on 9/11/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
#import "Address.h"
@interface CheckoutAdrPrefillCell : UITableViewCell<RTLabelDelegate>
@property (nonatomic, strong) RTLabel *rtLabel;
@property (nonatomic, strong) Address *address;
- (void) builtCell;
@property (strong, nonatomic) IBOutlet UIButton *editButton;


@end
