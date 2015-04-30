//
//  Comments.h
//  fitmoo
//
//  Created by hongjian lin on 4/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comments : NSObject

//comment can be many, only show first three

@property (nonatomic, strong) NSString *comment_id;
@property (nonatomic, strong) NSString *text;

//created by

@property (nonatomic, strong) NSString *created_by_id;
@property (nonatomic, strong) NSString *full_name;
@property (nonatomic, strong) NSString *is_following;   // not used now

//created by ---profile
@property (nonatomic, strong) NSString *original;
@property (nonatomic, strong) NSString *cover_photo_url;
@property (nonatomic, strong) NSString *thumb;     //use this one for comment person image


@end
