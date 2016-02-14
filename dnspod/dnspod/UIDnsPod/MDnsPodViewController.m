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

//添加域名窗口
@property (nonatomic, strong) UIAlertController *domainAdd;

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
    
    //添加域名窗口
    [self initDomainAddView];
}

#pragma mark - 添加域名窗口 -
-(void)initDomainAddView {
    _domainAdd = [UIAlertController alertControllerWithTitle:@"添加域名"
                                                     message:@"请输入你要添加的域名(不带www) 例:cachecha.com"
                                              preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancal = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //NSLog(@"fail");
    }];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString * domainValue = _domainAdd.textFields.firstObject.text;
        
        if ([domainValue isEqual:@""]) {
            [self showAlert:@"提示" msg:@"添加域名不能为空!!!"];
            return;
        }
        
        [self->api DomainCreate:domainValue success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
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
        
    }];
    
    [_domainAdd addAction:cancal];
    [_domainAdd addAction:confirm];
    
    [_domainAdd addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"域名(cachecha.com)";
    }];
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
        [self showAlert:@"提示" msg:@"网络不畅通,下拉重新获取!" time:1.5f block:nil];
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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"域名管理"
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *deleteDomain = [UIAlertAction actionWithTitle:@"删除域名" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self showAlert:@"你确定删除域名:" msg:[_selectedDomain objectForKey:@"name"] ok:^{
            [self hudWaitProgress:@selector(alertDeleteDomain)];
        } fail:^{}];
        
    }];
    
    
    //域名记录
    UIAlertAction *recordList = [UIAlertAction actionWithTitle:@"记录管理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *ext_status = [_selectedDomain objectForKey:@"ext_status"];
        if ([@"dnserror" isEqualToString:ext_status] || [@"notexist" isEqualToString:ext_status]) {
            [self DomainInfo];
        }else{
            MDnsPodRecordViewController *ds = [[MDnsPodRecordViewController alloc] init];
            ds.selectedDomain = _selectedDomain;
            [[SlideNavigationController sharedInstance] pushViewController:ds animated:YES];
        }
    }];
    
    //域名日志
    UIAlertAction *domainLog = [UIAlertAction actionWithTitle:@"记录日志" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        MDnsPodLogViewController *ds = [MDnsPodLogViewController sharedInstance];
        ds.selectedDomain = _selectedDomain;
        [[SlideNavigationController sharedInstance] pushViewController:ds animated:YES];
        
    }];
    
    //域名信息
    UIAlertAction *domainInfo = [UIAlertAction actionWithTitle:@"记录信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self DomainInfo];
    }];
    
    //域名状态
    NSString *statusName;
    if ([[_selectedDomain objectForKey:@"status"] isEqual:@"enable"]) {
        statusName = @"已启用";
    }else{
        statusName = @"已禁用";
    }
    UIAlertAction *domainStatus = [UIAlertAction actionWithTitle:statusName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self DomainEnable];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    if ([[_selectedDomain objectForKey:@"ext_status"] isEqual:@"dnserror"]) {
        [alertController addAction:deleteDomain];
        [alertController addAction:domainInfo];
        [alertController addAction:cancel];
    }else{
        [alertController addAction:deleteDomain];
        [alertController addAction:recordList];
        [alertController addAction:domainLog];
        [alertController addAction:domainStatus];
        [alertController addAction:domainInfo];
        [alertController addAction:cancel];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Private Method -

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

//域名支持
-(void)DomainEnable
{
    if ([[_selectedDomain objectForKey:@"status"] isEqual:@"enable"]) {
        
        
        [self showAlert:@"你确定禁用域名:" msg:[_selectedDomain objectForKey:@"name"] ok:^{
            [self hudWaitProgress:@selector(alertStopDomain)];
        } fail:nil];
    }else if([[_selectedDomain objectForKey:@"status"] isEqual:@"pause"])
    {
        
        [self showAlert:@"你确定启用域名:" msg:[_selectedDomain objectForKey:@"name"] ok:^{
            [self hudWaitProgress:@selector(alertStartDomain)];
        } fail:nil];
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
    [self presentViewController:_domainAdd animated:YES completion:nil];
}

@end
