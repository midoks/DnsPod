//
//  DnsPodApi.m
//  dnspod
//
//  Created by midoks on 14/10/25.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import "DnsPodApi.h"

@implementation DnsPodApi


    //url对象
// AFHTTPRequestOperationManager *_manager;

#pragma mark - 初始化
#pragma mark init
-(id)init
{
    if(self=[super init])
    {
        //初始化
        self->_manager = [[AFHTTPRequestOperationManager alloc] init];
        //设置格式
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [_manager.requestSerializer setValue:@"DNSPOD DDNS IOS Client/2.0.1(midoks@163.com)" forHTTPHeaderField:@"User-Agent"];
        //[_manager.requestSerializer setValue:@"application/json; charset=utf-8;" forHTTPHeaderField:@"Content-Type"];
        //_manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"utf-8"];
        
        self->_args = [[NSMutableDictionary alloc] init];
        [self setArgs:@"format" value:@"json"];
        [self setArgs:@"lang" value:@"cn"];
        [self setArgs:@"error_on_empty" value:@"yes"];
    }
    return self;
}

#pragma  mark 初始化
-(void)setValue:(NSString *)email password:(NSString *)pwd
{
    self->_email = email;
    self->_pwd = pwd;

//    [self setArgs:@"login_email" value:self->_email];
//    [self setArgs:@"login_password" value:self->_pwd];
}


#pragma  mark 初始化
-(void)setToken:(NSString *)token tid:(NSString *)tid
{
    self->_token = token;
    self->_token_id = tid;
    NSString *newToken = [NSString stringWithFormat:@"%@,%@", tid,token];
    [self setArgs:@"login_token" value:newToken];
}

#pragma mark 获取当前用户名
-(NSString*)getUserName{
    return self->_email;
}

#pragma mark 获取当前用户密码
-(NSString*)getUserPwd{
    return  self->_pwd;
}


#pragma mark 获取当前TokenID
-(NSString*)getTokenID{
    return self->_token_id;
}

#pragma mark 获取当前Token
-(NSString*)getToken{
    return self->_token;
}

#pragma mark 设置POST参数
-(void)setArgs:(NSString *)key value:(NSString *)value
{
    [self->_args setValue:value forKey:key];
}

#pragma mark DNSPOD API 版本号
-(void) InfoVersion:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [_manager POST:@"https://dnsapi.cn/Info.Version"
       parameters:_args
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              success(operation, responseObject);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation, error);
    }];
}

#pragma mark - 账户相关
#pragma mark 获取账户信息
-(void)UserDetail:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    //AFNetWoring
    NSString *newToken = [NSString stringWithFormat:@"%@,%@", self->_token_id, self->_token];
    NSDictionary *parameters = @{@"login_token": newToken,@"format":@"json"};
    [_manager POST:@"https://dnsapi.cn/User.Detail"
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              success(operation, responseObject);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              failure(operation, error);
    }];
}

#pragma mark 修改资料
-(void) UserModify:(id)real_name
              nick:(id)nick
         telephone:(id)telephone
                im:(id)im
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"real_name" value:real_name];
    [self setArgs:@"nick" value:nick];
    [self setArgs:@"telephone" value:telephone];
    [self setArgs:@"im" value:im];
    [_manager POST:@"https://dnsapi.cn/User.Modify"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 修改密码
-(void) UserpasswdModify:(id)old_password
            new_password:(id)new_password
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"old_password" value:old_password];
    [self setArgs:@"new_password" value:new_password];
    [_manager POST:@"https://dnsapi.cn/Userpasswd.Modify"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 修改邮箱
-(void) UseremailModify:(id)old_email
              new_email:(id)new_email
               password:(id)password
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"old_email" value:old_email];
    [self setArgs:@"new_email" value:new_email];
    [self setArgs:@"password" value:password];
    [_manager POST:@"https://dnsapi.cn/Useremail.Modify"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}

