//
//  AsyncConnect.h
//  RunTimeDemo
//
//  Created by tunsuy on 29/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct ProtocolHead {
    UInt32 length;
    UInt16 srv;
    UInt32 srvop;
    UInt16 flag;
}ProtocolHead;

@interface AsyncConnect : NSObject

+ (instancetype)shareInstance;
- (void)connectToHost:(NSString *)host port:(UInt16)port;

@end
