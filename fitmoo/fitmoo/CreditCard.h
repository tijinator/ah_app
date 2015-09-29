//
//  CreditCard.h
//  fitmoo
//
//  Created by hongjian lin on 9/15/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreditCard : NSObject

@property (nonatomic, retain) NSString * month;
@property (nonatomic, retain) NSString * year;
@property (nonatomic, retain) NSString * cardType;
@property (nonatomic, retain) NSString * cvc;
@property (nonatomic, retain) NSString * cardNumber;

@end
