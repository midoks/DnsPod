//
//  MAboutMeViewController.m
//  dnspod
//
//  Created by midoks on 14/12/17.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import "MAboutMeViewController.h"

@interface MAboutMeViewController ()
{
    UIWebView *_webView;
}

@end

@implementation MAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.title = @"关于我们";
    [self setTitleS:@"关于我们"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    NSString *html = @"<body style='background-color:#ccc;font-size:16px;'><p style='margin-top:50px;'>1.欢迎大家使用我和jason开发的DNSPod的iOS客服端。</p><p>2.本软件是根据DNSPod提供API开发完成。</p><p>3.本软件只对DnsPod上的域名进行管理。对域名进行添加、删除、暂停、启用。并对域名的记录,进行添加、删除、修改、暂停,启用。</p><p>4.本软件采用本地存储密码的方式,你可以使用注销的方式,清空所有信息。</p><p>5.本软件也对使用D令牌的用户进行了支持。</p><p>6.谢谢你的使用。对于我们的开发,有什么更好的意见。可以把你的意见,发送的我的邮件<a href='mailto:midoks@163.com'>midoks@163.com</a>(在使用期间,把你具体的需求描述出来,就更好了)。</p><hr /><p style='text-align:center;'>本软件是midoks和jason合作完成。</p></body>";
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [_webView loadHTMLString:html baseURL:nil];
    [self.view addSubview:_webView];
    
    MAboutMeViewControllerSingle = self;
}

static MAboutMeViewController *MAboutMeViewControllerSingle;
+(MAboutMeViewController *)sharedInstance
{
    if (!MAboutMeViewControllerSingle) {
        return [[self alloc] init];
    }
    return MAboutMeViewControllerSingle;
}

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect r = [UIScreen mainScreen].bounds;
    self.view.frame = r;
    _webView.frame = r;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
