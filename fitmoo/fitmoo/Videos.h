//
//  Videos.h
//  fitmoo
//
//  Created by hongjian lin on 4/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Videos : NSObject
@property (nonatomic, strong) NSString *video_url;
@property (nonatomic, strong) NSString *thumbnail_url;   //picture
@property (nonatomic, strong) NSString *thumbnail_url_width;
@property (nonatomic, strong) NSString *thumbnail_url_height;
@end
