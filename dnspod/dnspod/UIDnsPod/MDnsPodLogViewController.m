//
//  MDnsPodLogViewController.m
//  dnspod
//
//  Created by midoks on 15/1/2.
//  Copyright (c) 2015年 midoks. All rights reserved.
//

#import "MDnsPodLogViewController.h"
#import "MLeftMenuViewController.h"
#import "MDTableViewHAFPullRefresh.h"


@interface MDnsPodLogViewController () <UITableViewDelegate, UITableViewDataSource, MDTableViewHAFDelegate>
{
    MDTableViewHAFPullRefresh *_refreshHAFView;
}

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NSMutableArray *logs;


@property (nonatomic, assign) NSInteger datastart;
@property (nonatomic, assign) NSInteger dataend;
@property (nonatomic, assign) NSInteger datalength;

@property (nonatomic, assign) BOOL onceLoad;
@end

//static BOOL onceLoad;
@implementation MDnsPodLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"解析日志";
    
    self.datastart = 0;
    self.dataend = 10;
    self.datalength = 12;
    _onceLoad = NO;
    
    _logs = [[NSMutableArray alloc] init];
    
    //[SlideNavigationController sharedInstance].leftMenu = nil;
    //[SlideNavigationController sharedInstance].enableSwipeGesture = NO;
    
    
    UIBarButtonItem  *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(pushMenuBack)];
    leftButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = leftButton;
    
    [self hudWaitProgress:@selector(GetLoadNewData)];
    
    _table = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    [self.view addSubview:_table];
    
    //[_table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"logCell"];
    
    //__block
    //__block MDnsPodLogViewController *blockSelf = self;
    //    [_table setPullToRefreshHandler:^{
    //        [blockSelf GetLoadNewData];
    //    }];
    //
    
    //    [_table setPullToLoadMoreHandler:^{
    //        NSLog(@"start:%ld, length:%ld", blockSelf->_datastart, blockSelf->_datalength);
    //        blockSelf->_datastart = blockSelf->_datalength + 20;
    //        [blockSelf GetLoadNewData];
    //    }];
    
    if (!_refreshHAFView) {
        
        MDTableViewHAFPullRefresh *view = [[MDTableViewHAFPullRefresh alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height, self.table.bounds.size.width, self.table.bounds.size.height)];
        view.delegate = self;
        view.view = self.view;
        _refreshHAFView = view;
        [self.table addSubview:view];
    }
}

static MDnsPodLogViewController *MDnsPodLogViewControllerSingle;
+(MDnsPodLogViewController *)sharedInstance
{
    if (!MDnsPodLogViewControllerSingle) {
        return [[self alloc] init];
    }
    return MDnsPodLogViewControllerSingle;
}

