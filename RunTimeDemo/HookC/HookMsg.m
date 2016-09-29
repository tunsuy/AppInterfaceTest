//
//  HookMsg.m
//  RunTimeDemo
//
//  Created by tunsuy on 17/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "HookMsg.h"

//void save_original_symbols() {
//    orig_objc_msgSend = dlsym(RTLD_DEFAULT, "objc_msgSend");
//}

//void my_objc_msgSend(id self, SEL _cmd, ...) {
//    NSLog(@"Call class name: %@ ---- method name: %@", self, NSStringFromSelector(_cmd));
//    NSLog(@"--------%@", [NSThread callStackSymbols]);
//    NSLog(@"--------%@", [NSThread callStackReturnAddresses]);
//    
//    orig_objc_msgSend(self, _cmd);
//}

@implementation HookMsg

@end
