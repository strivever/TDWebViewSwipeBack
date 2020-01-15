//
//  UIViewController+GCWebViewSwipeBack.m
//  LiqForDoctors
//
//  Created by StriVever on 2020/1/9.
//  Copyright © 2020 iMac. All rights reserved.
//

#import "UIViewController+GCWebViewSwipeBack.h"
#import "UIView+TDSnapshot.h"
#import <WebKit/WebKit.h>
#import <objc/runtime.h>
static CGFloat kValidSwipeDistance;
#define kUIScreenSize [UIScreen mainScreen].bounds.size
#define kUIScreenWidth kUIScreenSize.width
#define kUIScreenHeight kUIScreenSize.height

@interface GCPanGestureReconizerDelegate : NSObject <UIGestureRecognizerDelegate>
@end
@implementation GCPanGestureReconizerDelegate
#pragma mark ---UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    UIView <GCWebViewSwipeBackProtocol>*  weakWebView = (UIView <GCWebViewSwipeBackProtocol>*)gestureRecognizer.view;
    // 当当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势
    if ([weakWebView canGoBack]) {
        CGPoint point = [gestureRecognizer velocityInView:weakWebView.superview];
        // 只有当横向滑动速度大于150时,并且纵向速度绝对值小于150时,才响应手势(可根据需要设置)
        if (point.x <= 150 || (point.y >= 150 || point.y <= -150)) {
            return NO;
        }
        return YES;
    }
    return NO;
}
//此方法返回YES时，手势事件会一直往下传递，不论当前层次是否对该事件进行响应。
- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
     UIView <GCWebViewSwipeBackProtocol>* weakWebView = (UIView <GCWebViewSwipeBackProtocol>*) gestureRecognizer.view;
    if ([weakWebView canGoBack] == NO) {
        return YES;
    }
    return NO;
}
@end

