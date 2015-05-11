//
//  Photos.h
//  fitmoo
//
//  Created by hongjian lin on 4/10/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photos : NSObject

//photo can be many, only show first three or show it as slider

@property (nonatomic, strong) NSString *photo_id;
@property (nonatomic, strong) NSString *originalUrl;      // -----get photo_url  (not used)
@property (nonatomic, strong) NSString *stylesUrl;        //----styles ---photo_url  (use for table home feed)
@property (nonatomic, strong) NSString *stylesUrlWidth;
@property (nonatomic, strong) NSString *stylesUrlHeight;




@end
