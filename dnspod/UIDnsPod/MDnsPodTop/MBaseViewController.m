//
//  BaseViewController.m
//  dnspod
//
//  Created by midoks on 14/11/4.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import "MBaseViewController.h"
#import "MLeftMenuViewController.h"

@interface MBaseViewController () <MBProgressHUDDelegate, UIAlertViewDelegate>
@end

@implementation MBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化接口
    self->api = [[DnsPodApi alloc] init];
    self->file = [[DnsPodFile alloc] init];
    
    if([self->file GetUser]){
        NSDictionary *_p_user = [self->file GetUser][0];
        NSString *user = [_p_user objectForKey:@"user"];
        NSString *pwd = [_p_user objectForKey:@"pwd"];
        [self->api setValue:user password:pwd];
    }
}

-(void)setTitle:(NSString *)title{
    [self setTitleW:title];
}

-(void)setTitleW:(NSString *)title
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    //titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    self.navigationItem.titleView = titleLabel;
}

-(void)setTitleS:(NSString *)title
{
    self.title = title;
}

#pragma mark 提示并调用
- (void)showAlert:(NSString *)msg time:(float)time ok:(SEL)ok
{
    [self showAlert:@"提示" msg:msg time:time];
    [self performSelector:ok withObject:nil afterDelay:time];
}

#pragma mark 弹出消息
- (void)showAlert:(NSString *)notice msg:(NSString *)msg
{
    [self showAlert:notice msg:msg time:2.0f];
}

#pragma mark 弹出消息
- (void)showAlert:(NSString *)notice msg:(NSString *)msg time:(float)time
{
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:notice message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [NSTimer scheduledTimerWithTimeInterval:time
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:NO];
    [promptAlert show];
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
    //NSLog(@"弹出框");
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = NULL;
}

#pragma mark 退出程序
-(void)ext{
    exit(0);
    //UIApplication
}

#pragma mark 设置成横屏
-(void)setHscreen
{
    //设置为横屏,更好的显示内容
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

#pragma mark 设置成竖屏
-(void)setPscreen
{
    //设置为竖屏,更好的显示内容
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIDeviceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

-(void)goMenu
{
    //[SlideNavigationController sharedInstance].leftMenu = [[MLeftMenuViewController alloc] init];
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
}

#pragma mark 导航返回
-(void)back
{
    [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
}


-(void)pushMenuBack
{
    [SlideNavigationController sharedInstance].leftMenu = [MLeftMenuViewController sharedInstance];
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
}

#pragma mark 用于排版,返回固定长度的数据
- (NSString *)returnFixedLength:(NSString *)fixedString fixedLen:(NSInteger)fixedLen
{
    NSString *str = nil;
    //当修改的字符串长度和修改的长度相等时,直接返回字符串
    if (fixedLen == [fixedString length]) {
        return fixedString;
    }
    //当修改的字符串长度大于修改后的长度时
    if ([fixedString length] > fixedLen) {
        str = [fixedString substringWithRange:NSMakeRange(0, fixedLen)];
    }
    //当修改的字符串长度小于修改后的长度时,填空字符
    if ([fixedString length] < fixedLen) {
        NSInteger len = fixedLen - [fixedString length];
        
        NSString *tmpStr = @"";
        for (int i = 0; i<len; i++) {
            //NSLog(@"jj");
            tmpStr = [NSString stringWithFormat:@"%@%@", tmpStr, @" "];
            //[tmpStr stringByAppendingFormat:@"%@", @"7"];
        }
        //NSLog(@"len:%zi, tmp:%@", len, tmpStr);
        str = [fixedString stringByAppendingFormat:@"%@",tmpStr];
    }
    //NSLog(@"%@::%zi", fixedString, fixedLen);
    //NSLog(@"%@-%ld", str, [str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]);
    return str;
}

#pragma mark - MBProgressHUB Methods -
- (void)hudWaitProgress:(SEL)func
{
    HUD = [[MBProgressHUD alloc] initWithView:[SlideNavigationController sharedInstance].view];
    [[SlideNavigationController sharedInstance].view addSubview:HUD];
    HUD.delegate = self;
    [HUD showWhileExecuting:func onTarget:self withObject:nil animated:YES];
    //    [HUD showAnimated:YES whileExecutingBlock:^{
    //    } completionBlock:^{
    //        NSLog(@"ok");
    //        //[HUD setHidden:YES];
    //        //[HUD removeFromSuperview];
    //        //HUD = nil;
    //    }];
}

-(void)hudClose
{
    [HUD setHidden:YES];
}


#pragma mark - D令牌统一处理 -
-(BOOL)DTokenHandle:(id)info success:(SEL)success
{
    _callFunc = success;
    NSString * i = [[info objectForKey:@"status"] objectForKey:@"code"];
    NSString *msg = [[info objectForKey:@"status"] objectForKey:@"message"];
    if([i isEqual:@"50"] || [i isEqual:@"52"]){
        [self showAlert:@"提示" msg:msg time:0.5f];
        [self performSelector:@selector(DTokenHandleAlert) withObject:nil afterDelay:0.5f];
        return true;
    }
    return false;
}

-(void)DTokenHandleAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"输入D令牌验证码"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    //设置输入框的键盘类型
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [[alert textFieldAtIndex:0] becomeFirstResponder];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //输入D令牌验证码
    if([alertView.title isEqualToString:@"输入D令牌验证码"] && (buttonIndex == 1))
    {
        NSString *number = [[alertView textFieldAtIndex:0] text];
        [self->api setArgs:@"login_code" value:number];
        [self->api setArgs:@"login_remember" value:@"yes"];
        [self performSelector:_callFunc withObject:nil afterDelay:0.5];
    }
}




@end
