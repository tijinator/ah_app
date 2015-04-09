//
//  LocalUser.h
//  fitmoo
//
//  Created by hongjian lin on 4/8/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@interface LocalUser : NSManagedObject
@property (nonatomic, retain) NSString * secret_id;
@property (nonatomic, retain) NSString * auth_token;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * password;
@end
