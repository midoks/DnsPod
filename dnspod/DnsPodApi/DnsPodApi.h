//
//  DnsPodApi.h
//  dnspod
//
//  Created by midoks on 14/10/25.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "JSONKit.h"

@interface DnsPodApi : NSObject
{
    NSString *_email;
    NSString *_pwd;
    
    //url对象
    AFHTTPRequestOperationManager *_manager;
    //参数
    NSMutableDictionary *_args;
    
}

#pragma mark - 初始化
#pragma mark 初始化账户和密码
- (void) setValue:(NSString *)email  password:(NSString *)pwd;
#pragma mark 获取当前用户名
-(NSString*)getUserName;
#pragma mark 获取当前用户密码
-(NSString*)getUserPwd;
#pragma mark 设置POST参数
- (void) setArgs:(NSString *)key value:(NSString *)value;

#pragma mark DNSPOD API 版本号
-(void) InfoVersion:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - 账户相关

#pragma mark 获取账户信息
- (void) UserDetail:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 修改资料
-(void) UserModify:(id)real_name
              nick:(id)nick
         telephone:(id)telephone
                im:(id)im
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 修改密码
-(void) UserpasswdModify:(id)old_password
            new_password:(id)new_password
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 修改邮箱
-(void) UseremailModify:(id)old_email
              new_email:(id)new_email
               password:(id)password
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 获取手机验证码
-(void) TelephoneverifyCode:(id)telephone
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 获取用户日志
-(void) UserLog:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - 域名相关

