# Paintinglite
[![Codacy Badge](https://app.codacy.com/project/badge/Grade/3a263edb5f124ee0a8bc2cdda9e9a334)](https://www.codacy.com/gh/CreaterOS/Paintinglite/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=CreaterOS/Paintinglite&amp;utm_campaign=Badge_Grade)
[![standard-readme compliant](https://img.shields.io/badge/CODEBEAT-2.06GPA-brightgreen.svg?style=message&color=green)]()
[![standard-readme compliant](https://img.shields.io/badge/Emblod-3.73-brightgreen.svg?style=message&color=green)]()
[![Coverage Status](https://coveralls.io/repos/github/CreaterOS/Paintinglite/badge.svg?branch=master)](https://coveralls.io/github/CreaterOS/Paintinglite?branch=master)
[![standard-readme compliant](https://img.shields.io/badge/Paintinglite-CreaterOS-brightgreen.svg?style=CreaterOS&color=blue)](https://github.com/CreaterOS/Paintinglite)
[![standard-readme compliant](https://img.shields.io/badge/platform-ios-brightgreen.svg?style=info&color=orange)](https://github.com/CreaterOS/Paintinglite)
[![Gitter](https://badges.gitter.im/Paintinglite/community.svg)](https://gitter.im/Paintinglite/community?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge)
<a href="https://www.producthunt.com/posts/paintinglite?utm_source=badge-featured&utm_medium=badge&utm_souce=badge-paintinglite" target="_blank"><img src="https://api.producthunt.com/widgets/embed-image/v1/featured.svg?post_id=295761&theme=dark" alt="Paintinglite - SQLite3 lightweight database framework | Product Hunt" style="width: 250px; height: 54px;" width="250" height="54" /></a>

## TODO
v2.2.0 Adjustment method name 

## Introduction

Paintinglite is an excellent and fast Sqlite3 database framework. Paintinglite has good encapsulation of data, fast data insertion characteristics, and can still show good resource utilization for huge amounts of data.
Paintinglite supports object mapping and has carried out a very lightweight object encapsulation on sqlite3. It establishes a mapping relationship between POJOs and database tables. Paintinglite can automatically generate SQL statements and manually write SQL statements to achieve convenient development and efficient querying. All-in-one lightweight framework.

## What's New in Paintinglite

1. Support for ORM operation
2. Customize the PQL syntax for quick queries
3. Support dynamic query
4. Secure thread protection mechanism
5. Support native operation
6. Support for XML configuration operations
7. Support compression, backup, porting MySQL, SQL Server operation
8. Support transaction operations

http://htmlpreview.github.io/?https://github.com/CreaterOS/Paintinglite/blob/master/Paintinglite/PaintingliteWeb/index.html
The detailed API documentation is contained in masterTOC.html in the Paintinglite/PaintingliteWeb directory

## Pod installation
``` objective-c
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MyApp' do
    # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
    use_frameworks!

    # Pods for MyApp2

    pod'Paintinglite', :git =>'https://github.com/CreaterOS/Paintinglite.git'#, :tag => '2.1.3'
end
```
Then install the pods:
```
$ pod install
```
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
 2. Conditional query

> Conditional query syntax rules:
>
> - Subscripts start from 0
>   - Use? As a placeholder for conditional parameters

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

# Constraint

In order to achieve better operation and comply with database specifications, table names are all lowercase.

### Contribute to this project

If you have a feature request or bug report, please feel free to send [863713745@qq.com](mailto:863713745@qq.com) to upload the problem, and we will provide you with revisions and help as soon as possible. Thank you very much for your support.

### Security Disclosure

If you have found the Paintinglite security vulnerabilities and vulnerabilities that need to be modified, you should email them to [863713745@qq.com](mailto:863713745@qq.com) as soon as possible. thank you for your support.
