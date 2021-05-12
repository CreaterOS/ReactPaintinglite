//
//  PaintingliteExecHeader.h
//  Paintinglite
//
//  Created by Bryant Reyn on 2020/6/3.
//  Copyright © 2020 Bryant Reyn. All rights reserved.
//

#ifndef PaintingliteExecHeader_h
#define PaintingliteExecHeader_h

#define PaintingliteFun(ppDb,pql,EXECNAME)\
({\
    __block NSMutableArray *array = [NSMutableArray array];\
if([EXECNAME isEqualToString: @"execQueryPQL"]){\
    [self execQueryPQL:ppDb pql:pql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {\
        if (success) {\
            array = resObjList;\
        }\
    }];\
}else if([EXECNAME isEqualToString: @"execLikeQueryPQL"]){\
    [self execLikeQueryPQL:ppDb pql:pql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {\
        if (success) {\
        array = resObjList;\
        }\
    }];\
}else if([EXECNAME isEqualToString: @"execLimitQueryPQL"]){\
    [self execLimitQueryPQL:ppDb pql:pql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {\
        if (success) {\
            array = resObjList;\
        }\
    }];\
}else if([EXECNAME isEqualToString: @"execOrderQueryPQL"]){\
    [self execOrderQueryPQL:ppDb pql:pql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {\
        if (success) {\
        array = resObjList;\
        }\
    }];\
}else if([EXECNAME isEqualToString: @"execPQL"]){\
    [self execPQL:ppDb pql:pql completeHandler:^(PaintingliteSessionError * _Nonnull error, Boolean success, NSMutableArray * _Nonnull resArray, NSMutableArray<id> * _Nonnull resObjList) {\
        if (success) {\
        array = resObjList;\
        }\
    }];\
}\
    return array;\
})

#endif /* PaintingliteExecHeader_h */
