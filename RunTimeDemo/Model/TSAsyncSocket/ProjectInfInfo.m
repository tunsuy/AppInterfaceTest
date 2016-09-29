//
//  ProjectInfInfo.m
//  RunTimeDemo
//
//  Created by tunsuy on 19/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "ProjectInfInfo.h"
#import "NSObject+TSExtension.h"
#import "Appinftest.pbobjc.h"
#import "Connect.h"

static NSString *host = @"200.200.169.162";
static int port = 8888;

@implementation ProjectInfInfo

+ (void)sendInfInfoForNet {
    PB_IOSInfInfo *infInfo = [[PB_IOSInfInfo alloc] init];
    PB_SendIOSInfReq *req = [[PB_SendIOSInfReq alloc] init];
    req.iOsInfoArray = [NSMutableArray array];
    
    NSArray *infInfoStack = [[[self class] infInfoStack] copy];
    
    [infInfoStack enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[NSDictionary class]]) {
            NSLog(@"bug: %@ not a dictionary type", obj);
        }
        else {
            infInfo.className = obj[@"className"];
            infInfo.methodName = obj[@"methodName"];
            [req.iOsInfoArray addObject:infInfo];
        }
       
    }];
    
    size_t size = [req serializedSize];
    NSMutableData *reqData = [NSMutableData dataWithCapacity:size + sizeof(size)];
//    [reqData writeSize:size];
    [reqData appendData:[req data]];
    
    Connect *con = [[Connect alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        if (![con connectToHost:host port:port]) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^(){
            [con sendDataToServerWithData:reqData resultCallback:^(id result){
                if ([result isKindOfClass:[NSData class]]) {
                    PB_SendIOSInfRsp *rsp = [[PB_SendIOSInfRsp alloc] init];
                    NSString *ret = [[NSString alloc] initWithData:result encoding:kCFStringEncodingUTF8];
                    rsp.result = [ret intValue];
                }
            }];
        });
    });
 
    
}

@end
