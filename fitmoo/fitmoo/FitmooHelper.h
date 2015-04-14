//
//  FitmooHelper.h
//  fitmoo
//
//  Created by hongjian lin on 4/7/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LocalUser.h"
#import "User.h"
#import <CoreData/CoreData.h>
#import "HomeFeed.h"
@interface FitmooHelper : NSObject{
    
}
+ (FitmooHelper*) sharedInstance;
- (CGRect) resizeFrameWithFrame:(UIView *) view  respectToSuperFrame: (UIView *) superView;
- (void) saveLocalUser: (User *) localUser;
- (void) setContext: (NSManagedObjectContext *) con;
- (User *) getUserLocally;
-(HomeFeed *) generateHomeFeed: (NSDictionary *) dic;
@property (strong, nonatomic) NSManagedObjectContext * context;
@property (strong, nonatomic) UIView * screenSizeView;




@end