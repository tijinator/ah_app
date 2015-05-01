//
//  FitmooHelper.m
//  fitmoo
//
//  Created by hongjian lin on 4/7/15.
//  Copyright (c) 2015 com.fitmoo. All rights reserved.
//

#import "FitmooHelper.h"

@implementation FitmooHelper

+ (FitmooHelper*)sharedInstance
{
    static dispatch_once_t pred;
    static FitmooHelper *settings = nil;
    
    dispatch_once(&pred, ^{ settings = [[self alloc] init]; });
    return settings;
    
}

- (NSString *)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth|NSCalendarUnitYear;
    
    NSDateComponents *conversionInfo = [calendar components:unitFlags fromDate:fromDateTime   toDate:toDateTime  options:0];
    
    int months = (int)[conversionInfo month];
    int days =(int) [conversionInfo day];
    int hours = (int)[conversionInfo hour];
    int minutes = (int)[conversionInfo minute];
    int year = (int)[conversionInfo year];
    if (year!=0) {
        return [NSString stringWithFormat:@"%d%@",year, @" years ago"];
    }
    else if (months!=0) {
        return [NSString stringWithFormat:@"%d%@",months, @" months ago"];
    }else if (days!=0) {
        return [NSString stringWithFormat:@"%d%@",days, @" days ago"];
    }else if (hours!=0) {
        return [NSString stringWithFormat:@"%d%@",hours, @" hours ago"];
    }else if (minutes!=0) {
        return [NSString stringWithFormat:@"%d%@",ABS(minutes), @" minutes ago"];
    }
    
    
    return @"about a minute ago";
}

-(CGRect) caculateLabelHeight: (UILabel *) label
{
    CGSize maximumLabelSize = CGSizeMake(label.frame.size.width*_frameRadio, FLT_MAX);
    
    CGSize expectedLabelSize = [label.text sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:label.lineBreakMode];
    CGRect newFrame = label.frame;
    newFrame.size.height = expectedLabelSize.height;
    return  newFrame;
}
- (CGRect) resizeFrameWithFrame:(UIView *) view  respectToSuperFrame: (UIView *) superView
{
    if (superView!=nil) {
         double Radio= superView.frame.size.width / 320;
        _frameRadio=Radio;
         view.frame= CGRectMake(view.frame.origin.x * Radio, view.frame.origin.y * Radio, view.frame.size.width * Radio, view.frame.size.height*Radio);
    }else
    {
        double Radio= self.screenSizeView.frame.size.width/320;
        _frameRadio=Radio;
        view.frame= CGRectMake(view.frame.origin.x * Radio, view.frame.origin.y * Radio, view.frame.size.width * Radio, view.frame.size.height*Radio);
    }
   
    
   
    
    return view.frame;
}

