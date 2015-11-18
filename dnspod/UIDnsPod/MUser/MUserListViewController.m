//
//  MUserListViewController.m
//  dnspod
//
//  Created by midoks on 15/9/5.
//  Copyright (c) 2015年 midoks. All rights reserved.
//

#import "MUserListViewController.h"
#import "MLoginViewController.h"

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
    [super viewDidAppear:animated];
    [self reloadGetUserData];
}

#pragma mark - UITableViewDelegate -
#pragma mark 显示多少行
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self._userTableData.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
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
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"账户管理" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //删除帐户
    UIAlertAction *userDelete = [UIAlertAction actionWithTitle:@"删除帐户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteUser];
    }];
    
    //查看帐户
    UIAlertAction *userInfo = [UIAlertAction actionWithTitle:@"查看帐户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self seeSelectedUser];
    }];
    
    //切换当前用户
    UIAlertAction *userSwitch = [UIAlertAction actionWithTitle:@"切换为当前" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self switchSelectedUser];
    }];
    
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];

    
    [alertController addAction:userDelete];
    [alertController addAction:userInfo];
    [alertController addAction:userSwitch];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];
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
        
    }
    
    
    //NSLog(@"%@", alertView.title);
    //NSLog(@"%ld", (long)buttonIndex);
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
 
        if(![i isEqual:@"1"]){
            [self showAlert:@"提示" msg:msg];
        }
        
        if (![self DTokenHandle:responseObject success:@selector(addUserDataChecked)]) {
            if([i isEqual: @"1"]){
                [self showAlert:@"提示" msg:@"添加成功"];
                [self->file AddUser:[self->api getUserName] password:[self->api getUserPwd] isMain:@"0"];
                [self reloadGetUserData];
            }
        }
     
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hudClose];
        [self showAlert:@"提示" msg:@"网络不畅通" time:1.0f];
    }];
}


#pragma mark 添加用户数据的View
-(void)addUser
{
    
    UIAlertController *addUser = [UIAlertController alertControllerWithTitle:@"添加用户"
                                                                     message:@"请输入你要添加的用户和密码"
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancal = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];

    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *user = addUser.textFields.firstObject.text;
        NSString *pwd  = addUser.textFields.lastObject.text;
        [self addUserData:user userPwd:pwd];
    }];
    
    [addUser addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入账户";
    }];
    
    [addUser addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入密码";
        textField.secureTextEntry = true;
    }];
    
    
    [addUser addAction:cancal];
    [addUser addAction:confirm];
    
    [self presentViewController:addUser animated:YES completion:^{
    }];
}

#pragma mark 删除用户
-(void)deleteUser
{
    [self showAlert:@"你确定删除帐户:" msg:[self._selectedUser objectForKey:@"user"] ok:^{
        [self deleteUserData];
    } fail:^{}];
}

-(void)deleteUserData{
    
    [self->file DeleteUserById:[self._selectedUser objectForKey:@"id"]];
    
    [self showAlert:@"提示" msg:@"删除成功" block:^{
        
        [self reloadGetUserData];
        
        if ([self->file UserCount]<1){
            MLoginViewController *loginPage = [[MLoginViewController alloc] init];
            [self addChildViewController:loginPage];
            [[SlideNavigationController sharedInstance] pushViewController:loginPage animated:YES];
        }else{
            id mainUser = [self->file GetMainUser];
            //NSLog(@"%@", mainUser);
            if(!mainUser){
                NSString *userName = [[self._userTableData objectAtIndex:0] objectForKey:@"user"];
                [self->file SwitchMainUser:userName];
                [self showAlert:@"提示" msg:@"切换成功" ok:^{
                    [self reloadGetUserData];
                } fail:^{}];
                
            }
        }
    }];
    
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
