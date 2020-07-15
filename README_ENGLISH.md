# Paintinglite

### Installation

**Download directly to the local through GitHub, drag Paintinglite to the project, you can experience Paintinglite. (Need to add libsqlite3.tbd or libsqlite3.0.tbd supported by Sqlite3 in the project)**

## Introduction

Paintinglite is an excellent and fast Sqlite3 database framework. Paintinglite has good encapsulation of data and fast data insertion characteristics. It can still show good resource utilization for huge data volume. Paintinglite supports object mapping and implements a very lightweight object encapsulation for sqlite3. It establishes a mapping relationship between POJO and database tables. Paintinglite can not only automatically generate SQL statements, but also manually write SQL statements to achieve convenient and efficient development. One-piece lightweight frame.

|                  Paintinglite Function Menu                  |      |
| :----------------------------------------------------------: | :--: |
|                   Database Basic Operation                   |      |
|                    Table Basic Operation                     |      |
|                   Package Query Operation                    |      |
|            PQL Feature Language Query Operations             |      |
|          Advanced Database Configuration Operations          |      |
|      Intelligent Query Operation (Multi-Package Query)       |      |
|                  Aggregate Query Operation                   |      |
|                      Cascade Operation                       |      |
|                    Transaction Operation                     |      |
|                  Safe Encryption Operation                   |      |
|                 Split Large Table Operation                  |      |
|                      Logging Operations                      |      |
|                   Snapshot Save Operation                    |      |
| Backup Database Operation (Support MySQL, SQLServer, Sqlite3, Oracle) |      |
|      Stress Test Operation (Support Report Generation)       |      |

## Core API

- PaintingliteSessionManager ： Basic Operations Manager (DataBase Operations | Table Operations)
- PaintingliteExec ： Perform Operation
- PaintingliteBackUpManager ： Database Backup Manager
- PaintingliteSplitTable ： Split Operation
- PaintinglitePressureOS ： Pressure Test

# Database Operations(PaintingliteSessionManager)

## 1.Build a DataBase

Create PaintingliteSessionManager, create a database through the manager.

```objective-c
- (Boolean)openSqlite:(NSString *)fileName;

- (Boolean)openSqlite:(NSString *)fileName completeHandler:(void(^ __nullable)(NSString *filePath,PaintingliteSessionError *error,Boolean success))completeHandler;
```

**Paintinglite has a good processing mechanism to create a database by passing in the database name. Even if the database suffix is not standardized, it can still create a database with a .db suffix.**

```objective-c
[self.sessionM openSqlite:@"sqlite"];
[self.sessionM openSqlite:@"sqlite02.db"];
[self.sessionM openSqlite:@"sqlite03.image"];
[self.sessionM openSqlite:@"sqlite04.text"];
[self.sessionM openSqlite:@"sqlite05.."];
```

**Obtain the absolute path to create the database.**

```objective-c
[self.sessionM openSqlite:@"sqlite" completeHandler:^(NSString * _Nonnull filePath, PaintingliteSessionError * _Nonnull error, Boolean success) {
       if (success) {
           NSLog(@"%@",filePath);
        }
 }];
```

## 2.Close Database

```
- (Boolean)releaseSqlite;

- (Boolean)releaseSqliteCompleteHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
```

## 3.Create Table

```
- (Boolean)execTableOptForSQL:(NSString *)sql;
- (Boolean)execTableOptForSQL:(NSString *)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content;
- (Boolean)createTableForName:(NSString *)tableName content:(NSString *)content completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)createTableForObj:(id)obj createStyle:(PaintingliteDataBaseOptionsCreateStyle)createStyle;
- (Boolean)createTableForObj:(id)obj createStyle:(PaintingliteDataBaseOptionsCreateStyle)createStyle completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
```

Three ways to create a table:

1. SQL creation

```
[self.sessionM execTableOptForSQL:@"CREATE TABLE IF NOT EXISTS cart(UUID VARCHAR(20) NOT NULL PRIMARY KEY,shoppingName TEXT,shoppingID INT(11))" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"===CREATE TABLE SUCCESS===");
        }
}];
```

2. Table name creation

```
[self.sessionM createTableForName:@"student" content:@"name TEXT,age INTEGER"];
```

