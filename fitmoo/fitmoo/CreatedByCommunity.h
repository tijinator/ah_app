//
//  CreatedByCommunity.h
//  fitmoo
//
//  Created by hongjian lin on 4/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreatedByCommunity : NSObject

@property (nonatomic, strong) NSString *created_by_community_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cover_photo_url;

@property (nonatomic, strong) NSString *joiners_count;
@property (nonatomic, strong) NSString *is_member;
@property (nonatomic, strong) NSString *is_owner;
@property (nonatomic, strong) NSString *is_selected;

@end
