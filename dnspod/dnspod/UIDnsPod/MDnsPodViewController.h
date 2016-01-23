//
//  DnsPodViewController.h
//  dnspod
//
//  Created by midoks on 14/10/20.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MBaseViewController.h"
#import "MDnsPodViewController.h"
#import "MDnsPodRecordViewController.h"


@interface MDnsPodViewController : MBaseViewController
//域名管理
@property (nonatomic, strong) NSDictionary *selectedDomain;

-(void)GetLoadNewData;
@end
