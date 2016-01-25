//
//  MSettingViewController.m
//  dnspod
//
//  Created by midoks on 15/11/16.
//  Copyright © 2015年 midoks. All rights reserved.
//

#import "MSettingViewController.h"
#import "MAboutMeViewController.h"
#import "MLoginViewController.h"
#import "MBaseViewController.h"

#import "MCommon.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface MSettingViewController() <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UITableView *settingTable;

@end

@implementation MSettingViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"设置";
    
    _settingTable = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _settingTable.delegate = self;
    _settingTable.dataSource = self;
    [self.view addSubview:_settingTable];
    
    UIBarButtonItem  *right = [[UIBarButtonItem alloc] initWithTitle:@"反馈" style:UIBarButtonItemStyleDone target:self action:@selector(adviseWe)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
    
    //MSettingViewControllerSingle = self;
}

//static MSettingViewController *MSettingViewControllerSingle;
//+(MSettingViewController *)sharedInstance
//{
//    if (!MSettingViewControllerSingle) {
//        MSettingViewControllerSingle = [[self alloc] init];
//    }
//    return MSettingViewControllerSingle;
//}


#pragma mark - UITableViewDelegate -

#pragma mark 显示多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

#pragma mark 显示多少行
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 4;
    } else if (section == 2) {
        return 1;
    }
    return 3;
}

#pragma mark - UITableViewDataSource -

#pragma mark - 每行数据显示 -
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"指纹解锁";
        
        UISwitch *touchId = [[UISwitch alloc] init];
        touchId.frame = CGRectMake(self.view.frame.size.width-55, fabs(cell.frame.size.height-50), 50, 50);
        
        BOOL touchIdValue = [MCommon getTouchIdValue];
        touchId.on = touchIdValue;
        [touchId addTarget:self action:@selector(touchIDValidate:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview: touchId];
        
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"关于我们";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if(indexPath.row == 1){
            cell.textLabel.text = @"反馈或建议";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if (indexPath.row == 2){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
            cell.textLabel.text = @"版本";
            cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        } else if (indexPath.row == 3){
            cell.textLabel.text = @"去评分";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    } else if (indexPath.section == 2) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.text = @"注销账号";
    }else{
        cell.textLabel.text = @"test";
    }
    
    return cell;
}

#pragma mark - 每行点击事件 -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self goAboutWe];
        }else if(indexPath.row ==1){
            [self adviseWe];
        } else if (indexPath.row == 3){
            [self goAppScore];
        }
    }else if(indexPath.section == 2){
        [self goUserExit];
    }
}


#pragma mark - MFMailComposeViewControllerDelegate -
-(void)mailComposeController:(MFMailComposeViewController *)controller
         didFinishWithResult:(MFMailComposeResult)result
                       error:(NSError *)error
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (result == MFMailComposeResultSent) {
            [self showAlert:@"提示" msg:@"反馈成功!!!"];
        }
        //        else if (result == MFMailComposeResultCancelled){
        //            [self showAlert:@"提示" msg:@"你已经取消反馈了!!!"];
        //        }
    }];
}

#pragma mark - Private Methods -

#pragma mark - 关于我们 -
-(void)goAboutWe
{
    MAboutMeViewController *ds = [[MAboutMeViewController alloc] init];
    [[SlideNavigationController sharedInstance] pushViewController:ds animated:YES];
}

#pragma mark 意见反馈
-(void) adviseWe {
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    mail.mailComposeDelegate = self;
    [mail setToRecipients:[NSArray arrayWithObject:@"midoks@163.com"]];
    [mail setSubject:@"米帮手-意见反馈"];
    [mail setMessageBody:@"" isHTML:NO];
    [self presentViewController:mail animated:YES completion:^{}];
}

#pragma mark - TouchID -
-(void) touchIDValidate:(id)sender
{
    UISwitch * whichSwitch = (UISwitch *)sender;
    BOOL setting = whichSwitch.isOn;
    
    if (setting) {
        [MCommon touchConfirm:@"开启指纹验证" success:^(BOOL success) {
            if(success){
                [MCommon setTouchIdValue:YES];
                [self showAlert:@"提示" msg:@"指纹验证开启成功!"];
            }else{
                [self showAlert:@"提示" msg:@"指纹验证开启失败!"];
            }
            
            [MCommon asynTask:^{
                [self.settingTable reloadData];
            }];
            
        } fail:^{
            [self showAlert:@"提示" msg:@"你的设备不支持!"];
            [self.settingTable reloadData];
        }];
        
    }else{
        [MCommon setTouchIdValue:NO];
        [self showAlert:@"提示" msg:@"你取消了指纹验证!"];
    }
}

#pragma mark - 去评分 -
-(void)goAppScore
{
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%d&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8", 1059963031];
    NSURL *goUrl = [[NSURL alloc] initWithString:url];
    //NSLog(@"%@",goUrl);
    [[UIApplication sharedApplication] openURL:goUrl];
}

#pragma mark - 账户注销 -
-(void)goUserExit
{
    [self showAlert:@"你确定注销用户" msg:@"" ok:^{
        [self clearCookies];
        [self->file ClearUser];
        [MCommon setTouchIdValue:NO];
        UIViewController* ds = [[MLoginViewController alloc] init];
        [[SlideNavigationController sharedInstance] pushViewController:ds animated:YES];
    } fail:^{}];
}

#pragma mark - 清空所有cookie -
-(void)clearCookies
{
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
        [cookieJar deleteCookie:cookie];
    }
}

@end
