# Paintinglite

### 安全披露
如果您已找到了Paintinglite安全漏洞和需要修改的漏洞，则应尽快通过电子邮件将其发送至[863713745@qq.com](mailto:863713745@qq.com)。感谢您的支持。

### 安装

**直接通过GitHub下载到本地，将Paintinglite拖到项目中，即可体验Paintinglite。(需要在项目中添加Sqlite3支持的libsqlite3.tbd或libsqlite3.0.tbd)**

## 版本迭代

| Paintinglite版本更新 |      |
| ------------------- | ---- |
| v1.1版本更新概要 | 相对比v1.0优化打开数据库操作和增加了查看数据库文件存在,大小等重要信息 |
| v1.2版本更新概要 | 重新修订了压力测试策略,极大程度上缩减框架大小(<10MB)，增加一级缓存和日志写入策略 |
| v1.3版本更新概要 | 修复了一级缓存导致的对象封装操作漏洞,完善了一集缓存,优化了对表的CREATE,ALTER,DROP操作,增加了线程优化策略 |

## 简介

Paintinglite是一款优秀,快速的Sqlite3数据库框架,Paintinglite对数据具有良好的封装性,快速的插入数据特点,对于庞大的数据量仍能够表现出良好的资源利用率。
Paintinglite支持对象映射,对sqlite3进行了非常轻量级的对象封装,它将POJO与数据库表建立映射关系,Paintinglite既能够自动生成SQL语句,又可以手动写入SQL语句,实现开发便捷和高效查询于一体的轻量级框架。

| Paintinglite功能表                                 |      |
| -------------------------------------------------- | ---- |
| 库基本操作                                         |      |
| 表基本操作                                         |      |
| 封装查询操作                                       |      |
| PQL特性语言查询操作                                |      |
| 高级数据库配置操作                                 |      |
| 智能查询操作(多封装查询)                           |      |
| 聚合查询操作                                       |      |
| 级联操作                                           |      |
| 事务操作                                           |      |
| 安全加密操作                                       |      |
| 拆分大型表操作                                     |      |
| 日志记录操作                                       |      |
| 快照保存操作                                       |      |
| 备份数据库操作(支持MySQL,SQLServer,Sqlite3,Oracle) |      |
| 压力测试操作(支持生成报告)                         |      |


## 核心对象
- PaintingliteSessionManager ： 基本操作管理者(库操作 | 表操作)
- PaintingliteExec ： 执行操作
- PaintingliteBackUpManager ： 数据库备份管理者
- PaintingliteSplitTable ： 拆分操作
- PaintinglitePressureOS ： 压力测试

---
# 数据库操作(PaintingliteSessionManager)
## 1.建库
###### 创建PaintingliteSessionManager,通过管理者创建数据库。

```objective-c
- (Boolean)openSqlite:(NSString *)fileName;

- (Boolean)openSqlite:(NSString *)fileName completeHandler:(void(^ __nullable)(NSString *filePath,PaintingliteSessionError *error,Boolean success))completeHandler;
```
**Paintinglite具有良好的处理机制,通过传入数据库名称进行创建数据库,即使数据库后缀不规范,它仍能创建出.db后缀的数据库。**

```objective-c
[self.sessionM openSqlite:@"sqlite"];
[self.sessionM openSqlite:@"sqlite02.db"];
[self.sessionM openSqlite:@"sqlite03.image"];
[self.sessionM openSqlite:@"sqlite04.text"];
[self.sessionM openSqlite:@"sqlite05.."];
```

**获得创建数据库的绝对路径。**

```objective-c
[self.sessionM openSqlite:@"sqlite" completeHandler:^(NSString * _Nonnull filePath, PaintingliteSessionError * _Nonnull error, Boolean success) {
       if (success) {
           NSLog(@"%@",filePath);
        }
 }];
```

## 2.关闭库

```objective-c
- (Boolean)releaseSqlite;

- (Boolean)releaseSqliteCompleteHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
```

## 3.创建表

