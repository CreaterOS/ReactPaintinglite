# Paintinglite
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/3a263edb5f124ee0a8bc2cdda9e9a334)](https://www.codacy.com/gh/CreaterOS/Paintinglite/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=CreaterOS/Paintinglite&amp;utm_campaign=Badge_Grade)
[![standard-readme compliant](https://img.shields.io/badge/Paintinglite-CreaterOS-brightgreen.svg?style=CreaterOS)](https://github.com/CreaterOS/Paintinglite)

## v2.1.1 Paintinglite API v1.0
http://htmlpreview.github.io/?https://github.com/CreaterOS/Paintinglite/blob/master/Paintinglite/PaintingliteWeb/index.html
The detailed API documentation is contained in masterTOC.html in the Paintinglite/PaintingliteWeb directory
## Version iteration

| Paintinglite version update | |
| ------------------- | ---- |
| Summary of the v1.1.0 version update | Optimized the operation of opening the database and added important information such as viewing the existence and size of the database file |
| Summary of v1.2.0 version update | Re-revised the stress test strategy, greatly reducing the frame size (<10MB), increasing the first level cache and log writing strategy |
| v1.3.0 version update summary | Fixed the object packaging operation vulnerability caused by the first-level cache, improved a set of caches, optimized the CREATE, ALTER, and DROP operations on the table, and added the thread optimization strategy |
| Summary of v1.3.1 version update | Optimize query thread safety, fix package disorder BUG, ​​optimize aggregation function |
| Summary of v1.3.2 version update | Optimize query thread safety, fix database backup, simplify framework structure |
| Summary of v2.0.0 version update | Introduced a new design mode, centralized management of SQL statements |
| Summary of v2.1.0 version update | Optimize big data CPU resource consumption problem, fix BUG |

## Pod installation
``` objective-c
pod'Paintinglite', :git =>'https://github.com/CreaterOS/Paintinglite.git'#, :tag => '2.1.1'
```
## Introduction

Paintinglite is an excellent and fast Sqlite3 database framework. Paintinglite has good encapsulation of data, fast data insertion characteristics, and can still show good resource utilization for huge amounts of data.
Paintinglite supports object mapping and has carried out a very lightweight object encapsulation on sqlite3. It establishes a mapping relationship between POJOs and database tables. Paintinglite can automatically generate SQL statements and manually write SQL statements to achieve convenient development and efficient querying. All-in-one lightweight framework.

| Paintinglite function table | |
| ------------------------------------------------- -| ---- |
| Basic library operations | |
| Table basic operations | |
| Package query operation | |
| PQL feature language query operation | |
| Advanced database configuration operations | |
| Intelligent query operation (multi-package query) | |
| Aggregate query operations | |
| Cascade operation | |
| Transaction operation | |
| Secure encryption operation | |
| Split large table operation | |
| Logging operations | |
| Snapshot save operation | |
| Backup database operations (support MySQL, SQLServer, Sqlite3, Oracle) | |
| Stress test operation (support report generation) | |
| XML centralized management database operation statement operation | |

## Core Object
-PaintingliteSessionManager: Basic operation manager (library operation | table operation)
-PaintingliteXMLSessionManager: Centralized management of SQL statement managers (specially introduced in v2.0)
-PaintingliteExec: Perform operation
-PaintingliteBackUpManager: Database backup manager
-PaintingliteSplitTable: Split operation
-PaintinglitePressureOS: pressure test

---
## Database operation (PaintingliteSessionManager)
### 1. Build a library
#### Create PaintingliteSessionManager, create a database through the manager.

```objective-c
-(Boolean)openSqlite:(NSString *)fileName;

-(Boolean)openSqlite:(NSString *)fileName completeHandler:(void(^ __nullable)(NSString *filePath,PaintingliteSessionError *error,Boolean success))completeHandler;
```
**Paintinglite has a good processing mechanism. It creates a database by passing in the database name. Even if the database suffix is ​​not standardized, it can still create a database with a .db suffix. **

```objective-c
[self.sessionM openSqlite:@"sqlite"];
[self.sessionM openSqlite:@"sqlite02.db"];
[self.sessionM openSqlite:@"sqlite03.image"];
[self.sessionM openSqlite:@"sqlite04.text"];
[self.sessionM openSqlite:@"sqlite05.."];
```

**Get the absolute path of the created database. **

```objective-c
[self.sessionM openSqlite:@"sqlite" completeHandler:^(NSString * _Nonnull filePath, PaintingliteSessionError * _Nonnull error, Boolean success) {
       if (success) {
           NSLog(@"%@",filePath);
        }
 }];
```

## 2. Close the library

```objective-c
-(Boolean)releaseSqlite;

-(Boolean)releaseSqliteCompleteHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
```

## 3. Create a table

```objective-c
-(Boolean)execTableOptForSQL:(NSString *)sql;
-(Boolean)execTableOptForSQL:(NSString *)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
-(Boolean)createTableForName:(NSString *)tableName content:(NSString *)content;
-(Boolean)createTableForName:(NSString *)tableName content:(NSString *)content completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
-(Boolean)createTableForObj:(id)obj createStyle:(PaintingliteDataBaseOptionsCreateStyle)createStyle;
-(Boolean)createTableForObj:(id)obj createStyle:(PaintingliteDataBaseOptionsCreateStyle)createStyle completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
```
Three ways to create a table:
 1. SQL creation

```objective-c
[self.sessionM execTableOptForSQL:@"CREATE TABLE IF NOT EXISTS cart(UUID VARCHAR(20) NOT NULL PRIMARY KEY,shoppingName TEXT,shoppingID INT(11))" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"===CREATE TABLE SUCCESS===");
        }
}];
```

 2. Table name creation

```objective-c
[self.sessionM createTableForName:@"student" content:@"name TEXT,age INTEGER"];
```

 3. Object creation

```objective-c
User *user = [[User alloc] init];
[self.sessionM createTableForObj:user createStyle:PaintingliteDataBaseOptionsUUID];
```

Object creation can automatically generate primary keys:

| Primary key | Type |
| ---- | ------ |
| UUID | String |
| ID | Value |

## 4. Update table

```objective-c
-(Boolean)execTableOptForSQL:(NSString *)sql;
-(Boolean)execTableOptForSQL:(NSString *)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
-(BOOL)alterTableForName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName;
-(BOOL)alterTableForName:(NSString *__nonnull)oldName newName:(NSString *__nonnull)newName completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
-(BOOL)alterTableAddColumnWithTableName:(NSString *)tableName columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType;
-(BOOL)alterTableAddColumnWithTableName:(NSString *)tableName columnName:(NSString *__nonnull)columnName columnType:(NSString *__nonnull)columnType completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
-(BOOL)alterTableForObj:(id)obj;
-(BOOL)alterTableForObj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
```
Three ways to update the table:
 1. SQL Update

 2. Table name update

```objective-c
[self.sessionM alterTableForName:@"cart" newName:@"carts"];
[self.sessionM alterTableAddColumnWithTableName:@"carts" columnName:@"newColumn" columnType:@"TEXT"];
```
 3. Object update
 Update User table operation

```objective-c
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface User: NSObject

@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSNumber *age;
@property (nonatomic,strong)NSMutableArray<id> *mutableArray;

@end

NS_ASSUME_NONNULL_END
```
According to the mapping relationship between the table and the object, the table fields are automatically updated according to the object.
```objective-c
User *user = [[User alloc] init];
[self.sessionM alterTableForObj:user];
```

### 5. Delete operation

```objective-c
-(Boolean)execTableOptForSQL:(NSString *)sql;
-(Boolean)execTableOptForSQL:(NSString *)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
-(Boolean)dropTableForTableName:(NSString *)tableName;
-(Boolean)dropTableForTableName:(NSString *)tableName completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
-(Boolean)dropTableForObj:(id)obj;
-(Boolean)dropTableForObj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
```
Three ways to delete a table:
 1. SQL operations
 2. Table name deletion

```objective-c
[self.sessionM execTableOptForSQL:@"DROP TABLE carts" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success) {
        if (success) {
            NSLog(@"===DROP TABLE SUCCESS===");
        }
}];
```

 3. Object deletion

```objective-c
User *user = [[User alloc] init];
[self.sessionM dropTableForObj:user];
```
## Table operation

### 1. Query
**Query can provide the feature of query results encapsulated in array or directly encapsulated by object. **
 1. General inquiry
 -General enquiries

```objective-c
-(NSMutableArray *)execQuerySQL:(NSString *__nonnull)sql;
-(Boolean)execQuerySQL:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray<NSDictionary *> *resArray))completeHandler;
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
> age = 21;
> name = CreaterOS;
>}
> 2020-06-27 15:35:45.967760+0800 Paintinglite[5805:295051] {
> age = 19;
> name = Painting;
>}
> 2020-06-27 15:35:45.967879+0800 Paintinglite[5805:295051] {
> age = 21;
> name = CreaterOS;
>}

 -Package query

  Encapsulated query can encapsulate query results into objects corresponding to table fields.

```objective-c
-(id)execQuerySQL:(NSString *__nonnull)sql obj:(id)obj;
-(Boolean)execQuerySQL:(NSString *__nonnull)sql obj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id> *resObjList))completeHandler;
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

 2. Conditional query

> Conditional query syntax rules:
>-Subscripts start from 0
>-Use? As a placeholder for conditional parameters

```sqlite
SELECT * FROM user WHERE name =? And age =?
```

```objective-c
-(NSMutableArray<NSDictionary *> *)execPrepareStatementSql;
-(Boolean)execPrepareStatementSqlCompleteHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;
```

```objective-c
[self.sessionM execQuerySQLPrepareStatementSql:@"SELECT * FROM student WHERE name = ?"];
[self.sessionM setPrepareStatementPQLParameter:0 paramter:@"CreaterOS"];
NSLog(@"%@",[self.sessionM execPrepareStatementSql]);
```
> 2020-06-27 15:44:06.664951+0800 Paintinglite[5984:310580] (
> {
> age = 21;
> name = CreaterOS;
> },
> {
> age = 21;
> name = CreaterOS;
>}
>)

 3. Fuzzy query

```objective-c
-(NSMutableArray<NSDictionary *> *)execLikeQuerySQLWithTableName:(NSString *__nonnull)tableName field:(NSString *__nonnull)field like:(NSString *__nonnull)like;
-(Boolean)execLikeQuerySQLWithTableName:(NSString *__nonnull)tableName field:(NSString *__nonnull)field like:(NSString *__nonnull)like completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

-(id)execLikeQuerySQLWithField:(NSString *__nonnull)field like:(NSString *__nonnull)like obj:(id)obj;
-(Boolean)execLikeQuerySQLWithField:(NSString *__nonnull)field like:(NSString *__nonnull)like obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;
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
> age = 21;
> name = CreaterOS;
>}
> 2020-06-27 15:46:31.310701+0800 Paintinglite[6030:314851] {
> age = 19;
> name = Painting;
>}
> 2020-06-27 15:46:31.310868+0800 Paintinglite[6030:314851] {
> age = 21;
> name = CreaterOS;
>}

 4. Paging query

```objective-c
-(NSMutableArray<NSDictionary *> *)execLimitQuerySQLWithTableName:(NSString *__nonnull)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end;
-(Boolean)execLimitQuerySQLWithTableName:(NSString *__nonnull)tableName limitStart:(NSUInteger)start limitEnd:(NSUInteger)end completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

-(id)execLimitQuerySQLWithLimitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj;
-(Boolean)execLimitQuerySQLWithLimitStart:(NSUInteger)start limitEnd:(NSUInteger)end obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler ;
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

 5. Sort query

```objective-c
-(NSMutableArray<NSDictionary *> *)execOrderByQuerySQLWithTableName:(NSString *__nonnull)tableName orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle;
-(Boolean)execOrderByQuerySQLWithTableName:(NSString *__nonnull)tableName orderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray))completeHandler;

-(id)execOrderByQuerySQLWithOrderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj;
-(Boolean)execOrderByQuerySQLWithOrderbyContext:(NSString *__nonnull)orderbyContext orderStyle:(PaintingliteOrderByStyle)orderStyle obj:(id)obj completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList) )completeHandler;
```
```objective-c
Student *student = [[Student alloc] init];
[self.sessionM execOrderByQuerySQLWithOrderbyContext:@"name" orderStyle:PaintingliteOrderByDESC obj:student completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray<NSDictionary *> * _Nonnull resArray, NSMutableArray<id> * _Nonnull resOb
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

### 2. Increase data

```objective-c
-(Boolean)insert:(NSString *__nonnull)sql;
-(Boolean)insert:(NSString *__nonnull)sql completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
-(Boolean)insertWithObj:(id)obj completeHandler:(void(^ __nullable)(PaintingliteSessionError *error,Boolean success))completeHandler;
```
 1. SQL Insert
```objective-c
[self.sessionM insert:@"INSERT INTO student(name,age) VALUES('CreaterOS',21),('Painting',19)"];
```
 2. Object Insertion

```objective-c
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Student: NSObject
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

> For the huge amount of data, Paintinglit can still show good efficiency. It only takes 6ms-7ms to read 16 million pieces of data at a time.

### 3. Update data

```objective-c
-(Boolean)update:(NSString *__nonnull)sql;
-(Boolean)update:(NSString *__nonnull)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
-(Boolean)updateWithObj:(id)obj condition:(NSString *__nonnull)condition completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
```
 1. SQL update data
   
```objective-c
[self.sessionM update:@"UPDATE student SET name ='Painting' WHERE name ='ReynBryant'"];
```

 2. Object update

   ```objective-c
   Student *stu = [[Student alloc] init];
   stu.name = @"CreaterOS";
   [self.sessionM updateWithObj:stu condition:@"age = 21" completeHandler:nil];
   ```

> Added update operation, which can be updated by object transfer method
> For example:
> User *user = [[User alloc] init];
> user.name = @"CreaterOS";
> user.age = 21;

### 4. Delete data

```objective-c
-(Boolean)del:(NSString *__nonnull)sql;
-(Boolean)del:(NSString *__nonnull)sql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success))completeHandler;
```
# PQL Syntax (PaintingliteSessionManager)
Through the PQL statement, Paintinglite can automatically help you complete the writing of the SQL statement.
> PQL grammar rules (uppercase | the class name must be associated with the table)
> FROM + class name + [condition]

```objective-c
-(id)execPrepareStatementPQL;
-(Boolean)execPrepareStatementPQLWithCompleteHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;

-(void)execQueryPQLPrepareStatementPQL:(NSString *__nonnull)prepareStatementPQL;
-(void)setPrepareStatementPQLParameter:(NSUInteger)index paramter:(NSString *__nonnull)paramter;
-(void)setPrepareStatementPQLParameter:(NSArray *__nonnull)paramter;

-(id)execPQL:(NSString *__nonnull)pql;
-(Boolean)execPQL:(NSString *__nonnull)pql completeHandler:(void(^)(PaintingliteSessionError *error,Boolean success,NSMutableArray *resArray,NSMutableArray<id>* resObjList))completeHandler;
```

```objective-c
[self.sessionM execPQL:@"FROM Student WHERE name ='CreaterOS'" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
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
[self.sessionM execPQL:@"FROM Student WHERE name LIKE'%t%'" completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {
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
> "<Student: 0x600000565420>",
> "<Student: 0x6000005657e0>"
>)

# Aggregate function (PaintingliteAggregateFunc)
Paintinglite encapsulates Sqlite3 aggregation functions, and automatically writes SQL statements to get the aggregation results.
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

# Transaction (PaintingliteTransaction)
Sqlite3 development defaults that an insert statement is a transaction. If there are multiple insert statements, the transaction will be repeated. This consumes a lot of resources. Paintinglite provides an operation to start a transaction (display transaction).

```objective-c
+ (void)begainPaintingliteTransaction:(sqlite3 *)ppDb;
+ (void)commit:(sqlite3 *)ppDb;
+ (void)rollback:(sqlite3 *)ppDb;
```
> Daily development integration
>
> @try {
>} @catch (NSException *exception) {
>} @finally {
>}
>
> Use

# Cascade operation (PaintingliteCascadeShowerIUD)

```objective-c
-(Boolean)cascadeInsert:(sqlite3 *)ppDb obj:(id)obj completeHandler:(void (^ __nullable)(PaintingliteSessionError *sessionError,Boolean success,NSMutableArray *resArray))completeHandler;

-(Boolean)cascadeUpdate:(sqlite3 *)ppDb obj:(id)obj condatation:(NSArray<NSString *> * __nonnull)condatation completeHandler:(void (^__nullable)(PaintingliteSessionError *sessionError,Boolean success,NSMutableArray *resArray)) completeHandler;

-(Boolean)cascadeDelete:(sqlite3 *)ppDb obj:(id)obj condatation:(NSArray<NSString *> * __nonnull)condatation completeHandler:(void (^__nullable)(PaintingliteSessionError *sessionError,Boolean success,NSMutableArray *resArray)) completeHandler;
```
The cascade is divided into three parts:
1. Insert
> For cascading insert operations, we need to connect two related tables through a variable array, for example:
> The user table and the student table are linked,
> A user can contain multiple students

Then, you can set variable data in the user to save multiple students, and then hand the user object to Paintinglite to write data in multiple tables at once.
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
2. Update
    The function is the same as cascading insertion. Pass in the user object, including the collection of student tables, and pass in the modification conditions as an array. Paintinglite can automatically update multiple tables. (Different conditions of multiple tables corresponding to the condition array)

  > name ='CreaterOS' corresponds to the user table
  >
  > name ='OS...' corresponds to the student table

```objective-c
[self.cascade cascadeUpdate:[self.sessionM getSqlite3] obj:user condatation:@[@"WHERE name ='CreaterOS'",@"WHERE name ='OS...'"] completeHandler:^(PaintingliteSessionError * _Nonnull sessionError , Boolean success, NSMutableArray * _Nonnull resArray) {
     if (success) {
            NSLog(@"%@",resArray);
     }
 }];
 
```

3. Delete

```objective-c
[self.cascade cascadeDelete:[self.sessionM getSqlite3] obj:user condatation:@[@"name ='WHY'",@"name ='YHD...'"] completeHandler:^(PaintingliteSessionError * _Nonnull sessionError, Boolean success, NSMutableArray * _Nonnull resArray) {
       if (success) {
           NSLog(@"%@",resArray);
       }
}];

```

# Log Mode (PaintingliteLog)

Paintinglite provides developers with a logging function, which can record key operations on sqlite3 data during development, and is marked with a timestamp. Developers can easily read the log through the database name, or according to the required time node or the status of success and failure Selectively read the log. It facilitates the debugging after the software is online.
```objective-c
-(void)readLogFile:(NSString *__nonnull)fileName;

-(void)readLogFile:(NSString *)fileName dateTime:(NSDate *__nonnull)dateTime;

-(void)readLogFile:(NSString *)fileName logStatus:(PaintingliteLogStatus)logStatus;

-(void)removeLogFile:(NSString *)fileName;

```

## Log module update
To write log files in batches through the first-level cache, it is recommended that the developer instantiate the PaintingliteCache in AppDelegate, and manually call the log write method in applicationDidEnterBackground:(UIApplication *)application and applicationWillTerminate:(UIApplication *)application, then the cache can not be reached The log of the base point is written to the log file in time.
```objective-c
[self.cache pushCacheToLogFile];
```

# Database backup (PaintingliteBackUpManager)
Database migration is a problem that developers often care about. It has always been a headache for sqlite3 to port the client SQL Server MySQL and Orcale. Paintinglite is very friendly to provide developers with four database backup files, including from building a database to inserting data. Paintinglite writes backup files for developers. Developers only need to upload these sql files and run them to get and move the device. Exactly the same data.
```objective-c
PaintingliteBackUpSqlite3,
PaintingliteBackUpMySql,
PaintingliteBackUpSqlServer,
PaintingliteBackUpORCALE
```

```objective-c
-(Boolean)backupDataBaseWithName:(sqlite3 *)ppDb sqliteName:(NSString *)sqliteName type:(PaintingliteBackUpManagerDBType)type completeHandler:(void(^ __nullable)(NSString *saveFilePath))completeHandler;
```

![image-20200627211330562](/Users/bryantreyn/Library/Application Support/typora-user-images/image-20200627211330562.png)

# Split table (PaintingliteSplitTable)
The time-consuming operation of table query with too large amount of data is huge. The Paintinglite test phase provides the operation of splitting the table, splitting the large table into multiple small tables, and the amount of splitting is determined by the developer.
Paintinglite provides split table operation for the first time, and the module is still being tested. Later version iterations will focus on optimizing this part of resource consumption and CPU usage.

```objective-c
/**
  * tableName: database name
  * basePoint: the number of splits
  */
-(Boolean)splitTable:(sqlite3 *)ppDb tabelName:(NSString *__nonnull)tableName basePoint:(NSUInteger)basePoint;
```
1. Query operation

```objective-c
-(NSMutableArray *)selectWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *__nonnull)tableName basePoint:(NSUInteger)basePoint;
```
2. Insert operation

```objective-c
-(Boolean)insertWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *)tableName basePoint:(NSUInteger)basePoint insertSQL:(NSString *)insertSQL;
```

3. Update operation

```objective-c
-(Boolean)updateWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *)tableName basePoint:(NSUInteger)basePoint updateSQL:(NSString *)updateSQL;
```

4. Delete operation

```objective-c
-(Boolean)deleteWithSpliteFile:(sqlite3 *)ppDb tableName:(NSString *)tableName basePoint:(NSUInteger)basePoint deleteSQL:(NSString *)deleteSQL;

