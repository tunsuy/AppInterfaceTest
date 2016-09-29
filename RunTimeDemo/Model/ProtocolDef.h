//
//  ProtocolDef.h
//  RunTimeDemo
//
//  Created by tunsuy on 30/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#ifndef ProtocolDef_h
#define ProtocolDef_h

#define kMinPacketLen 4+2+4

//服务码
#define SERVER_APPINF      (0x1) //app接口测试


#define SRVOP_MAKE(srv, op)		(((srv) << 8) | op)


//操作码
#define SRVOP_APPINF_SEND_IOSINF_REQ		SRVOP_MAKE(SERVER_APPINF, 1)
#define SRVOP_APPINF_SEND_IOSINF_RSP		SRVOP_MAKE(SERVER_APPINF, 2)

#endif /* ProtocolDef_h */
