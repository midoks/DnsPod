//
//  MAboutMeViewController.m
//  dnspod
//
//  Created by midoks on 14/12/17.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import "MAboutMeViewController.h"

#import <MessageUI/MFMailComposeViewController.h>

@interface MAboutMeViewController () <UIWebViewDelegate, MFMailComposeViewControllerDelegate>
{
    UIWebView *_webView;
}

@end

@implementation MAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setTitleS:@"关于我们"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    UIBarButtonItem  *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(adviseMe)];
//    self.navigationItem.rightBarButtonItem = rightButton;
    //rightButton.tintColor = [UIColor whiteColor];
    
    
    
    UIBarButtonItem  *right = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(pushMenuBack)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
    
    
 
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    //[_webView loadHTMLString:html baseURL:nil];
    
    NSString *path      = [[NSBundle mainBundle] pathForResource:@"dnspod_about_me" ofType:@"html"];
    NSURL *url          = [NSURL fileURLWithPath:path];
    NSURLRequest *req   = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:req];
    
    [self.view addSubview:_webView];
}



-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect r = [UIScreen mainScreen].bounds;
    self.view.frame = r;
    _webView.frame = r;
}

#pragma mark - webViewDelegate -
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"rewrite();"];
}



@end
