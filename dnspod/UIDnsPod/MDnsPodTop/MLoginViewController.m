//
//  ViewController.m
//  dnspod
//
//  Created by midoks on 14/10/26.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import "MLoginViewController.h"
#import "SlideNavigationController.h"

@interface MLoginViewController ()


@property (nonatomic, assign) CGFloat KeyboardHeight;
@property (nonatomic, assign) CGFloat viewX;

@end

@implementation MLoginViewController


#pragma mark 视图初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSLog(@"%@", NSHomeDirectory());
    
    
    [SlideNavigationController sharedInstance].leftMenu = nil;
    
    
    UIBarButtonItem  *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(ext)];
    
    UIBarButtonItem  *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"登陆" style:UIBarButtonItemStylePlain target:self action:@selector(login)];
    rightButton.tintColor = [UIColor whiteColor];
    leftButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _viewX = self.view.bounds.size.width/2;
    _logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dnspoder"]];
    _logo.frame = CGRectMake(100, 100, 150, 150);
    _logo.center = CGPointMake(_viewX, 160);
    _logo.backgroundColor = [UIColor clearColor];
    _logo.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_logo];
    
    
    UIToolbar *mdtextfield = [self setInputUIToolbar];
    
//    UILabel *_userlefttext = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50.0f, 40.0f)];
//    _userlefttext.textAlignment = NSTextAlignmentCenter;
//    _userlefttext.font = [UIFont systemFontOfSize:15.0f];
//    _userlefttext.text = @"用户";
    
    UIView *login_user = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40.0f, 40.0f)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 23.0f, 23.0f)];
    image.image = [UIImage imageNamed:@"login_user"];
    image.center = login_user.center;
    [login_user addSubview:image];
    
    //添加手机号码输入框
    _user = [[UITextField alloc] initWithFrame:CGRectMake(_viewX, 320, 230, 40)];
    _user.center = CGPointMake(_viewX, 280);
    _user.keyboardType = UIKeyboardTypeEmailAddress;
    _user.keyboardAppearance = UIKeyboardAppearanceLight;
    _user.borderStyle = UITextBorderStyleRoundedRect;
    _user.font = [UIFont systemFontOfSize:14.0f];
    //_user.leftView = _userlefttext;
    _user.leftView = login_user;
    _user.leftViewMode = UITextFieldViewModeAlways;
    _user.inputAccessoryView = mdtextfield;
    _user.placeholder = @"请输入你的用户名";
    _user.delegate = self;
    [self.view addSubview:_user];
    
    
//    UILabel *_pwdlefttext = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50.0f, 40.0f)];
//    _pwdlefttext.textAlignment = NSTextAlignmentCenter;
//    _pwdlefttext.font = [UIFont systemFontOfSize:15.0f];
//    _pwdlefttext.text = @"密码";
    
    
    UIView *login_password = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40.0f, 40.0f)];
    image = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 23.0f, 23.0f)];
    image.image = [UIImage imageNamed:@"login_password"];
    image.center = login_password.center;
    [login_password addSubview:image];
    
    
    //添加密码输入框
    _pwd = [[UITextField alloc] initWithFrame:CGRectMake(20, 390, 230, 40)];
    _pwd.center = CGPointMake(_viewX, 325);
    _pwd.keyboardType = UIKeyboardTypeNamePhonePad;
    _pwd.borderStyle = UITextBorderStyleRoundedRect;
    _pwd.font = [UIFont systemFontOfSize:14.0f];
    _pwd.placeholder = @"请输入你的密码";
    _pwd.leftViewMode = UITextFieldViewModeAlways;
    //_pwd.leftView = _pwdlefttext;
    _pwd.leftView = login_password;
    _pwd.inputAccessoryView = mdtextfield;
    _pwd.secureTextEntry = YES;
    _pwd.delegate = self;
    [self.view addSubview:_pwd];
    
    //检查已经登录的用户
    if([self->file GetUser]){
        NSDictionary  * _p_user = [self->file GetUser][0];
        NSString *user = [_p_user objectForKey:@"user"];
        NSString *pwd = [_p_user objectForKey:@"pwd"];
        _user.text = user;
        _pwd.text = pwd;
        [self login];
    }
    
    MLoginViewControllerSingle = self;
    
    //监控键盘的高度
    _KeyboardHeight = 264;
    //[self registerForKeyboardNotifications];
    
    
    //self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:10.0/255.0 green:58.0/255.0 blue:135.0/255.0 alpha:1];
    
    //[self.navigationController.navigationBar setTintColor:[UIColor redColor]];
    
    //    UIImage *backgroundImage = [self imageWithColor:[UIColor redColor]];
    //    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor redColor]}];
    
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//    titleLabel.backgroundColor = [UIColor grayColor];
//    titleLabel.font = [UIFont boldSystemFontOfSize:20];
//    titleLabel.textColor = [UIColor greenColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.text = @"登陆";
//    self.navigationItem.titleView = titleLabel;
}

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