-(HomeFeed *) generateHomeFeed: (NSDictionary *) dic
{
    HomeFeed * homeFeed= [[HomeFeed alloc] init];
    
    NSNumber * feed_id=[dic objectForKey:@"id"];
    homeFeed.feed_id= [feed_id stringValue];
    
     homeFeed.text= [dic objectForKey:@"text"];
    if ([homeFeed.text isEqual:[NSNull null ]]) {
       homeFeed.text=@"";
        
    }
   
    
    
    homeFeed.community_id=[dic objectForKey:@"community_id"];
    homeFeed.community_name= [dic objectForKey:@"community_name"];
    homeFeed.community_cover_photo= [dic objectForKey:@"community_cover_photo"];
    
    NSNumber * created_at=[dic objectForKey:@"created_at"];
    if (created_at!=nil) {
        homeFeed.created_at= [created_at stringValue];
    }

    NSNumber * updated_at=[dic objectForKey:@"updated_at"];
    if (updated_at!=nil) {
         homeFeed.updated_at= [updated_at stringValue];
    }
   
    
    NSNumber * total_comment=[dic objectForKey:@"total_comment"];
    if (total_comment!=nil) {
         homeFeed.total_comment= [total_comment stringValue];
    }
 
   
    NSNumber * total_like=[dic objectForKey:@"total_like"];
    if (total_like!=nil) {
        homeFeed.total_like= [total_like stringValue];
    }
    
    NSNumber * is_like=[dic objectForKey:@"is_liked"];
    homeFeed.is_liked= [is_like stringValue];
    
    homeFeed.workout_title= [dic objectForKey:@"workout_title"];
    homeFeed.type= [dic objectForKey:@"type"];
    homeFeed.action_sheet= [dic objectForKey:@"action_sheet"];
    homeFeed.service= [dic objectForKey:@"service"];
    
    NSDictionary * photoArray= [dic objectForKey:@"photos"];
     if (![photoArray isEqual:[NSNull null ]]) {
        for (NSDictionary *photoDic in photoArray) {
            homeFeed.photos.photo_id= [photoDic objectForKey:@"id"];
            NSDictionary *orignal=[photoDic objectForKey:@"original"];
            homeFeed.photos.originalUrl= [orignal objectForKey:@"photo_url"];
            
            NSDictionary *styles=[photoDic objectForKey:@"styles"];
            NSDictionary *slider=[styles objectForKey:@"slider"];
            homeFeed.photos.stylesUrl=[slider objectForKey:@"photo_url"];
            [homeFeed.photoArray addObject:homeFeed.photos];
        }
    }
    
    NSDictionary * commentsArray= [dic objectForKey:@"comments"];
    if (![commentsArray isEqual:[NSNull null ]]) {
        for (NSDictionary *commentsDic in commentsArray) {
            [homeFeed resetComments];
            homeFeed.comments.comment_id= [commentsDic objectForKey:@"id"];
            homeFeed.comments.text= [commentsDic objectForKey:@"text"];
            NSDictionary *created_by=[commentsDic objectForKey:@"created_by"];
            homeFeed.comments.created_by_id= [created_by objectForKey:@"id"];
            homeFeed.comments.full_name= [created_by objectForKey:@"full_name"];
            homeFeed.comments.is_following= [created_by objectForKey:@"is_following"];
            NSDictionary *profile=[created_by objectForKey:@"profile"];
            NSDictionary *avatars=[profile objectForKey:@"avatars"];
            homeFeed.comments.original=[avatars objectForKey:@"original"];
            homeFeed.comments.thumb=[avatars objectForKey:@"thumb"];
            homeFeed.comments.cover_photo_url=[profile objectForKey:@"cover_photo_url"];
            
            [homeFeed.commentsArray addObject:homeFeed.comments];
        }
    }
    
    NSDictionary *created_by=[dic objectForKey:@"created_by"];
    if (![created_by isEqual:[NSNull null ]]) {
        homeFeed.created_by.created_by_id= [created_by objectForKey:@"id"];
        homeFeed.created_by.full_name= [created_by objectForKey:@"full_name"];
        homeFeed.created_by.is_following= [created_by objectForKey:@"is_following"];
        NSDictionary *profile=[created_by objectForKey:@"profile"];
        NSDictionary *avatars=[profile objectForKey:@"avatars"];
        homeFeed.created_by.original=[avatars objectForKey:@"original"];
        homeFeed.created_by.thumb=[avatars objectForKey:@"thumb"];
        homeFeed.created_by.cover_photo_url=[profile objectForKey:@"cover_photo_url"];

    }
    
    NSDictionary *createdByCommunity=[dic objectForKey:@"created_by_community"];
    if (![createdByCommunity isEqual:[NSNull null ]]) {
        homeFeed.created_by_community.created_by_community_id= [createdByCommunity objectForKey:@"id"];
        homeFeed.created_by_community.name= [createdByCommunity objectForKey:@"name"];
        homeFeed.created_by_community.cover_photo_url= [createdByCommunity objectForKey:@"cover_photo_url"];
        if ([homeFeed.created_by_community.cover_photo_url isEqual:[NSNull null ]]) {
            homeFeed.created_by_community.cover_photo_url= @"https://fitmoo.com/assets/group/cover-default.png";
        }
    }
    
    NSDictionary *feed_action=[dic objectForKey:@"feed_action"];
    if (![feed_action isEqual:[NSNull null ]]) {
        homeFeed.feed_action.feed_action_id= [feed_action objectForKey:@"id"];
        homeFeed.feed_action.user_id= [feed_action objectForKey:@"user_id"];
        homeFeed.feed_action.community_id= [feed_action objectForKey:@"community_id"];
        homeFeed.feed_action.share_message= [feed_action objectForKey:@"share_message"];
        homeFeed.feed_action.action= [feed_action objectForKey:@"action"];
        
        NSDictionary *createdByCommunity=[feed_action objectForKey:@"community"];
        if (![createdByCommunity isEqual:[NSNull null ]]) {
            homeFeed.feed_action.created_by_community.created_by_community_id= [createdByCommunity objectForKey:@"id"];
            homeFeed.feed_action.created_by_community.name= [createdByCommunity objectForKey:@"name"];
            homeFeed.feed_action.created_by_community.cover_photo_url= [createdByCommunity objectForKey:@"cover_photo_url"];
        }
       
        NSDictionary *created_by=[feed_action objectForKey:@"user"];
        if (![created_by isEqual:[NSNull null ]]) {
            homeFeed.feed_action.created_by.created_by_id= [created_by objectForKey:@"id"];
            homeFeed.feed_action.created_by.full_name= [created_by objectForKey:@"full_name"];
            homeFeed.feed_action.created_by.is_following= [created_by objectForKey:@"is_following"];
            NSDictionary *profile=[created_by objectForKey:@"profile"];
            NSDictionary *avatars=[profile objectForKey:@"avatars"];
            homeFeed.feed_action.created_by.original=[avatars objectForKey:@"original"];
            homeFeed.feed_action.created_by.thumb=[avatars objectForKey:@"thumb"];
            homeFeed.feed_action.created_by.cover_photo_url=[profile objectForKey:@"cover_photo_url"];
            
        }
        
    }
    
    
    NSDictionary *title_info=[dic objectForKey:@"title_info"];
    if (![title_info isEqual:[NSNull null ]]) {
        homeFeed.title_info.avatar_id= [title_info objectForKey:@"avatar_id"];
        homeFeed.title_info.avatar_title= [title_info objectForKey:@"avatar_title"];
        homeFeed.title_info.avatar_type= [title_info objectForKey:@"avatar_type"];
        homeFeed.title_info.type= [title_info objectForKey:@"type"];
        
    }
    
    
    NSDictionary *product=[dic objectForKey:@"product"];
    if (![product isEqual:[NSNull null ]]) {
        homeFeed.product.product_id= [product objectForKey:@"id"];
        homeFeed.product.type_product= [product objectForKey:@"type_product"];
        homeFeed.product.title= [product objectForKey:@"title"];
        homeFeed.product.detail= [product objectForKey:@"detail"];
        homeFeed.product.gender= [product objectForKey:@"gender"];
        
        NSNumber * original_price=[product objectForKey:@"original_price"];
        homeFeed.product.original_price=[original_price stringValue];
        NSNumber * selling_price=[product objectForKey:@"selling_price"];
        homeFeed.product.selling_price= [selling_price stringValue];
        homeFeed.product.brand= [product objectForKey:@"brand"];
        homeFeed.product.photo= [product objectForKey:@"photo"];
        homeFeed.product.videos= [product objectForKey:@"videos"];
        
    }
    
    NSDictionary *nutrition=[dic objectForKey:@"nutrition"];
    if (![nutrition isEqual:[NSNull null ]]) {
        homeFeed.nutrition.nutrition_id= [nutrition objectForKey:@"id"];
        homeFeed.nutrition.title= [nutrition objectForKey:@"title"];
        homeFeed.nutrition.ingredients= [nutrition objectForKey:@"ingredients"];
        homeFeed.nutrition.preparation= [nutrition objectForKey:@"preparation"];
    }
    
    NSDictionary * videosArray= [dic objectForKey:@"videos"];
    if (![videosArray isEqual:[NSNull null ]]) {
        for (NSDictionary *videosDic in videosArray) {
            homeFeed.videos.video_url= [videosDic objectForKey:@"video_url"];
           
            NSDictionary *thumbnail=[videosDic objectForKey:@"thumbnail"];
            if (![thumbnail isEqual:[NSNull null]]) {
                homeFeed.videos.thumbnail_url= [thumbnail objectForKey:@"url"];
            }
              [homeFeed.videosArray addObject:homeFeed.videos];
        }
    }
    
    NSDictionary *event=[dic objectForKey:@"event"];
    if (![event isEqual:[NSNull null ]]) {
        homeFeed.event.event_id= [event objectForKey:@"id"];
        homeFeed.event.name= [event objectForKey:@"name"];
        homeFeed.event.begin_time= [event objectForKey:@"begin_time"];
        homeFeed.event.end_time= [event objectForKey:@"end_time"];
        homeFeed.event.theme= [event objectForKey:@"theme"];
        if([homeFeed.event.theme isEqualToString:@""])
        {
            homeFeed.event.theme=@"https://fitmoo.com/assets/cover/theme-event-feed.png";
        }
       
    }
    
    
    return homeFeed;
}