```

# Stress test (PaintinglitePressureOS)
The PaintinglitePressureOS system is a stress testing system. It evaluates the reasonableness of database read and write consumption time, resource consumption and memory usage, and supports the generation of stress test reports. (No report is generated by default)

Paintinglite can perform different measurement and calculation of memory consumption status according to different devices, allowing developers to more clearly design a more reasonable database table structure on different iPhones.
```objective-c
-(Boolean)paintingliteSqlitePressure;
```

 #### XML file configuration rules:
 1. The XML mapping file strictly abides by the DTD rules, which provides <mapper></mapper>,<sql></sql>,<include></include>,<resultMap></resultMap>,<select></ select>, <insert></insert>, <update></update>, <delete></delete> and other basic tags;
 2. The XML mapping file needs to be configured corresponding to the class created by the table (POJO mapping);
 3. The XML mapping file format has strict requirements (the v2.0 version has strict requirements);

#### XML mapping file hierarchy
(1) When configuring the XML mapping file, the outermost tag is <mapper></mapper>, and the mapper tag provides the namespace namespace;
```objective-c
<mapper namespace="...">
</mapper>
```
> namespace: Indicates the name of the table targeted by the current SQL statement operation object (the namespace content is not mandatory here, and it is recommended to be the same as the operation table name)

(2) <mapper></mapper> can configure database SQL operations inside;
#### select: Query label
```objective-c
<select id="getEleByObj" resultType="NSDictionary" parameterType="Eletest">
    SELECT * FROM eletest WHERE name =?