-(void) viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _table.frame = self.view.bounds;
    _refreshHAFView.frame = CGRectMake(0.0f, 0.0f - self.view.bounds.size.height, self.table.bounds.size.width, self.table.bounds.size.height);
    [_refreshHAFView headPosReload:_refreshHAFView.frame];
    _refreshHAFView.contetnInsetHeight = _table.scrollIndicatorInsets.top;
    [_table reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Mehotds -
-(void)GetLoadNewData
{
    sleep(1);
    //获取域名日志
    [self->api DomainLog:[_selectedDomain objectForKey:@"id"]
                  domain:nil
                  offset:[NSString stringWithFormat:@"%zd", _datastart]
                  length:[NSString stringWithFormat:@"%zd", _datalength]
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     [self hudClose];
                     [self pushLogIsShow:responseObject];
                     
                     NSString *message = [[responseObject objectForKey:@"status"] objectForKey:@"message"];
                     if ([[[responseObject objectForKey:@"status"] objectForKey:@"code"] isEqualToString:@"1"])
                     {
                         NSMutableArray * tmp_logs = [responseObject objectForKey:@"log"];
                         if (!tmp_logs)
                         {
                             [self showAlert:@"提示" msg:@"还没有解析日志"];
                             [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
                         }
                         [_logs removeAllObjects];
                         [_logs addObjectsFromArray:tmp_logs];
                     }
                     else
                     {
                         [self showAlert:@"提示" msg:message];
                         [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
                     }
                     [_table reloadData];
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [self hudClose];
                     [self showAlert:@"提示" msg:@"网络不畅通"];
                 }];
}

#pragma mark - UITableViewDelegate Methods -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_logs)
    {
        return [_logs count];
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * recordsSign = @"logCell";
    UITableViewCell *cell = [_table dequeueReusableCellWithIdentifier:recordsSign];
    if (!cell) {
       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:recordsSign];
    }
    NSString *log = [_logs objectAtIndex:indexPath.row];
    if (log){
        //UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width - 20, 54.0f)];
        //text.lineBreakMode = NSLineBreakByCharWrapping;
        //text.numberOfLines = 0;
        //text.font = [UIFont systemFontOfSize:12.0f];
        //text.text = log;
        //[cell.contentView addSubview:text];
        cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = log;
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
    }else{
        cell.textLabel.text = @"正在加载中...";
    }
    //NSLog(@"index:%zd", indexPath.row);
    //NSLog(@"cell:%@", cell);
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UIScrollViewDelegate Methods -
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHAFView mdRefreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshHAFView mdRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark - 上下拉刷新 -
- (void)mdRefreshTableHeadTriggerRefresh:(MDTableViewHAFPullRefresh *)view
{
    //获取域名日志
    [self->api DomainLog:[_selectedDomain objectForKey:@"id"]
                  domain:nil
                  offset:[NSString stringWithFormat:@"%zd", _datastart]
                  length:[NSString stringWithFormat:@"%zd", _datalength]
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     [self pushLogIsShow:responseObject];
                     _dataend = _datastart + _datalength;
                     [self performSelector:@selector(mdHeadOK) withObject:nil afterDelay:.8f];
                     NSString *message = [[responseObject objectForKey:@"status"] objectForKey:@"message"];
                     if ([[[responseObject objectForKey:@"status"] objectForKey:@"code"] isEqualToString:@"1"])
                     {
                         NSMutableArray * tmp_logs = [responseObject objectForKey:@"log"];
                         if (!tmp_logs)
                         {
                             [self showAlert:@"提示" msg:@"还没有解析日志"];
                             [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
                         }else
                         {
                             [_logs removeAllObjects];
                             [_logs addObjectsFromArray:tmp_logs];
                         }
                     }
                     else
                     {
                         [self showAlert:@"提示" msg:message];
                         [[SlideNavigationController sharedInstance] popViewControllerAnimated:YES];
                     }
                     [_table reloadData];
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [self showAlert:@"提示" msg:@"网络不畅通"];
                 }];
}

-(void)mdHeadOK
{
    [_refreshHAFView mdHeadOK];
}

-(void)mdRefreshTableFootTriggerRefresh:(MDTableViewHAFPullRefresh *)view
{
    //获取域名日志
    [self->api DomainLog:[_selectedDomain objectForKey:@"id"]
                  domain:nil
                  offset:[NSString stringWithFormat:@"%zd", _dataend]
                  length:[NSString stringWithFormat:@"%zd", _datalength]
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     _dataend = _dataend + _datalength;
                     [_refreshHAFView mdFootOK];
                     NSString *message = [[responseObject objectForKey:@"status"] objectForKey:@"message"];
                     
                     if ([[[responseObject objectForKey:@"status"] objectForKey:@"code"] isEqualToString:@"1"]){
                         NSMutableArray * tmp_logs = [responseObject objectForKey:@"log"];
                         if ([tmp_logs[0] isEqual:@"ok"])
                         {
                             [_refreshHAFView mdFootFinish];
                         }else{
                             [_logs addObjectsFromArray:tmp_logs];
                  
                         }
                     }else{
                         [self showAlert:@"提示" msg:message];
                     }
                     [_table reloadData];
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     [self showAlert:@"提示" msg:@"网络不畅通"];
                 }];
}

-(void)pushLogIsShow:(id)res
{
    NSString *count = [[res objectForKey:@"info"] objectForKey:@"count"];
    NSInteger countnum = [count integerValue];
    if (countnum < self.datalength) {
        [_refreshHAFView setLoadFoot:NO];
    }else
    {
        [_refreshHAFView setLoadFoot:YES];
    }
}



@end
