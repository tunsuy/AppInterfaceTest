//
//  HookHelper.h
//  RunTimeDemo
//
//  Created by tunsuy on 26/9/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HookHelper : NSObject

+ (NSArray *)notHookClasses;

+ (BOOL)notHookClasses:(NSArray *)notHookClasses containsObject:(NSString *)obj;

@end