#pragma mark 添加新域名
-(void) DomainCreate:(NSString *)domain
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 添加新域名 + 指定域名分组
-(void) DomainCreate:(NSString *)domain
            group_id:(NSString *)group_id
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 添加新域名 + 指定域名分组 + 是否星标域名
-(void) DomainCreate:(NSString *)domain
            group_id:(NSString *)group_id
             is_mark:(NSString *)is_mark
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 获取域名列表
-(void) DomainList:(id)type
            offset:(id)offset
            length:(id)length
          group_id:(id)group_id
           keyword:(id)keyword
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 删除域名
-(void) DomainRemove:(id)domain_id
              domain:(id)domain
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 设置域名状态
-(void) DomainStatus:(id)domain_id
              domain:(id)domain
              status:(id)status
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 获取域名信息
-(void) DomainInfo:(id)domain_id
            domain:(id)domain
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 设置域名日志
-(void) DomainLog:(id)domain_id
            domain:(id)domain
            offset:(id)offset
            length:(id)length
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 设置搜索引擎推送
-(void) DomainSearchenginepush:(id)domain_id
           domain:(id)domain
           status:(id)status
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 添加域名共享
-(void) DomainshareCreate:(id)domain_id
                   domain:(id)domain
                    email:(id)email
                     mode:(id)mode
               sub_domain:(id)sub_domain
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 域名共享列表
-(void) DomainshareList:(id)domain_id
                 domain:(id)domain
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 修改域名共享
-(void) DomainshareModify:(id)domain_id
                   domain:(id)domain
                    email:(id)email
                     mode:(id)mode
           old_sub_domain:(id)old_sub_domain
           new_sub_domain:(id)new_sub_domain
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 删除域名共享
-(void) DomainshareRemove:(id)domain_id
                   domain:(id)domain
                    email:(id)email
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 域名过户
-(void) DomainTransfer:(id)domain_id
                   domain:(id)domain
                    email:(id)email
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 锁定域名
-(void) DomainLock:(id)domain_id
            domain:(id)domain
              days:(id)days
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 锁定状态
-(void) DomainLockstatus:(id)domain_id
                  domain:(id)domain
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 锁定解锁
-(void) DomainUnlock:(id)domain_id
              domain:(id)domain
           lock_code:(id)lock_code
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 域名绑定列表
-(void) DomainaliasList:(id)domain_id
                 domain:(id)domain
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 添加域名绑定
-(void) DomainaliasCreate:(id)domain_id
                   domain:(id)domain
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 删除域名绑定
-(void) DomainaliasRemove:(id)domain_id
                   domain:(id)domain
                 alias_id:(id)alias_id
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - 分组(vip)
#pragma mark 获取域名分组
-(void) DomaingroupList:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 添加域名分组
-(void) DomaingroupCreate:(id)group_name
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 修改域名分组
-(void) DomaingroupModify:(id)group_id
               group_name:(id)group_name
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 删除域名分组
-(void) DomaingroupRemove:(id)group_id
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 设置域名分组
-(void) DomainChangegroup:(id)domain_id
                   domain:(id)domain
                 group_id:(id)group_id
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - 设置域名标记及其他
#pragma mark 设置域名星标
-(void) DomainIsmark:(id)domain_id
              domain:(id)domain
             is_mark:(id)is_mark
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 设置域名备注
-(void) DomainRemark:(id)domain_id
              domain:(id)domain
              remark:(id)remark
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 获取域名权限
-(void) DomainPurview:(id)domain_id
              domain:(id)domain
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 域名取回获取邮箱列表
-(void) DomainAcquire:(id)domain
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 域名取回发送验证码
-(void) DomainAcquiresend:(id)domain
                    email:(id)email
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 验证域名取回的验证码
-(void) DomainAcquirevalidate:(id)domain
                        email:(id)email
                         code:(id)code
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 获取等级允许的记录类型
-(void) RecordType:(id)domain_grade
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 获取等级允许的线路线路
-(void) RecordLine:(id)domain_id
            domain:(id)domain
      domain_grade:(id)domain_grade
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - 记录相关
#pragma mark 添加记录
-(void) RecordCreate:(id)domain_id
          sub_domain:(id)sub_domain
               value:(id)value
         record_type:(id)record_type
         record_line:(id)record_line
                  mx:(id)mx
                 ttl:(id)ttl
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 记录列表
-(void) RecordList:(id)domain_id
            offset:(id)offset
            length:(id)length
        sub_domain:(id)sub_domain
           keyword:(id)keyword
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 修改记录
-(void) RecordModify:(id)domain_id
           record_id:(id)record_id
          sub_domain:(id)sub_domain
         record_type:(id)record_type
         record_line:(id)record_line
               value:(id)value
                  mx:(id)mx
                 ttl:(id)ttl
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 删除记录
-(void) RecordRemove:(id)domain_id
           record_id:(id)record_id
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 更新动态DNS记录
-(void) RecordDdns:(id)domain_id
         record_id:(id)record_id
        sub_domain:(id)sub_domain
       record_line:(id)record_line
             value:(id)value
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 设置记录备注
-(void) RecordRemark:(id)domain_id
           record_id:(id)record_id
              remark:(id)remark
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 获取记录信息
-(void) RecordInfo:(id)domain_id
        record_id:(id)record_id
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 设置记录状态
-(void) RecordStatus:(id)domain_id
           record_id:(id)record_id
              status:(id)status
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark - D监控相关
#pragma mark 列出包含A记录的子域名
-(void) MonitorListsubdomain:(id)domain
           domain_id:(id)domain_id
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 列出子域名的A记录
-(void) MonitorListsubvalue:(id)domain
                  domain_id:(id)domain_id
                  subdomain:(id)subdomain
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 监控列表
-(void) MonitorList:(id)domain_id
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 监控添加
-(void) MonitorCreate:(id)domain_id
            record_id:(id)record_id
                 port:(id)port
     monitor_interval:(id)monitor_interval
                 host:(id)host
         monitor_type:(id)monitor_type
               points:(id)points
               bak_ip:(id)bak_ip
             keep_ttl:(id)keep_ttl
           sms_notice:(id)sms_notice
         email_notice:(id)email_notice
          less_notice:(id)less_notice
         callback_url:(id)callback_url
         callback_key:(id)callback_key
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 监控修改
-(void) MonitorModify:(id)monitor_id
                 port:(id)port
     monitor_interval:(id)monitor_interval
         monitor_type:(id)monitor_type
         monitor_path:(id)monitor_path
               points:(id)points
               bak_ip:(id)bak_ip
                 host:(id)host
             keep_ttl:(id)keep_ttl
           sms_notice:(id)sms_notice
         email_notice:(id)email_notice
          less_notice:(id)less_notice
         callback_url:(id)callback_url
         callback_key:(id)callback_key
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 获取监控信息
-(void) MonitorInfo:(id)monitor_id
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 设置监控状态
-(void) MonitorSetstatus:(id)monitor_id
                  status:(id)status
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 获取监控历史
-(void) MonitorGethistory:(id)monitor_id
                    hours:(id)hours
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark 获取监控概况
-(void) MonitorUserdesc:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;




@end
