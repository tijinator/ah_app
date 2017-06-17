//
//  SearchField.h
//  fitmoo
//
//  Created by hongjian lin on 6/17/17.
//  Copyright © 2017 com.fitmoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchTextFieldDelegate
- (void)requestSearchObject:(NSString *) searchTerm;

@end


@interface SearchField : UITextField <UITextFieldDelegate>

@property (nonatomic, assign) BOOL refresh;
@property (nonatomic, assign) double ticks;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) NSTimer * queueTimer;
@property (nonatomic, strong) NSMutableArray * callQueueArray;


@property (nonatomic, weak) id<SearchTextFieldDelegate> searchDelegate;

@end
