//
//  Person.m
//  RunTimeDemo
//
//  Created by tunsuy on 15/8/16.
//  Copyright © 2016年 tunsuy. All rights reserved.
//

#import "Person.h"

@implementation Person

- (instancetype)initWithName:(NSString *)name age:(NSUInteger)age {
    if (self = [super init]) {
        self.name = [name copy];
        self.age = age;
    }
    return self;
}

- (void)eat {
    NSLog(@"Person could eat some things");
}

- (void)sleep {
    NSLog(@"Person could sleep any when");
}

@end
