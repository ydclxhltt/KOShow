//
//  WebViewController.m
//  GeniusWatch
//
//  Created by clei on 15/9/16.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self addBackItem];
    [self initUI];
    [self loadWebView];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addWebView];
}


- (void)addWebView
{
    _webView = [[UIWebView  alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _webView.scalesPageToFit = YES;
    _webView.scrollView.bounces = NO;
    [self.view addSubview:_webView];
}


#pragma mark 加载网页
- (void)loadWebView
{
     __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
    {
        weakSelf.urlString = weakSelf.urlString ? weakSelf.urlString : @"";
        if (weakSelf.urlString.length == 0)
        {
            return;
        }
        NSURLRequest *request = [NSURLRequest  requestWithURL:[NSURL URLWithString:weakSelf.urlString]];
        [weakSelf.webView loadRequest:request];
    });

}

#pragma mark  返回
- (void)backButtonPressed:(UIButton *)sender
{
    if ([self.webView canGoBack])
    {
        [self.webView goBack];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
