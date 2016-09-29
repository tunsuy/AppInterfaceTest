//
//  Connect.m
//  RunTimeDemo
//
//  Created by tunsuy on 18/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "Connect.h"
#import "NetHelper.h"
#import "ProjectInfInfo.h"

#define kBufferSize 1024

@interface Connect ()

@property (nonatomic, weak) TSCallBack callBack;
@property (nonatomic, strong) NSMutableData *totalData;

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, strong) NSOutputStream *outputStream;

@end

@implementation Connect

- (instancetype)init {
    if (self = [super init]) {
        _totalData = [[NSMutableData alloc] init];
        
    }
    return self;
}

- (void)setCallBack:(TSCallBack)callBack {
    if (!_callBack) {
        _callBack = callBack;
    }
}

#pragma mark - 带delegate的方法
/** 需要业务方自己实现NSStream的代理 */
- (void)loadDataFromServerWithDelegate:(id<NSStreamDelegate>)delegate serverDomain:(NSString *)serverDomain port:(int)port resultCallBack:(TSCallBack)callback {
    self.callBack = callback;
    NSString *host = [NetHelper getIPWithHostName:serverDomain];
    [self loadDataFromServerWithDelegate:delegate host:host port:port resultCallBack:callback];
}

- (void)loadDataFromServerWithDelegate:(id<NSStreamDelegate>)delegate host:(NSString *)host port:(int)port resultCallBack:(TSCallBack)callback {
    self.callBack = callback;
    NSInputStream *readStream;
    [self loadDataFromServerWithStream:readStream host:host port:port resultCallBack:callback];
    [readStream setDelegate:delegate];
}

#pragma mark - 不带delegate的方法
/** 不需要业务方实现NSStream的代理 */
- (void)loadDataFromServerWithServerDomain:(NSString *)serverDomain port:(int)port resultCallBack:(TSCallBack)callback {
    self.callBack = callback;
    NSString *host = [NetHelper getIPWithHostName:serverDomain];
    [self loadDataFromServerWithHost:host port:port resultCallBack:callback];
}

- (void)loadDataFromServerWithHost:(NSString *)host port:(int)port resultCallBack:(TSCallBack)callback {
    self.callBack = callback;
    NSInputStream *readStream;
    [self loadDataFromServerWithStream:readStream host:host port:port resultCallBack:callback];
    [readStream setDelegate:self];
}

#pragma mark - NSStreamDelegate
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    NSLog(@" >> NSStreamDelegate in Thread %@", [NSThread currentThread]);
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            NSLog(@"输入输出流打开完成");
            break;
        }
        case NSStreamEventHasBytesAvailable: {
            NSLog(@"有字节可读");
            if (aStream == _inputStream) {
                uint8_t buffer[kBufferSize];
                NSInteger realDataLen;
                while ([_inputStream hasBytesAvailable]) {
                    realDataLen = [_inputStream read:buffer maxLength:kBufferSize];
                    if (realDataLen > 0) {
                        NSData *data = [NSData dataWithBytes:buffer length:realDataLen];
                        [self.totalData appendData:data];
                        //                self.callBack(data);
                    }
                    else if (realDataLen == 0) {
                        NSLog(@">> End of stream");
                    }
                    else {
                        NSLog(@">> Read stream error");
                    }
                }

            }
            break;
        }
        case NSStreamEventHasSpaceAvailable: {
            NSLog(@"可以发送字节");
            if (aStream == _outputStream) {
                [ProjectInfInfo sendInfInfoForNet];
            }
            break;
        }
        case NSStreamEventErrorOccurred: {
            NSLog(@"连接出现错误");
            NSError *error = [(NSInputStream *)aStream streamError];
            NSString *errorInfo = [NSString stringWithFormat:@">> Error while read stream , error:%@ %ld", error.localizedDescription, (long)error.code];
            [self cleanUpStream:aStream];
            self.callBack(errorInfo);
            break;
        }
        case NSStreamEventEndEncountered: {
            NSLog(@"连接结束");
            [self cleanUpStream:aStream];
            self.callBack(self.totalData);
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - private sel
- (void)loadDataFromServerWithStream:(NSStream *)stream host:(NSString *)host port:(int)port resultCallBack:(TSCallBack)callback {
    [NSStream getStreamsToHostWithName:host port:port inputStream:&stream outputStream:NULL];
    [stream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [stream open];
    [[NSRunLoop currentRunLoop] run];
}

- (void)cleanUpStream:(NSStream *)stream {
    [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [stream close];
    stream = nil;
}

- (BOOL)connectToHost:(NSString *)host port:(int)port {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    @try {
        CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)host, port, &readStream, &writeStream);
    } @catch (NSException *exception) {
        NSLog(@"创建连接失败");
        return NO;
    } @finally {
        
    }
    _inputStream = (__bridge NSInputStream *)readStream;
    _outputStream = (__bridge NSOutputStream *)writeStream;
    
    [_inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [_inputStream setDelegate:self];
    [_outputStream setDelegate:self];
    
    [_inputStream open];
    [_outputStream open];
    
    [[NSRunLoop currentRunLoop] run];
    
    return YES;
}

- (void)sendDataToServerWithData:(NSData *)data resultCallback:(TSCallBack)callback {
    NSString *reqData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reqData: %@", reqData);
    
    NSData *test = [@"tets" dataUsingEncoding:NSUTF8StringEncoding];
    
    [_outputStream write:test.bytes maxLength:test.length];
    
    uint8_t buf[kBufferSize];
    
    NSUInteger len = [_inputStream read:buf maxLength:sizeof(buf)];
    NSData *rspData = [NSData dataWithBytes:buf length:len];
    
    callback(rspData);
}

- (NSData *)dataFromServer {
    uint8_t buf[kBufferSize];
    
    NSUInteger len = [_inputStream read:buf maxLength:sizeof(buf)];
    NSData *rspData = [NSData dataWithBytes:buf length:len];
    
    return rspData;
    
}


@end
