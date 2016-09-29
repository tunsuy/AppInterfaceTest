//
//  hookmsg.c
//  RunTimeDemo
//
//  Created by tunsuy on 17/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#include "hookmsg.h"

#include "fishhook.h"
#include <dlfcn.h>
#include <Foundation/Foundation.h>
#include <objc/runtime.h>

void * (*origin_objc_msgSend)(id self, SEL _cmd, ...);

void save_original_symbols() {
    origin_objc_msgSend = dlsym(RTLD_DEFAULT, "objc_msgSend");
}

void * my_objc_msgSend(id self, SEL _cmd, ...) {
//    NSLog(@"Call class name: %@ ---- method name: %@", self, NSStringFromSelector(_cmd));
//    NSLog(@"--------%@", [NSThread callStackSymbols]);
//    NSLog(@"--------%@", [NSThread callStackReturnAddresses]);

    return origin_objc_msgSend(self, _cmd);
}