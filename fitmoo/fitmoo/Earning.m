//
//  Earning.m
//  fitmoo
//
//  Created by hongjian lin on 9/20/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import "Earning.h"

@implementation Earning


-(id)init
{
    _Redeem=[[Redeem alloc] init];
    _RedeemArray=[[NSMutableArray alloc] init];
    
    
    return self;
}

-(void) resetRedeem
{
    _Redeem= [[Redeem alloc] init];
    
}

@end
