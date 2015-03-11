//
//  MDnsRecordAddViewController.m
//  dnspod
//
//  Created by midoks on 14/12/12.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import "MDnsPodRecordAddViewController.h"
#import "MDnsPodRecordAddSelectViewController.h"
#import "MDnsPodRecordViewController.h"

@interface MDnsPodRecordAddViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@end

@implementation MDnsPodRecordAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"添加记录";
    NSString *submitText;
    if (_selectedRecord) {
        submitText = @"更新";
    }
    else
    {
        submitText = @"提交";
    }
    
    UIBarButtonItem  *rightButton = [[UIBarButtonItem alloc] initWithTitle:submitText style:UIBarButtonItemStyleDone target:self action:@selector(submit)];
    rightButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _data = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
             @"@",      MDRECORDNAME,
             @"请填写",   MDRECORDVALUE,
             @"A",       MDRECORDTYPE,
             @"默认",     MDRECORDLINETYPE,
             @"-",       MDRECORDMX,
             @"600",     MDRECORDTLL,
             nil];
    
    //tableView使用
    _table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _table.dataSource = self;
    _table.delegate = self;
    [self.view addSubview:_table];
    
    
    if(_selectedRecord){
        [_data setObject:[_selectedRecord objectForKey:@"name"] forKey:MDRECORDNAME];
        [_data setObject:[_selectedRecord objectForKey:@"value"] forKey:MDRECORDVALUE];
        [_data setObject:[_selectedRecord objectForKey:@"type"] forKey:MDRECORDTYPE];
        [_data setObject:[_selectedRecord objectForKey:@"ttl"] forKey:MDRECORDTLL];
        [_data setObject:[_selectedRecord objectForKey:@"line"] forKey:MDRECORDLINETYPE];
    }
}

static MDnsPodRecordAddViewController *MDnsPodRecordAddViewControllerSingle;
+(MDnsPodRecordAddViewController *)sharedInstance
{
    if (!MDnsPodRecordAddViewControllerSingle) {
        return [[self alloc] init];
    }
    return MDnsPodRecordAddViewControllerSingle;
}

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _table.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 显示多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark 显示多少行
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

#pragma mark 每一行的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * recordsSign = @"recordSign";
    UITableViewCell *cell = [_table dequeueReusableCellWithIdentifier:recordsSign];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:recordsSign];
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = MDRECORDNAME;
            cell.detailTextLabel.text = [_data objectForKey:MDRECORDNAME];
            break;
        case 1:
            cell.textLabel.text = MDRECORDVALUE;
            cell.detailTextLabel.text = [_data objectForKey:MDRECORDVALUE];
            break;
        case 2:
            cell.textLabel.text = MDRECORDTYPE;
            cell.detailTextLabel.text = [_data objectForKey:MDRECORDTYPE];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 3:
            cell.textLabel.text = MDRECORDLINETYPE;
            cell.detailTextLabel.text = [_data objectForKey:MDRECORDLINETYPE];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 4:
            cell.textLabel.text = MDRECORDMX;
            cell.detailTextLabel.text = [_data objectForKey:MDRECORDMX];
            break;
        case 5:
            cell.textLabel.text = MDRECORDTLL;
            cell.detailTextLabel.text = [_data objectForKey:MDRECORDTLL];
            break;
        default:
            cell.textLabel.text = @"...";
            cell.detailTextLabel.text = @"test";
            break;
    }
    return cell;
}

#pragma mark 点击操作
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:[self ModRecord];break;
        case 1:[self ModRecordValue];break;
        case 2:[self SelectRecordType];break;
        case 3:[self SelectRecordLineType];break;
        case 4:[self ModRecordMx];break;
        case 5:[self ModRecordTll];break;
        default:break;
    }
}

