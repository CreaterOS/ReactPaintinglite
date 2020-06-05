//
//  ViewController.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "ViewController.h"
#import "Paintinglite/PaintingliteSessionManager.h"
#import "Mouse.h"
#import "Person.h"
#import "User.h"

@interface ViewController ()
@property (nonatomic,strong)PaintingliteSessionManager *sessionManager;
@end

@implementation ViewController

#pragma mark - 懒加载
- (PaintingliteSessionManager *)sessionManager{
    if (!_sessionManager) {
        _sessionManager = [PaintingliteSessionManager sharePaintingliteSessionManager];
    }
    
    return _sessionManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
     2020.06.04 - 2020.06.07 任务模块
       测试前四个模块功能,修改未知BUG
       进行性能和功能优化
       抽取方法和公有类
       设计多线程
       注意快照和日志的书写(重点)
       增加数据库版本查询等方法
       对数据库的操作 增删改
       对表的操作 增删改查
       -------------------------------
       优化查询效率
       select * from user 中 * 的问题解决
       为多表操作抽取公共方法
     */

    //打开数据库
    [self openDB];
    
    //创建数据表
//    [self createTableSQL];
    
    //更新数据库
//    [self alterTableNameSQL];
//    [self alterTableNameForName];
    [self dropTableForName];
    
    //释放数据库
    //[self releaseDB];
}

#pragma mark - 打开数据库
- (void)openDB{
    [self.sessionManager openSqlite:@"sqlite" completeHandler:^(NSString * _Nonnull filePath, PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"创建数据库成功...");
            NSLog(@"%@",filePath);
        }
    }];

}

#pragma mark - 创建表
#pragma mark - SQL语句
- (void)createTableSQL{
    if([self.sessionManager execTableOptForSQL:@"CREATE TABLE IF NOT EXISTS person(name TEXT,age INTEGER)"]){
        NSLog(@"创建数据库成功...");
    }
}

- (void)createTableSQL_BUG{
//    if([self.sessionManager createTableForSQL:@"DROP TABLE person"]){
//        NSLog(@"创建数据库成功...但是我可以删除");
//    }
}

#pragma mark - 名称创建
- (void)createTableName{
    if([self.sessionManager createTableForName:@"person" content:@"name TEXT,age INTEGER"]){
        NSLog(@"创建数据库成功...");
    }
}

#pragma mark - 根据类来创建
- (void)createTableObj{
    Person *person = [[Person alloc] init];
    if ([self.sessionManager createTableForObj:person createStyle:PaintingliteDataBaseOptionsUUID]) {
        NSLog(@"创建数据库成功...");
    }
}

#pragma mark - 更新表
#pragma mark - SQL语句
- (void)alterTableNameSQL{
    if ([self.sessionManager execTableOptForSQL:@"ALTER TABLE person RENAME TO per"]) {
        NSLog(@"更改数据库成功...");
    }
}

- (void)alterTableAddSQL{
    if ([self.sessionManager execTableOptForSQL:@"ALTER TABLE mouse ADD COLUMN IDCards TEXT"]) {
        NSLog(@"更改数据库成功...");
    }
}

#pragma mark - 名称创建
- (void)alterTableNameForName{
    [self.sessionManager alterTableForName:@"person" newName:@"per" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"更改数据库成功...");
        }
    }];
}

- (void)alterTableADDForName{
    [self.sessionManager alterTableAddColumn:@"person" columnName:@"year" columnType:@"TEXT" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"更改数据库成功...");
        }
    }];
}

#pragma mark - 对象创建
- (void)alterTableForObj{
    Mouse *mouse = [[Mouse alloc] init];
    [self.sessionManager alterTableForObj:mouse completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"更改数据库成功...");
        }
    }];
}

#pragma mark - 删除数据库
- (void)dropTableForSQL{
    if ([self.sessionManager execTableOptForSQL:@"DROP TABLE per"]) {
        NSLog(@"删除数据库成功...");
    }
}

#pragma mark - 根据名称
- (void)dropTableForName{
    [self.sessionManager dropTableForTableName:@"per" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
             NSLog(@"删除数据库成功...");
        }
    }];
}

