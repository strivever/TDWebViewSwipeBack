//
//  UIView+TDSnapshot.h
//  WKWebViewSwipeBack
//
//  Created by StriVever on 2020/1/9.
//  Copyright © 2020 StriVever. All rights reserved.
//
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIView (TDSnapshot)
- (void )screenSnapshot:(void(^)(UIImage *snapShotImage))finishBlock;
@end

NS_ASSUME_NONNULL_END