#pragma mark - UIAlertViewDelegate Methods -
#pragma mark 执行操作
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *value;
    //主机记录
    if([alertView.title isEqualToString:MDRECORDNAME] && (buttonIndex == 1)){
        value = [[alertView textFieldAtIndex:0] text];
        [_data setObject:value forKey:MDRECORDNAME];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:alertView.tag inSection:0];
        NSArray *path = @[indexPath];
        [_table reloadRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationLeft];
    }
    
    //记录值
    if([alertView.title isEqualToString:MDRECORDVALUE] && (buttonIndex == 1)){
        value = [[alertView textFieldAtIndex:0] text];
        [_data setObject:value forKey:MDRECORDVALUE];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:alertView.tag inSection:0];
        NSArray *path = @[indexPath];
        [_table reloadRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationLeft];
    }
    
    //MX优先级
    if([alertView.title isEqualToString:MDRECORDMX] && (buttonIndex == 1)){
        value = [[alertView textFieldAtIndex:0] text];
        [_data setObject:value forKey:MDRECORDMX];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:alertView.tag inSection:0];
        NSArray *path = @[indexPath];
        [_table reloadRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationMiddle];
    }
    
    //TLL
    if([alertView.title isEqualToString:MDRECORDTLL] && (buttonIndex == 1)){
        value = [[alertView textFieldAtIndex:0] text];
        [_data setObject:value forKey:MDRECORDTLL];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:alertView.tag inSection:0];
        NSArray *path = @[indexPath];
        [_table reloadRowsAtIndexPaths:path withRowAnimation:UITableViewRowAnimationMiddle];
    }
    
    //添加记录 import
    if([alertView.title isEqualToString:@"添加记录"] && (buttonIndex == 1)){
        
        NSString *recordName = [_data objectForKey:MDRECORDNAME];
        if ([recordName isEqualToString:@"请填写"]) {
            [self showAlert:@"提示" msg:@"主机记录请填写"];
            return;
        }
        
        NSString *recordValue = [_data objectForKey:MDRECORDVALUE];
        if ([recordValue isEqualToString:@"请填写"]) {
            [self showAlert:@"提示" msg:@"主机值请填写"];
            return;
        }
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        [self->api RecordCreate:[_selectedDomain objectForKey:@"id"]
                     sub_domain:[_data objectForKey:MDRECORDNAME]
                          value:[_data objectForKey:MDRECORDVALUE]
                    record_type:[_data objectForKey:MDRECORDTYPE]
                    record_line:[_data objectForKey:MDRECORDLINETYPE]
                             mx:nil//[_data objectForKey:MDRECORDMX]
                            ttl:[_data objectForKey:MDRECORDTLL]
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            self.navigationItem.rightBarButtonItem.enabled = YES;
                            //NSLog(@"responseObject: %@", responseObject);
                            NSString *code = [[responseObject objectForKey:@"status"] objectForKey:@"code"];
                            NSString *msg = [[responseObject objectForKey:@"status"] objectForKey:@"message"];
                            if ([code isEqualToString:@"1"]) {
                                [self showAlert:@"提示" msg:@"添加记录成功"];
                                [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
                                [self.pvc GetLoadNewData];
                            }else{
                                [self showAlert:@"提示" msg:msg];
                            }
                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            self.navigationItem.rightBarButtonItem.enabled = YES;
                            //NSLog(@"error: %@", error);
                            [self showAlert:@"提示" msg:@"网络不畅通" time:2.0f];
                        }];
    }
    
    //修改记录
    if([alertView.title isEqualToString:@"修改记录"] && (buttonIndex == 1))
    {
        NSString *recordName = [_data objectForKey:MDRECORDNAME];
        if ([recordName isEqualToString:@"请填写"]) {
            [self showAlert:@"提示" msg:@"主机记录请填写"];
            return;
        }
        
        NSString *recordValue = [_data objectForKey:MDRECORDVALUE];
        if ([recordValue isEqualToString:@"请填写"]) {
            [self showAlert:@"提示" msg:@"主机值请填写"];
            return;
        }

        //修改值
        [self->api RecordModify:[_selectedDomain objectForKey:@"id"]
                      record_id:[_selectedRecord objectForKey:@"id"]
                     sub_domain:[_data objectForKey:MDRECORDNAME]
                    record_type:[_data objectForKey:MDRECORDTYPE]
                    record_line:[_data objectForKey:MDRECORDLINETYPE]
                          value:[_data objectForKey:MDRECORDVALUE]
                             mx:nil
                            ttl:[_data objectForKey:MDRECORDTLL]
                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            NSString *message = [[responseObject objectForKey:@"status"] objectForKey:@"message"];
                            if([[[responseObject objectForKey:@"status"] objectForKey:@"code"] isEqualToString:@"1"]){
                                [self showAlert:@"提示" msg:message];
                                [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
                                [self.pvc GetLoadNewData];
                            }else{
                                [self showAlert:@"提示" msg:message];
                            }
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            //NSLog(@"fail:%@", error);
                            [self showAlert:@"提示" msg:@"网络不畅通" time:2.0f];
                        }];
    }
}

