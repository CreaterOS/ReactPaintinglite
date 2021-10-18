//
//  PaintingliteXMLSessionManager.m
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/7/25.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#import "PaintingliteXMLSessionManager.h"
#import "PaintingliteObjRuntimeProperty.h"
#import "PaintingliteException.h"
#import "PaintingliteJSContext.h"
#import "XMLReader.h"

#define MAPPER @"mapper"
#define NAMESPACE @"namespace"
#define SELECT @"select"
#define DELETE @"delete"
#define INSERT @"insert"
#define UPDATE @"update"
#define SQL @"sql"
#define INCLUDE @"include"
#define IF @"if"
#define WHERE @"where"
#define RESULTMAP @"resultMap"

#define ID @"id"
#define RESULTTYPE @"resultType"
#define PARAMETERTYPE @"parameterType"
#define TEST @"test"
#define TEXT @"text"
#define UESGENERATEDKEYS @"useGeneratedKeys"
#define KEYPROPERTY @"keyProperty"
#define SELECTKEY @"selectKey"
#define ORDER @"order"
#define REFID @"refid"
#define TYPE @"type"
#define RESULT @"result"
#define PROPERTY @"property"
#define COLUMN @"column"

@interface PaintingliteXMLSessionManager()
@property (nonatomic,strong)NSDictionary *xmlDict; //xml结构字典
@end

@implementation PaintingliteXMLSessionManager

#pragma mark - 建立SessionManger
+ (instancetype)buildSesssionManger:(NSString *)xmlFilePath{
    return [[self alloc] initWithXMLFilePath:xmlFilePath];
}

- (instancetype)initWithXMLFilePath:(NSString *__nonnull)xmlFilePath
{
    self = [super init];
    if (self) {
        /* 解析XML文件 */
        self.xmlDict = [self analysisXMLFileContent:xmlFilePath];
    }
    return self;
}

#pragma mark - 查询操作
- (NSDictionary *)selectOne:(NSString *)methodID condition:(id)condition, ...{
    /* 目标字典 */
    __block NSDictionary *orderDict = [NSDictionary dictionary];
    NSString *sqlText = [self analysisXMLDTDMapperStruct:^id(NSDictionary *dict,NSString *idStr) {
        /**
         取出可能是一个SELECT字典数组
         根据XML字典进行分析进行查询
         */
        return [self getSqlText:orderDict methodID:methodID dict:dict idStr:idStr condition:condition];
    } labelType:SELECT methodID:methodID];

    NSString *resultType = [self handleSql:sqlText orderDict:orderDict condition:condition];

    if ([resultType isEqualToString:@"NSDictionary"] || [resultType isEqualToString:@"NSMutableDictionary"]) {
        return [[self execQuerySQL:sqlText] firstObject];
    }else{
        return [self packagingObjUseType:resultType sqlText:sqlText];
    }
}

- (NSArray<id> *)select:(NSString *)methodID condition:(id)condition, ...{
    /* 目标字典 */
    __block NSDictionary *orderDict = [NSDictionary dictionary];
    NSString *sqlText = [self analysisXMLDTDMapperStruct:^NSString *(NSDictionary *dict,NSString *idStr){
        /**
         取出可能是一个SELECT字典数组
         根据XML字典进行分析进行查询
         */
        return [self getSqlText:orderDict methodID:methodID dict:dict idStr:idStr condition:condition];
    } labelType:SELECT methodID:methodID];
    
    NSString *resultType = [self handleSql:sqlText orderDict:orderDict condition:condition];
    
    if ([resultType isEqualToString:@"NSArray"] || [resultType isEqualToString:@"NSMutableArray"]) {
        return [self execQuerySQL:sqlText];
    }else{
        return [self packagingObjUseType:resultType sqlText:sqlText];
    }
}