-(void) deleteDataLocally
{
    
    NSFetchRequest * UserFetched = [[NSFetchRequest alloc] init];
    [UserFetched setEntity:[NSEntityDescription entityForName:@"LocalUser" inManagedObjectContext:_context]];
    [UserFetched setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * users = [_context executeFetchRequest:UserFetched error:&error];
    
    for (NSManagedObject * user in users) {
        [_context deleteObject:user];
    }
    NSError *saveError = nil;
    [_context save:&saveError];
    //more error handling here
}

- (void) setContext: (NSManagedObjectContext *) con
{
    _context=con;
}

- (void) setScreenSizeView:(UIView *)screenView
{
    _screenSizeView=screenView;
}

- (void) saveLocalUser: (User *) localUser
{
    [self deleteDataLocally];
    LocalUser *user = [NSEntityDescription insertNewObjectForEntityForName:@"LocalUser"
                                                   inManagedObjectContext:_context];
    user.auth_token= localUser.auth_token;
    user.secret_id=localUser.secret_id;
    user.user_id=localUser.user_id;
    user.email=localUser.email;
    user.password=localUser.password;
    
        NSError *error;
        if (![_context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    
}

-(User *) getUserLocally
{
   
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LocalUser"
                                              inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [_context executeFetchRequest:fetchRequest error:&error];
   
    User *user= [[User alloc] init];
    
    for (LocalUser *result in fetchedObjects) {
        user.auth_token= result.auth_token;
        user.secret_id=result.secret_id;
        user.user_id=result.user_id;
        user.email=result.email;
        user.password=result.password;
    }
    
    
    return user;
}


-(NSAttributedString *) setAttributedString: (NSString *) stringToChange Font: (NSString *) fontName size:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:fontName size:size];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:stringToChange attributes:@{NSFontAttributeName: font}  ];
    return attributedString;
}

