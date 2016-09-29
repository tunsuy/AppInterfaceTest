//
//  HookMsg.h
//  RunTimeDemo
//
//  Created by tunsuy on 17/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "fishhook.h"
#import <dlfcn.h>

#import <Foundation/Foundation.h>

//typedef void (*original_objc_msgSend)(id self, SEL _cmd, ...);
//static original_objc_msgSend orig_objc_msgSend;
//
//void my_objc_msgSend(id self, SEL _cmd, ...);

@interface HookMsg : NSObject

@end
