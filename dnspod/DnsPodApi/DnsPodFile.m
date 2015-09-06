//
//  DnsPodFile.m
//  dnspod
//
//  Created by midoks on 14/10/30.
//  Copyright (c) 2014年 midoks. All rights reserved.
//


#import "DnsPodFile.h"


@implementation DnsPodFile

#pragma mark 初始化
- (id)init
{
    self = [super init];
    if (self) {
        [self openDB];
        [self initUserTable]; //初始化用户表
    }
    return self;
}

#pragma mark
-(void)dealloc
{
    [self closeDB];
}

#pragma mark 获取Documents文件夹中文件路径
- (NSString *)getDocumentsPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsdir = [paths objectAtIndex:0];
    NSString *retpath = [documentsdir stringByAppendingPathComponent:@"dnspod.sqlite"];
    //NSLog(@"%@", retpath);
    return retpath;
}

#pragma mark 打开数据库
- (void) openDB
{
    if (sqlite3_open([[self getDocumentsPath] UTF8String], &db) != SQLITE_OK)
    {
        sqlite3_close(self->db);
        NSAssert(0, @"数据打开失败");
    }
}

#pragma mark 关闭数据库
-(void) closeDB
{
    sqlite3_close(self->db);
}


#pragma mark 无返回查询
- (void)query:(NSString *) vsql
{
    char * err;
    if(sqlite3_exec(db, [vsql UTF8String], nil, nil, &err) != SQLITE_OK)
    {
        NSLog(@"创建资源失败...:%s:%s", sqlite3_errmsg(self->db), err);
    }
}

#pragma mark 初始化用户表
-(void)initUserTable
{
    [self query:@"create table if not exists 'm_user' ('id' integer primary key autoincrement, 'user' text ,'pwd' text, 'main' text);"];
}

#pragma mark 添加用户关键信息(一个)
-(Boolean)AddUser:(NSString *)username password:(NSString *)password isMain:(NSString *)isMain
{
    NSString *_password = [GTMBase64 encodeBase64String:password];
    NSMutableArray *allUser = [self GetUser:username];
    NSInteger allUserNum = [allUser count];
    if (allUserNum>0) {
        //NSLog(@"已经存在");
        return false;
    }else{
        NSString *sql = [NSString stringWithFormat:@"insert into 'm_user'('user', 'pwd', 'main') values('%@', '%@', '%@')",
                     username, _password, isMain];
        [self query:sql];
        return true;
    }
}

#pragma mark 添加多个用户信息(多个)
-(void)AddMUser:(NSString *)username password:(NSString *)password
{
     NSString *_password = [GTMBase64 encodeBase64String:password];
    NSMutableArray *allUser = [self GetUser:username];
    NSInteger allUserNum = [allUser count];
    if (allUserNum>0) {
        NSLog(@"已经存在");
    }else{
        NSString *sql = [NSString stringWithFormat:@"insert or replace into 'm_user'('user', 'pwd') values('%@', '%@')",username, _password];
        [self query:sql];
    }
}


#pragma mark 获取主账号信息
-(id)GetMainUser{
    NSString *sql = [NSString stringWithFormat:@"select id,user,pwd,main from m_user where main=1"];
    return [self GetUserData:sql];
}

#pragma mark 获取所有账户信息
-(id)GetUserList{
    NSString *sql = [NSString stringWithFormat:@"select id,user,pwd,main from m_user;"];
    return [self GetUserData:sql];
}

