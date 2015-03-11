//
//  MDnsPodRecordAddSelectViewController.h
//  dnspod
//
//  Created by midoks on 14/12/19.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBaseViewController.h"

@interface MDnsPodRecordAddSelectViewController : MBaseViewController

@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) NSString *currentSelected;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UITableView *prevTable;
@property (nonatomic, strong) NSMutableDictionary *data;



+(MDnsPodRecordAddSelectViewController *)sharedInstance;
@end
