//
//  AsyncProjectInfInfo.h
//  RunTimeDemo
//
//  Created by tunsuy on 29/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncConnect.h"

@interface AsyncProjectInfInfo : NSObject

+ (NSData *)interfaceInfoDataWithProtoHead:(ProtocolHead *)protoHead;
+ (void)resultForInterfaceInfoWithData:(NSData *)data;

@end
