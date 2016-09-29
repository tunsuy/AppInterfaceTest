//
//  AsyncConnect.m
//  RunTimeDemo
//
//  Created by tunsuy on 29/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "AsyncConnect.h"
#import "GCDAsyncSocket.h"
#import "AsyncProjectInfInfo.h"
#import "ProtocolDef.h"

@interface AsyncConnect ()<GCDAsyncSocketDelegate>
{
    ProtocolHead protoHead;
}

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong) NSMutableData *buf;

@property (nonatomic, assign) NSInteger recvDataIndex;
@property (nonatomic, strong) NSMutableData *recvData;

@end

@implementation AsyncConnect

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    static AsyncConnect *connect;
    
    dispatch_once(&onceToken, ^{
        connect = [[AsyncConnect alloc] init];
    });
    
    return connect;
}

- (NSMutableData *)buf {
    if (!_buf) {
        _buf = [NSMutableData data];
    }
    return _buf;
}

- (NSMutableData *)recvData {
    if (!_recvData) {
        _recvData = [NSMutableData data];
    }
    return _recvData;
}

- (GCDAsyncSocket *)socket {
    static dispatch_once_t onceToken;
    
    __weak typeof(self) weakself = self;
    dispatch_once(&onceToken, ^{
        dispatch_queue_t dq = dispatch_get_main_queue();
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:(id<GCDAsyncSocketDelegate>)weakself delegateQueue:dq socketQueue:NULL];
    });
    
    return _socket;
}

- (void)connectToHost:(NSString *)host port:(UInt16)port {
    [self.socket connectToHost:host onPort:port error:nil];
}

- (void)sendPacketForNet {
    NSData *infInfoData = [AsyncProjectInfInfo interfaceInfoDataWithProtoHead:&protoHead];
    
    // 添加头部信息
    UInt32 totalLen = (UInt32)(kMinPacketLen + infInfoData.length);
    
    char headBuf[kMinPacketLen];
    char *p = headBuf;
    *((UInt32 *)p) = htonl(totalLen);
    *((UInt16 *)p+4) = htons(protoHead.srv);
    *((UInt32 *)(p+6)) = htonl(protoHead.srvop);
    
    NSMutableData *sendPacket = [NSMutableData dataWithCapacity:totalLen];
    [sendPacket appendBytes:headBuf length:kMinPacketLen];
    [sendPacket appendBytes:infInfoData.bytes length:infInfoData.length];
    
    Byte *sendPacketByte = (Byte *)[sendPacket bytes];
    int j=0;
    for (int i=0; i<[sendPacket length]; i++) {
        printf("sendPacketByte: %d\n", sendPacketByte[i]);
        if (i/(1023*(j+1))) {
            j++;
            printf("==================================\n");
        }
    }
    
    //test
    Byte testByte[] = {115,99,114,105,112,116,111,114,18,4,102,105,108,101,10,21,10,13,71,80,66,68,101,115,99,114,105,112,116,111,114,18,4,102,105,108,101,10,21,10,13,71,80,66,68,101,115,99,114};
    NSData *testData = [[NSData alloc] initWithBytes:testByte length:49];
    NSString *testStr = [[NSString alloc] initWithData:testData encoding:NSUTF8StringEncoding];
    NSLog(@"testStr : %@", testStr);
    
    [self.socket writeData:sendPacket withTimeout:-1 tag:0];

}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data {
    
    NSAssert([sock isEqual:self.socket], nil);

    self.recvDataIndex += data.length;
    [self.recvData appendData:data];
    for (;;) {
        if (self.recvDataIndex >= kMinPacketLen) {
            NSInteger totolLength = [self totalLengthOfPacket:self.recvData];
            NSAssert(totolLength > 0, nil);
            if (self.recvData.length >= totolLength) {// 收到一个完整包
                NSMutableData *totolPacket = [NSMutableData dataWithBytes:self.recvData.bytes length:totolLength];
                [self.recvData replaceBytesInRange:NSMakeRange(0, totolLength) withBytes:NULL length:0];
                self.recvDataIndex -= totolLength;
                
                // get a packet
                // ...
                BOOL result = [self analysisRecvPacketData:totolPacket];
                if (! result) {
                    NSLog(@"Info: err to RecvPacketData");
                    [self asyncDisconnect];
                    break;
                }
                
                //处理服务端返回数据
                NSData *rspData = [self rspDataWithTotalPacket:totolPacket];
                [AsyncProjectInfInfo resultForInterfaceInfoWithData:rspData];
                
                NSAssert(self.recvDataIndex == self.recvData.length, nil);
            }else{
                break;
            }
        }else{
            NSAssert(self.recvData.length <= self.recvDataIndex, nil);
            break;
        }
    }
}

- (NSData *)rspDataWithTotalPacket:(NSData *)totalPacket {
    char *totalPkt = (char *)totalPacket.bytes;
    char *rsp = totalPkt+4+2+4;
    Byte *rspByte = malloc(sizeof(Byte)*strlen(rsp));
    return [NSData dataWithBytes:rspByte length:strlen(rsp)];
}

- (BOOL)analysisRecvPacketData:(NSData *)recvData {
    // 包解析
    char *buf = (char *)recvData.bytes;
    
    NSInteger dataTotolLen = ntohl(*((UInt32 *)(buf)));
//    NSInteger headLen = ntohl(*((UInt32 *)(buf+2+2+4)));
//    headLen > (dataTotolLen - kMinPacketLen)
    if (dataTotolLen != recvData.length) {
        NSLog(@"Error: Invalid packet:%zd - %zd", dataTotolLen, recvData.length);
        return NO;
    }
    return YES;

}

- (void)asyncDisconnect {
    [self.socket disconnect];
}

- (NSInteger)totalLengthOfPacket:(NSData *)orgData
{
    NSAssert(orgData.length >= kMinPacketLen, @"need cale packet length");
    const char *buf = (char *)orgData.bytes;
    NSInteger length = ntohl(*((UInt32 *)buf));
    return length;
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    [self sendPacketForNet];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {
    NSLog(@"Socket did disconnected .....");
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
    [self.socket readDataWithTimeout:-1 buffer:self.buf bufferOffset:0 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
//    NSString *rsp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"Server response data: %@", rsp);
    
    [self socket:sock didReadData:data];
    
//    self.buf = nil;
}

@end
