//
//  MDnsRecordAddViewController.h
//  dnspod
//
//  Created by midoks on 14/12/12.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MBaseViewController.h"
//#import "MDnsPodRecordViewController.h"
@class MDnsPodRecordViewController;

@interface MDnsPodRecordAddViewController : MBaseViewController
@property (nonatomic, strong) NSMutableDictionary *data;
@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) MDnsPodRecordViewController *pvc;


@property (nonatomic, strong) NSDictionary *selectedDomain;
@property (nonatomic, strong) NSDictionary *selectedRecord;


@end



#define MDRECORDNAME        @"主机记录"
#define MDRECORDVALUE       @"记录值"
#define MDRECORDTYPE        @"记录类型"
#define MDRECORDLINETYPE    @"线路类型"
#define MDRECORDMX          @"MX优先级"
#define MDRECORDTLL         @"TLL"
