//
//  ShopCart.m
//  fitmoo
//
//  Created by hongjian lin on 9/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "ShopCart.h"

@implementation ShopCart
-(id)init
{
    _shop_cart_detail=[[ShopCartDetail alloc] init];
    _shop_cart_details=[[NSMutableArray alloc] init];
    return self;
}

-(void) resetshopCartDetail
{
    _shop_cart_detail= [[ShopCartDetail alloc] init];
    
}

@end