```objective-c
- (Boolean)execTableOptForSQL:(NSString *)sql;
- (Boolean)execTableOptForSQL:(NSString *)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content;
- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)createTableForObj:(id)obj createStyle:(PaintingliteDataBaseOptionsCreateStyle)createStyle;
- (Boolean)createTableForObj:(id)obj createStyle:(PaintingliteDataBaseOptionsCreateStyle)createStyle completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
```
创建表的三种方式：
1. SQL创建

```objective-c
[self.sessionM execTableOptForSQL:@"CREATE TABLE IF NOT EXISTS cart(UUID VARCHAR(20) NOT NULL PRIMARY KEY,shoppingName TEXT,shoppingID INT(11))" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"===CREATE TABLE SUCCESS===");
        }
}];
```

2. 表名创建

```objective-c
[self.sessionM createTableForName:@"student" content:@"name TEXT,age INTEGER"];
```

3. 对象创建


```objective-c
User *user = [[User alloc] init];
[self.sessionM createTableForObj:user createStyle:PaintingliteDataBaseOptionsUUID];
```

对象创建可以自动生成主键:

| 主键 | 类型   |
| ---- | ------ |
| UUID | 字符串 |
| ID   | 数值   |


## 4.更新表

```objective-c
- (Boolean)execTableOptForSQL:(NSString *)sql;
- (Boolean)execTableOptForSQL:(NSString *)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (BOOL)alterTableForName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName;
- (BOOL)alterTableForName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (BOOL)alterTableAddColumnWithTableName:(NSString *)tableName columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType;
- (BOOL)alterTableAddColumnWithTableName:(NSString *)tableName columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (BOOL)alterTableForObj:(id)obj;
- (BOOL)alterTableForObj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
```
更新表三种方式:
1. SQL更新

2. 表名更新 [ 表名称 | 表字段 ]

```objective-c
[self.sessionM alterTableForName:@"cart" newName:@"carts"];
[self.sessionM alterTableAddColumnWithTableName:@"carts" columnName:@"newColumn" columnType:@"TEXT"];
```
3. 对象更新
更新User表操作

```objective-c
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User : NSObject

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSNumber *age;
@property (nonatomic,strong)NSMutableArray<id> *mutableArray;

@end

NS_ASSUME_NONNULL_END
```
根据表和对象的映射关系,自动根据对象更新表字段。
```objective-c
User *user = [[User alloc] init];
[self.sessionM alterTableForObj:user];
```

### 5.删除操作

```objective-c
- (Boolean)execTableOptForSQL:(NSString *)sql;
- (Boolean)execTableOptForSQL:(NSString *)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)dropTableForTableName:(NSString *)tableName;
- (Boolean)dropTableForTableName:(NSString *)tableName completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)dropTableForObj:(id)obj;
- (Boolean)dropTableForObj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
```
删除表的三种方法:
1. SQL操作
2. 表名删除

```objective-c
[self.sessionM execTableOptForSQL:@"DROP TABLE carts" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"===DROP TABLE SUCCESS===");
        }
}];
```

3. 对象删除

```objective-c
User *user = [[User alloc] init];
[self.sessionM dropTableForObj:user];
```
# 表操作

### 1.查询
**查询可以提供查询结果用数组封装或者采用对象直接封装的特点。**
1. 普通查询
-    一般查询

```objective-c
- (NSMutableArray *)execQuerySQL:(NSString *__nonnull)sql;
- (Boolean)execQuerySQL:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray))completeHandler;
```

```objective-c
[self.sessionM execQuerySQL:@"SELECT * FROM student" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<NSDictionary *> * _Nonnull resArray) {
        if (success) {
            for (NSDictionary *dict in resArray) {
                NSLog(@"%@",dict);
            }
        }
}];
```
> 2020-06-27 15:35:45.967569+0800 Paintinglite[5805:295051] {
>  age = 21;
>  name = CreaterOS;
> }
> 2020-06-27 15:35:45.967760+0800 Paintinglite[5805:295051] {
>  age = 19;
>  name = Painting;
> }
> 2020-06-27 15:35:45.967879+0800 Paintinglite[5805:295051] {
>  age = 21;
>  name = CreaterOS;
> }

