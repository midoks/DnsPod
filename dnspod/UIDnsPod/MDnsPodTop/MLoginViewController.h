//
//  ViewController.h
//  dnspod
//
//  Created by midoks on 14/10/26.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBaseViewController.h"
#import "MDnsPodViewController.h"


@interface MLoginViewController : MBaseViewController <UITextFieldDelegate>

#pragma mark logo
@property (nonatomic, strong) UIImageView *logo;
@property (nonatomic, strong) UITextField *user;
@property (nonatomic, strong) UITextField *pwd;


+(MLoginViewController *)sharedInstance;
@end

