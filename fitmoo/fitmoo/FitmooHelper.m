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

- (IBAction)likeButtonAnimation:(id)sender {
    UIButton *myButton= (UIButton *)sender;
    
//    NSMutableArray *imageArray = [NSMutableArray new];
//    
//    for (int i = 0; i < 6; i ++) {
//        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"blueheart%d.png",i*10+100]]];
//    }
//    
//    for (int i = 4; i >= 0; i --) {
//        [imageArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"blueheart%d.png",i*10+100]]];
//    }

    
//    [myButton setImage:[UIImage imageNamed:@"blueheart100.png"] forState:UIControlStateNormal];
    
//    [myButton.imageView setAnimationImages:[imageArray copy]];
//    [myButton.imageView setAnimationDuration:1.5];
//    [myButton.imageView setAnimationRepeatCount:2];
//    [myButton.imageView startAnimating];
//    
//    
    UIImageView *image= [[UIImageView alloc] initWithFrame:CGRectMake(myButton.imageView.frame.origin.x, myButton.imageView.frame.origin.y, 10, 10)];
    image.image=[UIImage imageNamed:@"blueheart100.png"];
    [myButton addSubview:image];
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        image.frame=CGRectMake(myButton.imageView.frame.origin.x-5, myButton.imageView.frame.origin.y-5, 20, 20);
    }completion:^(BOOL finished){
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            image.frame=CGRectMake(myButton.imageView.frame.origin.x, myButton.imageView.frame.origin.y, 10, 10);
        }completion:^(BOOL finished){
            [image removeFromSuperview];
           
        }];
    }];
    
    
    
}

- (void) makeAHomeFeedForTestPost
{
    
}

-(UIImage *) generateWatermarkForImage:(UIImage *) mainImg withType:(NSString *) type{
    UIImage *backgroundImage = mainImg;
    
    UIImage *watermarkImage = [UIImage imageNamed:@"instagramlogo8.png"];
    
    if ([type isEqualToString:@"workout"]) {
        watermarkImage = [UIImage imageNamed:@"instagramlogo_workout.png"];
    }else if ([type isEqualToString:@"nutrition"])
    {
        watermarkImage = [UIImage imageNamed:@"instagramlogo_nutrition.png"];
    }else if ([type isEqualToString:@"product"])
    {
        watermarkImage = [UIImage imageNamed:@"instagramlogo_product.png"];
    }else if ([type isEqualToString:@"invite"])
    {
        watermarkImage = [UIImage imageNamed:@"followmeonfitmoo.png"];
    }
    
    
    //Now re-drawing your  Image using drawInRect method
    UIGraphicsBeginImageContext(backgroundImage.size);
    [backgroundImage drawInRect:CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height)];
    // set watermark position/frame a s(xposition,yposition,width,height)
    
    
    if (backgroundImage.size.width>backgroundImage.size.height) {
        [watermarkImage drawInRect:CGRectMake((backgroundImage.size.width-watermarkImage.size.width)/2, backgroundImage.size.height - watermarkImage.size.height, watermarkImage.size.width, watermarkImage.size.height)];
    }else
    {
     [watermarkImage drawInRect:CGRectMake(0, backgroundImage.size.height - watermarkImage.size.height, watermarkImage.size.width, watermarkImage.size.height)];
    }
   // [watermarkImage drawInRect:CGRectMake(100, 300, 150, 23)];
    
    // now merging two images into one
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (void) addActivityIndicator:(UIView *)view
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [[FitmooHelper sharedInstance] resizeFrameWithFrame:activityIndicator respectToSuperFrame:nil];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = CGPointMake(160*[[FitmooHelper sharedInstance] frameRadio], 240*[[FitmooHelper sharedInstance] frameRadio]);
    activityIndicator.hidesWhenStopped = YES;
    [view addSubview:activityIndicator];
    [activityIndicator startAnimating];
}