- 封装查询

  封装查询可以将查询结果封装到与表字段相对应的对象中。

```objective-c
- (id)execQuerySQL:(NSString *__nonnull)sql obj:(id)obj;
- (Boolean)execQuerySQL:(NSString *__nonnull)sql obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id> *resObjList))completeHandler;
```

```objective-c
Student *stu = [[Student alloc] init];
[self.sessionM execQuerySQL:@"SELECT * FROM student" obj:stu completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<NSDictionary *> * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
  if (success) {
    for (Student *stu in resObjList) {
      NSLog(@"stu.name = %@ and stu.age = %@",stu.name,stu.age);
    }
  }
}];
```
> 2020-06-27 15:39:27.306786+0800 Paintinglite[5892:302879] stu.name = CreaterOS and stu.age = 21
> 2020-06-27 15:39:27.306961+0800 Paintinglite[5892:302879] stu.name = Painting and stu.age = 19
> 2020-06-27 15:39:27.307110+0800 Paintinglite[5892:302879] stu.name = CreaterOS and stu.age = 21

2. 条件查询

> 条件查询语法规则:
> - 下标从0开始
> - 条件参数使用?作占位符

```sqlite
SELECT * FROM user WHERE name = ? and age = ?
```

```objective-c
- (NSMutableArray<NSDictionary *> *)execPrepareStatementSql;
- (Boolean)execPrepareStatementSqlCompleteHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;
```

```objective-c
[self.sessionM execQuerySQLPrepareStatementSql:@"SELECT * FROM student WHERE name = ?"];
[self.sessionM setPrepareStatementPQLParameter:0 paramter:@"CreaterOS"];
NSLog(@"%@",[self.sessionM execPrepareStatementSql]);
```
> 2020-06-27 15:44:06.664951+0800 Paintinglite[5984:310580] (
>      {
>      age = 21;
>      name = CreaterOS;
>  },
>      {
>      age = 21;
>      name = CreaterOS;
>  }
> )

3. 模糊查询

```objective-c
- (NSMutableArray<NSDictionary *> *)execLikeQuerySQLWithTableName:(NSString *__nonnull)tableName field:(NSString *__nonnull)field like:(NSString *__nonnull)like;
- (Boolean)execLikeQuerySQLWithTableName:(NSString *__nonnull)tableName field:(NSString *__nonnull)field like:(NSString *__nonnull)like completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

- (id)execLikeQuerySQLWithField:(NSString *__nonnull)field like:(NSString *__nonnull)like obj:(id)obj;
- (Boolean)execLikeQuerySQLWithField:(NSString *__nonnull)field like:(NSString *__nonnull)like obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;
```

```objective-c
[self.sessionM execLikeQuerySQLWithTableName:@"student" field:@"name" like:@"%t%" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<NSDictionary *> * _Nonnull resArray) {
        if (success) {
            for (NSDictionary *dict in resArray) {
                NSLog(@"%@",dict);
            }
        }
}];

Student *stu = [[Student alloc] init];
[self.sessionM execLikeQuerySQLWithField:@"name" like:@"%t%" obj:stu completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<NSDictionary *> * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
  if (success) {
    for (NSDictionary *dict in resArray) {
      NSLog(@"%@",dict);
    }
  }
}];
```
> 2020-06-27 15:46:31.310495+0800 Paintinglite[6030:314851] {
>  age = 21;
>  name = CreaterOS;
> }
> 2020-06-27 15:46:31.310701+0800 Paintinglite[6030:314851] {
>  age = 19;
>  name = Painting;
> }
> 2020-06-27 15:46:31.310868+0800 Paintinglite[6030:314851] {
>  age = 21;
>  name = CreaterOS;
> }

4. 分页查询

```objective-c
- (NSMutableArray<NSDictionary *> *)execLimitQuerySQLWithTableName:(NSString *__nonnull)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end;
- (Boolean)execLimitQuerySQLWithTableName:(NSString *__nonnull)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

- (id)execLimitQuerySQLWithLimitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj;
- (Boolean)execLimitQuerySQLWithLimitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;
```