static MLoginViewController *MLoginViewControllerSingle;
+(MLoginViewController *)sharedInstance
{
    if (!MLoginViewControllerSingle) {
        return [[self alloc] init];
    }
    return MLoginViewControllerSingle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 旋转相关 -
- (BOOL)shouldAutorotate
{
    return NO;
}

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _viewX = self.view.bounds.size.width/2;
    
    _logo.center = CGPointMake(_viewX, 160);
    _user.center = CGPointMake(_viewX, 280);
    _pwd.center = CGPointMake(_viewX, 325);
    
    UIToolbar *mdtextfield = [self setInputUIToolbar];
    _user.inputAccessoryView = mdtextfield;
    _pwd.inputAccessoryView = mdtextfield;
    
    
    //强制竖屏
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

#pragma mark 登陆
- (void)login
{
    NSString *_c_user = _user.text.lowercaseString;
    NSString *_c_pwd = _pwd.text;
    [self toolbarDone];
    
    if([_c_user isEqual:@""]){
        [self showAlert:@"提示" msg:@"用户名不能为空"];
        return;
    }
    
    if([_c_pwd isEqual:@""]){
        [self showAlert:@"提示" msg:@"密码不能为空"];
        return;
    }
    [self hudWaitProgress:@selector(startCheckLogin)];
}

#pragma mark 检查是否登录
- (void) startCheckLogin
{
    sleep(2);
    NSString *_c_user = _user.text.lowercaseString;
    NSString *_c_pwd = _pwd.text;
    
    [self->api setValue:_c_user password:_c_pwd];
    
    [self->api InfoVersion:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@", responseObject);
        [self hudClose];
        NSString * i = [[responseObject objectForKey:@"status"] objectForKey:@"code"];
        NSString *msg = [[responseObject objectForKey:@"status"] objectForKey:@"message"];
        
        if (![self DTokenHandle:responseObject success:@selector(startCheckLogin)]) {
            if([i  isEqual: @"1"]){
                [self->file AddUser:_c_user password:_c_pwd];
                [self showAlert:@"登录成功!!!" time:1.0 ok:@selector(goDnsPod)];
            }else{
                [self showAlert:@"提示" msg:msg time:3.0f];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hudClose];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    _KeyboardHeight = keyboardSize.height;
    NSLog(@"keyBoardHeight:%f", keyboardSize.height);  //216
    ///keyboardWasShown = YES;
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    _KeyboardHeight = keyboardSize.height;
    //NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    // keyboardWasShown = NO;
    
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
    //NSLog([[UIDevice currentDevice] name]); // 获取设备的名称
    //NSLog([[UIDevice currentDevice] uniqueIdentifier]); //获取GUID 唯一标识符
    //NSLog([[UIDevice currentDevice] systemName]); //获取系统名称
    //NSLog([[UIDevice currentDevice] systemVersion]); // 版本号
    
    //NSLog(@"%@", [[UIDevice currentDevice] systemVersion]);
    //NSLog(@"_KeyboardHeight:%f", _KeyboardHeight);
    CGRect frame = textField.frame;
    float offset = frame.origin.y + 42.f - (self.view.frame.size.height - _KeyboardHeight);//键盘高度216
    //NSLog(@"frame.origin.y:%f", frame.origin.y);
    //NSLog(@"offset:%f", offset);
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:0.3f];
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0){
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
    }
    [UIView commitAnimations];
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