- (NSArray<id> *)select:(NSString *)methodID obj:(id)obj{
    /* 目标字典 */
    __block NSDictionary *orderDict = [NSDictionary dictionary];
    NSString *sqlText = [self analysisXMLDTDMapperStruct:^NSString *(NSDictionary *dict,NSString *idStr){
        /* 取出可能是一个SELECT字典数组 */
        orderDict = [self orderDictByType:dict methodID:methodID idStr:idStr type:SELECT];
        NSArray *orderKeysArray = [orderDict allKeys];
        
        NSString *sqlText = [NSString string];
        
        if (![orderKeysArray containsObject:PARAMETERTYPE]) {
            /* 没有配置传入参数 */
            [PaintingliteException paintingliteXMLException:[NSString stringWithFormat:@"XML映射文件<select id=\"%@\"></select>配置%@参数",methodID,PARAMETERTYPE] reason:[NSString stringWithFormat:@"调用%s方法必须配置%@参数",__func__,PARAMETERTYPE]];
            return [NSString string];
        }
        
        if ([[PaintingliteObjRuntimeProperty getObjName:obj] isEqualToString:orderDict[PARAMETERTYPE]]) {
            /* 根据XML字典进行分析进行查询 */
            sqlText = [self analysisXMLDTDMapperTEXT:orderDict];
            
            /* 属性值字典 */
            NSMutableDictionary *objPropertyDict = [PaintingliteObjRuntimeProperty getObjPropertyValue:obj];
            
            sqlText = [sqlText stringByAppendingString:[self analysisXMLDTDMapperIFTEXT:orderDict objPropertyDict:objPropertyDict]];
        }else{
            /* 配置文件和传入参数类型不一致 */
            [PaintingliteException paintingliteXMLException:@"修改配置文件传入的类型" reason:[NSString stringWithFormat:@"配置文件[%@]和传入参数[%@]类型不一致",orderDict[PARAMETERTYPE],[obj class]]];
        }
        
        if (![sqlText containsString:@"FROM"]) {
            /* 所有条件不符合 */
            sqlText = [sqlText stringByAppendingString:[NSString stringWithFormat:@"FROM %@",[[PaintingliteObjRuntimeProperty getObjName:obj] lowercaseString]]];
        }
        
        return sqlText;
    } labelType:SELECT methodID:methodID];
    
    /* 配置resultMap */
    if (sqlText.length != 0) {
        NSString *resultType = [self analysis:sqlText orderDict:orderDict];
        
        if ([resultType isEqualToString:@"NSArray"] || [resultType isEqualToString:@"NSMutableArray"]) {
            return [self execQuerySQL:sqlText];
        }else{
            return [self packagingObjUseType:resultType sqlText:sqlText];
        }
    }else{
        return [NSArray array];
    }
}

- (id)packagingObjUseType:(NSString *)resultType sqlText:(NSString *)sqlText {
    if (resultType.length == 0 || !NSClassFromString(resultType)) {
        /* 取出表名 */
        resultType = [[[[[[sqlText uppercaseString] componentsSeparatedByString:@"FROM "] lastObject] componentsSeparatedByString:@" "] firstObject] lowercaseString];
        resultType = [[[resultType substringWithRange:NSMakeRange(0, 1)] uppercaseString] stringByAppendingString:[resultType substringFromIndex:1]];
    }
    
    /* 生成对象封装 */
    return [[self execQuerySQL:sqlText obj:NSClassFromString(resultType)] firstObject];
}

