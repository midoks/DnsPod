//
//  MDnsPodDomainInfoViewController.m
//  dnspod
//
//  Created by midoks on 15/1/12.
//  Copyright (c) 2015年 midoks. All rights reserved.
//

#import "MDnsPodDomainInfoViewController.h"

@interface MDnsPodDomainInfoViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) NSMutableArray *domainKey;

@end

@implementation MDnsPodDomainInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"域名信息";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIBarButtonItem  *rightButtom = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    rightButtom.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButtom;
    
    _table = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _table.dataSource = self;
    _table.delegate = self;
    [self.view addSubview:_table];
    
    _domainKey = [[NSMutableArray alloc] init];
    [_domainKey removeAllObjects];
    [_domainKey addObjectsFromArray:[_selectedDomain allKeys]];
    
    MDnsPodDomainInfoViewControllerSingle = self;
}

static MDnsPodDomainInfoViewController *MDnsPodDomainInfoViewControllerSingle;
+(MDnsPodDomainInfoViewController *)sharedInstance
{
    if (!MDnsPodDomainInfoViewControllerSingle) {
        return [[self alloc] init];
    }
    return MDnsPodDomainInfoViewControllerSingle;
}

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _table.frame = self.view.bounds;
    [_table reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_selectedDomain count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * Sign = @"DomainInfoSign";
    UITableViewCell *cell = [_table dequeueReusableCellWithIdentifier:Sign];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:Sign];
    }
    
    //NSLog(@"%@", [[_selectedDomain objectEnumerator]]);
    
    NSString *key = _domainKey[indexPath.row];
    NSString *value = (NSString *)[_selectedDomain objectForKey:key];

    if([value isEqual:@""]){
        cell.detailTextLabel.text = @"空";
    }else{
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", value];
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
    if ([keyS isEqual:@"id"]) {
        keyS = @"ID";
    }else if ([keyS isEqual:@"name"]){
        keyS = @"域名";
    }else if([keyS isEqual:@"grade_title"]){
        keyS = @"套餐类型";
    }else if ([keyS isEqual:@"grade"]){
        keyS = @"类型";
    }else if([keyS isEqual:@"is_vip"]){
        keyS = @"是否VIP";
    }else if ([keyS isEqual:@"records"]){
        keyS = @"子记录数";
    }else if ([keyS isEqual:@"ttl"]){
        keyS = @"TLL";
    }else if ([keyS isEqual:@"owner"]){
        keyS = @"所有者";
    }else if([keyS isEqual:@"auth_to_anquanbao"]){
        keyS = @"支持安全中心";
    }else if ([keyS isEqual:@"searchengine_push"]){
        keyS = @"搜索引擎推送";
    }else if([keyS isEqual:@"group_id"]){
        keyS = @"组ID";
    }else if([keyS isEqual:@"cname_speedup"]){
        keyS = @"别名加速";
    }else if([keyS isEqual:@"created_on"]){
        keyS = @"创建时间";
    }else if([keyS isEqual:@"remark"]){
        keyS = @"备注";
    }else if([keyS isEqual:@"is_mark"]){
        keyS = @"是否备注";
    }else if([keyS isEqual:@"ext_status"]){
        keyS = @"域名状态";
    }else if([keyS isEqual:@"status"]){
        keyS = @"启用状态";
    }else if([keyS isEqual:@"updated_on"]){
        keyS = @"更新时间";
    }
    
    return keyS;
}

@end