```objective-c
[self.sessionM execLimitQuerySQLWithTableName:@"student" limitStart:0 limitEnd:1 completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<NSDictionary *> * _Nonnull resArray) {
        if (success) {
            for (NSDictionary *dict in resArray) {
                NSLog(@"%@",dict);
            }
        }
}];

Student *stu = [[Student alloc] init];
[self.sessionM execLimitQuerySQLWithLimitStart:0 limitEnd:1 obj:stu completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<NSDictionary *> * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
  if (success) {
    for (Student *stu in resObjList) {
      NSLog(@"stu.name = %@ and stu.age = %@",stu.name,stu.age);
    }
  }
}];
```
> 2020-06-27 15:51:13.026776+0800 Paintinglite[6117:323796] stu.name = CreaterOS and stu.age = 21

5. 排序查询

```objective-c
- (NSMutableArray<NSDictionary *> *)execOrderByQuerySQLWithTableName:(NSString *__nonnull)tableName orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle;
- (Boolean)execOrderByQuerySQLWithTableName:(NSString *__nonnull)tableName orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

- (id)execOrderByQuerySQLWithOrderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj;
- (Boolean)execOrderByQuerySQLWithOrderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;
```
```objective-c
Student *student = [[Student alloc] init];
[self.sessionM execOrderByQuerySQLWithOrderbyContext:@"name" orderStyle:PaintingliteOrderByDESC obj:student completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<NSDictionary *> * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
  if (success) {
    for (Student *stu in resObjList) {
      NSLog(@"stu.name = %@ and stu.age = %@",stu.name,stu.age);
    }
  }
}];
```

> 2020-06-27 15:55:06.714604+0800 Paintinglite[6196:331097] stu.name = Painting and stu.age = 19
> 2020-06-27 15:55:06.714801+0800 Paintinglite[6196:331097] stu.name = CreaterOS and stu.age = 21
> 2020-06-27 15:55:06.714962+0800 Paintinglite[6196:331097] stu.name = CreaterOS and stu.age = 21

### 2.增加数据

```objective-c
- (Boolean)insert:(NSString *__nonnull)sql;
- (Boolean)insert:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)insertWithObj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
```
1. SQL插入
```objective-c
[self.sessionM insert:@"INSERT INTO student(name,age) VALUES('CreaterOS',21),('Painting',19)"];
```
2. 对象插入

```objective-c
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Student : NSObject
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSNumber *age;
@end

NS_ASSUME_NONNULL_END
```

```objective-c
Student *stu = [[Student alloc] init];
stu.name = @"ReynBryant";
stu.age = [NSNumber numberWithInteger:21];
[self.sessionM insertWithObj:stu completeHandler:nil];
```

> 对于庞大数据量,Paintinglit仍能够表现出良好的效率，通过一次性读入1千6百万条数据只耗时6ms-7ms。

### 3.更新数据

```objective-c
- (Boolean)update:(NSString *__nonnull)sql;
- (Boolean)update:(NSString *__nonnull)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)updateWithObj:(id)obj condition:(NSString *__nonnull)condition completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
```
1. SQL更新数据
   
```objective-c
[self.sessionM update:@"UPDATE student SET name = 'Painting' WHERE name = 'ReynBryant'"];
```

2. 对象更新

   ```objective-c
   Student *stu = [[Student alloc] init];
   stu.name = @"CreaterOS";
   [self.sessionM updateWithObj:stu condition:@"age = 21" completeHandler:nil];
   ```

> 增加更新操作,可以通过对象传值方式进行更新
> 例如：
> User *user = [[User alloc] init];
> user.name = @"CreaterOS";
> user.age = 21;

### 4.删除数据

```objective-c
- (Boolean)del:(NSString *__nonnull)sql;
- (Boolean)del:(NSString *__nonnull)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
```
# PQL语法(PaintingliteSessionManager)
通过PQL语句,Paintinglite可以自动帮您完成SQL语句的书写。
> PQL语法规则(大写 | 类名一定要和表关联)
> FROM + 类名称 + [条件]

