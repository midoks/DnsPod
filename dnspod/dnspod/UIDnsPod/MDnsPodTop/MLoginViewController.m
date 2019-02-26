//
//  ViewController.m
//  dnspod
//
//  Created by midoks on 14/10/26.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import "MLoginViewController.h"
#import "SlideNavigationController.h"
#import "MCommon.h"



@interface MLoginViewController ()


@property (nonatomic, assign) CGFloat KeyboardHeight;
@property (nonatomic, assign) CGFloat viewX;

//保存当前编辑框的状态
@property (nonatomic, strong) UITextField *currentTextField;

@end

@implementation MLoginViewController


#pragma mark - 第一个视图(初始化的视图) -

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //NSLog(@"yes");
    //self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    //self.navigationController.navigationBarHidden = YES;
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1]];
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //NSLog(@"no");
    //self.navigationController.navigationBarHidden = NO;
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:8.0/255.0 green:57.0/255.0 blue:134.0/255.0 alpha:1]];
}

#pragma mark 视图初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SlideNavigationController sharedInstance].leftMenu = nil;
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    self.title = @"米帮手";
    
    [self initViewConfig];
    
    //打印app的文件目录,对调试有好处
    //NSLog(@"%@", NSHomeDirectory());
    
    //监听键盘高度
    [self registerForKeyboardNotifications];
}

#pragma mark 初始化视图设置
-(void)initViewConfig
{
    UIBarButtonItem  *nullButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = nullButton;
    self.navigationItem.leftBarButtonItem = nullButton;
    
    //[MCommon getTouchIdValue]
    if ([MCommon getTouchIdValue]) {
        [self touchIdLogin];
        [self initTouchID];
    } else {
        [self initView];
    }

}

#pragma mark - initTouchID -
-(void) initTouchID
{
    _touchIdButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    _touchIdButton.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height*0.35);
    [_touchIdButton setBackgroundImage:[UIImage imageNamed:@"login_touch_id"] forState:UIControlStateNormal];
    [_touchIdButton addTarget:self action:@selector(touchIdLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_touchIdButton];
    
    UILabel *explain = [[UILabel alloc] initWithFrame:CGRectMake(0, _touchIdButton.frame.size.height + _touchIdButton.frame.origin.y + 5, self.view.frame.size.width, 40.0f)];
    explain.text = @"点击进行指纹解锁";
    explain.textAlignment = NSTextAlignmentCenter;
    explain.font = [UIFont systemFontOfSize:10.0f];
    explain.textColor = [UIColor colorWithRed:86.0/255.0 green:171.0/255.0 blue:228.0/255.0 alpha:1];
    [self.view addSubview:explain];
    
    _switchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 40)];
    
    [_switchButton setTitleColor:[UIColor colorWithRed:86.0/255.0 green:171.0/255.0 blue:228.0/255.0 alpha:1] forState:UIControlStateNormal];
    [_switchButton setTitle:@"重新登陆" forState:UIControlStateNormal];
    _switchButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    [_switchButton addTarget:self action:@selector(switchLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_switchButton];
}

#pragma mark - 指纹登陆 -
-(void)touchIdLogin
{
    [MCommon touchConfirm:@"通过Home健验证已有手机指纹" success:^(BOOL success) {
        if(success){
            [MCommon asynTask:^{
                [self goDnsPod];
            }];
        }else{
            [MCommon asynTask:^{
                [self showAlert:@"提示" msg:@"指纹验证失败!" time:1];
            }];
        }
    } fail:^{
        [self showAlert:@"提示" msg:@"你的设备不支持!"];
    }];
    
}

#pragma mark - 登陆 -
-(void) switchLogin
{
    [self showAlert:@"重新登陆" msg:@"要清空所有信息?" ok:^{
//        [_touchIdButton removeFromSuperview];
//        [_switchButton removeFromSuperview];
        [self->file ClearUser];
        [MCommon setTouchIdValue:NO];
        [self initView];
    } fail:^{
    }];
}

