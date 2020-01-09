//
//  TDViewController.m
//  TDWebViewSwipeBack
//
//  Created by 458362366@qq.com on 01/09/2020.
//  Copyright (c) 2020 458362366@qq.com. All rights reserved.
//

#import "TDViewController.h"
#import <UIViewController+GCWebViewSwipeBack.h>
#import <WebKit/WebKit.h>
@interface TDViewController ()
@property (strong, nonatomic) WKWebView<GCWebViewSwipeBackProtocol> *wkWebView;

@end

@implementation TDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.wkWebView];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dogedoge.com"]]];
    [self addWkwebView:self.wkWebView swipeBackAble:YES];
	// Do any additional setup after loading the view, typically from a nib.
}
#pragma mark ---getter
- (WKWebView *)wkWebView{
    if (_wkWebView == nil) {
        _wkWebView = [[WKWebView alloc]initWithFrame:self.view.bounds];
    }
    return _wkWebView;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
