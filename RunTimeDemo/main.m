//
//  main.m
//  RunTimeDemo
//
//  Created by tunsuy on 11/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

//#import "fishhook.h"
//#import <dlfcn.h>

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

/**  
 使用fishhook来hook C函数objc_msgSend（OC的swizzing技术对C函数无效）
 结果：发现这样实现不了，因为objc_msgSend底层是汇编实现的，在编译的时候就已经确认好栈/寄存器数据
 */

//void * (*origin_objc_msgSend)(id self, SEL _cmd, ...);

//void save_original_symbols() {
//    origin_objc_msgSend = dlsym(RTLD_DEFAULT, "objc_msgSend");
//}

//void * my_objc_msgSend(id self, SEL _cmd, ...) {
//    NSBundle *mainB = [NSBundle bundleForClass:[self class]];
//    
//    if (mainB == [NSBundle mainBundle]) { // 自定义类
//        NSLog(@"Call class name: %@ ---- method name: %@", self, NSStringFromSelector(_cmd));
//        NSLog(@"--------%@", [NSThread callStackSymbols]);
//        NSLog(@"--------%@", [NSThread callStackReturnAddresses]);
//    }
//    
//    return origin_objc_msgSend(self, _cmd);
//}

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
//        rebind_symbols((struct rebinding[1]){{"objc_msgSend", my_objc_msgSend, (void *)&origin_objc_msgSend}}, 1);
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