3. Object creation

```
User *user = [[User alloc] init];
[self.sessionM createTableForObj:user createStyle:PaintingliteDataBaseOptionsUUID];
```

Object creation can automatically generate a primary key:

| PrimaryKey | Type    |
| ---------- | ------- |
| UUID       | 字符串  |
| ID         | INTEGER |

## 4.Update Datebase

```
- (Boolean)execTableOptForSQL:(NSString *)sql;
- (Boolean)execTableOptForSQL:(NSString *)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (BOOL)alterTableForName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName;
- (BOOL)alterTableForName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (BOOL)alterTableAddColumnWithTableName:(NSString *)tableName columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType;
- (BOOL)alterTableAddColumnWithTableName:(NSString *)tableName columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (BOOL)alterTableForObj:(id)obj;
- (BOOL)alterTableForObj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
```

Three ways to update the table:

1. SQL update
2. Table name update [table name | table field]

```objective-c
[self.sessionM alterTableForName:@"cart" newName:@"carts"];
[self.sessionM alterTableAddColumnWithTableName:@"carts" columnName:@"newColumn" columnType:@"TEXT"];
```

3. Object update Update User table operation

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

According to the mapping relationship between the table and the object, the table field is automatically updated according to the object.

```
User *user = [[User alloc] init];
[self.sessionM alterTableForObj:user];
```

### 5.Drop Table

```
- (Boolean)execTableOptForSQL:(NSString *)sql;
- (Boolean)execTableOptForSQL:(NSString *)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)dropTableForTableName:(NSString *)tableName;
- (Boolean)dropTableForTableName:(NSString *)tableName completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)dropTableForObj:(id)obj;
- (Boolean)dropTableForObj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
```

Three ways to drop the table:

1. SQL drop
2. Tablename drop

```
[self.sessionM execTableOptForSQL:@"DROP TABLE carts" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"===DROP TABLE SUCCESS===");
        }
}];
```

3. Object drop

```
User *user = [[User alloc] init];
[self.sessionM dropTableForObj:user];
```

# Table operation

### 1.Select

**Query can provide the feature that the query result is encapsulated by array or directly encapsulated by object. **

1. General query

- General query

```
- (NSMutableArray *)execQuerySQL:(NSString *__nonnull)sql;
- (Boolean)execQuerySQL:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray))completeHandler;
[self.sessionM execQuerySQL:@"SELECT * FROM student" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<NSDictionary *> * _Nonnull resArray) {
        if (success) {
            for (NSDictionary *dict in resArray) {
                NSLog(@"%@",dict);
            }
        }
}];
```

> 2020-06-27 15:35:45.967569+0800 Paintinglite[5805:295051] { age = 21; name = CreaterOS; } 2020-06-27 15:35:45.967760+0800 Paintinglite[5805:295051] { age = 19; name = Painting; } 2020-06-27 15:35:45.967879+0800 Paintinglite[5805:295051] { age = 21; name = CreaterOS; }

- Package query

  Encapsulated queries can encapsulate the query results into objects corresponding to table fields.

```
- (id)execQuerySQL:(NSString *__nonnull)sql obj:(id)obj;
- (Boolean)execQuerySQL:(NSString *__nonnull)sql obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id> *resObjList))completeHandler;
Student *stu = [[Student alloc] init];
[self.sessionM execQuerySQL:@"SELECT * FROM student" obj:stu completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<NSDictionary *> * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
  if (success) {
    for (Student *stu in resObjList) {
      NSLog(@"stu.name = %@ and stu.age = %@",stu.name,stu.age);
    }
  }
}];
```

> 2020-06-27 15:39:27.306786+0800 Paintinglite[5892:302879] stu.name = CreaterOS and stu.age = 21 2020-06-27 15:39:27.306961+0800 Paintinglite[5892:302879] stu.name = Painting and stu.age = 19 2020-06-27 15:39:27.307110+0800 Paintinglite[5892:302879] stu.name = CreaterOS and stu.age = 21

2. Conditional query

> Conditional query syntax rules:
>
> - Conditional query syntax rules:
> - Use conditional parameters as ? placeholders

