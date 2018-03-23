//
//  JavaScriptCoreDemoVC.m
//  HotFix
//
//  Created by GujyHy on 2018/3/22.
//  Copyright © 2018年 Gujy. All rights reserved.
//

#import "JavaScriptCoreDemoVC.h"
#import <objc/runtime.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface JavaScriptCoreDemoVC ()

@end

@implementation JavaScriptCoreDemoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self testJs];
    
}

- (void) testJs {
    
    NSString *jsString = @"function add(a,b) {return a+b}";
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:jsString];
    JSValue *value  = [context[@"add"] callWithArguments:@[@2,@3]];
    NSLog(@"reusult is %d",[value toInt32]);
    
    
}

@end
