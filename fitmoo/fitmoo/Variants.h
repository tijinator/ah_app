//
//  Variants.h
//  fitmoo
//
//  Created by hongjian lin on 9/3/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Photos.h"
@interface Variants : NSObject

@property (nonatomic, strong) NSString *deleted;
@property (nonatomic, strong) NSString *enabled;
@property (nonatomic, strong) NSString *variants_id;
@property (nonatomic, strong) NSString *needs_shipping;
@property (nonatomic, strong) NSString *price ;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *shipping;
@property (nonatomic, strong) NSString *sku;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *options;

@property (nonatomic, strong) Photos *photo;
@property (nonatomic, strong) NSMutableArray *dataArray;






@end
