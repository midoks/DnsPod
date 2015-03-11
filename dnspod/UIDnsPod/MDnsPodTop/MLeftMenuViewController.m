//
//  MLeftViewController.m
//  dnspod
//
//  Created by midoks on 14/12/16.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import "MLeftMenuViewController.h"
#import "MDnsPodViewController.h"
#import "MLoginViewController.h"
#import "MAboutMeViewController.h"
#import "MAdviseViewController.h"
#import "SlideNavigationController.h"

@interface MLeftMenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftMenu.jpg"]];
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    _tableView.backgroundView = imageView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    UIColor *tableviewBgcolor = [UIColor colorWithRed:91.0/255.0
                                             green:90.0/255.0
                                              blue:91.0/255.0
                                             alpha:1];
    _tableView.backgroundColor = tableviewBgcolor;
    MLeftMenuViewControllerSingle = self;
}

static MLeftMenuViewController *MLeftMenuViewControllerSingle;
+(MLeftMenuViewController *)sharedInstance
{
    if (!MLeftMenuViewControllerSingle) {
        return [[self alloc] init];
    }
    return MLeftMenuViewControllerSingle;
}


-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    //_tableView.frame = self.view.bounds;
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width - MENU_DEFAULT_SLIDE_OFFSET,
                                  self.view.frame.size.height);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 20)];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 20;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leftMenuCell"];
        NSString *username = nil;
        //检查已经登录的用户
        if([self->file GetUser]){
            NSDictionary *_p_user = [self->file GetUser][0];
            NSString *user = [_p_user objectForKey:@"user"];
            username = [NSString stringWithFormat:@"账户信息:\r\n%@", user];
        }else{
            username = [NSString stringWithFormat:@"账户信息:\r\n%@", @"获取失败!!"];
        }
        
        switch (indexPath.row)
        {
            case 0:
                cell.imageView.image = [UIImage imageNamed:@"info_icon"];
                cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.text = username;
                break;
            case 1:
                cell.imageView.image = [UIImage imageNamed:@"com_icon"];
                cell.textLabel.text = @"主页域名";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"about_icon"];
                cell.textLabel.text = @"关于我们";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 3:
                cell.imageView.image = [UIImage imageNamed:@"logout_icon"];
                cell.textLabel.text = @"注销账户";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 4:
                cell.imageView.image = [UIImage imageNamed:@"exit_icon"];
                cell.textLabel.text = @"退出程序";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
        }

        cell.textLabel.font = [UIFont systemFontOfSize:18.0];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60;
    }else{
        return 44;
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return nil;
    }
    else
    {
        return indexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *ds = nil;
    switch (indexPath.row) {
        case 0:break;
        case 1:[self goMainDomainList];break;
        case 2:ds = [MAboutMeViewController sharedInstance];break;
        //case 3:[self sendMailText];return;
        case 3:[self UserExt];break;
        case 4:[self AppExt];break;
    }
    
    if (ds){[self push:ds];}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)push:(UIViewController *)vc
{
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:NO
                                                                     andCompletion:nil];
}

- (void)goMainDomainList
{
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
        UIViewController *ds = [[MDnsPodViewController alloc] init];
        [self push:ds];
    }];
}

- (void)sendMailText
{
    MAdviseViewController *ds = [MAdviseViewController sharedInstance];
    [self push:ds];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://deveprograms@apple.com"]];
    //
    //    NSString *subject = @"Message subject";
    //    NSString *body = @"Message body";
    //    NSString *address = @"test1@akosma.com";
    //    NSString *cc = @"test2@akosma.com";
    //    NSString *path = [NSString stringWithFormat:@"mailto:%@?cc=%@&subject=%@&body=%@", address, cc, subject, body];
    //    NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //    [[UIApplication sharedApplication] openURL:url];
    //
    //
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://blog.csdn.net/duxinfeng2010"]];
    //    [self push:mailPicker];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //程序退出
    if([alertView.title isEqualToString:@"你确定退出程序"] && (buttonIndex == 1))
    {
        exit(0);
    }
    
    //注销账户
    if([alertView.title isEqualToString:@"你确定注销用户"] && (buttonIndex == 1))
    {
        [self clearCookies];
        [self->file ClearUser];
        UIViewController* ds = [[MLoginViewController alloc] init];
        [self push:ds];
    }
}

//用户注销
-(void)UserExt
{
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你确定注销用户"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        [alert show];
    }];
}

//用户退出
-(void)AppExt
{
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你确定退出程序"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        [alert show];
    }];
}

//清空所有cookie
-(void)clearCookies
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://dnsapi.cn/Info.Version"]
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:3];
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:nil
                                      error:nil];
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieJar deleteCookie:cookie];
    }
}

@end
