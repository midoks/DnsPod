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
    
    //self.title = @"关于我们";
    [self setTitleS:@"关于我们"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIBarButtonItem  *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(adviseMe)];
    rightButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    //NSString *html = @"<body style='background-color:#ccc;font-size:16px;'><p style='margin-top:50px;'>1.欢迎大家使用我和jason开发的DNSPod的iOS客服端。</p><p>2.本软件是根据DNSPod提供API开发完成。</p><p>3.本软件只对DnsPod上的域名进行管理。对域名进行添加、删除、暂停、启用。并对域名的记录,进行添加、删除、修改、暂停,启用。</p><p>4.本软件采用本地存储密码的方式,你可以使用注销的方式,清空所有信息。</p><p>5.本软件也对使用D令牌的用户进行了支持。</p><p>6.谢谢你的使用。对于我们的开发,有什么更好的意见。可以把你的意见,发送的我的邮件<a href='mailto:midoks@163.com'>midoks@163.com</a>(在使用期间,把你具体的需求描述出来,就更好了)。</p><hr /><p style='text-align:center;'>本软件是midoks和jason合作完成。</p></body>";
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    //[_webView loadHTMLString:html baseURL:nil];
    
    NSString *path      = [[NSBundle mainBundle] pathForResource:@"dnspod_about_me" ofType:@"html"];
    NSURL *url          = [NSURL fileURLWithPath:path];
    NSURLRequest *req   = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:req];
    
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

#pragma mark - webViewDelegate -
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView stringByEvaluatingJavaScriptFromString:@"rewrite();"];
}


#pragma mark 意见反馈
-(void) adviseMe {
    //NSString *url = @"mailto:foo@example.com?cc=bar@example.com&subject=Greetings%20from%20Cupertino!&body=Wish%20you%20were%20here!";
    //[[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    mail.mailComposeDelegate = self;
    [mail setToRecipients:[NSArray arrayWithObject:@"midoks@163.com"]];
    [mail setCcRecipients:[NSArray arrayWithObject:@"627293072@qq.com"]];
    [mail setBccRecipients:[NSArray arrayWithObject:@"renlairenwang@foxmail.com"]];
    [mail setSubject:@"意见反馈"];
    [mail setMessageBody:@"" isHTML:NO];
    [self presentViewController:mail animated:YES completion:^{
        //NSLog(@"present ok");
    }];
}

#pragma mark - MFMailComposeViewControllerDelegate -
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result
                       error:(NSError *)error
{
    if (result == MFMailComposeResultSent) {
        //NSLog(@"it`s away!");
        [self showAlert:@"提示" msg:@"反馈成功!!!"];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        //NSLog(@"dismiss ok");
    }];
}



@end
