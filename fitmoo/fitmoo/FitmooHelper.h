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
-(CGRect) caculateLabelHeight: (UILabel *) label;
@property (strong, nonatomic) NSManagedObjectContext * context;
@property (strong, nonatomic) UIView * screenSizeView;
@property (assign, nonatomic) double frameRadio;
- (NSString *)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
-(void) showViewWithAnimation: (NSString *) text withPareView: (UIView *)parentView;
-(NSAttributedString *) setAttributedString: (NSString *) stringToChange Font: (NSString *) fontName size:(CGFloat) size;
-(NSAttributedString *) setPartialAttributedString: (NSMutableAttributedString *) stringToChange Font: (NSString *) fontName size:(CGFloat) size range:(NSString *)rangeString color:(UIColor *)color;
-(NSAttributedString *) setBaseLineOffsetAttributedString: (NSMutableAttributedString *) stringToChange Font: (NSString *) fontName size:(CGFloat)size range:(NSString *)rangeString;
-(NSAttributedString *) replaceAttributedString: (NSMutableAttributedString *) stringToChange Font: (UIFont *) fontName range:(NSString *)rangeString newString:(NSString *)newString;
- (NSString *) getTextForNumber: (NSString *) numberString;
- (void) addActivityIndicator:(UIView *)view;
- (UIView *) addActivityIndicatorView: (UIView *)indicatorView and: (UIView *) selfView;
@end