//
//  ShopOrder.m
//  fitmoo
//
//  Created by hongjian lin on 9/19/15.
//  Copyright © 2015 com.fitmoo. All rights reserved.
//

#import "ShopOrder.h"

@implementation ShopOrder

-(id)init
{
    _shippingAddress=[[Address alloc] init];
    _billingAddress=[[Address alloc] init];
    return self;
}

@end