#pragma mark - initView初始化 -
-(void) initView
{
    
    _viewX = self.view.bounds.size.width/2;
    
    _logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dnspoder"]];
    _logo.frame = CGRectMake(100, 100, 150, 150);
    _logo.center = CGPointMake(_viewX, 160);
    _logo.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_logo];
    
    
    //    NSLog(@"%@", _logo);
    //    NSLog(@"%f", _logo.frame.origin.y);
    //    NSLog(@"%f", _logo.frame.origin.y + _logo.frame.size.height);
    //    NSLog(@"%f", _logo.frame.origin.y + _logo.frame.size.height + 45.0f/2);
    
    //工具
    UIToolbar *mdtextfield = [self setInputUIToolbar];
    
    //填写用户名
    UIView *login_user = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 40.0f)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 23.0f, 23.0f)];
    image.image = [UIImage imageNamed:@"login_user"];
    image.center = login_user.center;
    [login_user addSubview:image];
    
    
    _user = [[UITextField alloc] initWithFrame:CGRectMake(_viewX, 260, self.view.frame.size.width, 45.0f)];
    _user.center = CGPointMake(_viewX, _logo.frame.origin.y + _logo.frame.size.height + 45.0f/2);
    _user.keyboardType = UIKeyboardTypeEmailAddress;
    _user.keyboardAppearance = UIKeyboardAppearanceLight;
    _user.borderStyle = UITextBorderStyleNone;
    _user.font = [UIFont systemFontOfSize:14.0f];
    _user.leftViewMode = UITextFieldViewModeAlways;
    _user.leftView = login_user;
    _user.inputAccessoryView = mdtextfield;
    _user.backgroundColor = [UIColor whiteColor];
    _user.clearButtonMode = UITextFieldViewModeWhileEditing;
    _user.placeholder = @"请输入TOKEN_ID";
    _user.delegate = self;
    [self.view addSubview:_user];
    
    //添加密码输入框
    UIView *login_password = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 40.0f)];
    image = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 23.0f, 23.0f)];
    image.image = [UIImage imageNamed:@"login_password"];
    image.center = login_password.center;
    [login_password addSubview:image];
    
    _pwd = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45.0f)];
    _pwd.center = CGPointMake(_viewX, _user.frame.origin.y + _user.frame.size.height + 45.0f/2 + 1);
    _pwd.keyboardType = UIKeyboardTypeDefault;
    _pwd.borderStyle = UITextBorderStyleNone;
    _pwd.font = [UIFont systemFontOfSize:14.0f];
    _pwd.backgroundColor = [UIColor whiteColor];
    _pwd.placeholder = @"请输入TOKEN";
    _pwd.leftViewMode = UITextFieldViewModeAlways;
    _pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    _pwd.leftView = login_password;
    _pwd.inputAccessoryView = mdtextfield;
