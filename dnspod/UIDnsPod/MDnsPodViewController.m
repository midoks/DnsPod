//
//  DnsPodViewController.m
//  dnspod
//
//  Created by midoks on 14/10/20.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import "MLoginViewController.h"
#import "SlideNavigationController.h"
#import "MLeftMenuViewController.h"

#import "MDnsPodRecordViewController.h"
#import "MDnsPodLogViewController.h"
#import "MDnsPodDomainInfoViewController.h"


@interface MDnsPodViewController ()  <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

//域名数组的信息
@property (nonatomic, strong) NSMutableArray *domains;
//UITabView
@property (nonatomic, strong) UITableView *table;
//选择的域名信息
@property (nonatomic, strong) NSDictionary *currentDomain;

//UIRefreshControl
@property (nonatomic, strong) UIRefreshControl *pullRefreshControll;
@end

@implementation MDnsPodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏设置
    [self setTitleW:@"域名列表"];
    
    
    [SlideNavigationController sharedInstance].leftMenu = [MLeftMenuViewController sharedInstance];
    [SlideNavigationController sharedInstance].enableSwipeGesture = YES;
    
    UIBarButtonItem  *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddDomain)];
    rightButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _domains = [[NSMutableArray alloc] init];
    
    //tableView使用
    _table = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    [self.view addSubview:_table];
    
    //下拉刷新
    [self setupRefresh];
}



#pragma mark 下拉刷新
-(void)setupRefresh{
    
    _pullRefreshControll = [[UIRefreshControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    _pullRefreshControll.backgroundColor = [UIColor colorWithRed: 239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    
    [_pullRefreshControll addTarget:self action:@selector(pullReloadDomainListData:) forControlEvents:UIControlEventValueChanged];
    [_table addSubview:_pullRefreshControll];
    [_pullRefreshControll beginRefreshing];
    
    [self pullReloadDomainListData:_pullRefreshControll];
    
}

#pragma mark - 下拉加载方式
-(void) pullReloadDomainListData:(UIRefreshControl *)control
{
    [self reloadDomainListData:^{
        [control endRefreshing];
    } fail:^{
        [control endRefreshing];
    }];
}

-(void)GetLoadNewData{
    [self pullReloadDomainListData:_pullRefreshControll];
}


#pragma mark 加载数据
-(void) reloadDomainListData:(void (^)())ok fail:(void (^)())fail
{
    //获取域名数据
    [self->api DomainList:@"all" offset:@"0" length:nil group_id:nil keyword:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableArray *t = [responseObject objectForKey:@"domains"];
        [_domains removeAllObjects];
        [_domains addObjectsFromArray:t];
        
        ok();
        if ([_domains count] < 1){
            [self showAlert:@"提示" msg:@"没有域名,添加域名!"];
        }
        [_table reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        fail();
        [self showAlert:@"提示" msg:@"网络不畅通,下拉重新获取!"];
    }];
}

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _table.frame = self.view.bounds;
}

#pragma mark 显示多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark 显示多少行
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_domains count] > 0) {
        return [_domains count];
    }else{
        return 0;
    }
}

#pragma mark 每一行的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * Sign = @"domainSign";
    //在缓存池取值
    UITableViewCell *cell = [_table dequeueReusableCellWithIdentifier:Sign];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Sign];
    }
    
    NSDictionary *obj = [_domains objectAtIndex:indexPath.row];
    cell.textLabel.text = [obj objectForKey:@"name"];
    
    cell.textLabel.textColor = [UIColor blueColor];//颜色控制
    cell.imageView.image = [UIImage imageNamed:@"list_blue_icons"];
    
    NSString *ext_status = [obj objectForKey:@"ext_status"];
    if ([@"dnserror" isEqualToString:ext_status] || [@"notexist" isEqualToString:ext_status]) {//DNS错误
        //cell.textLabel.textColor = [UIColor redColor];
        cell.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:245.0/255.0 blue:240.0/255.0 alpha:1];
        cell.imageView.image = [UIImage imageNamed:@"list_red_icons"];
    }
    
    //    if([@"notexist" isEqualToString:ext_status]){//不存在
    //        cell.textLabel.textColor = [UIColor redColor];
    //    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//进入图标
    return cell;
}