#pragma mark - 对象删除
- (void)dropTableForObj{
    Person *person = [[Person alloc] init];
    [self.sessionManager dropTableForObj:person completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"删除数据库成功...");
        }
    }];
}

#pragma mark - 释放数据库
- (void)releaseDB{
    [self.sessionManager releaseSqliteCompleteHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"释放数据库成功...");
        }
    }];
}


- (void)test{
    //    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    //    NSString *fileName = [filePath stringByAppendingPathComponent:@"sqlite.db"];
    
//    PaintingliteSessionManager *sessionManager = [PaintingliteSessionManager sharePaintingliteSessionManager];
    
    //    Boolean flag = [sessionManager openSqlite:@"sqlite.db"];
    
    //    NSLog(@"%hhu",flag);
    
//    [sessionManager openSqlite:@"sqlite2.db" completeHandler:^(NSString * _Nonnull filePath, PaintingliteSessionError * _Nonnull error, Boolean success) {
//        if (success) {
//            NSLog(@"%@",filePath);
//            NSLog(@"连接数据库成功...");
//        }else{
//            NSLog(@"%@",[error localizedDescription]);
//        }
//    }];
    
    
    //    NSLog(@"%hhu",[sessionManager releaseSqlite]);
    //
    //    [sessionManager releaseSqliteCompleteHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
    //        if (success) {
    //            NSLog(@"关闭数据库成功...");
    //        }
    //    }];
    //
    //    NSLog(@"%hhu",[sessionManager releaseSqlite]);
    
    //    [sessionManager removeLogFile:@"sqlite"];
    //    NSLog(@"%@",[sessionManager readLogFile:@"sqlite.db"]);
    //    NSLog(@"%@",[sessionManager readLogFile:@"sqlite" dateTime:[NSDate date]]);
    //    NSLog(@"%@",[sessionManager readLogFile:@"sqlites.db"]);
    
    //    NSString *baseStr = [PaintingliteSecurity StringWithSecurityBase64:@"加密操作"];
    //    NSLog(@"%@",baseStr);
    //    NSLog(@"%@",[PaintingliteSecurity StringWithDecodeSecurityBase64:baseStr]);
    
    //    [sessionManager createTableForSQL:@"CREATE TABLE IF NOT EXISTS person(name TEXT,age INTEGER)"];
    //    [sessionManager dropTableForSQL:@"DROP TABLE user"];
    
    //    [sessionManager createTableForSQL:@"CREATE TABLE IF NOT EXISTS user(name TEXT,age INTEGER)" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
    //        if (success) {
    //            NSLog(@"创建表成功");
    //        }
    //    }];
    //
    //    [sessionManager dropTableForSQL:@"DROP TABLE teacher" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
    //        if (success) {
    //            NSLog(@"%@",@"删除表成功");
    //        }
    //    }];
    //
    //    [sessionManager createTableForSQL:@"CREATE TABLE IF NOT EXISTS person(phone TEXT)" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
    //        if (success) {
    //            NSLog(@"创建表成功");
    //        }
    //    }];
    //
    //
    //    NSLog(@"%@",[sessionManager readLogFile:@"sqlite" logStatus:PaintingliteLogSuccess]);
    //    NSLog(@"%@",[sessionManager readLogFile:@"sqlite" logStatus:PaintingliteLogError]);
    
    //    NSError *error = nil;
    //    NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:[PaintingliteSecurity SecurityDecodeBase64:[NSData dataWithContentsOfFile:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Tables_Snap.json"]]] options:NSJSONReadingAllowFragments error:&error][@"TablesSnap"]);
    
    //    [sessionManager createTableForName:@"dogs" content:@"id INTEGER" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
    //        if (success) {
    //            NSLog(@"person表创建成功...");
    //        }
    //    }];
    
    //    [sessionManager dropTableForTableName:@"user" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
    //        if (success) {
    //            NSLog(@"user表删除成功...");
    //        }
    //    }];
    
    //    [sessionManager dropTableForTableName:@"dog"];
    
    //    Person *person = [[Person alloc] init];
    //
    //    [sessionManager createTableForObj:person
    //                      createStyle:PaintingliteDataBaseOptionsUUID completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
    //        if (success) {
    //            NSLog(@"dog表创建成功...");
    //        }
    //    }];
    //
    //    Person *person = [[Person alloc] init];
    //
    //    [sessionManager dropTableForObj:person completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
    //        if (success) {
    //            NSLog(@"dogs表删除成功...");
    //        }
    //    }];
    
    //    [sessionManager alterTableForSQL:@"ALTER TABLE teacher RENAME TO teachers" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
    //        if (success) {
    //            NSLog(@"teacher表重新命名成功...");
    //        }
    //    }];
    
    //    [sessionManager alterTableForSQL:@"ALTER TABLE teachers ADD COLUMN year TEXT"];
    
    //    [sessionManager alterTableForName:@"teachers" newName:@"teacher" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
    //        if (success) {
    //            NSLog(@"teachers表重新命名成功...");
    //        }
    //    }];
    
    //    [sessionManager alterTableAddColumn:@"teachers" columnName:@"phone" columnType:@"TEXT"];
    //
    //    Person *person = [[Person alloc] init];
    //    [sessionManager alterTableForObj:person completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
    //        if (success) {
    //            NSLog(@"person更新成功...");
    //        }
    //    }];
    
    //    Elephant *ele = [[Elephant alloc] init];
    //    [sessionManager dropTableForObj:ele];
    //    [sessionManager createTableForObj:ele createStyle:PaintingliteDataBaseOptionsUUID completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
    //        if (success) {
    //            NSLog(@"ele创建成功...");
    //        }
    //    }];
    
    
    //    [sessionManager execQuerySQL:@"SELECT * FROM user" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
    //        if (success) {
    //            for (NSDictionary *dict in resArray) {
    //                NSLog(@"name = %@ age = %@ --- %@",dict[@"name"],dict[@"age"],[dict[@"age"] class]);
    //            }
    //        }
    //    }];
    
    //    NSMutableArray *arr = [NSMutableArray array];
    //    User *user1 = [[User alloc] init];
    //    user1.name = @"CreaterOS";
    //    [arr addObject:user1];
    //    User *user2 = [[User alloc] init];
    //    user2.name = @"adsf";
    //    [arr addObject:user2];
    //    User *user3 = [[User alloc] init];
    //    user3.name = @"ddd";
    //    [arr addObject:user3];
    //
    //    for (User *user in arr) {
    //        NSLog(@"%@ %p",user.name,user);
    //    }
    
    //    NSMutableArray *arr = [NSMutableArray array];
    //    User *user = [[User alloc] init];
    //    user.name = @"CreaterOS";
    //    [arr addObject:user];
    //    user.name = @"adsf";
    //    [arr addObject:user];
    //    user.name = @"ddd";
    //    [arr addObject:user];
    //
    //    for (User *user in arr) {
    //        NSLog(@"%@ %p",user.name,user);
    //    }
    
    //    User *user = [[User alloc] init];
    //    [sessionManager execQuerySQL:@"SELECT * FROM user" obj:user completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> *  _Nonnull resObjList) {
    //        if (success) {
    //            for (User *user in resObjList) {
    //                NSLog(@"user.name = %@ user.age = %zd user.tempStr = %@ user.tempStr1 = %@ user.tempStr2 = %@ user.tempStr3 = %@",user.name,[user.age integerValue],user.tempStr,user.tempStr1,user.tempStr2,user.tempStr3);
    //            }
    //        }
    //    }];
    
    //    NSLog(@"%@",[sessionManager execQuerySQL:@"SELECT * FROM user WHERE name = 'asdf'"]);
    //    [sessionManager execQuerySQLPrepareStatementSql:@"SELECT * FROM user WHERE name = ? and age = ?"];
    //    [sessionManager setPrepareStatementSqlParameter:0 paramter:@"asdf"];
    //    [sessionManager setPrepareStatementSqlParameter:1 paramter:@"21"];
    //    [sessionManager execPrepareStatementSqlCompleteHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
    //        if (success) {
    //            NSLog(@"%@",resArray);
    //        }
    //    }];
    //
    //    User *user = [[User alloc] init];
    //    [sessionManager execQuerySQLPrepareStatementSql:@"SELECT * FROM user WHERE name = ? and age = ?"];
    //    [sessionManager setPrepareStatementSqlParameter:0 paramter:@"asdf"];
    //    [sessionManager setPrepareStatementSqlParameter:1 paramter:@"21"];
    //
    //    [sessionManager execPrepareStatementSqlWithObj:user completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
    //        if (success) {
    //            for (User *user in resObjList) {
    //                NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //            }
    //        }
    //    }];
    
    //    User *user = [[User alloc] init];
    //    [sessionManager execQuerySQLPrepareStatementSql:@"SELECT * FROM user WHERE name = ? and age = ?"];
    //    [sessionManager setPrepareStatementSqlParameter:@[@"asdf",@"21"]];
    //
    //    [sessionManager execPrepareStatementSqlWithObj:user completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
    //        if (success) {
    //            for (User *user in resObjList) {
    //                NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //            }
    //        }
    //    }];
    //
    //    NSLog(@"%@",[sessionManager execLikeQuerySQLWithTableName:@"user" field:@"name" like:@"%a%"]);
    //
    //    [sessionManager execLikeQuerySQLWithTableName:@"user" field:@"name" like:@"%a%" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
    //        if (success) {
    //            NSLog(@"%@",resArray);
    //        }
    //    }];
    
    //    User *user = [[User alloc] init];
    //    [sessionManager execLikeQuerySQLWithField:@"name" like:@"%a%" obj:user completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
    //        if (success) {
    //            for (User *user in resObjList) {
    //                NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //            }
    //        }
    //    }];
    //
    //    [sessionManager execLimitQuerySQLWithTableName:@"user" limitStart:0 limitEnd:2 completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
    //        if (success) {
    //            NSLog(@"%@",resArray);
    //        }
    //    }];
    
    //    User *user = [[User alloc] init];
    //    [sessionManager execLimitQuerySQLWithLimitStart:0 limitEnd:2 obj:user completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
    //        if (success) {
    //            for (User *user in resObjList) {
    //                NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //            }
    //        }
    //    }];
    //
    //    [sessionManager execOrderByQuerySQLWithTableName:@"user" orderbyContext:@"age" orderStyle:PaintingliteOrderByASC completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
    //        if (success) {
    //            NSLog(@"%@",resArray);
    //        }
    //    }];
    //
    //    [sessionManager execOrderByQuerySQLWithTableName:@"user" orderbyContext:@"age" orderStyle:PaintingliteOrderByDESC completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray) {
    //        if (success) {
    //            NSLog(@"%@",resArray);
    //        }
    //    }];
    //
    //    User *user = [[User alloc] init];
    //    [sessionManager execOrderByQuerySQLWithOrderbyContext:@"name" orderStyle:PaintingliteOrderByDESC obj:user completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
    //        if (success) {
    //            for (User *user in resObjList) {
    //                NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //            }
    //        }
    //    }];
    
    //    [sessionManager execQueryPQL:@"FROM user" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
    //        if (success) {
    //            for (User *user in resObjList) {
    //                NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //            }
    //        }
    //    }];
    
    //    [sessionManager execQueryPQLPrepareStatementPQL:@"FROM user WHERE name = ? AND age = ?"];
    ////    [sessionManager setPrepareStatementPQLParameter:0 paramter:@"asdf"];
    ////    [sessionManager setPrepareStatementPQLParameter:1 paramter:@"21"];
    //    [sessionManager setPrepareStatementPQLParameter:@[@"asdf",@"21"]];
    //    for (User *user in [sessionManager execPrepareStatementPQL]) {
    //        NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //    }
    
    
    //    [sessionManager execLikeQueryPQL:@"FROM user WHERE name LIKE '%a%'" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
    //        if (success) {
    //            for (User *user in resObjList) {
    //                NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //            }
    //        }
    //    }];
    
    //    [sessionManager execLimitQueryPQL:@"FROM user LIMIT 1,1" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
    //        if (success) {
    //            for (User *user in resObjList) {
    //                NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //            }
    //        }
    //    }];
    
    //    [sessionManager execOrderQueryPQL:@"FROM user ORDER BY name DESC" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
    //        if (success) {
    //            for (User *user in resObjList) {
    //                NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //            }
    //        }
    //    }];
    
    //    [sessionManager execPQL:@"FROM user" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
    //        if (success) {
    //            for (User *user in resObjList) {
    //                NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //            }
    //        }
    //    }];
    //    Person *person = [[Person alloc] init];
    //    User *user = [[User alloc] init];
    //    PaintingliteIntellegenceSelect *select = [PaintingliteIntellegenceSelect sharePaintingliteIntellegenceSelect];
    
    //    [select load:[sessionManager getSqlite3] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull loadArray) {
    //        if (success) {
    //            NSLog(@"%@",loadArray);
    //            for (User *user in loadArray[0]) {
    //                NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //            }
    //        }
    //    } objects:user,user, nil];
    
    //    [select limit:[sessionManager getSqlite3] start:0 end:2 completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull limitArray) {
    //        if (success) {
    //            for (User *user in limitArray[0]) {
    //                NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //            }
    //        }
    //    } objects:person,user, nil];
    //    [select limit:[sessionManager getSqlite3] startAndEnd:@[@[[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:1]],@[[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:2]],@[[NSNumber numberWithInteger:0],[NSNumber numberWithInteger:1]]] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull limitArray) {
    //        if (success) {
    //            for (User *user in limitArray[0]) {
    //                NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //            }
    //        }
    //    } objects:person,user, nil];
    
    //    [select orderBy:[sessionManager getSqlite3] orderStyle:PaintingliteOrderByDESC condation:@[@"name",@"age",@"name"] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull orderArray) {
    //        if (success) {
    //            for (User *user in orderArray[0]) {
    //                NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //            }
    //        }
    //    } objects:person,user, nil];
    
    
    //    [select orderBy:[sessionManager getSqlite3] orderStyleArray:@[@"ASC",@"DESC"] condation:@[@"name",@"age",@"name"] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull orderArray) {
    //        if (success) {
    //            for (User *user in orderArray[0]) {
    //                NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //            }
    //        }
    //    } objects:person,user, nil];
    
    //    [select query:[sessionManager getSqlite3] sql:@[@"SELECT * FROM person",@"SELECT * FROM user"] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull orderArray) {
    //        if (success) {
    //            for (User *user in orderArray[0]) {
    //                NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //            }
    //        }
    //    } objects:person,user, nil];
    
    //    for (User *user in [sessionManager execQueryPQL:@"From user"]){
    //        NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //    }
    
    //    for (User *user in [sessionManager execLikeQueryPQL:@"FROM user WHERE name LIKE '%a%'"]){
    //        NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //    }
    
    //    for (User *user in [sessionManager execLimitQueryPQL:@"FROM user LIMIT 0,2"]){
    //        NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //    }
    
    //    for (User *user in [sessionManager execOrderQueryPQL:@"FROM user ORDER BY name DESC"]){
    //        NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
    //    }
    
    //    [sessionManager insert:@"INSERT INTO user(name,age) VALUES('hongyan',22),('haodong',22),('createros',21)" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<id> * _Nonnull newList) {
    //        if (success) {
    //            NSLog(@"%@",newList);
    //        }
    //    }];
    
//    User *user = [[User alloc] init];
//    user.name = @"sadf";
    //    user.age = [NSNumber numberWithInteger:21];
    //    user.name = @"ReynBryant";
    //    user.age = [NSNumber numberWithInteger:21];
    
    //    [sessionManager createTableForSQL:@"CREATE TABLE user(name TEXT,age INTEGER)"];
    //    NSLog(@"%d",[sessionManager insertWithObj:user completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<id> * _Nonnull newList) {
    //        if (success) {
    //            NSLog(@"%@",newList);
    //        }
    //    }] == true);
    //    [sessionManager insertWithObj:user completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<id> * _Nonnull newList) {
    //        if (success) {
    //            NSLog(@"%@",newList);
    //        }
    //    }];
    
    //    [sessionManager update:@"UPDATE user SET age = 21 where age=20 " completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<id> * _Nonnull newList) {
    //        if (success) {
    //            NSLog(@"%@",newList);
    //        }
    //    }];
    
    //    [sessionManager updateWithObj:user condition:@"age = 21" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<id> * _Nonnull newList) {
    //        if (success) {
    //            NSLog(@"%@",newList);
    //        }
    //    }];
    
//    [sessionManager del:@"DELETE FROM user WHERE age = 21" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<id> * _Nonnull newList) {
//        if (success) {
//            NSLog(@"%@",newList);
//        }
//    }];
}

@end
