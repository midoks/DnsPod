//
//  DnsPodRecordViewController.h
//  dnspod
//
//  Created by midoks on 14/11/30.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import "MBaseViewController.h"
#import "MDnsPodRecordAddViewController.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"

typedef struct _currentSelectedCell {
__unsafe_unretained  MGSwipeTableCell *cell;
__unsafe_unretained  NSString *selectedId;
    NSInteger index;
} currentSelectedCell;

NS_INLINE currentSelectedCell NSSelectedCell(MGSwipeTableCell *cell, NSInteger index, NSString *selectedId) {
    currentSelectedCell r;
    r.cell = cell;
    r.index = index;
    r.selectedId = selectedId;
    return r;
}

@interface MDnsPodRecordViewController : MBaseViewController

#pragma mark 当前的域名
@property (nonatomic, strong) NSDictionary *selectedDomain;
//记录数组的信息
@property (nonatomic, strong) NSMutableArray *records;
//记录当前选的记录
@property (nonatomic, strong) NSDictionary *selectedRecord;
//当前记录选择
@property currentSelectedCell selectedCell;
//UITabView
@property (nonatomic, strong) UITableView *table;


#pragma mark 重新获取数据,并刷新表
-(void)GetLoadNewData;
@end


