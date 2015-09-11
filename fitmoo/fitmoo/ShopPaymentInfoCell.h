//
//  ShopPaymentInfoCell.h
//  fitmoo
//
//  Created by hongjian lin on 9/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopPaymentInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *cardType;
@property (strong, nonatomic) IBOutlet UITextField *cardNumber;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *year;
@property (strong, nonatomic) IBOutlet UITextField *cvc;

@end