-(NSAttributedString *) setPartialAttributedString: (NSMutableAttributedString *) stringToChange Font: (NSString *) fontName size:(CGFloat) size range:(NSString *)rangeString color:(UIColor *)color
{
    UIFont *font = [UIFont fontWithName:fontName size:size];
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:rangeString attributes:@{NSFontAttributeName: font}  ];
    NSRange range = [[stringToChange string] rangeOfString:rangeString];
    [stringToChange replaceCharactersInRange:range withAttributedString:attributedString];
    [stringToChange addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    
    return stringToChange;
}

-(NSAttributedString *) setBaseLineOffsetAttributedString: (NSMutableAttributedString *) stringToChange Font: (NSString *) fontName size:(CGFloat)size range:(NSString *)rangeString
{
    NSRange range = [[stringToChange string] rangeOfString:rangeString];
    int endRange=range.length;
    UIFont *font = [UIFont fontWithName:fontName size:size];
    
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:rangeString];
    [attributedString setAttributes:@{NSFontAttributeName : font, NSBaselineOffsetAttributeName : @7} range:NSMakeRange(0, endRange)];
    [stringToChange replaceCharactersInRange:range withAttributedString:attributedString];
    
    
    return stringToChange;
    
}

-(NSAttributedString *) replaceAttributedString: (NSMutableAttributedString *) stringToChange Font: (UIFont *) fontName range:(NSString *)rangeString newString:(NSString *)newString
{
    NSRange range = [[stringToChange string] rangeOfString:rangeString];
    int endRange=range.length;
    UIFont *font = fontName;
    
    NSMutableAttributedString *attributedString= [[NSMutableAttributedString alloc] initWithString:newString];
    [attributedString setAttributes:@{NSFontAttributeName : font} range:NSMakeRange(0, endRange)];
    [stringToChange replaceCharactersInRange:range withAttributedString:attributedString];
    
    
    return stringToChange;
    
}



- (id) init;{
    
    if ((self = [super init])) {
    }
    
   
    
    
    return self;
}


@end