```objective-c
- (id)execPrepareStatementPQL;
- (Boolean)execPrepareStatementPQLWithCompleteHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

- (void)execQueryPQLPrepareStatementPQL:(NSString *__nonnull)prepareStatementPQL;
- (void)setPrepareStatementPQLParameter:(NSUInteger)index paramter:(NSString *__nonnull)paramter;
- (void)setPrepareStatementPQLParameter:(NSArray *__nonnull)paramter;

- (id)execPQL:(NSString *__nonnull)pql;
- (Boolean)execPQL:(NSString *__nonnull)pql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;
```

```objective-c
[self.sessionM execPQL:@"FROM Student WHERE name = 'CreaterOS'" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if (success) {
            for (Student *stu in resObjList) {
                NSLog(@"stu.name = %@ and stu.age = %@",stu.name,stu.age);
            }
        }
}];
```
> 2020-06-27 16:16:47.145774+0800 Paintinglite[6753:369828] stu.name = CreaterOS and stu.age = 21
> 2020-06-27 16:16:47.145928+0800 Paintinglite[6753:369828] stu.name = CreaterOS and stu.age = 21

```objective-c
[self.sessionM execPQL:@"FROM Student LIMIT 0,1" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if (success) {
            for (Student *stu in resObjList) {
                NSLog(@"stu.name = %@ and stu.age = %@",stu.name,stu.age);
            }
        }
}];
```

```objective-c
[self.sessionM execPQL:@"FROM Student WHERE name LIKE '%t%'" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if (success) {
            for (Student *stu in resObjList) {
                NSLog(@"stu.name = %@ and stu.age = %@",stu.name,stu.age);
            }
        }
}];
```

```objective-c
[self.sessionM execPQL:@"FROM Student ORDER BY name ASC" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if (success) {
            for (Student *stu in resObjList) {
                NSLog(@"stu.name = %@ and stu.age = %@",stu.name,stu.age);
            }
        }
}];

```

```objective-c
[self.sessionM execQueryPQLPrepareStatementPQL:@"FROM Student WHERE name = ?"];
[self.sessionM setPrepareStatementPQLParameter:@[@"CreaterOS"]];
NSLog(@"%@",[self.sessionM execPrepareStatementPQL]);
```

> 2020-06-27 16:26:11.404815+0800 Paintinglite[7025:389268] (
>  "<Student: 0x600000565420>",
>  "<Student: 0x6000005657e0>"
> )

# 聚合函数(PaintingliteAggregateFunc)
Paintinglite封装Sqlite3聚合函数,自动写入SQL语句就可以得到聚合结果。
1. Count
```objective-c
[self.aggreageteF count:[self.sessionM getSqlite3] tableName:@"eletest" completeHandler:^(PaintingliteSessionError * _Nonnull sessionerror, Boolean success, NSUInteger count) {
        if (success) {
            NSLog(@"%zd",count);
        }
 }];
```
2. Max

```objective-c
[self.aggreageteF max:[self.sessionM getSqlite3] field:@"age" tableName:@"eletest" completeHandler:^(PaintingliteSessionError * _Nonnull sessionerror, Boolean success, double max) {
        if (success) {
            NSLog(@"%.2f",max);
        }
}];
```

3. Min

```objective-c
[self.aggreageteF min:[self.sessionM getSqlite3] field:@"age" tableName:@"eletest" completeHandler:^(PaintingliteSessionError * _Nonnull sessionerror, Boolean success, double min) {
        if (success) {
            NSLog(@"%.2f",min);
        }
}];
```
4. Sum

```objective-c
[self.aggreageteF sum:[self.sessionM getSqlite3] field:@"age" tableName:@"eletest" completeHandler:^(PaintingliteSessionError * _Nonnull sessionerror, Boolean success, double sum) {
        if (success) {
            NSLog(@"%.2f",sum);
        }
}];
```
5. Avg

```objective-c
[self.aggreageteF avg:[self.sessionM getSqlite3] field:@"age" tableName:@"eletest" completeHandler:^(PaintingliteSessionError * _Nonnull sessionerror, Boolean success, double avg) {
        if (success) {
            NSLog(@"%.2f",avg);
        }
}];

```

