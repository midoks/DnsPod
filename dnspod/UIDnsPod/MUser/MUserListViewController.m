//
//  MUserListViewController.m
//  dnspod
//
//  Created by midoks on 15/9/5.
//  Copyright (c) 2015年 midoks. All rights reserved.
//

#import "MUserListViewController.h"

@interface MUserListViewController () <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>

//信息列表
@property (nonatomic, strong) UITableView *_userTableView;
//数据
@property (nonatomic, strong) NSMutableArray *_userTableData;
//当前选择的用户
@property (nonatomic, strong) NSMutableDictionary *_selectedUser;

@end

@implementation MUserListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //导航栏设置
    [self setTitleW:@"用户列表"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem  *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUser)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    self._userTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self._userTableView.delegate = self;
    self._userTableView.dataSource = self;
    self.view = self._userTableView;
    
    [self reloadGetUserData];
}

-(void)viewDidAppear:(BOOL)animated{
    [self reloadGetUserData];
}

#pragma mark - UITableViewDelegate -
#pragma mark 显示多少行
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self._userTableData.count;
}

#pragma mark 每一行的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * Sign = @"UserSign";
    //在缓存池取值
    UITableViewCell *cell = [self._userTableView dequeueReusableCellWithIdentifier:Sign];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Sign];
    }
    
    NSMutableDictionary *userData = [self._userTableData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [userData objectForKey:@"user"];
    //cell.textLabel.textColor = [UIColor blueColor];//颜色控制
    //cell.imageView.image = [UIImage imageNamed:@"list_blue_icons"];
    
    //进入图标
    if([[userData objectForKey:@"main"] isEqual:@"1"]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark 显示删除数据
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(editingStyle == UITableViewCellEditingStyleDelete){
        self._selectedUser  = [self._userTableData objectAtIndex:indexPath.row];
        [self deleteUser];
    }
}

#pragma mark 选择数据
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    self._selectedUser  = [self._userTableData objectAtIndex:indexPath.row];
    
    UIActionSheet *domainActionSheet;
    
    domainActionSheet = [[UIActionSheet alloc] initWithTitle:@"账户管理"
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:@"删除账户"
                                           otherButtonTitles:@"查看账户", @"切换为当前", nil];
    
    [domainActionSheet showInView:self.view];
}

#pragma mark - AlertViewDelegate -
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.title isEqual:@"添加用户"] && (buttonIndex == 1))
    {
        NSString *userName  = [[alertView textFieldAtIndex:0] text];
        NSString *userPwd   = [[alertView textFieldAtIndex:1] text];
        
        
        [self addUserData:[userName lowercaseString] userPwd:userPwd];
    }
    
    if ([alertView.title isEqual:@"你确定删除域名:"] && (buttonIndex == 1)) {
        [self->file DeleteUserById:[self._selectedUser objectForKey:@"id"]];
        [self showAlert:@"提示" msg:@"删除成功!!!" time:1.0f];
        [self reloadGetUserData];
    }
    

    
    NSLog(@"%@", alertView.title);
    NSLog(@"%ld", (long)buttonIndex);
}


#pragma mark - UIActionSheet 代理方法 -
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:[self deleteUser];break;
        case 1:[self seeSelectedUser];break;
        case 2:[self switchSelectedUser];break;
        default:break;
    }
}


#pragma mark 添加用户数据
-(void)addUserData:(NSString *)userName userPwd:(NSString *)userPwd
{
    if([userName isEqual:@""]){
        [self showAlert:@"提示" msg:@"用户名不能为空"];
        return;
    }
    
    if([userPwd isEqual:@""]){
        [self showAlert:@"提示" msg:@"密码不能为空"];
        return;
    }
    
    [self->api setValue:userName password:userPwd];
    [self hudWaitProgress:@selector(addUserDataChecked)];

}

-(void)addUserDataChecked
{
    [self->api InfoVersion:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hudClose];
        NSString * i = [[responseObject objectForKey:@"status"] objectForKey:@"code"];
        NSString *msg = [[responseObject objectForKey:@"status"] objectForKey:@"message"];
 
        if (![self DTokenHandle:responseObject success:nil]) {
            if([i isEqual: @"1"]){
                [self->file AddUser:[self->api getUserName] password:[self->api getUserPwd] isMain:@"0"];
                [self reloadGetUserData];
            }
        }
        [self showAlert:@"提示" msg:msg time:1.0f];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hudClose];
        [self showAlert:@"提示" msg:@"网络不畅通" time:1.0f];
    }];
}



#pragma mark 添加用户数据的View
-(void)addUser
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加用户"
                                                    message:@"请输入你要添加的用户和密码"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    //设置输入框的键盘类型
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNamePhonePad];
    [[alert textFieldAtIndex:0] setPlaceholder:@"请输入你的账户"];
    [[alert textFieldAtIndex:1] setKeyboardType:UIKeyboardTypeNamePhonePad];
    [[alert textFieldAtIndex:1] setPlaceholder:@"请输入你的密码"];
    [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [alert show];
}

//删除用户
-(void)deleteUser
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你确定删除域名:"
                                                    message:[self._selectedUser objectForKey:@"user"]
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    [alert show];
}

//切换当前用户
-(void)switchSelectedUser
{
    NSString *userName = [self._selectedUser objectForKey:@"user"];
    [self->file SwitchMainUser:userName];
    [self showAlert:@"提示" msg:@"切换成功!!" time:1.0f];
    [self reloadGetUserData];
}

//查看选择用户的信息
-(void)seeSelectedUser
{
    MUserInfoViewController *ds = [[MUserInfoViewController alloc] init];
    ds._selectedUser = self._selectedUser;
    
    [self.navigationController pushViewController:ds animated:true];

    //NSLog(@"%@", self._selectedUser);
}

//重新获取用户数据
-(void)reloadGetUserData{
    [self._userTableData removeAllObjects];
    self._userTableData = [self->file GetUserList];
    [self._userTableView reloadData];
    
    [SlideNavigationController sharedInstance].leftMenu = [[MLeftMenuViewController alloc] init];
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;

}


@end