```
SELECT * FROM user WHERE name = ? and age = ?
- (NSMutableArray<NSDictionary *> *)execPrepareStatementSql;
- (Boolean)execPrepareStatementSqlCompleteHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;
[self.sessionM execQuerySQLPrepareStatementSql:@"SELECT * FROM student WHERE name = ?"];
[self.sessionM setPrepareStatementPQLParameter:0 paramter:@"CreaterOS"];
NSLog(@"%@",[self.sessionM execPrepareStatementSql]);
```

> 2020-06-27 15:44:06.664951+0800 Paintinglite[5984:310580] ( { age = 21; name = CreaterOS; }, { age = 21; name = CreaterOS; } )

3. Fuzzy query

```
- (NSMutableArray<NSDictionary *> *)execLikeQuerySQLWithTableName:(NSString *__nonnull)tableName field:(NSString *__nonnull)field like:(NSString *__nonnull)like;
- (Boolean)execLikeQuerySQLWithTableName:(NSString *__nonnull)tableName field:(NSString *__nonnull)field like:(NSString *__nonnull)like completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

- (id)execLikeQuerySQLWithField:(NSString *__nonnull)field like:(NSString *__nonnull)like obj:(id)obj;
- (Boolean)execLikeQuerySQLWithField:(NSString *__nonnull)field like:(NSString *__nonnull)like obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;
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

> 2020-06-27 15:46:31.310495+0800 Paintinglite[6030:314851] { age = 21; name = CreaterOS; } 2020-06-27 15:46:31.310701+0800 Paintinglite[6030:314851] { age = 19; name = Painting; } 2020-06-27 15:46:31.310868+0800 Paintinglite[6030:314851] { age = 21; name = CreaterOS; }

4. Paging query

```
- (NSMutableArray<NSDictionary *> *)execLimitQuerySQLWithTableName:(NSString *__nonnull)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end;
- (Boolean)execLimitQuerySQLWithTableName:(NSString *__nonnull)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

- (id)execLimitQuerySQLWithLimitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj;
- (Boolean)execLimitQuerySQLWithLimitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;
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

5. Sort query

```
- (NSMutableArray<NSDictionary *> *)execOrderByQuerySQLWithTableName:(NSString *__nonnull)tableName orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle;
- (Boolean)execOrderByQuerySQLWithTableName:(NSString *__nonnull)tableName orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

- (id)execOrderByQuerySQLWithOrderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj;
- (Boolean)execOrderByQuerySQLWithOrderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;
Student *student = [[Student alloc] init];
[self.sessionM execOrderByQuerySQLWithOrderbyContext:@"name" orderStyle:PaintingliteOrderByDESC obj:student completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<NSDictionary *> * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
  if (success) {
    for (Student *stu in resObjList) {
      NSLog(@"stu.name = %@ and stu.age = %@",stu.name,stu.age);
    }
  }
}];
```

> 2020-06-27 15:55:06.714604+0800 Paintinglite[6196:331097] stu.name = Painting and stu.age = 19 2020-06-27 15:55:06.714801+0800 Paintinglite[6196:331097] stu.name = CreaterOS and stu.age = 21 2020-06-27 15:55:06.714962+0800 Paintinglite[6196:331097] stu.name = CreaterOS and stu.age = 21

### 2.Insert

```
- (Boolean)insert:(NSString *__nonnull)sql;
- (Boolean)insert:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)insertWithObj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
```

1. SQL insert

```
[self.sessionM insert:@"INSERT INTO student(name,age) VALUES('CreaterOS',21),('Painting',19)"];
```

2. Object insert

```
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Student : NSObject
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSNumber *age;
@end

NS_ASSUME_NONNULL_END
Student *stu = [[Student alloc] init];
stu.name = @"ReynBryant";
stu.age = [NSNumber numberWithInteger:21];
[self.sessionM insertWithObj:stu completeHandler:nil];
```

> For large amounts of data, Paintinglit can still show good efficiency. It only takes 6ms-7ms to read 16 million pieces of data at a time.

### 3.Update

```
- (Boolean)update:(NSString *__nonnull)sql;
- (Boolean)update:(NSString *__nonnull)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
- (Boolean)updateWithObj:(id)obj condition:(NSString *__nonnull)condition completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
```

1. SQL update