</select>
```
> id: select the bound ID
> resultType: result return type, currently supports NSDictionary&&NSMutableDictionary | NSArray && NSMutableArray
> parameterType: Incoming type (variable parameters do not need to be configured, parameterType must be configured for all obj methods)
> The query SQL statement can be written inside the select tag
> ?: Need to replace part of the adoption?

#### select: omit query
```objective-c
<select id="getEleById" resultType="Eletest">
?
</select>
```
> When you need to use select * from tableName to query, you can omit the SQL statement and replace the SQL statement that needs to be written with a?

#### insert: insert tag
```objective-c
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Eletest: NSObject
@property (nonatomic,strong)NSNumber *age;
@property (nonatomic,copy)NSString *desc;
@property (nonatomic,copy)NSString *name;
@property (nonatomic,strong)NSNumber *tage;
@property (nonatomic,copy)NSString *teacher;
@end

NS_ASSUME_NONNULL_END
```
```objective-c
<insert id="getInsertEletest" parameterType="Eletest">
INSERT INTO eletest(name,age,desc,tage,teacher) VALUES (#name,#age,#desc,#tage,#teacher);
</insert>

<insert id="getInsertEletestAuto" parameterType="Eletest">
?
</insert>
```
> id: insert tag binding ID
> parameterType: Incoming parameter, which must be configured here, is the class name of the POJO object (note the case)
> #name,#age,#desc,#tage,#teacher: replace the inserted value with a combination of "#+class attribute name"
> insert supports the omission of insert statements, and only needs to set the corresponding attribute values ​​for the objects that need to be passed in
> useGeneratedKeys="true" keyProperty="ID": Return the inserted primary key value

```objective-c
<insert id="getInsertUserReturnPrimaryKey" parameterType="Eletest" useGeneratedKeys="true" keyProperty="ID">
<selectKey keyProperty="ID" order="AFTER">
SELECT LAST_INSERT_ID();
</selectKey>
?
</insert>
```
<selectKey></selectKey> can also be configured to insert the return value
> keyProperty="ID": Primary key value (corresponding property value)
> order="AFTER": Call timing, AFTER&&BEFORE can be configured

#### update tag
```objective-c
<update id="getUpdateEle" parameterType="Eletest">
UPDATE eletest SET name = #name and tage = #tage WHERE teacher = #teacher and age = #age;
</update>
```
> id: update tag binding ID
> parameterType: Incoming parameter, which must be configured here, is the class name of the POJO object (note the case)
> #name,#age,#tage,#teacher: replace the inserted value with a combination of "#+class attribute name"
> update supports omitting the insert statement, just set the corresponding attribute value for the object that needs to be passed in

#### delete tag
```objective-c
<delete id="getDeleteUser" parameterType="Eletest">
DELETE FROM eletest WHERE name = #name and teacher = #teacher and tage = #tage;
</delete>

<delete id="getDeleteEleAuto" parameterType="Eletest">
?
</delete>
```
> id: delete tag binding ID
> parameterType: Incoming parameter, which must be configured here, is the class name of the POJO object (note the case)
> #name,#teacher,#tage: replace the inserted value with a combination of "#+class attribute name"
> delete supports omitting the insert statement, just set the corresponding attribute value for the object that needs to be passed in

#### Advanced use of XML mapping file
##### <sql></sql>&&<include></include>Use
 ```objective-c
 <sql id="eletestSql">id,name,age,teacher,tage,desc</sql>
 <select id="getEleByObj" resultType="NSDictionary" parameterType="Eletest" resultMap="eletestResult">
 SELECT <include refid="eletestSql"></include> FROM eletest
 </select>
 ```
Normally operating SQL statements will write select id, name, age, teacher, tag, desc From eletest fields for query, and multiple field names will be used in an XML mapping file. You can use <sql></sql> to change the field name Package, in combination with <include></include> application.

> Note: Use the <include></include> tag to configure the refid to pass in the value must be the same as the <sql></sql> configuration id

#### Dynamic SQL operation tags
##### <if></if> tag
The if tag provides a dynamic judgment of whether the value of the incoming field is empty, and the statement is added if the condition is true, otherwise no statement is added.
 ```objective-c
<select id="getEleByObj" resultType="NSDictionary" parameterType="Eletest" resultMap="eletestResult">
SELECT <include refid="eletestSql"></include> FROM eletest WHERE 1 = 1 AND tage =? <if test="name != null and name !=''">AND name = ?</if> <if test="desc != null and desc !=''">AND desc = ?</if> <if test="teacher != null and teacher !=''">AND teacher = ?</if>
</select>
 ```
```objective-c
<if test="desc != null and desc !=''"></if>
```
> test: Judgment condition, currently only supports! = operation

> Configure the <if></if> tag to put all the fields that need to be judged at the end of the unified judgment writing. In order to ensure the correctness of the SQL statement, add 1 = 1 after the WHERE
> Every <if></if> structure needs to be added with a larger AND
> <if test="desc != null and desc !=''">AND desc = ?</if>

##### <where></where> tag
The where tag eliminates the restriction that the if tag must add 1 = 1 after the WHERE. At the same time, omit AND in each if structure
 ```objective-c
<select id="getEleByObjWhere" resultType="NSDictionary" parameterType="Eletest" resultMap="eletestResult">
SELECT <include refid="eletestSql"></include> FROM eletest <where><if test="name != null and name !=''">name = ?</if> <if test="desc != null and desc !=''">desc = ?</if> <if test="teacher != null and teacher !=''">teacher = ?</if></where>
</select>
```

#### PaintingliteXMLSessionManager common methods
 ```objective-c
 /**
 * Create SessionManager
 * xmlFileName: Each class corresponds to an XML file, and the name of the XML file is passed in
 */
 + (instancetype)buildSesssionManger:(NSString *__nonnull)xmlFileName;
 
 /**
 * Query one
 * methodID: Select ID of XML binding
 * condition: query condition
 */
 -(NSDictionary *)selectOne:(NSString *__nonnull)methodID condition:(id)condition,... NS_REQUIRES_NIL_TERMINATION;
 
 /* Query multiple */
 -(NSArray<id> *)select:(NSString *__nonnull)methodID condition:(id)condition,... NS_REQUIRES_NIL_TERMINATION;
 
 -(NSArray<id> *)select:(NSString *)methodID obj:(id)obj;
 
 /**
 * Insert
 * methodID: INSERT ID bound to XML
 * obj: the inserted object
 */
 -(Boolean)insert:(NSString *)methodID obj:(id)obj;
 
 /**
 * Insert return primary key ID
 * methodID: INSERT ID bound to XML
 * obj: the inserted object
 */
 -(sqlite3_int64)insertReturnPrimaryKeyID:(NSString *)methodID obj:(id)obj;
 
 /**
 * Update
 * methodID: INSERT ID bound to XML
 * obj: the inserted object
 */
 -(Boolean)update:(NSString *)methodID obj:(id)obj;
 
 /**
 * Delete
 * methodID: INSERT ID bound to XML
 * obj: the inserted object
 */
 -(Boolean)del:(NSString *)methodID obj:(id)obj;
```
#### Instance call
 ```objective-c
 PaintingliteXMLSessionManager *xmlSessionM = [PaintingliteXMLSessionManager buildSesssionManger:[[NSBundle mainBundle] pathForResource:@"user" ofType:@"xml"]];
 [xmlSessionM openSqlite:@"sqlite"];

//Inquire
NSLog(@"%@",[xmlSessionM selectOne:@"eletest.getEleById" condition:[NSNumber numberWithInt:1],[NSNumber numberWithInt:21],nil]);
 NSLog(@"%@",[xmlSessionM select:@"eletest.getEleById" condition:[NSNumber numberWithInt:1],[NSNumber numberWithInt:21], nil]);
 
 Eletest *eletest = [[Eletest alloc] init];
 eletest.name = @"CreaterOS";
 eletest.age = [NSNumber numberWithInteger:21];
 eletest.desc = @"CreaterOS";
 eletest.teacher = @"CreaterOS";
 eletest.tage = [NSNumber numberWithInteger:21];
 
 NSLog(@"%zd",[[xmlSessionM select:@"eletest.getEleByObj" obj:eletest] count]);
 NSLog(@"%zd",[[xmlSessionM select:@"eletest.getEleByObjWhere" obj:eletest] count]);
 
 //insert
 [xmlSessionM insert:@"eletest.getInsertEletest" obj:eletest];
 
 NSLog(@"%lu",(unsigned long)[xmlSessionM insertReturnPrimaryKeyID:@"eletest.getInsertUserReturnPrimaryKey" obj:eletest]);
 
 //delete
 [xmlSessionM del:@"eletest.getDeleteUser" obj:eletest];
 [xmlSessionM del:@"eletest.getDeleteEleAuto" obj:eletest];
 
 //Update
 [xmlSessionM update:@"eletest.getUpdateEle" obj:eletest];
```

# Constraint

In order to achieve better operation and comply with database specifications, table names are all lowercase.

### Contribute to this project

If you have a feature request or bug report, please feel free to send [863713745@qq.com](mailto:863713745@qq.com) to upload the problem, and we will provide you with revisions and help as soon as possible. Thank you very much for your support.

### Security Disclosure

If you have found the Paintinglite security vulnerabilities and vulnerabilities that need to be modified, you should email them to [863713745@qq.com](mailto:863713745@qq.com) as soon as possible. thank you for your support.