#pragma mark 获取手机验证码
-(void) TelephoneverifyCode:(id)telephone
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"telephone" value:telephone];
    [_manager POST:@"https://dnsapi.cn/Telephoneverify.Code"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}

#pragma mark 获取用户日志
-(void) UserLog:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [_manager POST:@"https://dnsapi.cn/User.Log"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}

#pragma mark - 域名相关

#pragma mark 添加新域名
-(void) DomainCreate:(NSString *)domain
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain" value:domain];
    [_manager POST:@"https://dnsapi.cn/Domain.Create"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
    }];
}

#pragma mark 添加新域名 + 指定域名分组
-(void) DomainCreate:(NSString *)domain
            group_id:(NSString *)group_id
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"group_id" value:group_id];
    [self DomainCreate:domain success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

#pragma mark 添加新域名 + 指定域名分组 + 是否星标域名
-(void) DomainCreate:(NSString *)domain
            group_id:(NSString *)group_id
             is_mark:(NSString *)is_mark
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"is_mark" value:is_mark];
    [self DomainCreate:domain group_id:group_id success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation, error);
    }];
}

#pragma mark 获取域名列表
-(void) DomainList:(id)type
            offset:(id)offset
            length:(id)length
          group_id:(id)group_id
           keyword:(id)keyword
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"types" value:type];
    [self setArgs:@"offset" value:offset];
    [self setArgs:@"length" value:length];
    [self setArgs:@"group_id" value:group_id];
    [self setArgs:@"keyword" value:keyword];
    [_manager POST:@"https://dnsapi.cn/Domain.List"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
    }];
}

