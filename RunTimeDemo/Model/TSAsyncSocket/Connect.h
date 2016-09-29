//
//  Connect.h
//  RunTimeDemo
//
//  Created by tunsuy on 18/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TSCallBack)(id result);

@interface Connect : NSObject<NSStreamDelegate>

- (void)loadDataFromServerWithDelegate:(id<NSStreamDelegate>)delegate
                          serverDomain:(NSString *)serverDomain
                                  port:(int)port
                        resultCallBack:(TSCallBack)callback;
- (void)loadDataFromServerWithDelegate:(id<NSStreamDelegate>)delegate
                                  host:(NSString *)host
                                  port:(int)port
                        resultCallBack:(TSCallBack)callback;


- (void)loadDataFromServerWithServerDomain:(NSString *)serverDomain port:(int)port resultCallBack:(TSCallBack)callback;
- (void)loadDataFromServerWithHost:(NSString *)host port:(int)port resultCallBack:(TSCallBack)callback;

- (BOOL)connectToHost:(NSString *)host port:(int)port;
- (void)sendDataToServerWithData:(NSData *)data resultCallback:(TSCallBack)callback;
- (NSData *)dataFromServer;

@end
