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
#import "MUserListViewController.h"
#import "MSettingViewController.h"


@interface MLeftMenuViewController () <UITableViewDelegate, UITableViewDataSource, UIApplicationDelegate>

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
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width - MENU_DEFAULT_SLIDE_OFFSET,
                                  self.view.frame.size.height);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftMenuCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leftMenuCell"];
        NSString *username = nil;
        //检查已经登录的用户
        if([self->file GetMainUser]){
            NSDictionary *_p_user = [self->file GetMainUser][0];
            NSString *user = [_p_user objectForKey:@"user"];
            username = [NSString stringWithFormat:@"账户:\r\n%@", user];
        }else{
            username = [NSString stringWithFormat:@"账户:\r\n%@", @"获取失败!!"];
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
                cell.textLabel.text = @"主页";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 2:
                cell.imageView.image = [UIImage imageNamed:@"setting"];
                cell.textLabel.text = @"设置";
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
        return indexPath;
    } else {
        return indexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *ds = nil;
    switch (indexPath.row) {
        case 0:[self goUserList];break;
        case 1:[self goMainDomainList];break;
        case 2:[self goUserSetting];break;
    }
    if (ds){[self push:ds];}
}


#pragma mark - Private Methods -

#pragma mark - 跳页的功能 -
- (void)push:(UIViewController *)vc
{
    [[SlideNavigationController sharedInstance] popToRootAndSwitchToViewController:vc
                                                             withSlideOutAnimation:NO
                                                                     andCompletion:nil];
}

#pragma mark - 跳到域名列表的功能 -
- (void)goMainDomainList
{
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
        UIViewController *ds = [[MDnsPodViewController alloc] init];
        [self push:ds];
    }];
}

#pragma mark - 跳到用户列表页 -
-(void)goUserList
{
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
        UIViewController *ds = [[MUserListViewController alloc] init];
        [self push:ds];
    }];

}

#pragma mark - 程序设置 -
-(void)goUserSetting
{
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
        UIViewController *ds = [[MSettingViewController alloc] init];
        [self push:ds];
    }];
}

#pragma mark - 应用退出 -
-(void)exitApplication
{
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
    } completion:^(BOOL finished) {
        exit(0);
    }];
}
#pragma mark - 用户退出 -
-(void)AppExt
{
    [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
        [self showAlert:@"你确定退出程序" msg:@"" ok:^{
            [self exitApplication];
        } fail:^{}];
    }];
}

@end
