//
//  NSObject+TSExtension.m
//  MOA
//
//  Created by tunsuy on 12/7/16.
//  Copyright © 2016年 moa. All rights reserved.
//

#import "NSObject+TSExtension.h"
#import "fishhook.h"
#import <dlfcn.h>
#import <objc/runtime.h>

//id (*origin_objc_msgSend)(id self, SEL _cmd, ...);
//
//void save_original_symbols() {
//    origin_objc_msgSend = dlsym(RTLD_DEFAULT, "objc_msgSend");
//}
//
//id my_objc_msgSend(id self, SEL _cmd, ...) {
//    NSLog(@"Call class name: %@ ---- method name: %@", self, NSStringFromSelector(_cmd));
//    NSLog(@"--------%@", [NSThread callStackSymbols]);
//    NSLog(@"--------%@", [NSThread callStackReturnAddresses]);
//    
//    return origin_objc_msgSend(self, _cmd);
//}

@implementation NSObject (TSExtension)

//+ (void)ts_swizzleMethodWithOriginSel:(SEL)originSel swizzleSel:(SEL)swizzleSel {
//    Method originMethod = class_getClassMethod([self class], originSel);
//    Method swizzleMethod = class_getClassMethod([self class], swizzleSel);
//    
//    BOOL didAddMethod = class_addMethod([self class], originSel, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
//    
//    if (didAddMethod) {
//        class_replaceMethod([self class], swizzleSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
//    }
//    else {
//        method_exchangeImplementations(originMethod, swizzleMethod);
//    }
//}



//+ (void)initialize {
//    rebind_symbols((struct rebinding[1]){{"objc_msgSend", my_objc_msgSend, (void *)&origin_objc_msgSend}}, 1);
//}

@end
