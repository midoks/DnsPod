//
//  MCommon.h
//  dnspod
//
//  Created by midoks on 15/11/17.
//  Copyright © 2015年 midoks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCommon : NSObject

#pragma mark - 异步任务 -
+(void)asynTask:(void (^)())task;

#pragma mark - 获取TouchID值 -
+(BOOL)getTouchIdValue;

#pragma mark - 设置TouchID值 -
+(void) setTouchIdValue:(BOOL)b;

#pragma mark - touchID验证 -
+(void) touchConfirm:(NSString *)title success:(void (^)(BOOL success))success fail:(void (^)())fail;

@end
