//
//  ViewController.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/5/26.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "ViewController.h"
#import "Paintinglite/PaintingliteSessionManager.h"
#import "Paintinglite/PaintingliteSecurity.h"
#import "Paintinglite/PaintingliteDataBaseOptions.h"
#import "Paintinglite/PaintingliteIntellegenceSelect.h"
#import "Dogs.h"
#import "Mouse.h"
#import "Person.h"
#import "Elephant.h"
#import "User.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
//    NSString *fileName = [filePath stringByAppendingPathComponent:@"sqlite.db"];
    
    PaintingliteSessionManager *sessionManager = [PaintingliteSessionManager sharePaintingliteSessionManager];

//    Boolean flag = [sessionManager openSqlite:@"sqlite.db"];
    
//    NSLog(@"%hhu",flag);
    
    [sessionManager openSqlite:@"sqlite2.db" completeHandler:^(NSString * _Nonnull filePath, PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"%@",filePath);
            NSLog(@"连接数据库成功...");
        }else{
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
    
   
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
    Person *person = [[Person alloc] init];
    User *user = [[User alloc] init];
    PaintingliteIntellegenceSelect *select = [PaintingliteIntellegenceSelect sharePaintingliteIntellegenceSelect];
    
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
    
    [select query:[sessionManager getSqlite3] sql:@[@"SELECT * FROM person",@"SELECT * FROM user"] completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull orderArray) {
        if (success) {
            for (User *user in orderArray[0]) {
                NSLog(@"user.name = %@ user.age = %@",user.name,user.age);
            }
        }
    } objects:person,user, nil];
    
}


@end