```
[self.sessionM update:@"UPDATE student SET name = 'Painting' WHERE name = 'ReynBryant'"];
```

2. Object update

```
Student *stu = [[Student alloc] init];
stu.name = @"CreaterOS";
[self.sessionM updateWithObj:stu condition:@"age = 21" completeHandler:nil];
```

> Increase the update operation, you can update the object by value, for example： User *user = [[User alloc] init]; user.name = @"CreaterOS"; user.age = 21;

### 4.Delete

```
- (Boolean)del:(NSString *__nonnull)sql;
- (Boolean)del:(NSString *__nonnull)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
```

# PQL Grammar(PaintingliteSessionManager)

Through PQL statements, Paintinglite can automatically help you write SQL statements.

> PQL syntax rules (upper case | class name must be associated with the table) FROM + class name + [condition]

```
- (id)execPrepareStatementPQL;
- (Boolean)execPrepareStatementPQLWithCompleteHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

- (void)execQueryPQLPrepareStatementPQL:(NSString *__nonnull)prepareStatementPQL;
- (void)setPrepareStatementPQLParameter:(NSUInteger)index paramter:(NSString *__nonnull)paramter;
- (void)setPrepareStatementPQLParameter:(NSArray *__nonnull)paramter;

- (id)execPQL:(NSString *__nonnull)pql;
- (Boolean)execPQL:(NSString *__nonnull)pql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;
[self.sessionM execPQL:@"FROM Student WHERE name = 'CreaterOS'" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if (success) {
            for (Student *stu in resObjList) {
                NSLog(@"stu.name = %@ and stu.age = %@",stu.name,stu.age);
            }
        }
}];
```

> 2020-06-27 16:16:47.145774+0800 Paintinglite[6753:369828] stu.name = CreaterOS and stu.age = 21 2020-06-27 16:16:47.145928+0800 Paintinglite[6753:369828] stu.name = CreaterOS and stu.age = 21

```
[self.sessionM execPQL:@"FROM Student LIMIT 0,1" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if (success) {
            for (Student *stu in resObjList) {
                NSLog(@"stu.name = %@ and stu.age = %@",stu.name,stu.age);
            }
        }
}];
[self.sessionM execPQL:@"FROM Student WHERE name LIKE '%t%'" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if (success) {
            for (Student *stu in resObjList) {
                NSLog(@"stu.name = %@ and stu.age = %@",stu.name,stu.age);
            }
        }
}];
[self.sessionM execPQL:@"FROM Student ORDER BY name ASC" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
        if (success) {
            for (Student *stu in resObjList) {
                NSLog(@"stu.name = %@ and stu.age = %@",stu.name,stu.age);
            }
        }
}];
[self.sessionM execQueryPQLPrepareStatementPQL:@"FROM Student WHERE name = ?"];
[self.sessionM setPrepareStatementPQLParameter:@[@"CreaterOS"]];
NSLog(@"%@",[self.sessionM execPrepareStatementPQL]);
```

> 2020-06-27 16:26:11.404815+0800 Paintinglite[7025:389268] ( "<Student: 0x600000565420>", "<Student: 0x6000005657e0>" )

# Aggregate Function(PaintingliteAggregateFunc)

Paintinglite encapsulates the Sqlite3 aggregation function, and automatically writes SQL statements to get the aggregation result.

1. Count

```
[self.aggreageteF count:[self.sessionM getSqlite3] tableName:@"eletest" completeHandler:^(PaintingliteSessionError * _Nonnull sessionerror, Boolean success, NSUInteger count) {
        if (success) {
            NSLog(@"%zd",count);
        }
 }];
```

2. Max

```
[self.aggreageteF max:[self.sessionM getSqlite3] field:@"age" tableName:@"eletest" completeHandler:^(PaintingliteSessionError * _Nonnull sessionerror, Boolean success, double max) {
        if (success) {
            NSLog(@"%.2f",max);
        }
}];
```

3. Min

```
[self.aggreageteF min:[self.sessionM getSqlite3] field:@"age" tableName:@"eletest" completeHandler:^(PaintingliteSessionError * _Nonnull sessionerror, Boolean success, double min) {
        if (success) {
            NSLog(@"%.2f",min);
        }
}];
```

4. Sum

