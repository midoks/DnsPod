//
//  BaseViewController.h
//  dnspod
//
//  Created by midoks on 14/11/4.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DnsPodApi.h"
#import "DnsPodFile.h"
#import "SlideNavigationController.h"
#import "MBProgressHUD.h"

@interface MBaseViewController : UIViewController
{
@private
    MBProgressHUD *HUD;
    SEL _callFunc;
@public
    //DNSPOD的接口
    DnsPodApi *api;
    //密码操作
    DnsPodFile *file;
}

#pragma mark 提示并调用
- (void)showAlert:(NSString *)msg time:(float)time ok:(SEL)ok;
#pragma mark 弹出消息
- (void)showAlert:(NSString *)notice msg:(NSString *)msg;
#pragma mark 弹出消息(可以设置时间)
- (void)showAlert:(NSString *)notice msg:(NSString *)msg time:(float)time;

#pragma mark 设置成横屏
-(void)setHscreen;
#pragma mark 设置成竖屏
-(void)setPscreen;
#pragma mark 退出程序
-(void)ext;
#pragma mark 返回
-(void)back;
#pragma mark 压入菜单返回
-(void)pushMenuBack;

#pragma mark 自定义
-(void)setTitleW:(NSString *)title;
#pragma mark 源
-(void)setTitleS:(NSString *)title;

#pragma mark 进程等待
- (void)hudWaitProgress:(SEL)func;
-(void)hudClose;

#pragma mark - D令牌统一处理 -
-(BOOL)DTokenHandle:(id)info success:(SEL)success;
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