#pragma mark 删除域名
-(void) DomainRemove:(id)domain_id
              domain:(id)domain
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [_manager POST:@"https://dnsapi.cn/Domain.Remove"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 设置域名状态
-(void) DomainStatus:(id)domain_id
              domain:(id)domain
              status:(id)status
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [self setArgs:@"status" value:status];
    [_manager POST:@"https://dnsapi.cn/Domain.Status"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 获取域名信息
-(void) DomainInfo:(id)domain_id
            domain:(id)domain
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [_manager POST:@"https://dnsapi.cn/Domain.Info"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 获取域名日志
-(void) DomainLog:(id)domain_id
           domain:(id)domain
           offset:(id)offset
           length:(id)length
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [self setArgs:@"offset" value:offset];
    [self setArgs:@"length" value:length];
    [_manager POST:@"https://dnsapi.cn/Domain.Log"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}

#pragma mark 设置搜索引擎推送
-(void) DomainSearchenginepush:(id)domain_id
                        domain:(id)domain
                        status:(id)status
                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [self setArgs:@"status" value:status];
    [_manager POST:@"https://dnsapi.cn/Domain.Searchenginepush"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];

}

#pragma mark 添加域名共享
-(void) DomainshareCreate:(id)domain_id
                   domain:(id)domain
                    email:(id)email
                     mode:(id)mode
               sub_domain:(id)sub_domain
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [self setArgs:@"mode" value:mode];
    [self setArgs:@"sub_domain" value:sub_domain];
    [_manager POST:@"https://dnsapi.cn/Domainshare.Create"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}

#pragma mark 域名共享列表
-(void) DomainshareList:(id)domain_id
                 domain:(id)domain
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [_manager POST:@"https://dnsapi.cn/Domainshare.List"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}

#pragma mark 修改域名共享
-(void) DomainshareModify:(id)domain_id
                   domain:(id)domain
                    email:(id)email
                     mode:(id)mode
           old_sub_domain:(id)old_sub_domain
           new_sub_domain:(id)new_sub_domain
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [self setArgs:@"email" value:email];
    [self setArgs:@"mode" value:mode];
    [self setArgs:@"old_sub_domain" value:old_sub_domain];
    [self setArgs:@"new_sub_domain" value:new_sub_domain];
    [_manager POST:@"https://dnsapi.cn/Domainshare.Modify"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}

#pragma mark 删除域名共享
-(void) DomainshareRemove:(id)domain_id
                   domain:(id)domain
                    email:(id)email
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [self setArgs:@"email" value:email];
    [_manager POST:@"https://dnsapi.cn/Domainshare.Remove"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}

#pragma mark 域名过户
-(void) DomainTransfer:(id)domain_id
                domain:(id)domain
                 email:(id)email
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [self setArgs:@"email" value:email];
    [_manager POST:@"https://dnsapi.cn/Domain.Transfer"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 锁定域名
-(void) DomainLock:(id)domain_id
            domain:(id)domain
              days:(id)days
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [self setArgs:@"days" value:days];
    [_manager POST:@"https://dnsapi.cn/Domain.Lock"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 锁定状态
-(void) DomainLockstatus:(id)domain_id
            domain:(id)domain
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [_manager POST:@"https://dnsapi.cn/Domain.Lockstatus"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 锁定解锁
-(void) DomainUnlock:(id)domain_id
              domain:(id)domain
           lock_code:(id)lock_code
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [self setArgs:@"lock_code" value:lock_code];
    [_manager POST:@"https://dnsapi.cn/Domain.Unlock"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 域名绑定列表
-(void) DomainaliasList:(id)domain_id
                 domain:(id)domain
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [_manager POST:@"https://dnsapi.cn/Domainalias.List"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 添加域名绑定
-(void) DomainaliasCreate:(id)domain_id
                   domain:(id)domain
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [_manager POST:@"https://dnsapi.cn/Domainalias.Create"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 删除域名绑定
-(void) DomainaliasRemove:(id)domain_id
                   domain:(id)domain
                 alias_id:(id)alias_id
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [self setArgs:@"alias_id" value:alias_id];
    [_manager POST:@"https://dnsapi.cn/Domainalias.Remove"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}
#pragma mark - 分组(vip)
#pragma mark 获取域名分组
-(void) DomaingroupList:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [_manager POST:@"https://dnsapi.cn/Domaingroup.List"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 添加域名分组
-(void) DomaingroupCreate:(id)group_name
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"group_name" value:group_name];
    [_manager POST:@"https://dnsapi.cn/Domaingroup.Create"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 修改域名分组
-(void) DomaingroupModify:(id)group_id
               group_name:(id)group_name
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"group_id" value:group_id];
    [self setArgs:@"group_name" value:group_name];
    [_manager POST:@"https://dnsapi.cn/Domaingroup.Create"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 删除域名分组
-(void) DomaingroupRemove:(id)group_id
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"group_id" value:group_id];
    [_manager POST:@"https://dnsapi.cn/Domaingroup.Remove"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 设置域名分组
-(void) DomainChangegroup:(id)domain_id
                   domain:(id)domain
                 group_id:(id)group_id
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [self setArgs:@"group_id" value:group_id];
    [_manager POST:@"https://dnsapi.cn/Domain.Changegroup"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark - 设置域名标记及其他
#pragma mark 设置域名星标
-(void) DomainIsmark:(id)domain_id
              domain:(id)domain
             is_mark:(id)is_mark
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [self setArgs:@"is_mark" value:is_mark];
    [_manager POST:@"https://dnsapi.cn/Domain.Ismark"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 设置域名备注
-(void) DomainRemark:(id)domain_id
              domain:(id)domain
              remark:(id)remark
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [self setArgs:@"remark" value:remark];
    [_manager POST:@"https://dnsapi.cn/Domain.Remark"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 获取域名权限
-(void) DomainPurview:(id)domain_id
               domain:(id)domain
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [_manager POST:@"https://dnsapi.cn/Domain.Purview"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 域名取回获取邮箱列表
-(void) DomainAcquire:(id)domain
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain" value:domain];
    [_manager POST:@"https://dnsapi.cn/Domain.Acquire"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 域名取回发送验证码
-(void) DomainAcquiresend:(id)domain
                    email:(id)email
                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain" value:domain];
    [self setArgs:@"email" value:email];
    [_manager POST:@"https://dnsapi.cn/Domain.Acquiresend"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 验证域名取回的验证码
-(void) DomainAcquirevalidate:(id)domain
                        email:(id)email
                         code:(id)code
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain" value:domain];
    [self setArgs:@"email" value:email];
    [self setArgs:@"code" value:code];
    [_manager POST:@"https://dnsapi.cn/Domain.Acquirevalidate"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 获取等级允许的记录类型
-(void) RecordType:(id)domain_grade
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_grade" value:domain_grade];
    [_manager POST:@"https://dnsapi.cn/Record.Type"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
    
}

#pragma mark 获取等级允许的线路线路
-(void) RecordLine:(id)domain_id
            domain:(id)domain
      domain_grade:(id)domain_grade
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"domain" value:domain];
    [self setArgs:@"domain_grade" value:domain_grade];
    [_manager POST:@"https://dnsapi.cn/Record.Line"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

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
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"sub_domain" value:sub_domain];
    [self setArgs:@"value" value:value];
    [self setArgs:@"record_type" value:record_type];
    [self setArgs:@"record_line" value:record_line];
    [self setArgs:@"mx" value:mx];
    [self setArgs:@"ttl" value:ttl];
    [_manager POST:@"https://dnsapi.cn/Record.Create"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

-(void) RecordList:(id)domain_id
            offset:(id)offset
            length:(id)length
        sub_domain:(id)sub_domain
           keyword:(id)keyword
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"offset" value:offset];
    [self setArgs:@"length" value:length];
    [self setArgs:@"sub_domain" value:sub_domain];
    [self setArgs:@"keyword" value:keyword];
    [_manager POST:@"https://dnsapi.cn/Record.List"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

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
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"record_id" value:record_id];
    [self setArgs:@"sub_domain" value:sub_domain];
    [self setArgs:@"record_type" value:record_type];
    [self setArgs:@"record_line" value:record_line];
    [self setArgs:@"value" value:value];
    [self setArgs:@"mx" value:mx];
    [self setArgs:@"ttl" value:ttl];
    [_manager POST:@"https://dnsapi.cn/Record.Modify"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 删除记录
-(void) RecordRemove:(id)domain_id
           record_id:(id)record_id
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"record_id" value:record_id];
    [_manager POST:@"https://dnsapi.cn/Record.Remove"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}


#pragma mark 更新动态DNS记录
-(void) RecordDdns:(id)domain_id
         record_id:(id)record_id
        sub_domain:(id)sub_domain
       record_line:(id)record_line
             value:(id)value
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"record_id" value:record_id];
    [self setArgs:@"sub_domain" value:sub_domain];
    [self setArgs:@"record_line" value:record_line];
    [self setArgs:@"value" value:value];
    [_manager POST:@"https://dnsapi.cn/Record.Ddns"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 设置记录备注
-(void) RecordRemark:(id)domain_id
           record_id:(id)record_id
              remark:(id)remark
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"record_id" value:record_id];
    [self setArgs:@"remark" value:remark];
    [_manager POST:@"https://dnsapi.cn/Record.Remark"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 获取记录信息
-(void) RecordInfo:(id)domain_id
         record_id:(id)record_id
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"record_id" value:record_id];
    [_manager POST:@"https://dnsapi.cn/Record.Info"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}

#pragma mark 设置记录状态
-(void) RecordStatus:(id)domain_id
           record_id:(id)record_id
              status:(id)status
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"record_id" value:record_id];
    [self setArgs:@"status" value:status];
    [_manager POST:@"https://dnsapi.cn/Record.Status"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark - D监控相关
#pragma mark 列出包含A记录的子域名
-(void) MonitorListsubdomain:(id)domain
                   domain_id:(id)domain_id
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain" value:domain];
    [self setArgs:@"domain_id" value:domain_id];
    [_manager POST:@"https://dnsapi.cn/Monitor.Listsubdomain"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
    ];
}

#pragma mark 列出子域名的A记录
-(void) MonitorListsubvalue:(id)domain
                  domain_id:(id)domain_id
                  subdomain:(id)subdomain
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain" value:domain];
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"subdomain" value:subdomain];
    [_manager POST:@"https://dnsapi.cn/Monitor.Listsubvalue"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}

#pragma mark 监控列表
-(void) MonitorList:(id)domain_id
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:domain_id value:@"domain_id"];
    [_manager POST:@"https://dnsapi.cn/Monitor.List"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}

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
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"domain_id" value:domain_id];
    [self setArgs:@"record_id" value:record_id];
    [self setArgs:@"port" value:port];
    [self setArgs:@"monitor_interval" value:monitor_interval];
    [self setArgs:@"host" value:host];
    [self setArgs:@"monitor_type" value:monitor_type];
    [self setArgs:@"points" value:points];
    [self setArgs:@"bak_ip" value:bak_ip];
    [self setArgs:@"keep_ttl" value:keep_ttl];
    [self setArgs:@"sms_notice" value:sms_notice];
    [self setArgs:@"email_notice" value:email_notice];
    [self setArgs:@"less_notice" value:less_notice];
    [self setArgs:@"callback_url" value:callback_url];
    [self setArgs:@"callback_key" value:callback_key];
    [_manager POST:@"https://dnsapi.cn/Monitor.Create"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}

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
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"monitor_id" value:monitor_id];
    [self setArgs:@"port" value:port];
    [self setArgs:@"monitor_interval" value:monitor_interval];
    [self setArgs:@"monitor_type" value:monitor_type];
    [self setArgs:@"monitor_path" value:monitor_path];
    [self setArgs:@"points" value:points];
    [self setArgs:@"bak_ip" value:bak_ip];
    [self setArgs:@"host" value:host];
    [self setArgs:@"keep_ttl" value:keep_ttl];
    [self setArgs:@"sms_notice" value:sms_notice];
    [self setArgs:@"email_notice" value:email_notice];
    [self setArgs:@"less_notice" value:less_notice];
    [self setArgs:@"callback_url" value:callback_url];
    [self setArgs:@"callback_key" value:callback_key];
    [_manager POST:@"https://dnsapi.cn/Monitor.Modify"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}

#pragma mark 监控删除
-(void) MonitorRemove:(id)monitor_id
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"monitor_id" value:monitor_id];
    [_manager POST:@"https://dnsapi.cn/Monitor.Remove"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}

#pragma mark 获取监控信息
-(void) MonitorInfo:(id)monitor_id
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"monitor_id" value:monitor_id];
    [_manager POST:@"https://dnsapi.cn/Monitor.Info"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}

#pragma mark 设置监控状态
-(void) MonitorSetstatus:(id)monitor_id
                  status:(id)status
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"monitor_id" value:monitor_id];
    [self setArgs:@"status" value:status];
    [_manager POST:@"https://dnsapi.cn/Monitor.Setstatus"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}

#pragma mark 获取监控历史
-(void) MonitorGethistory:(id)monitor_id
                  hours:(id)hours
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"monitor_id" value:monitor_id];
    [self setArgs:@"hours" value:hours];
    [_manager POST:@"https://dnsapi.cn/Monitor.Gethistory"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}

#pragma mark 获取监控概况
-(void) MonitorUserdesc:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [_manager POST:@"https://dnsapi.cn/Monitor.Userdesc"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}

#pragma mark 获取监控概况
-(void) MonitorGetdowns:(id)offset
                 length:(id)length
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self setArgs:@"offset" value:offset];
    [self setArgs:@"length" value:length];
    [_manager POST:@"https://dnsapi.cn/Monitor.Getdowns"
        parameters:_args
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               success(operation, responseObject);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               failure(operation, error);
           }
     ];
}


@end
