//
//  DnsPodRecordViewController.m
//  dnspod
//
//  Created by midoks on 14/11/30.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import "MDnsPodRecordViewController.h"
#import "MLeftMenuViewController.h"

@interface MDnsPodRecordViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, MGSwipeTableCellDelegate, UIActionSheetDelegate>
@end

@implementation MDnsPodRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SlideNavigationController sharedInstance].leftMenu = nil;
    [SlideNavigationController sharedInstance].enableSwipeGesture = NO;
    
    self.title = @"记录管理";
    
    UIBarButtonItem  *left = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(pushMenuBack)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
    UIBarButtonItem  *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(GoAddRecords)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self GetLoadNewData];
    
    //tableView使用
    _table = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    [self.view addSubview:_table];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 重新获取数据,并刷新表
-(void)GetLoadNewData
{
    //获取域名的记录
    [self hudWaitProgress:@selector(reloadDomainListData)];
}


#pragma mark - 下拉加载方式
-(void) pullReloadDomainListData
{
    [self reloadDomainListData];
}


#pragma mark 加载数据
-(void) reloadDomainListData
{
    [self->api RecordList:[_selectedDomain objectForKey:@"id"] offset:@"0" length:nil sub_domain:nil keyword:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hudClose];
        //NSLog(@"_records:%@", responseObject);
        _records = [responseObject objectForKey:@"records"];
        [_table reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hudClose];
        [self showAlert:@"提示" msg:@"网络不畅通"];
    }];
}

#pragma mark 重新排版
-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _table.frame = self.view.bounds;
}

#pragma mark - UITableViewDelegate Methods -

#pragma mark 显示多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark 显示多少行
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_records count] > 0){
        return [_records count];
    }
    return 0;
}

#pragma mark 每行的高度

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}


#pragma mark 每一行的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * recordsSign = @"Cell";
    MGSwipeTableCell * cell = [_table dequeueReusableCellWithIdentifier:recordsSign];
    if (!cell) {
        cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:recordsSign];
    }
    
    if ([_records count] > 0) {
        cell.textLabel.text = @"测试";
        NSDictionary *obj = [_records objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"记录:%@", [obj objectForKey:@"name"]];//主要内容
        cell.detailTextLabel.text = [obj objectForKey:@"value"];//记录值
        cell.textLabel.textColor = [UIColor blueColor];//颜色控制
        [cell setSelectedObj:obj];//保存对象
        
        
        //图标设置
        cell.imageView.image = [UIImage imageNamed:@"list_blue_icons"];
        cell.backgroundColor = nil;
        if ([[obj objectForKey:@"enabled"] isEqual:@"0"]) {
            cell.imageView.image = [UIImage imageNamed:@"list_red_icons"];
            cell.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:245.0/255.0 blue:240.0/255.0 alpha:1];
        }
        
#if !TEST_USE_MG_DELEGATE
        cell.leftSwipeSettings.transition = MGSwipeTransitionStatic;
        cell.rightSwipeSettings.transition = MGSwipeTransitionStatic;
        cell.leftExpansion.fillOnTrigger = NO;
        cell.rightExpansion.buttonIndex = 0;
        cell.rightExpansion.fillOnTrigger = YES;
        cell.rightButtons = [self createRightButtons:3 status:[obj objectForKey:@"enabled"]];
#endif
    }else{
        cell.textLabel.text = @"正在加载中...";
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.delegate = self;
    
    
    return cell;
}