@interface UIViewController ()
@property (nonatomic, assign) BOOL swiping;
@property (nonatomic, strong) UIImageView * fromImageView;
@property (nonatomic, strong) UIView * coverView;
@property (nonatomic, strong) UIPanGestureRecognizer * panGestureReconizer;
@property (nonatomic, weak) id <GCWebViewSwipeBackProtocol> weakWebView;
@property (nonatomic, strong) GCPanGestureReconizerDelegate * panGestureReconizerDelegate;
@end
@implementation UIViewController (GCWebViewSwipeBack)
- (void)addSwipeBackableForWebView:(id <GCWebViewSwipeBackProtocol>)webView{
    self.weakWebView = webView;
    [self.weakWebView addGestureRecognizer:self.panGestureReconizer];
    kValidSwipeDistance = kUIScreenWidth/2.0 - 30;
}
- (void)setSwiping:(BOOL)swiping{
    objc_setAssociatedObject(self, @selector(swiping), @(swiping), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)swiping{
    return  [objc_getAssociatedObject(self, _cmd)boolValue];
}
- (void)setPanGestureReconizerDelegate:(GCPanGestureReconizerDelegate *)panGestureReconizerDelegate{
    objc_setAssociatedObject(self, @selector(panGestureReconizerDelegate), panGestureReconizerDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (GCPanGestureReconizerDelegate *)panGestureReconizerDelegate{
    GCPanGestureReconizerDelegate * panGestureReconizerDelegate = objc_getAssociatedObject(self, _cmd);
    if (panGestureReconizerDelegate == nil) {
        panGestureReconizerDelegate = [[GCPanGestureReconizerDelegate alloc]init];
        objc_setAssociatedObject(self, @selector(panGestureReconizerDelegate), panGestureReconizerDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureReconizerDelegate;
}
- (void)setFromImageView:(UIImageView *)fromImageView{
    objc_setAssociatedObject(self, @selector(fromImageView), fromImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIImageView *)fromImageView{
    UIImageView * fromImageView = objc_getAssociatedObject(self, _cmd);
    if (fromImageView == nil) {
        fromImageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        objc_setAssociatedObject(self, @selector(fromImageView), fromImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return fromImageView;
}
- (void)setCoverView:(UIView *)coverView{
    objc_setAssociatedObject(self, @selector(coverView), coverView, OBJC_ASSOCIATION_RETAIN);
}
- (UIView *)coverView{
    UIView * coverView = objc_getAssociatedObject(self, _cmd);
    if (coverView == nil) {
        coverView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        coverView.backgroundColor = [UIColor grayColor];
        coverView.userInteractionEnabled = NO;
        objc_setAssociatedObject(self, @selector(coverView), coverView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return coverView;
}
- (void)setPanGestureReconizer:(UIPanGestureRecognizer *)panGestureReconizer{
    objc_setAssociatedObject(self, @selector(panGestureReconizer), panGestureReconizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIPanGestureRecognizer *)panGestureReconizer{
    UIPanGestureRecognizer * panGestureReconizer = objc_getAssociatedObject(self, _cmd);
    if (panGestureReconizer == nil) {
        panGestureReconizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(swipeBackAction:)];
        panGestureReconizer.delegate = self.panGestureReconizerDelegate;
        objc_setAssociatedObject(self, _cmd, panGestureReconizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureReconizer;
}
- (void)setWeakWebView:(WKWebView *)weakWebView{
    objc_setAssociatedObject(self, @selector(weakWebView), weakWebView, OBJC_ASSOCIATION_ASSIGN);
}
- (WKWebView *)weakWebView{
    return objc_getAssociatedObject(self, _cmd);
}
#pragma mark --- private
- (void)_showFromViewContent{
    __weak typeof(self)weakSelf = self;
    [self.view.window screenSnapshot:^(UIImage * _Nonnull snapShotImage) {
         __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.fromImageView removeFromSuperview];
        [strongSelf.coverView removeFromSuperview];
        strongSelf.coverView.hidden = NO;
        strongSelf.fromImageView.image = snapShotImage;
        strongSelf.fromImageView.hidden = NO;
        strongSelf.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
        [strongSelf.view addSubview:self.coverView];
        [strongSelf.view.window addSubview:self.fromImageView];
    }];
}
///返回成功
- (void)_backSucessHideFromViewContent{
    self.swiping = NO;
    [UIView animateWithDuration:.2 animations:^{
        CGRect frame = self.fromImageView.frame;
        frame.origin.x = kUIScreenWidth;
        self.fromImageView.frame = frame;
    }completion:^(BOOL finished) {
        [self _hideAllAssistView];
    }];
}
- (void)_backFailHideFromViewContent{
    [self.weakWebView goForward];
    self.weakWebView.hidden = YES;
    [UIView animateWithDuration:.3 animations:^{
        CGRect frame = self.fromImageView.frame;
        frame.origin.x = 0;
        self.fromImageView.frame = frame;
    }completion:^(BOOL finished) {
        self.weakWebView.hidden = NO;
        [self _hideAllAssistView];
    }];
}
- (void)_hideAllAssistView{
    self.fromImageView.hidden = YES;
    self.coverView.hidden = YES;
    [self.fromImageView removeFromSuperview];
    [self.coverView removeFromSuperview];
}
#pragma mark ---<##>GestureRecognizerSelector
- (void)swipeBackAction:(UIPanGestureRecognizer *)panGestureRecognizer{
    CGPoint point = [panGestureRecognizer translationInView :self.view];
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (self.swiping == NO) {
            [self _showFromViewContent];
            [self.weakWebView goBack];
        }
    }else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded){
        self.swiping = NO;
        if (point.x >= kValidSwipeDistance) {
            [self _backSucessHideFromViewContent];
        }else{
            [self _backFailHideFromViewContent];
        }
    }else if (panGestureRecognizer.state == UIGestureRecognizerStateCancelled){
        self.swiping = NO;
        self.fromImageView.hidden = YES;
        [self.weakWebView goForward];
    }else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged){
        self.fromImageView.hidden = NO;
        CGRect frame = self.fromImageView.frame;
        frame.origin.x = MAX(point.x, 0);;
        self.fromImageView.frame = frame;
        CGFloat alpha = 0.6 * (kValidSwipeDistance - point.x)/kValidSwipeDistance;
        if (alpha < 0) {
            alpha = 0;
        }
        self.coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
        self.navigationController.navigationBar.alpha = 1 - alpha;
        self.tabBarController.tabBar.alpha = 1 - alpha;
    }
}

@end
