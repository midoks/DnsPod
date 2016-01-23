//
//  MDnsPodRecordAddSelectViewController.m
//  dnspod
//
//  Created by midoks on 14/12/19.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import "MDnsPodRecordAddSelectViewController.h"
#import "MDnsPodRecordAddViewController.h"

@interface MDnsPodRecordAddSelectViewController () <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) UITableView *table;


@end

@implementation MDnsPodRecordAddSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _table.dataSource = self;
    _table.delegate = self;
    [self.view addSubview:_table];
}

static MDnsPodRecordAddSelectViewController *MDnsPodRecordAddSelectViewControllerSingle;
+(MDnsPodRecordAddSelectViewController *)sharedInstance
{
    if (!MDnsPodRecordAddSelectViewControllerSingle) {
        return [[self alloc] init];
    }
    return MDnsPodRecordAddSelectViewControllerSingle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _table.frame = self.view.bounds;
}

#pragma mark - UITableViewDelegate -

#pragma mark 显示多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark 显示多少行
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list count];
}

#pragma mark 每一行的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * recordsSign = @"listCell";
    UITableViewCell *cell = [_table dequeueReusableCellWithIdentifier:recordsSign];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recordsSign];
    }
    NSString *val = [_list objectAtIndex:indexPath.row];
    cell.textLabel.text = val;
    
    if ([val isEqualToString:self.currentSelected]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

#pragma mark 点击行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *val = [_list objectAtIndex:indexPath.row];
    //NSLog(@"%@", val);
    if ([_type isEqualToString:MDRECORDLINETYPE]) {
        [self.data setValue:val forKey:MDRECORDLINETYPE];
        //NSLog(@"%@", MDRECORDLINETYPE);
    }else if ([_type isEqualToString:MDRECORDTYPE]){
        [self.data setValue:val forKey:MDRECORDTYPE];
        //NSLog(@"%@", MDRECORDTYPE);
    }
    [self.prevTable reloadData];
    [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
