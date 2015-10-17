//
//  BaseViewController.m
//  dnspod
//
//  Created by midoks on 14/11/4.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import "MBaseViewController.h"
#import "MLeftMenuViewController.h"

@interface MBaseViewController () <MBProgressHUDDelegate, UIAlertViewDelegate, UIPopoverPresentationControllerDelegate>
@end

@implementation MBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化接口
    self->api = [[DnsPodApi alloc] init];
    self->file = [[DnsPodFile alloc] init];
    
    if([self->file GetMainUser]){
        NSDictionary *_p_user = [self->file GetMainUser][0];
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

#pragma mark 提示消息,取消或或成功执行block
-(void)showAlert:(NSString *)title msg:(NSString *)msg ok:(void (^)())ok fail:(void (^)())fail
{
    UIAlertController *alertDelete = [UIAlertController alertControllerWithTitle:title
                                                                         message:msg
                                                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancal = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if(fail){
            fail();
        }
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ok();
    }];
    
    [alertDelete addAction:cancal];
    [alertDelete addAction:confirm];

    [self presentViewController:alertDelete animated:YES completion:nil];
    
}

#pragma mark 提示并调用
- (void)showAlert:(NSString *)msg time:(float)time ok:(SEL)ok
{
    [self showAlert:@"提示" msg:msg time:time];
    [self performSelector:ok withObject:nil afterDelay:time];
}

#pragma mark 提示并调用block
- (void)showAlert:(NSString *)msg time:(float)time block:(void (^)())block
{
    [self showAlert:@"提示" msg:msg time:time block:block];
}

#pragma mark 弹出消息
- (void)showAlert:(NSString *)notice msg:(NSString *)msg
{
    [self showAlert:notice msg:msg time:2.0f block:nil];
}

#pragma mark 弹出消息
- (void)showAlert:(NSString *)notice msg:(NSString *)msg block:(void (^)())block
{
    [self showAlert:notice msg:msg time:2.0f block:block];
}

#pragma mark 弹出消息
- (void)showAlert:(NSString *)notice msg:(NSString *)msg time:(float)time
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:notice message:msg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:time
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:alert
                                    repeats:NO];
}


#pragma mark 弹出消息并回调block
- (void)showAlert:(NSString *)notice msg:(NSString *)msg time:(float)time block:(void (^)())block
{
    callAlertBlock = block;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:notice message:msg preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alert animated:YES completion:^{
        
        [NSTimer scheduledTimerWithTimeInterval:time
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:block
                                        repeats:NO];
        
    }];

}

#pragma mark 定时消失
- (void)timerFireMethod:(NSTimer*)theTimer
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (callAlertBlock) {
            callAlertBlock();
        }
    }];
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
    
        [self showAlert:@"提示" msg:msg time:0.5 block:^{
            [self performSelector:@selector(DTokenHandleAlert) withObject:nil afterDelay:0.2f];
        }];
        
        return true;
    }
    return false;
}

-(void)DTokenHandleAlert
{
    UIAlertController *tokenAlert = [UIAlertController alertControllerWithTitle:@"输入D令牌验证码"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){}];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *number = tokenAlert.textFields.firstObject.text;
        [self loginIn:number];
        
    }];
    
    [tokenAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"6位或8位数字验证码";
    }];
    
    [tokenAlert addAction:cancel];
    [tokenAlert addAction:ok];
    
    [self presentViewController:tokenAlert animated:YES completion:^{}];
    
}

#pragma mark 验证number
-(void)loginIn:(NSString *)number
{
    [self->api setArgs:@"login_code" value:number];
    [self->api setArgs:@"login_remember" value:@"yes"];
    
    if(_callFunc){
        [self performSelector:_callFunc withObject:nil afterDelay:0.2f];
    }
    
}


@end