- (UIView *) addActivityIndicatorView: (UIView *)indicatorView and: (UIView *) selfView
{
    indicatorView= [[UIView alloc] initWithFrame:CGRectMake(selfView.frame.size.width/2-50, 200*[[FitmooHelper sharedInstance] frameRadio], 100, 100)];
    indicatorView.backgroundColor=[UIColor colorWithRed:174.0/255.0 green:182.0/255.0 blue:186.0/255.0 alpha:1];
  
  //  indicatorView.backgroundColor=[UIColor clearColor];
    //  view.backgroundColor=[UIColor whiteColor];
    indicatorView.layer.cornerRadius=5;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [[FitmooHelper sharedInstance] resizeFrameWithFrame:activityIndicator respectToSuperFrame:nil];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = CGPointMake(50, 40);
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator setBackgroundColor:[UIColor clearColor]];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [activityIndicator startAnimating];
    
    UILabel * postingLabel= [[UILabel alloc] initWithFrame: CGRectMake(0,60, 100, 30)];
    postingLabel.text= @"LOADING...";
    //  postingLabel.textColor=[UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1];
    postingLabel.textColor=[UIColor whiteColor];
    UIFont *font = [UIFont fontWithName:@"BentonSans-Bold" size:13];
    [postingLabel setFont:font];
    postingLabel.textAlignment=NSTextAlignmentCenter;
    
    [indicatorView addSubview:activityIndicator];
    [indicatorView addSubview:postingLabel];
    [selfView addSubview:indicatorView];
    
    
    return indicatorView;
    // self.view.userInteractionEnabled=NO;
}

-(void) showViewWithAnimation: (NSString *) text withPareView: (UIView *)parentView
{
    double radio= [[FitmooHelper sharedInstance] frameRadio];
    UILabel *v= [[UILabel alloc] initWithFrame:CGRectMake(10*radio, -80*radio, 300*radio, 40*radio)];
    v.alpha=1;
    v.backgroundColor=[UIColor blackColor];
    v.textColor= [UIColor whiteColor];
    v.text=text;
    v.textAlignment=NSTextAlignmentCenter;
    UIFont *font = [UIFont fontWithName:@"BentonSans" size:12];
    [v setFont:font];
    
    [parentView addSubview:v];
    
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        v.frame=CGRectMake(10*radio, 20*radio, 300*radio, 40*radio);
    }completion:^(BOOL finished){
        [UIView animateWithDuration:1 delay:0.7 options:UIViewAnimationOptionTransitionNone animations:^{
            v.alpha=0;
        }completion:^(BOOL finished){
            [v removeFromSuperview];
        }];
        
        
    }];
    
    
}

- (NSString *) getTextForNumber: (NSString *) numberString
{
    if (numberString.intValue>999999) {
        CGFloat following=numberString.intValue/1000000.0f;
        NSString *result= [NSString stringWithFormat:@"%0.01f%@",following,@"M"];
        return result;
    }
    
    if (numberString.intValue>999) {
        CGFloat following=numberString.intValue/1000.0f;
        NSString *result= [NSString stringWithFormat:@"%0.01f%@",following,@"K"];
        return result;
    }
    
  
    
    return numberString;
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
        if (year==1) {
            return @"about a year ago";
        }
        return [NSString stringWithFormat:@"%d%@",year, @" years ago"];
    }
    else if (months!=0) {
        if (months==1) {
            return @"about a month ago";
        }
        return [NSString stringWithFormat:@"%d%@",months, @" months ago"];
    }else if (days!=0) {
        if (days==1) {
            return @"about a day ago";
        }
        return [NSString stringWithFormat:@"%d%@",days, @" days ago"];
    }else if (hours!=0) {
        if (hours==1) {
            return @"about a hour ago";
        }
        
        return [NSString stringWithFormat:@"%d%@",hours, @" hours ago"];
    }else if (minutes!=0) {
        if (minutes<=1) {
            return @"about a minute ago";
        }
        
        return [NSString stringWithFormat:@"%d%@",minutes, @" minutes ago"];
    }
    
    
    return @"about a minute ago";
}

