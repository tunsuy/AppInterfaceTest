//
//  NSObject+TSExtension.m
//  MOA
//
//  Created by tunsuy on 17/5/16.
//  Copyright © 2016年 moa. All rights reserved.
//

#import "NSObject+TSExtension.h"
#import "HookHelper.h"
#import <objc/runtime.h>
#import "Aspects.h"

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    Stuff; \
    _Pragma("clang diagnostic pop") \
} while (0)

//定义全局静态变量
static NSMutableArray *_infInfoStack = nil; //所有接口信息桟
static NSArray *_notHookClasses = nil; //所有不需要hook的类

//static char *infInfoStackKey = "infInfoStack";

@implementation NSObject (TSExtension)

+ (void)load {
//    NSBundle *mainB = [NSBundle bundleForClass:[self class]];
//    NSLog(@"mainB: %@", mainB);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _infInfoStack = [[NSMutableArray alloc] init];
        _notHookClasses = [NSArray arrayWithArray:[HookHelper notHookClasses]];
        
    });
    
    SEL origSEL = @selector(init);
    SEL swizSEL = @selector(swiz_init);
    [self ts_swizzleMethodWithOriginSEL:origSEL swizzleSEL:swizSEL];
    
//    SEL origSEL = @selector(initialize);
//    SEL swizSEL = @selector(swiz_initialize);
//    [self ts_swizzleMethodWithOriginSEL:origSEL swizzleSEL:swizSEL];
    
}

//+ (void)swiz_initialize {
//    unsigned int method_count, class_method_count;
//    
//    NSBundle *mainB = [NSBundle bundleForClass:[self class]];
//    //    NSLog(@"mainB: %@", mainB);
//    
//    if (mainB != [NSBundle mainBundle]) {
//        /** 系统的类——不处理 */
//        [self swiz_initialize];
//    }
//    
//    /** 自定义的类 */
//    
//    if ([_notHookClasses containsObject:NSStringFromClass([self class])]) {
//        /** 不需要hook的类——不处理 */
//        [self swiz_initialize];
//    }
//    
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wunused-variable"
//    NSString *className = NSStringFromClass([self class]);
//    const char *class_name = [className UTF8String];
//    //获取所有类方法
//    Method *class_method_list = class_copyMethodList(objc_getClass(class_name), &class_method_count);
//    
//    //获取所有实例方法 -- todo:
//#pragma clang diagnostic pop
//    
//    NSLog(@"===========TS TEST=============");
//    
//    //获取所有方法
//    Method *method_list = class_copyMethodList([self class], &method_count);
//    
//    for (int i=0; i<method_count; i++) {
//        Method method = method_list[i];
//        SEL sel = method_getName(method);
//        //            NSLog(@"<class: %@> method: %@", NSStringFromClass([self class]),NSStringFromSelector(sel));
//        NSDictionary *dataDict = @{@"className": NSStringFromClass([self class]),
//                                   @"methodName": NSStringFromSelector(sel)};
//        [_infInfoStack addObject:dataDict];
//        
//        //                [TSMOATest saveMethodsWithDataDict:dataDict complitionHandle:^(id result) {
//        //                    if ([result isKindOfClass:[NSError class]]) {
//        //                        NSError *error = (NSError *)result;
//        //                        NSLog(@"Save method to DB error, error: %@", error);
//        //                    }
//        //
//        //                }];
//        
//        /**
//         使用AOP切面技术对每个方法添加自定义监控代码
//         第三方库文件：Aspects
//         */
//        [self aspect_hookSelector:sel
//                      withOptions:AspectPositionBefore
//                       usingBlock:^(){
//                           NSLog(@"Call class name: %@ ---- method name: %@", [self class], NSStringFromSelector(sel));
//                           NSLog(@"--------%@", [NSThread callStackSymbols]);
//                           NSLog(@"--------%@", [NSThread callStackReturnAddresses]);
//                       }
//                            error:NULL];
//        
//        /**
//         想要通过hook重定义所有方法，在原有的方法中添加监控代码
//         结果：可以知道任何一个方法的参数等，但是无法动态添加hook方法
//         */
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wunused-variable"
//        NSMethodSignature *methodSign =  [self methodSignatureForSelector:sel];
//        NSUInteger argNum = [methodSign numberOfArguments]; //参数数量
//        NSMutableArray *argTypeArr = [NSMutableArray array];
//        for (NSUInteger i=0; i<argNum; i++) {
//            const char *argType = [methodSign getArgumentTypeAtIndex:i]; //第idx个参数的类型
//            NSString *argTypeStr = [NSString stringWithUTF8String:argType];
//            [argTypeArr addObject:argTypeStr];
//        }
//        const char *retType = [methodSign methodReturnType]; //返回值类型
//        NSString *retTypeStr = [NSString stringWithUTF8String:retType];
//        
//        NSString *swizMethodName = [NSString stringWithFormat:@"swiz_%@", NSStringFromSelector(sel)];
//        
//        SEL swizSEL = NSSelectorFromString(swizMethodName);
//#pragma clang diagnostic pop
//        
//    }
//    
//    [self swiz_initialize];
//
//}


