//
//  PhotoGalary.h
//  fitmoo
//
//  Created by hongjian lin on 5/11/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoGalary : NSObject

@property (nonatomic, strong) NSString *photo_id;
@property (nonatomic, strong) NSString *originalUrl;      // -----get photo_url  (not used)
@property (nonatomic, strong) NSString *stylesUrl;        //----styles ---photo_url  (use for table home feed)
@property (nonatomic, strong) NSString *stylesUrlWidth;
@property (nonatomic, strong) NSString *stylesUrlHeight;

@property (nonatomic, strong) NSString *total_comment;
@property (nonatomic, strong) NSString *total_like;
@property (nonatomic, strong) NSString *imageable_type;
@property (nonatomic, strong) NSString *imageable_id;
@end