#pragma mark 获取用户数据
-(id)GetUserData:(NSString *)sql
{
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        NSMutableArray *retTable = [[NSMutableArray alloc] init];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
            char * _id = (char *)sqlite3_column_text(stmt, 0);
            char * _user= (char *)sqlite3_column_text(stmt, 1);
            char * _pwd = (char *)sqlite3_column_text(stmt, 2);
            NSString *_bpwd = [NSString stringWithFormat:@"%s", _pwd];
            _bpwd = [GTMBase64 decodeBase64String:_bpwd];
            
            char *  _main = (char *)sqlite3_column_text(stmt, 3);
            
            [row setValue:[NSString stringWithFormat:@"%s", _id] forKey:@"id"];
            [row setValue:[NSString stringWithFormat:@"%s", _user] forKey:@"user"];
            [row setValue:_bpwd forKey:@"pwd"];
            [row setValue:[NSString stringWithFormat:@"%s", _main] forKey:@"main"];
            //NSLog(@"test, _id:%s, _user:%s, _pwd:%s, _timeout:%s", _id, _user, _pwd, _timeout);
            //[retTable setValue:row forKey:@"id"];
            [retTable addObject:row];
        }
        
        if ([retTable count] > 0)
        {
            return retTable;
        }
    }
    return false;
}

#pragma mark 获取指定用户数据
-(id)GetUser:(NSString *)UserName
{
    NSString *sql = [NSString stringWithFormat:@"select id,user,pwd,main from m_user where user='%@'", UserName];
    return [self GetUserData:sql];
}

#pragma mark 切换为主账户
-(void)SwitchMainUser:(NSString *)mainUser
{
    NSString *sql_update = [NSString stringWithFormat:@"update m_user set main=0"];
    [self query:sql_update];
    NSString *sql_set = [NSString stringWithFormat:@"update m_user set main=1 where user='%@'", mainUser];
    [self query:sql_set];
}

#pragma mark 删除用户(指定用户)
-(void)DeleteUser:(NSString *)UserName
{
    NSString *sql = [NSString stringWithFormat:@"delete from 'm_user' where user='%@'", UserName];
    [self query:sql];
}

#pragma mark 删除用户(通过ID)
-(void)DeleteUserById:(NSString *)userId
{
    NSString *sql = [NSString stringWithFormat:@"delete from 'm_user' where id='%@'", userId];
    [self query:sql];
}

#pragma mark 清空用户(所有用户)
-(void)ClearUser
{
    [self query:@"delete from 'm_user'"];
    [self query:@"update sqlite_sequence set seq=0 where name='m_user'"];
}

#pragma mark 返回用户总数
-(NSInteger)UserCount
{
    //sqlite3_errmsg(db)
    NSInteger r = 0;
    NSString *sql  = [NSString stringWithFormat:@"select count(id) from 'm_user'"];
    sqlite3_stmt *statment;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statment, nil) == SQLITE_OK) {
        while (sqlite3_step(statment) == SQLITE_ROW) {
            char *s = (char *)sqlite3_column_text(statment, 0);
            if (s) {
                r = atoi(s);
            }
        }
    }
    return r;
}

- (void)test
{
    
    //[self query:@"CREATE TABLE IF NOT EXISTS mdnspod (user INTEGER PRIMARY KEY ,pwd TEXT, timeout TEXT);"];
    //[self query:@"create table if not exists 'mdnspods' ('user' text primary key, 'pwd' text, 'timeout' interger);"];
    
    //添加数据
    [self AddUser:@"nihao" password:@"ooo" isMain:@"1"];
    //[self GetUser];
    //NSLog(@"%@", [self GetUser]);
    
    
    NSDate *  senddate=[NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    NSLog(@"时间戳:%@", timeSp);
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYYMMdd"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    NSLog(@"locationString:%@",locationString);
    
    //[self DeleteUser:@"user"];
    
    //[self ClearUser];
    
    //[self query:@"insert or replace into 'm_user' ('id', 'user', 'pwd', 'timeout') values(null, 'd', 'd', '1')"];
    //[self querytest];
    NSLog(@"user count %zd", [self UserCount]);
    //[self query:@"drop table 'mdnspod'"];
    
    //[self query:@"insert into 'mdnspod' ('user', 'pwd') value('d','p')"];
}

@end