```
[self.aggreageteF sum:[self.sessionM getSqlite3] field:@"age" tableName:@"eletest" completeHandler:^(PaintingliteSessionError * _Nonnull sessionerror, Boolean success, double sum) {
        if (success) {
            NSLog(@"%.2f",sum);
        }
}];
```

5. Avg

```
[self.aggreageteF avg:[self.sessionM getSqlite3] field:@"age" tableName:@"eletest" completeHandler:^(PaintingliteSessionError * _Nonnull sessionerror, Boolean success, double avg) {
        if (success) {
            NSLog(@"%.2f",avg);
        }
}];
```

# Transaction (PaintingliteTransaction)

Sqlite3 development defaults that an insert statement is a transaction. Assuming that there are multiple insert statements, the transaction will be started repeatedly. This is huge for resource consumption. Paintinglite provides the operation to start a transaction (display transaction).

```
+ (void)begainPaintingliteTransaction:(sqlite3 *)ppDb;
+ (void)commit:(sqlite3 *)ppDb;
+ (void)rollback:(sqlite3 *)ppDb;
```

> Daily development integration Use
>
> @try { } @catch (NSException *exception) { } @finally { }

# Cascade Operation(PaintingliteCascadeShowerIUD)

```
- (Boolean)cascadeInsert:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionError,Boolean success,NSMutableArray *resArray))completeHandler;

- (Boolean)cascadeUpdate:(sqlite3 *)ppDb obj:(id)obj condatation:(NSArray<NSString *> * __nonnull)condatation completeHandler:(void (^__nullable)(PaintingliteSessionError *sessionError,Boolean success,NSMutableArray *resArray))completeHandler;

- (Boolean)cascadeDelete:(sqlite3 *)ppDb obj:(id)obj condatation:(NSArray<NSString *> * __nonnull)condatation completeHandler:(void (^__nullable)(PaintingliteSessionError *sessionError,Boolean success,NSMutableArray *resArray))completeHandler;
```

The cascade is divided into three parts:

1. Insert

> For cascading insert operations, we need to connect two related tables through a variable array, for example: user table and student table are connected, a user can contain multiple students

Then, you can set variable data in the user to save multiple students, and then hand over the user object to Paintinglite to write data in multiple tables at once.

```
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

2. Update function is the same as cascading insert. Pass in the user object, which contains the collection of student tables, and pass the modification conditions in an array. Paintinglite can automatically update multiple tables. (Different conditions of multiple tables corresponding to the condition array)

> name = 'CreaterOS' 对应user表
>
> name = 'OS...' 对应student表

```
[self.cascade cascadeUpdate:[self.sessionM getSqlite3] obj:user condatation:@[@"WHERE name = 'CreaterOS'",@"WHERE name = 'OS...'"] completeHandler:^(PaintingliteSessionError * _Nonnull sessionError, Boolean success, NSMutableArray * _Nonnull resArray) {
     if (success) {
            NSLog(@"%@",resArray);
     }
 }];
 
```

3. Delete

```
[self.cascade cascadeDelete:[self.sessionM getSqlite3] obj:user condatation:@[@"name = 'WHY'",@"name = 'YHD...'"] completeHandler:^(PaintingliteSessionError * _Nonnull sessionError, Boolean success, NSMutableArray * _Nonnull resArray) {
       if (success) {
           NSLog(@"%@",resArray);
       }
}];
```

# Log Mode(PaintingliteLog)

Paintinglite provides a logging function for developers, which can record key operations on sqlite3 data during development, and is marked with a time stamp.Developers can easily read the log through the database name, or according to the required time node or the state of successful failure Selectively read logs. It is convenient for debugging after the software goes online.

```
- (void)readLogFile:(NSString *__nonnull)fileName;

- (void)readLogFile:(NSString *)fileName dateTime:(NSDate *__nonnull)dateTime;

- (void)readLogFile:(NSString *)fileName logStatus:(PaintingliteLogStatus)logStatus;