# 事务(PaintingliteTransaction)
Sqlite3开发默认一条插入语句是一个事务,假设有多个插入语句则会重复开起事务,这对资源消耗是巨大的,Paintinglite提供了开起事务的操作(显示事务)。

```objective-c
+ (void)begainPaintingliteTransaction:(sqlite3 *)ppDb;
+ (void)commit:(sqlite3 *)ppDb;
+ (void)rollback:(sqlite3 *)ppDb;
```
> 日常开发结合
>
> @try {
>  } @catch (NSException *exception) {
>  } @finally {
>  }
>
> 使用

# 级联操作(PaintingliteCascadeShowerIUD)

```objective-c
- (Boolean)cascadeInsert:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionError,Boolean success,NSMutableArray *resArray))completeHandler;

- (Boolean)cascadeUpdate:(sqlite3 *)ppDb obj:(id)obj condatation:(NSArray<NSString *> * __nonnull)condatation completeHandler:(void (^__nullable)(PaintingliteSessionError *sessionError,Boolean success,NSMutableArray *resArray))completeHandler;

- (Boolean)cascadeDelete:(sqlite3 *)ppDb obj:(id)obj condatation:(NSArray<NSString *> * __nonnull)condatation completeHandler:(void (^__nullable)(PaintingliteSessionError *sessionError,Boolean success,NSMutableArray *resArray))completeHandler;
```
级联分为三个部分:
1. 插入 
> 级联插入操作,我们需要将两个有关系的表通过可变数组进行连接,例如:
> user表和student表有联系,
> 一个user可以包含多个student

那么,可以在user中设置可变数据保存多个student,然后将user对象交给Paintinglite就可以一次写入多个表的数据。
```objective-c
User *user = [[User alloc] init];
user.name = @"Jay";
user.age = [NSNumber numberWithInteger:40];
user.studentsArray = [NSMutableArray array];

Student *student = [[Student alloc] init];
student.name = @"Hony";
student.age = [NSNumber numberWithInteger:30];

Student *student1 = [[Student alloc] init];
student1.name = @"Jack";
student1.age = [NSNumber numberWithInteger:41];

[user.studentsArray addObject:student];
[user.studentsArray addObject:student1];

[self.cascade cascadeInsert:[self.sessionM getSqlite3] obj:user completeHandler:^(PaintingliteSessionError * _Nonnull sessionError, Boolean success, NSMutableArray * _Nonnull resArray) {
    if (success) {
        NSLog(@"%@",resArray);
    }
}];
```
2. 更新 
    作用和级联插入相同,传入user对象,包含student表的集合,将修改条件以数组方式传入,Paintinglite可以自动实现多表的更新。(条件数组对应的多个表的不同条件)

  > name = 'CreaterOS' 对应user表
  >
  > name = 'OS...' 对应student表

```objective-c
[self.cascade cascadeUpdate:[self.sessionM getSqlite3] obj:user condatation:@[@"WHERE name = 'CreaterOS'",@"WHERE name = 'OS...'"] completeHandler:^(PaintingliteSessionError * _Nonnull sessionError, Boolean success, NSMutableArray * _Nonnull resArray) {
     if (success) {
            NSLog(@"%@",resArray);
     }
 }];
 
```

3. 删除

```objective-c
[self.cascade cascadeDelete:[self.sessionM getSqlite3] obj:user condatation:@[@"name = 'WHY'",@"name = 'YHD...'"] completeHandler:^(PaintingliteSessionError * _Nonnull sessionError, Boolean success, NSMutableArray * _Nonnull resArray) {
       if (success) {
           NSLog(@"%@",resArray);
       }
}];

```

# 日志模式(PaintingliteLog)