-(CGRect) caculateLabelHeight: (UILabel *) label
{
    //    if ([label isEqual:[NSNull null]]) {
    //        CGRect newFrame =CGRectMake(0, 0, 1, 1);
    //        return newFrame;
    //    }
    
    CGSize maximumLabelSize = CGSizeMake(label.frame.size.width*_frameRadio, FLT_MAX);
    
    CGSize expectedLabelSize = [label.text sizeWithFont:label.font constrainedToSize:maximumLabelSize lineBreakMode:label.lineBreakMode];
    
    CGRect newFrame = label.frame;
    //   newFrame.size.height = expectedLabelSize.height;
    
    int lines = expectedLabelSize.height/label.font.pointSize;
    
    newFrame.size.height = expectedLabelSize.height+10*(lines-1)+10;
    
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


- (NSString *) generateTimeString:(NSString *)timeString
{
    
//    if (timeString.intValue<60) {
//        if (timeString.intValue<2) {
//            timeString=[NSString stringWithFormat:@"%@ %@",timeString, @"sec"];
//        }else
//        {
//            timeString=[NSString stringWithFormat:@"%@ %@",timeString, @"secs"];
//        }
//        
//    }else  if (timeString.intValue<3600)
//    {
//        
//        double min=timeString.intValue/60;
//        double sec=timeString.intValue%60;
//        if (sec==0) {
//            if (min==1) {
//                timeString=[NSString stringWithFormat:@"%1.0f%@",min, @" min"];
//            }else
//            {
//                timeString=[NSString stringWithFormat:@"%1.0f%@",min, @" mins"];
//            }
//        }else
//        {
//            NSString * minuteStr= [NSString stringWithFormat:@"%1.0f",min];
//            NSString * secondStr= [NSString stringWithFormat:@"%1.0f",sec];
//            if (min<10) {
//                minuteStr= [NSString stringWithFormat:@"0%1.0f",min];
//            }
//            if (sec<10) {
//                secondStr= [NSString stringWithFormat:@"0%1.0f",sec];
//            }
//            
//            timeString=[NSString stringWithFormat:@"00 : %@%@%@",minuteStr, @" : ", secondStr];
//        }
//        
//        
//    }else
//    {
//        
//        double hour=timeString.intValue/3600;
//        double min=(timeString.intValue-3600*hour)/60;
//        double sec=timeString.intValue%60;
//        
//        if (min==0&&sec==0) {
//            if (hour==1) {
//                timeString=[NSString stringWithFormat:@"%1.0f%@",hour, @" hour"];
//            }else
//            {
//                timeString=[NSString stringWithFormat:@"%1.0f%@",hour, @" hours"];
//            }
//        }else
//        {
//            NSString * minuteStr= [NSString stringWithFormat:@"%1.0f",min];
//            NSString * secondStr= [NSString stringWithFormat:@"%1.0f",sec];
//            if (min<10) {
//                minuteStr= [NSString stringWithFormat:@"0%1.0f",min];
//            }
//            if (sec<10) {
//                secondStr= [NSString stringWithFormat:@"0%1.0f",sec];
//            }
//            timeString=[NSString stringWithFormat:@"%1.0f%@%@%@%@",hour, @" : ", minuteStr,@" : ", secondStr ];
//        }
//    }
//    
    int hour=timeString.intValue/3600;
    int min=(timeString.intValue-3600*hour)/60;
    int sec=timeString.intValue%60;
    NSString * minuteStr= [NSString stringWithFormat:@"%d",min];
    NSString * secondStr= [NSString stringWithFormat:@"%d",sec];
    NSString * hourStr= [NSString stringWithFormat:@"%d",hour];
    if (min<10) {
        minuteStr= [NSString stringWithFormat:@"0%d",min];
    }
    if (sec<10) {
        secondStr= [NSString stringWithFormat:@"0%d",sec];
    }
    
    if (hour<10) {
        hourStr= [NSString stringWithFormat:@"0%d",hour];
    }
    timeString=[NSString stringWithFormat:@"%@%@%@%@%@",hourStr, @" : ", minuteStr,@" : ", secondStr ];

    
    return timeString;
}


- (Workout *) generateWorkout: (NSDictionary *) dic
{

        Workout *workout= [[Workout alloc] init];
    
        workout.name=[dic objectForKey:@"name"];
  //      NSNumber *type_id=[dic objectForKey:@"id"];
  //      workout.workout_id=type_id.stringValue;
        
        NSNumber *feed_id=[dic objectForKey:@"feed_id"];
        workout.feed_id=feed_id.stringValue;
    
        NSNumber *begin_time=[dic objectForKey:@"begin_time"];
        NSNumber *end_time=[dic objectForKey:@"end_time"];
        workout.begin_time=begin_time.stringValue;
        workout.end_time=end_time.stringValue;
        
        NSNumber *is_repeated=[dic objectForKey:@"is_repeated"];
        workout.is_repeated=is_repeated.stringValue;
    
        return workout;
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
            [homeFeed resetPhotos];
            homeFeed.photos.photo_id= [photoDic objectForKey:@"id"];
            NSDictionary *orignal=[photoDic objectForKey:@"original"];
            homeFeed.photos.originalUrl= [orignal objectForKey:@"photo_url"];
            
            NSDictionary *styles=[photoDic objectForKey:@"styles"];
            NSDictionary *slider=[styles objectForKey:@"slider"];
            
            homeFeed.photos.stylesUrlWidth=[slider objectForKey:@"width"];
            homeFeed.photos.stylesUrlHeight=[slider objectForKey:@"height"];
            homeFeed.photos.stylesUrl=[slider objectForKey:@"photo_url"];
            
            NSDictionary *small=[styles objectForKey:@"small"];
            homeFeed.photos.smallUrl=[small objectForKey:@"photo_url"];
            
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
        if ([homeFeed.created_by_community.cover_photo_url isEqual:[NSNull null ]]||homeFeed.created_by_community.cover_photo_url==nil) {
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
            NSDictionary *coverPhoto= [createdByCommunity objectForKey:@"cover_photo"];
            homeFeed.feed_action.created_by_community.cover_photo_url= [coverPhoto objectForKey:@"url"];
            
            if ([homeFeed.feed_action.created_by_community.cover_photo_url isEqual:[NSNull null ]]||homeFeed.feed_action.created_by_community.cover_photo_url==nil) {
                homeFeed.feed_action.created_by_community.cover_photo_url= @"https://fitmoo.com/assets/group/cover-default.png";
            }
            
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
        homeFeed.product.photo= [product objectForKey:@"feed_photos"];
        NSNumber * allowed_for_sale=[product objectForKey:@"allowed_for_sale"];
        homeFeed.product.allowed_for_sale=[allowed_for_sale stringValue];
        NSNumber * shipping_buyer_amount=[product objectForKey:@"shipping_buyer_amount"];
        homeFeed.product.shipping_buyer_amount=[shipping_buyer_amount stringValue];
        NSNumber * shipping_full_amount=[product objectForKey:@"shipping_full_amount"];
        homeFeed.product.shipping_full_amount=[shipping_full_amount stringValue];
        NSNumber * shipping_type_id=[product objectForKey:@"shipping_type_id"];
        homeFeed.product.shipping_type_id=[shipping_type_id stringValue];
        NSNumber * sold_out=[product objectForKey:@"sold_out"];
        homeFeed.product.sold_out=[sold_out stringValue];
    
        
        NSDictionary *options=[product objectForKey:@"variant_options"];
        for (NSDictionary *option in options) {
            [homeFeed.product resetOptions];
            homeFeed.product.variant_options.title=[option objectForKey:@"title"];
            NSArray *optionArray= [option objectForKey:@"options"];
            homeFeed.product.variant_options.optionArray=[optionArray mutableCopy];
            [homeFeed.product.variant_options_array addObject:homeFeed.product.variant_options];
        }
        
        NSDictionary *variants=[product objectForKey:@"variants"];
        for (NSDictionary *variant in variants) {
            [homeFeed.product resetVariants];
            
            NSNumber * deleted=[variant objectForKey:@"deleted"];
            homeFeed.product.variants.deleted=[deleted stringValue];
            NSNumber * enabled=[variant objectForKey:@"enabled"];
            homeFeed.product.variants.enabled=[enabled stringValue];
            NSNumber * variants_id=[variant objectForKey:@"id"];
            homeFeed.product.variants.variants_id=[variants_id stringValue];
            NSNumber * needs_shipping=[variant objectForKey:@"needs_shipping"];
            homeFeed.product.variants.needs_shipping=[needs_shipping stringValue];
            NSNumber * price=[variant objectForKey:@"price"];
            homeFeed.product.variants.price=[price stringValue];
            NSNumber * quantity=[variant objectForKey:@"quantity"];
            homeFeed.product.variants.quantity=[quantity stringValue];
          //  NSNumber * sku=[variant objectForKey:@"sku"];
            homeFeed.product.variants.sku=[variant objectForKey:@"sku"];
           // NSNumber * weight=[variant objectForKey:@"weight"];
            homeFeed.product.variants.weight=[variant objectForKey:@"weight"];
            
            NSDictionary *photoDic=[variant objectForKey:@"photo"];
            
            if ([photoDic isKindOfClass:[NSDictionary class]]) {
                NSDictionary *slider=[photoDic objectForKey:@"slider"];
                homeFeed.product.variants.photo.stylesUrl=[slider objectForKey:@"photo_url"];
                homeFeed.product.variants.photo.stylesUrlWidth=[slider objectForKey:@"width"];
                homeFeed.product.variants.photo.stylesUrlHeight=[slider objectForKey:@"height"];
            }else
            {
                homeFeed.product.variants.photo.stylesUrl=[variant objectForKey:@"photo"];
                homeFeed.product.variants.photo.stylesUrlWidth=@"320";
                homeFeed.product.variants.photo.stylesUrlHeight=@"320";
            }
            
            homeFeed.product.variants.type=[variant objectForKey:@"type"];
            homeFeed.product.variants.title=[variant objectForKey:@"title"];
            homeFeed.product.variants.options=[variant objectForKey:@"options"];
            [homeFeed.product.variant_array addObject:homeFeed.product.variants];
            
        }
        
        
        NSMutableArray *allOptions=[[NSMutableArray alloc] init];
        NSMutableArray *allOptionsTitle=[[NSMutableArray alloc] init];
        for (int i=0; i<[homeFeed.product.variant_options_array count]; i++) {
             [homeFeed.product resetOptions];
             homeFeed.product.variant_options=[homeFeed.product.variant_options_array objectAtIndex:i];
            [allOptionsTitle addObject:homeFeed.product.variant_options.title];
            for (int j=0; j<[homeFeed.product.variant_options.optionArray count]; j++) {
                [allOptions addObject:[homeFeed.product.variant_options.optionArray objectAtIndex:j]];
            }
        }
        
        
        NSArray *variant_matrixs_array=[product objectForKey:@"variant_matrix"];
        
        if ([variant_matrixs_array count]>0) {
            NSDictionary *variant_matrixs= [variant_matrixs_array objectAtIndex:0];
            
            for (int m=0; m<[variant_matrixs count]; m++) {
                [homeFeed.product resetMatrixs];
                NSString *matrixs_name= [allOptions objectAtIndex:m];
                NSDictionary *matrixsDic= [variant_matrixs objectForKey:matrixs_name];
                //check matixs_name belongs to which option and remove it
                NSMutableArray *allOptionsTitleCopy=[allOptionsTitle mutableCopy];
                int index=0;
                for (int i=0; i<[homeFeed.product.variant_options_array count]; i++) {
                    [homeFeed.product resetOptions];
                    homeFeed.product.variant_options=[homeFeed.product.variant_options_array objectAtIndex:i];
                    for (int j=0; j<[homeFeed.product.variant_options.optionArray count]; j++) {
                        if ([matrixs_name isEqualToString:[homeFeed.product.variant_options.optionArray objectAtIndex:j]]) {
                            index=i;
                        }
                    }
                }
                
                [allOptionsTitleCopy removeObjectAtIndex:index];
                
                for (int i=0; i<[allOptionsTitleCopy count]; i++) {
                    homeFeed.product.variant_matrix.matrix_name=matrixs_name;
                    [homeFeed.product.variant_matrix.matrix_data_array addObject:[matrixsDic objectForKey:[allOptionsTitleCopy objectAtIndex:i]]];
                    [homeFeed.product.variant_matrix.matrix_option_array addObject:[allOptionsTitleCopy objectAtIndex:i]];
                    
                }

                [homeFeed.product.variant_matrix_array addObject:homeFeed.product.variant_matrix];
                
            }
            


        }//end of[variant_matrixs_array count]>0
        
        
    }
    
    NSDictionary *nutrition=[dic objectForKey:@"nutrition"];
    if (![nutrition isEqual:[NSNull null ]]) {
        homeFeed.nutrition.nutrition_id= [nutrition objectForKey:@"id"];
        homeFeed.nutrition.title= [nutrition objectForKey:@"title"];
        homeFeed.nutrition.ingredients= [nutrition objectForKey:@"ingredients"];
        if ([homeFeed.nutrition.ingredients isEqual:[NSNull null]]) {
            homeFeed.nutrition.ingredients=@"";
        }
        
        homeFeed.nutrition.preparation= [nutrition objectForKey:@"preparation"];
        
        if ([homeFeed.nutrition.preparation isEqual:[NSNull null]]) {
            homeFeed.nutrition.preparation=@"";
        }
    }
    
    NSDictionary *workout=[dic objectForKey:@"workout"];
    if (![workout isEqual:[NSNull null ]]) {
        homeFeed.workout.workout_id= [workout objectForKey:@"id"];
        homeFeed.workout.title= [workout objectForKey:@"title"];
        
        NSNumber * time=[workout objectForKey:@"time"];
        
        if ([time isEqual:[NSNull null]]) {
            homeFeed.workout.time=@"";
        }else
        {
            homeFeed.workout.time= [time stringValue];
        }
        
        homeFeed.workout.workout_type= [workout objectForKey:@"workout_type"];
        
        if ([homeFeed.workout.workout_type isEqual:[NSNull null]]) {
            homeFeed.workout.workout_type=@"";
        }
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
        
        //        NSDictionary *theme= [dic  objectForKey:@"theme"];
        //        if (![theme isEqual:[NSNull null]]) {
        //            NSDictionary *styles= [theme  objectForKey:@"styles"];
        //            NSDictionary *medium= [styles  objectForKey:@"medium"];
        //            homeFeed.event.theme= [medium  objectForKey:@"photo_url"];
        //            if(homeFeed.event.theme==nil||[homeFeed.event.theme isEqualToString:@""])
        //            {
        //                homeFeed.event.theme=@"https://fitmoo.com/assets/cover/theme-event-feed.png";
        //            }
        //
        //        }
        
        homeFeed.photos.originalUrl=homeFeed.event.theme;
        homeFeed.photos.stylesUrl=homeFeed.event.theme;
        [homeFeed.photoArray addObject:homeFeed.photos];
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

- (NSString *) checkStringIsANumeric:(NSString *)newString
{
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([newString rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        return newString;
        // newString consists only of the digits 0 through 9
    }
    
    return newString.uppercaseString;
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
    
    _firstTimeLoadingCircle=0;
    _firstTimeLoadingCircle1=0;
    _firstTimeLoadingCircle2=0;
    _firstTimeLoadingCircle3=0;
    
    
    return self;
}


@end