- (void)removeLogFile:(NSString *)fileName;
```

# Database Backup(PaintingliteBackUpManager)

Database migration is a problem that developers often care about. It has always been a headache for SQLite3 to migrate clients SQL Server MySQL and Orcale. Paintinglite is very friendly to provide developers with four kinds of database backup files, including from building a library to inserting data. Paintinglite writes backup files for developers. Developers only need to upload these sql files and run them to get and mobile devices. The exact same data.

```
PaintingliteBackUpSqlite3,
PaintingliteBackUpMySql,
PaintingliteBackUpSqlServer,
PaintingliteBackUpORCALE
- (Boolean)backupDataBaseWithName:(sqlite3 *)ppDb sqliteName:(NSString *)sqliteName type:(PaintingliteBackUpManagerDBType)type completeHandler:(void(^ __nullable)(NSString *saveFilePath))completeHandler;
```

![image-20200627211330562](/Users/bryantreyn/Library/Application Support/typora-user-images/image-20200627211330562.png)

# Split Table(PaintingliteSplitTable)

The time-consuming operation of table query for excessive data volume is huge. The Paintinglite test stage provides the operation of splitting the table. The large table is split into multiple small tables. The amount of the split is determined by the developer. Paintinglite provides split table operation for the first time, the module is still being tested, and later version iterations will focus on optimizing this part of the resource consumption and CPU utilization issues.

```
/**
  * tableName: 数据库名称 
  * basePoint: 拆分个数 
  */
