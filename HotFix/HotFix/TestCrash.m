//
//  TestCrash.m
//  HotFix
//
//  Created by GujyHy on 2018/3/20.
//  Copyright © 2018年 Gujy. All rights reserved.
//

#import "TestCrash.h"

@implementation TestCrash

- (NSString *) getArrayValue:(NSString *) value{
    NSMutableArray *array = [NSMutableArray array];
    // 要加判断
    [array addObject:value];
    return  array[0];
}

@end
