//
//  VimeoHelper.h
//  PlayVimeo
//
//  Created by Tan Nguyen on 1/30/13.
//  Copyright (c) 2013 East Agile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol VimeoDelegate

- (void)finishedGetVimeoURL:(NSString *)url;
@end


@interface VimeoHelper : NSObject {
    UIWebView *_webView;
    UIWebView *_webViewPlay;
    id<VimeoDelegate> _delegate;
    NSString *_originUrl;
}

@property (nonatomic, retain) UIWebView *webView;
- (void)getVimeoRedirectUrlWithUrl:(NSString *)url delegate:(id<VimeoDelegate>)delegate;
@end