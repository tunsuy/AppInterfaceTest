//
//  Person.h
//  RunTimeDemo
//
//  Created by tunsuy on 15/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger age;

- (instancetype)initWithName:(NSString *)name age:(NSUInteger)age;

- (void)eat;
- (void)sleep;

@end
