//
//  MCommon.m
//  dnspod
//
//  Created by midoks on 15/11/17.
//  Copyright © 2015年 midoks. All rights reserved.
//

#import "MCommon.h"
#import <LocalAuthentication/LAContext.h>

@implementation MCommon

#pragma mark - 异步任务 -
+(void)asynTask:(void (^)())task
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            task();
        });
    });
}

#pragma mark - 获取TouchID值 -
+(BOOL)getTouchIdValue
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL v = [userDefaults boolForKey:@"touchIdValue"];
    return v;
}

#pragma mark - 设置TouchID值 -
+(void) setTouchIdValue:(BOOL)b{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:b forKey:@"touchIdValue"];
    [userDefaults synchronize];
}

#pragma mark - touchID验证 -
+(void) touchConfirm:(NSString *)title success:(void (^)(BOOL success))block_success fail:(void (^)())fail
{
    LAContext *mContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *mReasonString = title;
    
    if ([mContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        
        [mContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                 localizedReason:mReasonString
                           reply:^(BOOL success, NSError * _Nullable error) {
                               block_success(success);
                           }];
    }else{
        fail();
    }
}

@end