#pragma mark 选择row
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UIAlertViewDelegate Methods -
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //删除记录
    if([alertView.title isEqualToString:@"删除记录"] && (buttonIndex == 1))
    {
        NSString *value = [self.selectedCell.cell.selectedObj objectForKey:@"value"];
        if ([value isEqual:@"f1g1ns1.dnspod.net."] || [value isEqual:@"f1g1ns2.dnspod.net."]) {
            [self showAlert:@"提示" msg:@"此记录不能删除." time:2.0f];
            return;
        }
        
        NSString *domain_id = [_selectedDomain objectForKey:@"id"];
        NSString *record_id = self.selectedCell.selectedId;
        [self->api RecordRemove:domain_id
                      record_id:record_id
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSString *msg = [[responseObject objectForKey:@"status"] objectForKey:@"message"];
                            //NSLog(@"responseObject:%@", responseObject);
                            
                            if ([[[responseObject objectForKey:@"status"] objectForKey:@"code"] isEqual:@"1"]){
                                [self GetLoadNewData];
                                [self showAlert:@"提示" msg:msg time:2.0f];
                            }else{
                                [self showAlert:@"失败" msg:msg time:5.0f];
                            }
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self showAlert:@"提示" msg:@"网络不畅通" time:5.0f];
                        }];
    }
    
    //更改记录状态
    if ([alertView.title isEqualToString:@"更改记录状态"] && (buttonIndex == 1))
    {
        NSString *value = [self.selectedCell.cell.selectedObj objectForKey:@"value"];
        if ([value isEqual:@"f1g1ns1.dnspod.net."] || [value isEqual:@"f1g1ns2.dnspod.net."]) {
            [self showAlert:@"提示" msg:@"此记录不能修改状态." time:2.0f];
            return;
        }
        
        NSString *domain_id = [_selectedDomain objectForKey:@"id"];
        NSString *record_id = self.selectedCell.selectedId;
        NSString *status;
        MGSwipeButton *btn = self.selectedCell.cell.rightButtons[self.selectedCell.index];
        
        if ([btn.titleLabel.text isEqualToString:@"已启用"]){
            status = @"disable";
        }else{
            status = @"enable";
        }
        
        [self->api RecordStatus:domain_id
                      record_id:record_id
                         status:status
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if ([[[responseObject objectForKey:@"status"] objectForKey:@"code"] isEqual:@"1"])
                            {
                                [self showAlert:@"提示" msg:[[responseObject objectForKey:@"status"] objectForKey:@"message"]];
                                [self GetLoadNewData];
                            }else{
                                NSString *msg = [[responseObject objectForKey:@"status"] objectForKey:@"message"];
                                [self showAlert:@"失败" msg:msg time:5.0f];
                            }
                            
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            [self showAlert:@"提示" msg:@"网络不畅通" time:5.0f];
                        }];
    }
    
    //修改
    if([alertView.title isEqualToString:@"确定修改?"] && (buttonIndex == 1))
    {
        NSString *value = [self.selectedCell.cell.selectedObj objectForKey:@"value"];
        if ([value isEqual:@"f1g1ns1.dnspod.net."] || [value isEqual:@"f1g1ns2.dnspod.net."]) {
            [self showAlert:@"提示" msg:@"不能修改此记录." time:2.0f];
            return;
        }
        
        MDnsPodRecordAddViewController *mod = [[MDnsPodRecordAddViewController alloc] init];
        mod.selectedDomain = _selectedDomain;
        mod.selectedRecord = self.selectedCell.cell.selectedObj;
        mod.pvc = self;
        [[SlideNavigationController sharedInstance] pushViewController:mod animated:YES];
    }
}

#pragma mark - Extends -
-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell
   tappedButtonAtIndex:(NSInteger) index
             direction:(MGSwipeDirection)direction
         fromExpansion:(BOOL) fromExpansion
{
    //删除按钮
    if ( 0 == index ){
        NSString *selectedId = [cell.selectedObj objectForKey:@"id"];
        self.selectedCell = NSSelectedCell(cell, index, selectedId);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除记录"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        [alert show];
    }
    
    //设置启用
    if (1 == index){
        MGSwipeButton *btn = cell.rightButtons[index];
        NSString *msg;
        if ([btn.titleLabel.text isEqual:@"已启用"]){
            msg = @"是否要禁用该记录?";
        }else{
            msg = @"是否要启用该记录?";
        }
        NSString *selectedId = [cell.selectedObj objectForKey:@"id"];
        self.selectedCell = NSSelectedCell(cell, index, selectedId);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更改记录状态"
                                                        message:msg
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        [alert show];
    }
    
    if(2 == index)
    {
        NSString *selectedId = [cell.selectedObj objectForKey:@"id"];
        self.selectedCell = NSSelectedCell(cell, index, selectedId);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确定修改?"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
        [alert show];
    }
    return YES;
}

#pragma mark - Private Methods -
-(NSArray *) createRightButtons: (int) number status:(NSString *)status
{
    NSMutableArray * result = [NSMutableArray array];
    NSMutableArray *titles;
    if ([status isEqual:@"1"])
    {
        titles = [NSMutableArray arrayWithObjects:@"删除", @"已启用", @"修改", nil];
    }
    else
    {
        titles = [NSMutableArray arrayWithObjects:@"删除", @"已暂停", @"修改", nil];
    }
    UIColor * colors[3] = {
        [UIColor colorWithRed:230.0/255.0
                        green:46.0/255.0
                         blue:37.0/255.0
                        alpha:1],
        [UIColor colorWithRed:109.0/255.
                        green:109.0/255.0
                         blue:109.0/255.0
                        alpha:1],
        [UIColor colorWithRed:10.0/255.
                        green:40.0/255.0
                         blue:240.0/255.0
                        alpha:1]
    };
    for (int i = 0; i < number; ++i)
    {
        MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
            //NSLog(@"Convenience callback received (right).");
            return YES;
        }];
        [result addObject:button];
    }
    return result;
}

#pragma mark 添加记录
-(void)GoAddRecords
{
    MDnsPodRecordAddViewController *add = [[MDnsPodRecordAddViewController alloc] init];
    add.selectedDomain = _selectedDomain;
    add.pvc = self;
    [[SlideNavigationController sharedInstance] pushViewController:add animated:YES];
}

@end