#pragma mark 选择数据
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *obj = [_domains objectAtIndex:indexPath.row];
    
    if ([[obj objectForKey:@"id"] isEqual:@""]) {
        [self showAlert:@"错误" msg:@"网络获取错误,刷新后再试!!!"];
        return;
    }
    
    _selectedDomain = obj;
    
    
    UIActionSheet *domainActionSheet;
    //检查是否为有效域名
    NSString *ext_status = [_selectedDomain objectForKey:@"ext_status"];
    if ([@"dnserror" isEqualToString:ext_status] || [@"notexist" isEqualToString:ext_status]) {//DNS错误
        //[self showAlert:@"提示" msg:@"无效域名!!!"];
        domainActionSheet = [[UIActionSheet alloc] initWithTitle:@"域名管理(无效域名)"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:@"删除域名"
                                               otherButtonTitles:@"域名信息",nil];
        [domainActionSheet showInView:self.view];
        return;
    }
    
    
    /**
     *  @func 跳入域名管理页
     *  @explain 在1.2.1使用的方法
     *  点击使用 UIActionSheet 进行管理
     *  需要使用 UIActionSheetDelegate
     */
    
    if ([[_selectedDomain objectForKey:@"status"] isEqual:@"enable"]) {
        domainActionSheet = [[UIActionSheet alloc] initWithTitle:@"域名管理"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:@"删除域名"
                                               otherButtonTitles:@"记录管理", @"查看日志", @"已启用", @"域名信息", nil];
    }else if([[_selectedDomain objectForKey:@"status"] isEqual:@"pause"]){
        domainActionSheet = [[UIActionSheet alloc] initWithTitle:@"域名管理"
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:@"删除域名"
                                               otherButtonTitles:@"记录管理", @"查看日志", @"已禁用", @"域名信息", nil];
    }
    
    //[domainActionSheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    [domainActionSheet showInView:self.view];
    
    /**
     *  @func 跳入域名管理页 (已经删除)
     *  @explain 在1.1.9使用的方法
     *  点击进入 MDnsPodCollectionViewController 进行管理
     */
    //    MDnsPodCollectionViewController *ds = [[MDnsPodCollectionViewController alloc] initWithNibName:@"MDnsPodCollectionViewController" bundle:nil];
    //    ds.selectedDomain = obj;
    //    ds.pvc = self;
    //    [[SlideNavigationController sharedInstance] pushViewController:ds animated:YES];
}


//UIActionSheet 代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:[self DeleteDomain];break;
        case 1:[self recordList];break;
        case 2:[self DomainLog];break;
        case 3:[self DomainEnable];break;
        case 4:[self DomainInfo];break;
        default:break;
    }
    //NSLog(@"%d", buttonIndex);
}


#pragma mark - Private Method -

//删除域名
-(void)DeleteDomain
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你确定删除域名:"
                                                    message:[_selectedDomain objectForKey:@"name"]
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    [alert show];
}

//删除域名域名
-(void)alertDeleteDomain
{
    NSString *domain = [_selectedDomain objectForKey:@"id"];
    [self->api DomainRemove:domain
                     domain:nil
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hudClose];
                        NSString *successMsg = [[responseObject objectForKey:@"status"] objectForKey:@"message"];
                        if(![self DTokenHandle:responseObject success:@selector(alertDeleteDomain)]){
                            [self showAlert:@"提示" msg:successMsg time:3.0f];
                            [self GetLoadNewData];
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [self hudClose];
                        [self showAlert:@"提示" msg:@"网络不畅通" time:5.0f];
                    }];
}

//记录管理
-(void)recordList
{
    NSString *ext_status = [_selectedDomain objectForKey:@"ext_status"];
    if ([@"dnserror" isEqualToString:ext_status] || [@"notexist" isEqualToString:ext_status]) {
        [self DomainInfo];
    }else{
        MDnsPodRecordViewController *ds = [[MDnsPodRecordViewController alloc] init];
        ds.selectedDomain = _selectedDomain;
        [[SlideNavigationController sharedInstance] pushViewController:ds animated:YES];
    }
    
}

