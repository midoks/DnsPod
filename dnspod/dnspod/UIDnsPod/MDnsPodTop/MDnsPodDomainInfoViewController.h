//
//  MDnsPodDomainInfoViewController.h
//  dnspod
//
//  Created by midoks on 15/1/12.
//  Copyright (c) 2015年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBaseViewController.h"

@interface MDnsPodDomainInfoViewController : MBaseViewController

@property (nonatomic, strong) NSDictionary *selectedDomain;

+(MDnsPodDomainInfoViewController *)sharedInstance;
@end
