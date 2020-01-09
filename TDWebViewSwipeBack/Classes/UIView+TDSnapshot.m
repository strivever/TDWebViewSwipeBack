//
//  UIView+TDSnapshot.m
//  WKWebViewSwipeBack
//
//  Created by StriVever on 2020/1/9.
//  Copyright © 2020 StriVever. All rights reserved.
//

#import "UIView+TDSnapshot.h"
@implementation UIView (TDSnapshot)
- (void )screenSnapshot:(void(^)(UIImage *snapShotImage))finishBlock{
    if (!finishBlock)return;
    
    UIImage *snapshotImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size,NO,[UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.layer renderInContext:context];

    snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    finishBlock(snapshotImage);
}
@end