//解析日记
-(void)DomainLog
{
    NSString *ext_status = [_selectedDomain objectForKey:@"ext_status"];
    if ([@"dnserror" isEqualToString:ext_status] || [@"notexist" isEqualToString:ext_status]) {
    }else{
        MDnsPodLogViewController *ds = [MDnsPodLogViewController sharedInstance];
        ds.selectedDomain = _selectedDomain;
        [[SlideNavigationController sharedInstance] pushViewController:ds animated:YES];
    }
}

//域名支持
-(void)DomainEnable
{
    if ([[_selectedDomain objectForKey:@"status"] isEqual:@"enable"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你确定禁用域名:"
                                                        message:[_selectedDomain objectForKey:@"name"]
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        [alert show];
    }else if([[_selectedDomain objectForKey:@"status"] isEqual:@"pause"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"你确定启用域名:"
                                                        message:[_selectedDomain objectForKey:@"name"]
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        [alert show];
    }
}

//启用域名
-(void)alertStartDomain
{
    [self->api DomainStatus:[_selectedDomain objectForKey:@"id"]
                     domain:nil
                     status:@"enable"
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hudClose];
                        NSString *successMsg = [[responseObject objectForKey:@"status"] objectForKey:@"message"];
                        if(![self DTokenHandle:responseObject success:@selector(alertStartDomain)]){
                            [self showAlert:@"提示" msg:successMsg time:3.0f];
                            [self GetLoadNewData];
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [self hudClose];
                        [self showAlert:@"提示" msg:@"网络不畅通" time:5.0f];
                    }];
}

//禁用域名
-(void)alertStopDomain
{
    [self->api DomainStatus:[_selectedDomain objectForKey:@"id"]
                     domain:nil
                     status:@"disable"
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [self hudClose];
                        NSString *successMsg = [[responseObject objectForKey:@"status"] objectForKey:@"message"];
                        if(![self DTokenHandle:responseObject success:@selector(alertStopDomain)]){
                            [self showAlert:@"提示" msg:successMsg time:3.0f];
                            [self GetLoadNewData];
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [self hudClose];
                        [self showAlert:@"提示" msg:@"网络不畅通" time:5.0f];
                    }];
}

//域名信息
-(void)DomainInfo
{
    MDnsPodDomainInfoViewController *ds = [MDnsPodDomainInfoViewController sharedInstance];
    ds.selectedDomain = _selectedDomain;
    [[SlideNavigationController sharedInstance] pushViewController:ds animated:YES];
}

#pragma mark 添加域名
-(void)AddDomain
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加域名"
                                                    message:@"请输入你要添加的域名(不带www) 例:cachecha.com"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    //设置输入框的键盘类型
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNamePhonePad];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
}

#pragma mark - AlertView判断 -
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //点击确认后[添加域名处理]
    if([alertView.title isEqual:@"添加域名"] && (buttonIndex == 1))
    {
        NSString *domain = [[alertView textFieldAtIndex:0] text];
        
        if ([domain isEqual:@""]) {
            [self showAlert:@"提示" msg:@"添加域名不能为空!!!"];
            return;
        }
        
        
        [self->api DomainCreate:domain success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //NSLog(@"%@", responseObject);
            if([responseObject objectForKey:@"domain"]){
                [self showAlert:@"添加成功" msg:[[responseObject objectForKey:@"domain"] objectForKey:@"domain"] time:3.0f];
            }else if ([responseObject objectForKey:@"status"]){
                NSString *errMsg = [NSString stringWithFormat:@"添加失败:%@", [[responseObject objectForKey:@"status"] objectForKey:@"message"]];
                [self showAlert:@"提示" msg:errMsg time:5.0f];
            }
            [self GetLoadNewData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self showAlert:@"提示" msg:@"网络不畅通" time:3.0f];
        }];
    }
    
    //删除域名
    if([alertView.title isEqualToString:@"你确定删除域名:"] && (buttonIndex == 1))
    {
        //[self showAlert:@"提示" msg:@"删除功能" time:3.0];
        [self hudWaitProgress:@selector(alertDeleteDomain)];
    }
    
    //禁用域名
    if ([alertView.title isEqualToString:@"你确定禁用域名:"] && (buttonIndex == 1)) {
        [self hudWaitProgress:@selector(alertStopDomain)];
    }
    
    //启用域名
    if([alertView.title isEqualToString:@"你确定启用域名:"] && (buttonIndex == 1)){
        [self hudWaitProgress:@selector(alertStartDomain)];
    }
}

@end