Paintinglite为开发者提供了日志记录功能,可以记录开发中对sqlite3数据的关键操作,并且标有时间戳,开发者可以通过数据库名称轻松读取日志,也可以根据需要的时间节点或者成功失败的状态选择性的读取日志。方便了软件上线后的调试。
```objective-c
- (void)readLogFile:(NSString *__nonnull)fileName;

- (void)readLogFile:(NSString *)fileName dateTime:(NSDate *__nonnull)dateTime;

- (void)readLogFile:(NSString *)fileName logStatus:(PaintingliteLogStatus)logStatus;

- (void)removeLogFile:(NSString *)fileName;

```

## 日志模块更新
通过一级缓存分批写入日志文件,建议开发在AppDelegate中实例化PaintingliteCache,在applicationDidEnterBackground:(UIApplication *)application和applicationWillTerminate:(UIApplication *)application中手动调用日志写入方法,则可以将未达到缓存基点的日志及时写入日志文件。
```objective-c
[self.cache pushCacheToLogFile];
```

# 数据库备份(PaintingliteBackUpManager)
数据库迁移是开发人员经常关心的问题,对于sqlite3移植客户端SQL Server MySQL 和 Orcale一直是一个头疼的问题。Paintinglite非常友好的为开发者提供了四种数据库的备份文件,包括从建库到插入数据,Paintinglite为开发者写入了备份文件,开发者只需要上传这些sql文件并运行就可以得到和移动设备完全一样的数据。
```objective-c
PaintingliteBackUpSqlite3,
PaintingliteBackUpMySql,
PaintingliteBackUpSqlServer,
PaintingliteBackUpORCALE
```

```objective-c
- (Boolean)backupDataBaseWithName:(sqlite3 *)ppDb sqliteName:(NSString *)sqliteName type:(PaintingliteBackUpManagerDBType)type completeHandler:(void(^ __nullable)(NSString *saveFilePath))completeHandler;
```

![image-20200627211330562](/Users/bryantreyn/Library/Application Support/typora-user-images/image-20200627211330562.png)

# 拆分表(PaintingliteSplitTable)
对于过大的数据量的表查询耗时操作是巨大的,Paintinglite测试阶段提供了拆分表的操作,将大表拆分成为多个小表,拆分的数额由开发者自己决定。
Paintinglite首次提供拆分表操作,模块尚在测试,后期版本迭代会重点优化这部分的资源消耗和CPU占用率问题。

```objective-c
/**
  * tableName: 数据库名称 
  * basePoint: 拆分个数 
  */
- (Boolean)splitTable:(sqlite3 *)ppDb tabelName:(NSString *__nonnull)tableName basePoint:(NSUInteger)basePoint;
```
1. 查询操作

```objective-c
- (NSMutableArray *)selectWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName basePoint:(NSUInteger)basePoint;
```
2. 插入操作

```objective-c
- (Boolean)insertWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *)tableName basePoint:(NSUInteger)basePoint insertSQL:(NSString *)insertSQL;
```

3. 更新操作

```objective-c
- (Boolean)updateWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *)tableName basePoint:(NSUInteger)basePoint updateSQL:(NSString *)updateSQL;
```

4. 删除操作

```objective-c
- (Boolean)deleteWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *)tableName basePoint:(NSUInteger)basePoint deleteSQL:(NSString *)deleteSQL;

```

# 压力测试(PaintinglitePressureOS)
PaintinglitePressureOS系统是一个压力测试系统,它对于数据库读写消耗时间,资源消耗和内存的使用进行了合理性的评估,并支持生成压力测试报告。(默认不生成报告)

Paintinglite可以根据不同设备进行不同的测算内存消耗状态，让开发者更清楚在不同iPhone上设计更为合理的数据库表结构。
```objective-c
- (Boolean)paintingliteSqlitePressure;
```

# 约束

为了更好的实现操作,符合数据库规范,表名一律小写。

### 为这个项目做贡献

如果您有功能请求或错误报告，请随时发送[863713745@qq.com](mailto:863713745@qq.com)上传问题，我们会第一时间为您提供修订和帮助。也非常感谢您的支持。

### 安全披露

如果您已找到了Paintinglite安全漏洞和需要修改的漏洞，则应尽快通过电子邮件将其发送至[863713745@qq.com](mailto:863713745@qq.com)。感谢您的支持。