- (Boolean)splitTable:(sqlite3 *)ppDb tabelName:(NSString *__nonnull)tableName basePoint:(NSUInteger)basePoint;
```

1. Query operation

```
- (NSMutableArray *)selectWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName basePoint:(NSUInteger)basePoint;
```

2. Insert operation

```
- (Boolean)insertWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *)tableName basePoint:(NSUInteger)basePoint insertSQL:(NSString *)insertSQL;
```

3. Update operation

```
- (Boolean)updateWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *)tableName basePoint:(NSUInteger)basePoint updateSQL:(NSString *)updateSQL;
```

4. Delete operation

```
- (Boolean)deleteWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *)tableName basePoint:(NSUInteger)basePoint deleteSQL:(NSString *)deleteSQL;
```

# Pressure Test(PaintinglitePressureOS)

The PaintinglitePressureOS system is a stress testing system, which makes a reasonable assessment of the database read and write time consumption, resource consumption and memory usage, and supports the generation of stress test reports. (Reports are not generated by default)

Paintinglite can calculate the memory consumption status differently according to different devices, so that developers can more clearly design a more reasonable database table structure on different iPhones.

```
- (Boolean)paintingliteSqlitePressure;
```

# Constraint

In order to achieve better operation, in line with the database specifications, all table names are lowercase.

### Contribute To This Project

If you have a feature request or error report, please feel free to send Facebook to upload the problem, we will provide you with revision and help as soon as possible. Thank you very much for your support.

| Paintinglite Version |      |
| ------------------- | ---- |
| v1.1 | Compared with v1.0, it optimizes the operation of opening the database and adds important information such as the existence and size of the database file. |
| v1.2 | The stress test strategy has been revised, the frame size has been greatly reduced (<10MB), and a first-level cache and log write strategy have been added. |


### Security Disclosure

If you have found the Paintlitelite security vulnerability and the one that needs to be modified, you should email it to Facebook as soon as possible. thank you for your support.

<details class="details-reset details-overlay details-overlay-dark " style="box-sizing: border-box; display: block;"><summary class="float-right" role="button" style="box-sizing: border-box; display: list-item; cursor: pointer; float: right !important; list-style: none;"><div class="link-gray-dark pt-1 pl-2" style="box-sizing: border-box; color: rgb(36, 41, 46) !important; padding-top: 4px !important; padding-left: 8px !important;"><svg height="16" class="octicon octicon-gear float-right" aria-label="Edit repository metadata" float="right" viewBox="0 0 16 16" version="1.1" width="16" role="img"><path fill-rule="evenodd" d="M7.429 1.525a6.593 6.593 0 011.142 0c.036.003.108.036.137.146l.289 1.105c.147.56.55.967.997 1.189.174.086.341.183.501.29.417.278.97.423 1.53.27l1.102-.303c.11-.03.175.016.195.046.219.31.41.641.573.989.014.031.022.11-.059.19l-.815.806c-.411.406-.562.957-.53 1.456a4.588 4.588 0 010 .582c-.032.499.119 1.05.53 1.456l.815.806c.08.08.073.159.059.19a6.494 6.494 0 01-.573.99c-.02.029-.086.074-.195.045l-1.103-.303c-.559-.153-1.112-.008-1.529.27-.16.107-.327.204-.5.29-.449.222-.851.628-.998 1.189l-.289 1.105c-.029.11-.101.143-.137.146a6.613 6.613 0 01-1.142 0c-.036-.003-.108-.037-.137-.146l-.289-1.105c-.147-.56-.55-.967-.997-1.189a4.502 4.502 0 01-.501-.29c-.417-.278-.97-.423-1.53-.27l-1.102.303c-.11.03-.175-.016-.195-.046a6.492 6.492 0 01-.573-.989c-.014-.031-.022-.11.059-.19l.815-.806c.411-.406.562-.957.53-1.456a4.587 4.587 0 010-.582c.032-.499-.119-1.05-.53-1.456l-.815-.806c-.08-.08-.073-.159-.059-.19a6.44 6.44 0 01.573-.99c.02-.029.086-.075.195-.045l1.103.303c.559.153 1.112.008 1.529-.27.16-.107.327-.204.5-.29.449-.222.851-.628.998-1.189l.289-1.105c.029-.11.101-.143.137-.146zM8 0c-.236 0-.47.01-.701.03-.743.065-1.29.615-1.458 1.261l-.29 1.106c-.017.066-.078.158-.211.224a5.994 5.994 0 00-.668.386c-.123.082-.233.09-.3.071L3.27 2.776c-.644-.177-1.392.02-1.82.63a7.977 7.977 0 00-.704 1.217c-.315.675-.111 1.422.363 1.891l.815.806c.05.048.098.147.088.294a6.084 6.084 0 000 .772c.01.147-.038.246-.088.294l-.815.806c-.474.469-.678 1.216-.363 1.891.2.428.436.835.704 1.218.428.609 1.176.806 1.82.63l1.103-.303c.066-.019.176-.011.299.071.213.143.436.272.668.386.133.066.194.158.212.224l.289 1.106c.169.646.715 1.196 1.458 1.26a8.094 8.094 0 001.402 0c.743-.064 1.29-.614 1.458-1.26l.29-1.106c.017-.066.078-.158.211-.224a5.98 5.98 0 00.668-.386c.123-.082.233-.09.3-.071l1.102.302c.644.177 1.392-.02 1.82-.63.268-.382.505-.789.704-1.217.315-.675.111-1.422-.364-1.891l-.814-.806c-.05-.048-.098-.147-.088-.294a6.1 6.1 0 000-.772c-.01-.147.039-.246.088-.294l.814-.806c.475-.469.679-1.216.364-1.891a7.992 7.992 0 00-.704-1.218c-.428-.609-1.176-.806-1.82-.63l-1.103.303c-.066.019-.176.011-.299-.071a5.991 5.991 0 00-.668-.386c-.133-.066-.194-.158-.212-.224L10.16 1.29C9.99.645 9.444.095 8.701.031A8.094 8.094 0 008 0zm1.5 8a1.5 1.5 0 11-3 0 1.5 1.5 0 013 0zM11 8a3 3 0 11-6 0 3 3 0 016 0z"></path></svg></div></summary></details>

## About

No description, website, or topics provided.

### Topics

### Resources

[ Readme](https://github.com/CreaterOS/Paintinglite#readme)

## [Releases](https://github.com/CreaterOS/Paintinglite/releases)

No releases published

[Create a new release](https://github.com/CreaterOS/Paintinglite/releases/new)

## [Packages ](https://github.com/CreaterOS/Paintinglite/packages)

No packages published 
[Publish your first package](https://github.com/CreaterOS/Paintinglite/packages)

## Languages

- [Objective-C75.3%](https://github.com/CreaterOS/Paintinglite/search?l=objective-c) 
- [C15.5%](https://github.com/CreaterOS/Paintinglite/search?l=c)
- [MATLAB4.8%](https://github.com/CreaterOS/Paintinglite/search?l=matlab) 
- [C++2.9%](https://github.com/CreaterOS/Paintinglite/search?l=c%2B%2B)
- [M1.5%](https://github.com/CreaterOS/Paintinglite/search?l=m)