- (instancetype)swiz_init {
    unsigned int method_count, class_method_count;
    
    NSBundle *mainB = [NSBundle bundleForClass:[self class]];
    NSLog(@"mainB: %@", mainB);
    
    if (mainB != [NSBundle mainBundle]) {
        /** 系统的类——不处理 */
        return [self swiz_init];
    }
    
    /** 自定义的类 */
    
    if ([HookHelper notHookClasses:_notHookClasses containsObject:NSStringFromClass([self class])]) {
        /** 不需要hook的类——不处理 */
        NSLog(@"not hook class: ==%@==", [self class]);
        return [self swiz_init];
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    NSString *className = NSStringFromClass([self class]);
    const char *class_name = [className UTF8String];
    //获取所有类方法
    Method *class_method_list = class_copyMethodList(objc_getClass(class_name), &class_method_count);
    
    //获取所有实例方法 -- todo:
#pragma clang diagnostic pop
    
    NSLog(@"===========TS TEST=============");
    
    //获取所有方法
    Method *method_list = class_copyMethodList([self class], &method_count);
    
    for (int i=0; i<method_count; i++) {
        Method method = method_list[i];
        SEL sel = method_getName(method);
        //            NSLog(@"<class: %@> method: %@", NSStringFromClass([self class]),NSStringFromSelector(sel));
        NSDictionary *dataDict = @{@"className": NSStringFromClass([self class]),
                                   @"methodName": NSStringFromSelector(sel)};
        NSLog(@"%@", dataDict);
        [_infInfoStack addObject:dataDict];
        
        //                [TSMOATest saveMethodsWithDataDict:dataDict complitionHandle:^(id result) {
        //                    if ([result isKindOfClass:[NSError class]]) {
        //                        NSError *error = (NSError *)result;
        //                        NSLog(@"Save method to DB error, error: %@", error);
        //                    }
        //
        //                }];
        
        /**
         使用AOP切面技术对每个方法添加自定义监控代码
         第三方库文件：Aspects
         */
        [self aspect_hookSelector:sel
                      withOptions:AspectPositionBefore
                       usingBlock:^(){
                           NSLog(@"Call class name: %@ ---- method name: %@", [self class], NSStringFromSelector(sel));
                           NSLog(@"--------%@", [NSThread callStackSymbols]);
//                           NSLog(@"--------%@", [NSThread callStackReturnAddresses]);
                       }
                            error:NULL];
        
        /**
         想要通过hook重定义所有方法，在原有的方法中添加监控代码
         结果：可以知道任何一个方法的参数等，但是无法动态添加hook方法
         */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
//        NSMethodSignature *methodSign =  [self methodSignatureForSelector:sel];
//        NSUInteger argNum = [methodSign numberOfArguments]; //参数数量
//        NSMutableArray *argTypeArr = [NSMutableArray array];
//        for (NSUInteger i=0; i<argNum; i++) {
//            const char *argType = [methodSign getArgumentTypeAtIndex:i]; //第idx个参数的类型
//            NSString *argTypeStr = [NSString stringWithUTF8String:argType];
//            [argTypeArr addObject:argTypeStr];
//        }
//        const char *retType = [methodSign methodReturnType]; //返回值类型
//        NSString *retTypeStr = [NSString stringWithUTF8String:retType];
//        
//        NSString *swizMethodName = [NSString stringWithFormat:@"swiz_%@", NSStringFromSelector(sel)];
//        
//        SEL swizSEL = NSSelectorFromString(swizMethodName);
#pragma clang diagnostic pop
        
    }
    
    return [self swiz_init];

}

+ (NSMutableArray *)infInfoStack {
//    return objc_getAssociatedObject(self, infInfoStackKey);
    return _infInfoStack;
}

+ (void)setInfInfoStack:(NSMutableArray *)infInfoStack {
//    objc_setAssociatedObject(self, infInfoStackKey, infInfoStack, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    _infInfoStack = infInfoStack;
}

#pragma mark -- Private method
+ (void)ts_swizzleMethodWithOriginSEL:(SEL)originSEL swizzleSEL:(SEL)swizzleSEL {
//    Method originMethod = class_getClassMethod([self class], originSEL);
//    Method swizzleMethod = class_getClassMethod([self class], swizzleSEL);
    
    Method originMethod = class_getInstanceMethod([self class], originSEL);
    Method swizzleMethod = class_getInstanceMethod([self class], swizzleSEL);

    BOOL didAddMethod = class_addMethod([self class], originSEL, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    
    if (didAddMethod) {
        class_replaceMethod([self class], swizzleSEL, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    }
    else {
        method_exchangeImplementations(originMethod, swizzleMethod);
    }
}


@end
