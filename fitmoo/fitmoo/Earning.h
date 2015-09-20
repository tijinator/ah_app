//
//  Earning.h
//  fitmoo
//
//  Created by hongjian lin on 9/20/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Redeem.h"
@interface Earning : NSObject

@property (nonatomic, retain) NSString * completed_endorsements;
@property (nonatomic, retain) NSString * completed_sales;
@property (nonatomic, retain) NSString * pending_endorsements;
@property (nonatomic, retain) NSString * pending_sales;

@property (nonatomic, retain) NSString * pending_total;
@property (nonatomic, retain) NSString * redeemable;
@property (nonatomic, retain) NSString * redeemed;
@property (nonatomic, retain) NSString * total_earnings;

@property (nonatomic, retain) Redeem * Redeem;
@property (nonatomic, retain) NSMutableArray * RedeemArray;


-(void) resetRedeem;
@end