#pragma mark 修改主机记录
-(void)ModRecord
{
    NSString *value = [_data objectForKey:MDRECORDNAME];
    if([value isEqualToString:@"请填写"]){
        value = @"";
    }
    [self ModRecordCommonValue:MDRECORDNAME value:value notice:@"请输入或修改主机记录" tag:0];
}

#pragma mark 修改主机记录值
-(void)ModRecordValue
{
    NSString *value = [_data objectForKey:MDRECORDVALUE];
    if([value isEqualToString:@"请填写"]){
        value = @"";
    }
    [self ModRecordCommonValue:MDRECORDVALUE value:value notice:@"请输入或修改记录值" tag:1];
}

#pragma mark 修改Mx优先级
-(void)ModRecordMx
{
    NSString *value = [_data objectForKey:MDRECORDMX];
    [self ModRecordCommonValue:MDRECORDMX value:value notice:@"请输入或修改MX优先级" tag:4];
}

#pragma mark Tll
-(void)ModRecordTll
{
    NSString *value = [_data objectForKey:MDRECORDTLL];
    [self ModRecordCommonValue:MDRECORDTLL value:value notice:@"请输入或修改TLL" tag:5];
}

-(void)ModRecordCommonValue:(NSString *)name value:(NSString *)value notice:(NSString *)notice tag:(NSInteger)tag;
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:name
                                                    message:notice
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    alert.tag = tag;
    //设置输入框的键盘类型
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeEmailAddress];
    [alert textFieldAtIndex:0].text = value;
    [alert show];
}

#pragma mark 选择记录类型
-(void)SelectRecordType
{
    [self->api RecordType:@"D_Free" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        MDnsPodRecordAddSelectViewController *ds = [[MDnsPodRecordAddSelectViewController alloc] init];
        ds.title = @"选择线路类型";
        ds.list = [responseObject objectForKey:@"types"];
        ds.currentSelected = [_data objectForKey:MDRECORDTYPE];
        ds.type = MDRECORDTYPE;
        ds.prevTable = _table;
        ds.data = _data;
        [[SlideNavigationController sharedInstance] pushViewController:ds animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlert:@"提示" msg:@"网络不畅通" time:2.0f];
    }];
}

#pragma mark 选择线路类型
-(void)SelectRecordLineType
{
    
    [self->api RecordLine:nil
                   domain:nil
             domain_grade:@"D_Free"
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
        MDnsPodRecordAddSelectViewController *ds = [[MDnsPodRecordAddSelectViewController alloc] init];
            ds.title = @"选择线路类型";
            ds.list = [responseObject objectForKey:@"lines"];
            ds.currentSelected = [_data objectForKey:MDRECORDLINETYPE];
            ds.type = MDRECORDLINETYPE;
            ds.prevTable = _table;
            ds.data = _data;
            [[SlideNavigationController sharedInstance] pushViewController:ds animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showAlert:@"提示" msg:@"网络不畅通" time:2.0f];
    }];
}

-(void)submit
{
    if (_selectedRecord)
    {
        [self submitMod];
    }
    else
    {
        [self submitAdd];
    }
}

-(void)submitAdd
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加记录"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    [alert show];
}

-(void)submitMod
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改记录"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定",nil];
    [alert show];
}

@end