- (NSString *)getSqlText:(NSDictionary *)orderDict methodID:(NSString *)methodID dict:(NSDictionary *)dict idStr:(NSString *)idStr condition:(id)condition, ...{
    orderDict = [self orderDictByType:dict methodID:methodID idStr:idStr type:SELECT];
    NSString *sqlText = [self analysisXMLDTDMapperTEXT:orderDict];;
    
    if ([sqlText containsString:@"?"]) {
        NSRange range = [sqlText rangeOfString:@"?"];
        sqlText = [sqlText stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%@",condition]];
    }
    
    return sqlText;
}

- (NSString *)handleSql:(NSString *__nonnull)sqlText orderDict:(NSDictionary *)orderDict condition:(id)condition, ...  {
    if (sqlText.length != 0) {
        /* sql语句处理#{} */
        /* 获得可变参数列表 */
        id str;
        va_list list;
        va_start(list, condition);
        while((str = va_arg(list, id))){
            /* 获得参数 */
            if ([sqlText containsString:@"?"]) {
                NSRange range = [sqlText rangeOfString:@"?"];
                sqlText = [sqlText stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%@",str]];
            }
        }
        va_end(list);
        
        return [self analysis:sqlText orderDict:orderDict];
    }else{
        return NULL;
    }
}

- (NSString *)analysis:(NSString *)sqlText orderDict:(NSDictionary *)orderDict {
    /* ResultMap */
    sqlText = [self analysisResultMap:sqlText orderDict:orderDict];
    
    NSLog(@"%@",sqlText);
    
    /* 获得期望返回值类型 */
    NSString *resultType = [NSString string];
    if ([[orderDict allKeys] containsObject:RESULTTYPE]) {
        resultType = orderDict[RESULTTYPE];
    }
    
    return resultType;
}

#pragma mark - 插入操作
- (Boolean)insert:(NSString *)methodID obj:(id)obj{
    /* 目标字典 */
    __block NSDictionary *orderDict = [NSDictionary dictionary];
    NSString *sqlText = [self analysisXMLDTDMapperStruct:^id(NSDictionary *dict,NSString *idStr) {
        /* 从dict中取出insert字典 */
        orderDict = [self orderDictByType:dict methodID:methodID idStr:idStr type:INSERT];
        
        /* 目标字典取出传入参数类型,检查配置参数类型是否相符 */
        if ([[orderDict allKeys] containsObject:PARAMETERTYPE]) {
            NSString *parameterType = orderDict[PARAMETERTYPE];
            if ([parameterType isEqualToString:[PaintingliteObjRuntimeProperty getObjName:obj]]) {
                /* 属性值字典 */
                NSMutableDictionary *objPropertyDict = [PaintingliteObjRuntimeProperty getObjPropertyValue:obj];
                NSMutableDictionary *objPropertyType = [PaintingliteObjRuntimeProperty getObjPropertyType:obj];
                
                /* 配置文件和传入参数类型一致 */
                /* sql语句 */
                NSString *sqlText = [self analysisXMLDTDMapperTEXT:orderDict];
                
                if (![sqlText isEqualToString:@"?"]) {
                    /* 处理sql语句 */
                    /*INSERT INTO user (username,birthday,sex,address) VALUES (#{username}, #{birthday},#{sex}, #{address}) */
                    /* 插入语句前半部分保留 */
                    NSArray *splitInsertSqlStr = [sqlText componentsSeparatedByString:@"VALUES"];
                    NSString *frontInsertSqlStr = [splitInsertSqlStr firstObject];
                    NSString *behindInsertSqlStr = [splitInsertSqlStr lastObject];
                    
                    /* 处理后半部分插入语句 */
                    /* (#username,#birthday,#sex,#address) */
                    NSArray<NSString *> *insertValueArray;
                    
                    /* XML映射文件语句分号处理 */
                    if ([sqlText containsString:@";"]) {
                        insertValueArray = [[behindInsertSqlStr substringWithRange:NSMakeRange(2, behindInsertSqlStr.length-4)] componentsSeparatedByString:@","];
                    }else{
                        insertValueArray = [[behindInsertSqlStr substringWithRange:NSMakeRange(2, behindInsertSqlStr.length-3)] componentsSeparatedByString:@","];
                    }
                    
                    for (NSString *subStr in insertValueArray) {
                        if([subStr containsString:@"#"]){
                            NSString *propertyStr = [subStr substringFromIndex:1];
                            if ([objPropertyType[propertyStr] isEqualToString:@"@\"NSString\""]) {
                                behindInsertSqlStr = [behindInsertSqlStr stringByReplacingOccurrencesOfString:subStr withString:[NSString stringWithFormat:@"'%@'",objPropertyDict[propertyStr]]];
                            }else{
                                behindInsertSqlStr = [behindInsertSqlStr stringByReplacingOccurrencesOfString:subStr withString:[NSString stringWithFormat:@"%@",objPropertyDict[propertyStr]]];
                            }
                        }
                    }
                    
                    sqlText = [frontInsertSqlStr stringByAppendingString:[NSString stringWithFormat:@"VALUES%@",behindInsertSqlStr]];
                    return sqlText;
                }else{
                    return [NSString string];
                }
            }else{
                /* 配置文件和传入参数类型不一致 */
                [PaintingliteException paintingliteXMLException:@"修改配置文件传入的类型" reason:[NSString stringWithFormat:@"配置文件[%@]和传入参数[%@]类型不一致",parameterType,[obj class]]];
                return [NSString string];
            }
        }
        
        return [NSString string];
    } labelType:INSERT methodID:methodID];

    /* 打印SQL语句 */
    NSLog(@"%@",sqlText);
    
    /* 执行插入语句 */
    return (sqlText.length != 0) ? [self insert:sqlText] : [self insertWithObj:obj completeHandler:nil];
}

#pragma mark - 插入返回主键ID
- (sqlite3_int64)insertReturnPrimaryKeyID:(NSString *)methodID obj:(id)obj{
    NSDictionary *orderDict = [self orderDictByType:self.xmlDict methodID:methodID idStr:[NSString string] type:INSERT];
    NSArray *orderKeysArray = [orderDict allKeys];
    if([orderKeysArray containsObject:UESGENERATEDKEYS] && [orderDict[UESGENERATEDKEYS] isEqualToString:@"true"] && [orderKeysArray containsObject:KEYPROPERTY] && [orderDict[KEYPROPERTY] isEqualToString:@"ID"]){
        [self insert:methodID obj:obj];
        return sqlite3_last_insert_rowid([self getSqlite3]);
    }else{
        if ([orderKeysArray containsObject:SELECTKEY]) {
            NSDictionary *selectKeyDict = orderDict[SELECTKEY];
            NSArray *selectKeysArray = [selectKeyDict allKeys];
            
            if (selectKeyDict != nil) {
                if ([selectKeysArray containsObject:KEYPROPERTY] && [selectKeyDict[KEYPROPERTY] isEqualToString:@"ID"]) {
                    /* 配置了SELECTKEY */
                    NSString *execTime = [selectKeysArray containsObject:ORDER] ? selectKeyDict[ORDER] : @"";
                    NSString *text = [selectKeysArray containsObject:TEXT] ? selectKeyDict[TEXT] : @"";
                    if ([execTime isEqualToString:@"AFTER"]) {
                        /* 后执行 */
                        [self insert:methodID obj:obj];
                        return sqlite3_last_insert_rowid([self getSqlite3]);
                    }else{
                        /* 先执行 */
                        if ([text isEqualToString:@"SELECT LAST_INSERT_ID();"] || [text isEqualToString:[@"SELECT LAST_INSERT_ID();" lowercaseString]]) {
                            sqlite3_int64 lastRowID = sqlite3_last_insert_rowid([self getSqlite3]);
                            
                            /* 执行插入 */
                            [self insert:methodID obj:obj];
                            
                            return lastRowID;
                        }
                    }
                }
            }
        }
    }

    return 0;
}

#pragma mark - 更新操作
- (Boolean)update:(NSString *)methodID obj:(id)obj{
    NSString *sqlText = [self analysisXMLDTDMapperStruct:^id(NSDictionary *dict, NSString *idStr) {
        /* 目标字典 */
        NSDictionary *orderDict = [self orderDictByType:dict methodID:methodID idStr:idStr type:UPDATE];
        NSString *parameterType = [[orderDict allKeys] containsObject:PARAMETERTYPE] ? orderDict[PARAMETERTYPE] : @"";
        NSString *sqlText = [self analysisXMLDTDMapperTEXT:orderDict];
        
        /* 分号处理 */
        if ([sqlText containsString:@";"]) {
            sqlText = [sqlText stringByReplacingOccurrencesOfString:@";" withString:@""];
        }else{
            sqlText = sqlText;
        }
        
        NSMutableDictionary *objPropertyValueDict = [PaintingliteObjRuntimeProperty getObjPropertyValue:obj];
        
        /* 判断传参类型和配置文件给定类型是否相同 */
        if ([[PaintingliteObjRuntimeProperty getObjName:obj] isEqualToString:parameterType]) {
            if (![sqlText isEqualToString:@"?"]) {
                /* 处理更新语句 */
                NSMutableArray<NSString *> *sqlTextArray = [[NSMutableArray alloc] initWithArray:[sqlText componentsSeparatedByString:@" "]];
                
                NSUInteger count = sqlTextArray.count;
                for (NSUInteger i = 0; i < count; ++i) {
                    NSString *str = sqlTextArray[i];
                    /* 去除分号 */
                    if ([str containsString:@"#"]) {
                        /* 占位字符串处理 */
                        id place = objPropertyValueDict[[str substringFromIndex:1]];
                        
                        if ([place isKindOfClass:[NSString class]]) {
                            [sqlTextArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"\"%@\"",place]];
                        }else{
                            [sqlTextArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@",place]];
                        }
                    }
                }
                
                /* 拼接 */
                sqlText = [sqlTextArray componentsJoinedByString:@" "];
            }
        }
        
        
        return sqlText;
    } labelType:UPDATE methodID:methodID];
    
    /* 打印SQL语句 */
    NSLog(@"%@",sqlText);
    
    return [self update:sqlText];
}

#pragma mark - 删除操作
- (Boolean)del:(NSString *)methodID obj:(id)obj{
   NSString *sqlText = [self analysisXMLDTDMapperStruct:^id(NSDictionary *dict, NSString *idStr) {
        /* 获得目标字典 */
       NSDictionary *orderDict = [self orderDictByType:dict methodID:methodID idStr:idStr type:DELETE];
       
       /* 目标字典获取传入类型 */
       NSString *parameterType = [[orderDict allKeys] containsObject:PARAMETERTYPE] ? orderDict[PARAMETERTYPE] : @"";
       NSString *sqlText = [self analysisXMLDTDMapperTEXT:orderDict];
       
       /* 判断传参类型和配置文件类型相同 */
       if ([[PaintingliteObjRuntimeProperty getObjName:obj] isEqualToString:parameterType]) {
           NSMutableDictionary *objPropertyValueDict = [PaintingliteObjRuntimeProperty getObjPropertyValue:obj];
           if ([sqlText isEqualToString:@"?"]) {
               /* 自动填充删除语句 */
               NSString *frontDelSqlText = [NSString stringWithFormat:@"DELETE FROM %@ WHERE ",[[PaintingliteObjRuntimeProperty getObjName:obj] lowercaseString]];
               NSString *behindDelSqlText;
               
               /* obj配置了哪些值就作为删除条件 */
               behindDelSqlText = [[NSString alloc] initWithData: [NSJSONSerialization dataWithJSONObject:objPropertyValueDict options:0 error:0] encoding:NSUTF8StringEncoding];
               
               if ([objPropertyValueDict allKeys].count > 1) {
                   /* 含有多个条件 */
                   behindDelSqlText = [[behindDelSqlText substringWithRange:NSMakeRange(1, behindDelSqlText.length-2)] stringByReplacingOccurrencesOfString:@"," withString:@" AND "];
                   NSArray<NSString *> *separatedArray = [behindDelSqlText componentsSeparatedByString:@" AND "];
                   
                   NSString *tempStr = [NSString string];
                   NSUInteger count = separatedArray.count;
                   NSUInteger i = 0;
                   for (NSString *str in separatedArray) {
                       NSArray<NSString *> *strArray = [str componentsSeparatedByString:@":"];
                       /* 取出冒号前半部分双引号 */
                       tempStr = (i < count - 1) ? [[tempStr stringByAppendingString:[[[strArray firstObject] stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByAppendingString:[NSString stringWithFormat:@" = %@",[strArray lastObject]]]] stringByAppendingString:@" AND "] : [tempStr stringByAppendingString:[[[strArray firstObject] stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByAppendingString:[NSString stringWithFormat:@" = %@",[strArray lastObject]]]];
                       i++;
                   }
                   
                   behindDelSqlText = tempStr;
               }else{
                   /* 含有一个条件 */
                   NSArray<NSString *> *separatedArray = [behindDelSqlText componentsSeparatedByString:@":"];
                   behindDelSqlText = [[[separatedArray firstObject] stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByAppendingString:[NSString stringWithFormat:@" = %@",[separatedArray lastObject]]];
                   behindDelSqlText = [behindDelSqlText substringWithRange:NSMakeRange(1, behindDelSqlText.length-2)];
               }
               
               sqlText = [[frontDelSqlText stringByAppendingString:behindDelSqlText] stringByAppendingString:@";"];
               
           }else{
               /* 处理sqlText语句 */
               /* DELETE FROM eletest WHERE name = #name; */
               NSArray<NSString *> *subSqlTextArray = [sqlText componentsSeparatedByString:@"WHERE"];
               /* sqlText前半部分 */
               /* DELETE FROM eletest WHERE */
               NSString *frontSqlText = [subSqlTextArray firstObject];
               /* sqlText后半部分 */
               /* name = #name and teacher = #teacher; */
               NSString *behindSqlText = [subSqlTextArray lastObject];
               
               /* 处理后半部分sqlText */
               /* 包含占位字符串 */
               NSArray *whiteSeparatedArray = [behindSqlText componentsSeparatedByString:@" "];
               for (NSString *str in whiteSeparatedArray) {
                   if ([str containsString:@"#"]) {
                       /* 对占位符进行处理 */
                       NSString *placeStr;
                       if ([str containsString:@";"]) {
                           /* 分号处理 */
                           placeStr = [str substringWithRange:NSMakeRange(1, str.length-2)];
                       }else{
                           placeStr = [str substringFromIndex:1];
                       }
                       
                       /* 根据占位字符串从obj中取出值 */
                       id place = objPropertyValueDict[placeStr];
                       if ([place isKindOfClass:[NSString class]]) {
                           behindSqlText = [behindSqlText stringByReplacingOccurrencesOfString:str withString:[NSString stringWithFormat:@"\"%@\"",place]];
                       }else{
                           behindSqlText = [behindSqlText stringByReplacingOccurrencesOfString:str withString:[NSString stringWithFormat:@"%@",place]];
                       }     
                   }
               }
               
               sqlText = [[[frontSqlText stringByAppendingString:@"WHERE"] stringByAppendingString:behindSqlText] stringByAppendingString:@";"];
           }
       }else{
           /* 配置文件和传入参数类型不一致 */
           [PaintingliteException paintingliteXMLException:@"修改配置文件传入的类型" reason:[NSString stringWithFormat:@"配置文件[%@]和传入参数[%@]类型不一致",parameterType,[obj class]]];
           return [NSString string];
       }
       
       return sqlText;
    } labelType:DELETE methodID:methodID];
    
    /* 打印SQL语句 */
    NSLog(@"%@",sqlText);
    
    /* 执行删除语句 */
    return [self del:sqlText];
}

#pragma mark - XML解析TEXT
- (NSString *)analysisXMLDTDMapperTEXT:(NSDictionary *__nonnull)orderDict{
    NSString *sqlText = [NSString string];
    /* 目标字典 -- TEXT */
    /* INCLUDE标签 */
    if ([[orderDict allKeys] containsObject:INCLUDE] && [[orderDict[INCLUDE] allKeys] containsObject:REFID] && [[self.xmlDict[MAPPER] allKeys] containsObject:SQL]) {
        NSDictionary *includeDict = orderDict[INCLUDE];
        /* 取出refid */
        NSString *refidStr = includeDict[REFID];
        /* 取出文本 */
        NSString *includeText = includeDict[TEXT];
        
        /* 根据MAPPER下的SQL取出SQL片段 */
        NSDictionary *sqlDict = self.xmlDict[MAPPER][SQL];
       
        if (sqlDict != nil) {
            /* 取出sql片段文本,绑定ID */
            NSString *sqlID = [[sqlDict allKeys] containsObject:ID] ? sqlDict[ID] : @"";
            NSString *str = [[sqlDict allKeys] containsObject:TEXT] ? sqlDict[TEXT] : @"";
            
            /* 判断sql片段绑定ID和include绑定的ID相等 */
            if ([refidStr isEqualToString:sqlID]) {
                /* 拼接sql语句 */
                sqlText = [[[sqlText stringByAppendingString:includeText] stringByAppendingString:[NSString stringWithFormat:@" %@ ",str]] stringByAppendingString:orderDict[TEXT]];
            }
        }
    }else{
        sqlText = orderDict[TEXT];
    }
    
    return sqlText;
}

- (NSString *)analysisXMLDTDMapperIFTEXT:(NSDictionary *__nonnull)orderDict objPropertyDict:(NSMutableDictionary *__nonnull)objPropertyDict{
    NSString *sqlText = [NSString string];
    /* IF字典,字典数组 */
    id ifStruct;
    
    /* where标签存在性 */
    if ([self isWhereLabelExists:orderDict]) {
        /* 存在WHERE标签 */
        if ([[orderDict[WHERE] allKeys] containsObject:IF]) {
            ifStruct = orderDict[WHERE][IF];
        }else{
            return sqlText;
        }
    }else{
        /* 不存在WHERE标签 */
        /* IF标签 */
        if ([[orderDict allKeys] containsObject:IF]) {
            ifStruct = orderDict[IF];
        }else{
            return sqlText;
        }
    }
    
    /* ifStruct类型 */
    if ([ifStruct isKindOfClass:[NSDictionary class]]) {
        /* 单个字典 */
        sqlText = [self analysisIfDict:ifStruct objPropertyDict:objPropertyDict sqlText:sqlText orderDict:orderDict];
    }else{
        /* 数组 */
        for (NSDictionary *dict in ifStruct) {
            sqlText = [self analysisIfDict:dict objPropertyDict:objPropertyDict sqlText:sqlText orderDict:orderDict];
        }
    }

    return [sqlText stringByAppendingString:orderDict[TEXT]];
}

- (NSString *)analysisIfDict:(NSDictionary *__nonnull)dict objPropertyDict:(NSMutableDictionary *__nonnull)objPropertyDict sqlText:(NSString *__nonnull)sqlText orderDict:(NSDictionary *__nonnull)orderDict{
    NSString *condition = dict[TEST];
    
    NSString *conditionStr = [[dict[TEST] componentsSeparatedByString:@" "] firstObject];
    
    NSArray<NSString *> *dictArray;
    Boolean flag = [self isWhereLabelExists:orderDict];
    dictArray = flag ? [dict[TEXT] componentsSeparatedByString:[NSString stringWithFormat:@" %@ ",[orderDict[PARAMETERTYPE] lowercaseString]]] : [dict[TEXT] componentsSeparatedByString:[NSString stringWithFormat:@" AND %@",conditionStr]];
    
    NSString *frontStr = [dictArray firstObject];
    NSString *behindStr = [dictArray lastObject];

    if (flag && dictArray.count > 1) {
        /* where标签存在,字符串的处理 */
        /* dictArray前半部分 -- 追加表名&WHERE */
        frontStr = [frontStr stringByAppendingString:[NSString stringWithFormat:@" %@ WHERE ",[orderDict[PARAMETERTYPE] lowercaseString]]];
    }else if(flag && (dictArray.count == 1)) {
        frontStr = [@"AND " stringByAppendingString:frontStr];
    }
  
    //递归调用
    NSString *resStr = (dictArray.count > 1 && !flag) ? [[self replaceStr:frontStr objPropertyDict:objPropertyDict] stringByAppendingString:@" AND "] : [self replaceStr:frontStr objPropertyDict:objPropertyDict];
    
    /* 目标字典获得赋值给value */
    id value = objPropertyDict[conditionStr];
    
    NSString *tempCondition = [condition stringByReplacingOccurrencesOfString:conditionStr withString:@"value"];
    if ([tempCondition containsString:@"and"]) {
        tempCondition = [tempCondition stringByReplacingOccurrencesOfString:@"and" withString:@"&&"];
    }else if([tempCondition containsString:@"or"]){
        tempCondition = [tempCondition stringByReplacingOccurrencesOfString:@"and" withString:@"||"];
    }
    
    /* JS脚本 */
    PaintingliteJSContext *context = [[PaintingliteJSContext alloc] init];
    //获得结果返回值
    [context evaluateScript:[NSString stringWithFormat:@"var value = '%@'",value]];
    [context evaluateScript:[NSString stringWithFormat:@"var flag = function(value){ return %@; }",tempCondition]];
    JSValue *flagValue = [context evaluateScript:[NSString stringWithFormat:@"flag(value)"]];
    
    if ([flagValue toBool]) {
        /* IF标签成立 */
        NSString *sql;

        NSString *lastStr = (dictArray.count > 1) ? (flag ? behindStr : [[NSString stringWithFormat:@"%@",conditionStr] stringByAppendingString:behindStr]) : @"";
        
        if ([value isKindOfClass:[NSString class]]) {
            sql = [resStr stringByAppendingString:[lastStr stringByReplacingOccurrencesOfString:@"?" withString:[NSString stringWithFormat:@"\"%@\"",value]]];
        }else{
            sql = [resStr stringByAppendingString:[lastStr stringByReplacingOccurrencesOfString:@"?" withString:[NSString stringWithFormat:@"%@",value]]];
        }
        
        sqlText = [sqlText stringByAppendingString:[NSString stringWithFormat:@"%@ ",sql]];
    }
    
    return sqlText;
}

- (NSString *)analysisResultMap:(NSString *__nonnull)sqlText orderDict:(NSDictionary *__nonnull)orderDict{
    /* resultMap配置查询字段 */
    NSString *resSqlText = sqlText;
    
    NSDictionary *dict = self.xmlDict;
    if ([[dict[MAPPER] allKeys] containsObject:RESULTMAP]){
        /* 从resSqlText截取查询字段 */
        NSString *fieldsStr = [[[[resSqlText componentsSeparatedByString:@" FROM"] firstObject] componentsSeparatedByString:@" "] lastObject];
        NSString *tempFieldsStr = fieldsStr;
        
        if (![fieldsStr isEqualToString:@"*"]) {
            NSDictionary *resultMapDict = dict[MAPPER][RESULTMAP];
            /* resultMap -- TYPE */
            NSString *resultMapType = resultMapDict[TYPE];
            /* resultMap -- ID */
            NSString *resultMapID = resultMapDict[ID];
            
            /* 查看传入的类型存在 */
            if ([PaintingliteObjRuntimeProperty ObjNameExists:resultMapType]) {
                /* resultMap -- result */
                id resultStruct = resultMapDict[RESULT];
                
                if ([resultStruct isKindOfClass:[NSDictionary class]]) {
                    /* 字典 */
                    tempFieldsStr = [self replaceFieldsStr:resultStruct fieldsStr:tempFieldsStr];
                }else{
                    /* 数组 */
                    for (NSDictionary *dict in resultStruct) {
                        tempFieldsStr = [self replaceFieldsStr:dict fieldsStr:tempFieldsStr];
                    }
                }
            }else{
                [PaintingliteException paintingliteXMLException:[NSString stringWithFormat:@"请在项目中创建[%@]类",resultMapType] reason:[NSString stringWithFormat:@"XML配置文件type类型[%@]未在项目中声明",resultMapType]];
            }

            /* 替换原有字符串 */
            if ([resultMapID isEqualToString:orderDict[RESULTMAP]]) {
                resSqlText = [resSqlText stringByReplacingOccurrencesOfString:fieldsStr withString:tempFieldsStr];
            }
        }
    }
    
    return resSqlText;
}

#pragma mark - 递归替代
- (NSString *)replaceStr:(NSString *__nonnull)resStr objPropertyDict:(NSMutableDictionary *__nonnull)objPropertyDict{
    /* 替代前半部分的？ */
    if ([resStr containsString:@"?"]){
        NSString *conditionStr = [[[[resStr componentsSeparatedByString:@" = ?"] firstObject] componentsSeparatedByString:@" "] lastObject];
        
        id value = objPropertyDict[conditionStr];
        NSRange range = [resStr rangeOfString:@"?"];
        
        if ([value isKindOfClass:[NSString class]]) {
            resStr = [resStr stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"\"%@\"",value]];
        }else{
            resStr = [resStr stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%@",value]];
        }

        resStr = [self replaceStr:resStr objPropertyDict:objPropertyDict];
    }
    
    return resStr;
}

#pragma mark - 字段替代
- (NSString *)replaceFieldsStr:(NSDictionary *__nonnull)dict fieldsStr:(NSString *__nonnull)fieldsStr{
    /* property */
    NSString *resProperty = dict[PROPERTY];
    /* column */
    NSString *resColumn = dict[COLUMN];
    
    /* 不相等修改 */
    if (![resProperty isEqualToString:resColumn]) {
        /* 修改 */
        fieldsStr = [fieldsStr stringByReplacingOccurrencesOfString:resColumn withString:[NSString stringWithFormat:@"%@ as %@",resColumn,resProperty]];
    }
    
    return fieldsStr;
}

#pragma mark - 目标字典
- (NSDictionary *)orderDictByType:(NSDictionary *__nonnull)dict methodID:(NSString *__nonnull)methodID idStr:(NSString *__nonnull)idStr type:(NSString *__nonnull)type{
    /* idStr长度为0时候 */
    if (idStr.length == 0) {
        if ([methodID containsString:@"."]){
            if([[[methodID componentsSeparatedByString:@"."] firstObject] isEqualToString:dict[MAPPER][NAMESPACE]]){
                idStr = [[methodID componentsSeparatedByString:@"."] lastObject];
            }else{
                /* 命名空间错误 */
                [PaintingliteException paintingliteXMLException:@"提供的的ID限定与XML Mapper namespace不相符" reason:@"XML Mapper namespace error"];
            }
        } else{
            idStr = methodID;
        }
    }
    
    NSDictionary *orderDict = [NSDictionary dictionary];
    /* 从dict中取出insert字典 */
    if (![dict[MAPPER][type] isKindOfClass:[NSDictionary class]] || ![dict[MAPPER][type] isKindOfClass:[NSMutableDictionary class]]){
        //字典数组
        /* 遍历找到绑定方法的ID */
        for (NSDictionary *tempDict in dict[MAPPER][type]) {
            if ([[tempDict allValues] containsObject:idStr]) {
                orderDict = tempDict;
                break;
            }
        }
    }else{
        //一个字典
        orderDict = dict[MAPPER][type];
    }
    
    return orderDict;
}

#pragma mark - 判断where标签
- (Boolean)isWhereLabelExists:(NSDictionary *__nonnull)orderDict{
    return [[orderDict allKeys] containsObject:WHERE];
}

#pragma mark - 解析XMLMapper结构
- (NSString *)analysisXMLDTDMapperStruct:(id (^)(NSDictionary *dict,NSString *idStr))mapperBlock labelType:(NSString *__nonnull)labelType methodID:(NSString *__nonnull)methodID{
    /* 获得解析dict */
    NSDictionary *dict = self.xmlDict;
    /* 取出MAPPER标签下的内容,查看是否有SELECT标签 */
    if ([[dict[MAPPER] allKeys] containsObject:labelType]){
        NSString *idStr = [NSString string];
        if ([methodID containsString:@"."]){
            if([[[methodID componentsSeparatedByString:@"."] firstObject] isEqualToString:dict[MAPPER][NAMESPACE]]){
                idStr = [[methodID componentsSeparatedByString:@"."] lastObject];
            }else{
                /* 命名空间错误 */
                [PaintingliteException paintingliteXMLException:@"提供的的ID限定与XML Mapper namespace不相符" reason:@"XML Mapper namespace error"];
            }
        } else{
            idStr = methodID;
        }
        
        //执行mapperBlock
        if (mapperBlock != nil) {
            return mapperBlock(dict,idStr);
        }
    }else{
        [PaintingliteException paintingliteXMLException:[NSString stringWithFormat:@"请检查XML配置文件是否配置%@标签",labelType] reason:[NSString stringWithFormat:@"无法找到%@标签",labelType]];
    }
    
    return [NSString string];
}

#pragma mark - 解析XML文件
- (NSDictionary *)analysisXMLFileContent:(NSString *__nonnull)xmlFileName{
    NSError *error = nil;
    
    return [XMLReader dictionaryForXMLString:[[NSString alloc] initWithContentsOfFile:xmlFileName encoding:NSUTF8StringEncoding error:&error] error:&error];
}

@end
