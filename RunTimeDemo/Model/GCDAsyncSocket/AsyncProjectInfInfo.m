//
//  AsyncProjectInfInfo.m
//  RunTimeDemo
//
//  Created by tunsuy on 29/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "AsyncProjectInfInfo.h"
#import "NSObject+TSExtension.h"
#import "Appinftest.pbobjc.h"
#import "ProtocolDef.h"
#import "GPBDescriptor.h"

@implementation AsyncProjectInfInfo

+ (NSData *)interfaceInfoDataWithProtoHead:(ProtocolHead *)protoHead {
    
//    PB_IOSInfInfo *infInfo = [[PB_IOSInfInfo alloc] init];
    PB_SendIOSInfReq *req = [[PB_SendIOSInfReq alloc] init];
    req.iOsInfoArray = [NSMutableArray array];
    
    NSArray *infInfoStack = [[[self class] infInfoStack] copy];
    
    [infInfoStack enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"bug: %@ not a dictionary type", obj);
        }
        else {
            PB_IOSInfInfo *infInfo = [[PB_IOSInfInfo alloc] init];
            infInfo.className = obj[@"className"];
            infInfo.methodName = obj[@"methodName"];
            [req.iOsInfoArray addObject:infInfo];
        }
        
    }];
    
    size_t size = [req serializedSize];
    NSMutableData *reqData = [NSMutableData dataWithCapacity:size + sizeof(size)];
    [reqData appendData:[req data]];
    
    protoHead->srv = SERVER_APPINF;
    protoHead->srvop = SRVOP_APPINF_SEND_IOSINF_REQ;
    
    return reqData;
}

+ (void)resultForInterfaceInfoWithData:(NSData *)data {
    char *len = (char *)[data bytes];
    char *ept = "";
//    NSInteger headLen = *((UInt32 *)len);
    if (strcmp(len, ept) == 0) {
        NSLog(@"服务端返回成功。。。");
        return;
    }
    NSError *err = nil;
    PB_SendIOSInfRsp *rsp = [PB_SendIOSInfRsp parseFromData:data error:&err];
    if (err) {
        NSLog(@"proto反序列化失败，err: %@", err);
    }
    int32_t rst = rsp.result;
    if (rst < 0) {
        NSLog(@"服务端返回错误。。");
        return;
    }
    NSLog(@"服务端返回成功。。。");
}

@end
