//
//  HookHelper.m
//  RunTimeDemo
//
//  Created by tunsuy on 26/9/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "HookHelper.h"

@implementation HookHelper

+ (NSArray *)notHookClasses {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"NotHook" ofType:@"plist"];
    id notHook = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if (!notHook || ![notHook isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id notHookClasses = notHook[@"NotHookClass"];
    if (!notHookClasses || ![notHookClasses isKindOfClass:[NSDictionary class]] || !notHookClasses[@"ClassName"] || ![notHookClasses[@"ClassName"] isKindOfClass:[NSArray class]]) {
        return nil;
    }
    return notHookClasses[@"ClassName"];
}

+ (BOOL)notHookClasses:(NSArray *)notHookClasses containsObject:(NSString *)object {
    NSAssert([object isKindOfClass:[NSString class]], @"object must is a NSString type");
    if ([notHookClasses containsObject:object]) {
        return YES;
    }
    __block BOOL isContain = NO;
    [notHookClasses enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj hasSuffix:@"*"]) {
            NSString *pref = [obj substringWithRange:NSMakeRange(0, [obj length]-1)];
            if ([object hasPrefix:pref]) {
                isContain = YES;
                *stop = YES;
            }
        }
    }];
    return isContain;
}

@end
