//
//  MUserInfoViewController.m
//  dnspod
//
//  Created by midoks on 15/9/6.
//  Copyright (c) 2015年 midoks. All rights reserved.
//

#import "MUserInfoViewController.h"

@interface MUserInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *userTableView;
@property (nonatomic, strong) NSMutableDictionary *userInfo;
@property (nonatomic, strong) NSMutableArray *userKey;

@end

@implementation MUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitleW:@"用户详情"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem  *rightButtom = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    rightButtom.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButtom;
    
    _userTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _userTableView.dataSource = self;
    _userTableView.delegate = self;
    [self.view addSubview:_userTableView];
    

    [self->api setValue:[self._selectedUser objectForKey:@"user"] password:[self._selectedUser objectForKey:@"pwd"]];
    [self->api UserDetail:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@", [responseObject objectForKey:@"info"]);
        NSMutableDictionary *response = [responseObject objectForKey:@"info"];
        self.userInfo = [response objectForKey:@"user"];
        
        self.userKey = [[NSMutableArray alloc] init];
        [self.userKey addObjectsFromArray:[self.userInfo allKeys]];
        
        [self.userTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlert:@"提示" msg:@"网络不畅通" time:1.0f];
    }];
}

#pragma mark - TableViewDelegate -
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_userInfo count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@""];
   
    NSString *key = _userKey[indexPath.row];
    NSString *value = (NSString *)[_userInfo objectForKey:key];
 
    value = [NSString stringWithFormat:@"%@", value];
    if([value isEqual:@""]  || [value isEqual:@"<null>"] || [value isEqual:nil]){
        cell.detailTextLabel.text = @"空";
    }else{
        cell.detailTextLabel.text = value;
    }

    cell.textLabel.text = [self keyReplaceString:key];
    return cell;
}

#pragma mark 选择数据
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 把key换成可以认识的中文
-(NSString *)keyReplaceString:(NSString *)keyS
{
    if ([keyS isEqual:@"agent_pending"]) {
        keyS = @"正在申请代理";
    }else if ([keyS isEqual:@"balance"]){
        keyS = @"账号余额";
    }else if([keyS isEqual:@"email"]){
        keyS = @"用户账号";
    }else if ([keyS isEqual:@"email_verified"]){
        keyS = @"邮箱通过验证";
    }else if([keyS isEqual:@"id"]){
        keyS = @"ID";
    }else if ([keyS isEqual:@"nick"]){
        keyS = @"用户昵称";
    }else if ([keyS isEqual:@"real_name"]){
        keyS = @"用户名称";
    }else if ([keyS isEqual:@"smsbalance"]){
        keyS = @"剩余短信条数";
    }else if([keyS isEqual:@"status"]){
        keyS = @"账号状态";
    }else if ([keyS isEqual:@"telephone"]){
        keyS = @"电话号码";
    }else if([keyS isEqual:@"telephone_verified"]){
        keyS = @"手机通过验证";
    }else if([keyS isEqual:@"user_grade"]){
        keyS = @"账号等级";
    }else if([keyS isEqual:@"user_type"]){
        keyS = @"账号类型";
    }else if([keyS isEqual:@"weixin_binded"]){
        keyS = @"绑定微信";
    }else if([keyS isEqual:@"is_mark"]){
        keyS = @"是否备注";
    }
    
    return keyS;
}

@end
