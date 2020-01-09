//
//  UIViewController+GCWebViewSwipeBack.h
//  LiqForDoctors
//
//  Created by StriVever on 2020/1/9.
//  Copyright © 2020 iMac. All rights reserved.
//
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class WKWebView;
@protocol GCWebViewSwipeBackProtocol;
@interface UIViewController (GCWebViewSwipeBack)
- (void)addWkwebView:(id <GCWebViewSwipeBackProtocol>)webView swipeBackAble:(BOOL)canSwipeBack;
@end
@protocol GCWebViewSwipeBackProtocol <NSObject>
@property(nonatomic,getter=isHidden) BOOL              hidden; 
@property (nonatomic, readonly, getter=canGoBack) BOOL canGoBack;
@property (nonatomic, readonly, getter=canGoForward) BOOL canGoForward;
- (void)goBack;
- (void)goForward;
- (void)addGestureRecognizer:(UIGestureRecognizer*)gestureRecognizer;
@end
NS_ASSUME_NONNULL_END
