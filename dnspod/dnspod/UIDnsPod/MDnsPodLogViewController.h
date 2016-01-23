//
//  MDnsPodLogViewController.h
//  dnspod
//
//  Created by midoks on 15/1/2.
//  Copyright (c) 2015年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBaseViewController.h"

@interface MDnsPodLogViewController : MBaseViewController

@property (nonatomic, strong) NSDictionary *selectedDomain;


+(MDnsPodLogViewController *)sharedInstance;
@end