//    _pwd.secureTextEntry = YES;
    _pwd.delegate = self;
    [self.view addSubview:_pwd];
    
    
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, self.view.frame.size.width * 0.95, 40.0f)];
    _loginButton.center = CGPointMake(_viewX, _pwd.frame.origin.y + _pwd.frame.size.height + 40.0f/2 + 10);
    
    [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [_loginButton setBackgroundColor:[UIColor colorWithRed:8.0/255.0 green:57.0/255.0 blue:134.0/255.0 alpha:0.6]];
    
    [_loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    
    
    //检查已经登录的用户
    if([self->file GetMainUser]){
        
        NSDictionary  * _p_user = [self->file GetMainUser][0];
        NSString *user = [_p_user objectForKey:@"user"];
        NSString *pwd = [_p_user objectForKey:@"pwd"];
        _user.text = user;
        _pwd.text = pwd;
        
        [_loginButton setTitle:@"正在登陆中..." forState:UIControlStateNormal];
        //[self showAlert:@"登录成功" time:1.0 ok:@selector(goDnsPod)];
        [self login];
    }
    
    
    //监控键盘的高度
    _KeyboardHeight = 293;
}

#pragma mark - 通过颜色生成图片 -
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark - 旋转相关 -
- (BOOL)shouldAutorotate
{
    return NO;
}

//-(void) viewWillLayoutSubviews
//{
//    [super viewWillLayoutSubviews];
//    _viewX = self.view.bounds.size.width/2;
//
//    _logo.center = CGPointMake(_viewX, 160);
//    _user.center = CGPointMake(_viewX, 280);
//    _pwd.center = CGPointMake(_viewX, 325);
//
//    UIToolbar *mdtextfield = [self setInputUIToolbar];
//    _user.inputAccessoryView = mdtextfield;
//    _pwd.inputAccessoryView = mdtextfield;
//
//
//    //强制竖屏
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = UIDeviceOrientationPortrait;
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
//}

-(void) login:(id)sender
{
    UIButton *l = (UIButton *)sender;
    NSString *v = l.titleLabel.text;
    
    if([v isEqual:@"正在登陆中..."]){
        [self showAlert:@"提示" msg:@"正在登陆中...,稍后再试!"];
        return;
    }

    [self login];
}

#pragma mark 登陆
- (void)login
{
    NSString *_c_user = _user.text.lowercaseString;
    NSString *_c_pwd = _pwd.text;
    [self toolbarDone];
    
    if([_c_user isEqual:@""]){
        [self showAlert:@"提示" msg:@"TokenID不能为空"];
        return;
    }
    
    if([_c_pwd isEqual:@""]){
        [self showAlert:@"提示" msg:@"Token不能为空"];
        return;
    }
    
//    [self->api setValue:_c_user password:_c_pwd];
    [self->api setToken:_c_pwd tid:_c_user];
    
    [self hudWaitProgress:@selector(startCheckLogin)];
    [_user setEnabled:false];
    [_pwd setEnabled:false];
    [_loginButton setTitle:@"正在登陆中..." forState:UIControlStateNormal];
}

#pragma mark 检查是否登录
- (void) startCheckLogin
{
    //sleep(4);
    [self->api InfoVersion:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self hudClose];
        NSString * i = [[responseObject objectForKey:@"status"] objectForKey:@"code"];
        NSString *msg = [[responseObject objectForKey:@"status"] objectForKey:@"message"];
        NSLog(@"%@", msg);
        [self->_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        [self->_user setEnabled:true];
        [self->_pwd setEnabled:true];
        
        if (![self DTokenHandle:responseObject success:@selector(startCheckLogin)]) {
            if([i isEqual: @"1"]){
                [self->file AddUser:[self->api getTokenID] password:[self->api getToken] isMain:@"1"];
                [self showAlert:@"登录成功" time:1.0 ok:@selector(goDnsPod)];
            }else{
                
                [self showAlert:@"提示" msg:msg time:3.0f];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hudClose];
        
        [self->_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        [self->_user setEnabled:true];
        [self->_pwd setEnabled:true];
        
        [self showAlert:@"提示" msg:@"网络不畅通" time:3.0f];
    }];
}

-(void)goDnsPod
{
    MDnsPodViewController *dnspod = [[MDnsPodViewController alloc] init];
    [[SlideNavigationController sharedInstance] pushViewController:dnspod animated:YES];
}

#pragma mark - 输入框 -

//-(void)register
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void) keyboardWasShow:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    _KeyboardHeight = keyboardSize.height;
    //NSLog(@"keyBoardHeight:%f", keyboardSize.height);  //293
    //self.view.frame = CGRectMake(0.0f, -_KeyboardHeight, self.view.frame.size.width, self.view.frame.size.height);
    //NSLog(@"2");
    
    CGRect frame = _currentTextField.frame;
    float offset = frame.origin.y + frame.size.height - (self.view.frame.size.height - _KeyboardHeight);//键盘高度216
    //NSLog(@"frame.origin.y:%f", frame.origin.y);
    //NSLog(@"offset:%f", offset);
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.1f];
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0){
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
//    NSDictionary *info = [notif userInfo];
//    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
//    _KeyboardHeight = keyboardSize.height;
//    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
}


//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:.3f animations:^{
    } completion:^(BOOL finished) {
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //NSLog(@"1");
    _currentTextField = textField;
    
    //NSLog(@"%@",[[UIDevice currentDevice] name]); // 获取设备的名称
    //NSLog(@"%@",[[UIDevice currentDevice] uniqueIdentifier]); //获取GUID 唯一标识符
    //NSLog(@"%@",[[UIDevice currentDevice] systemName]); //获取系统名称
    //NSLog(@"%@",[[UIDevice currentDevice] systemVersion]); // 版本号
    //NSLog(@"%@", [[UIDevice currentDevice] systemVersion]);
}

#pragma mark - 自定义UIToolbar -
- (UIToolbar *)setInputUIToolbar
{
    UIToolbar *t = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40.0f)];
    
    //登陆
    UIButton *loginIn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60.0f, 40.0f)];
    [loginIn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginIn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [loginIn setTitleColor:[UIColor brownColor] forState:UIControlStateHighlighted];
    [loginIn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchDown];
    [t addSubview:loginIn];
    
    //完成
    UIButton *done = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 60.0f, 0, 60.0f, 40.0f)];
    [done setTitle:@"完成" forState:UIControlStateNormal];
    [done setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [done setTitleColor:[UIColor brownColor] forState:UIControlStateHighlighted];
    [done addTarget:self action:@selector(toolbarDone) forControlEvents:UIControlEventTouchDown];
    [t addSubview:done];
    
    return t;
}

#pragma mark 退出编辑
- (void)toolbarDone
{
    [self.view endEditing:YES];
}

@end
