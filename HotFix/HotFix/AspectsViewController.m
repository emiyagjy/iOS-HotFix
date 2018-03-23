//
//  AspectsViewController.m
//  HotFix
//
//  Created by GujyHy on 2018/3/22.
//  Copyright © 2018年 Gujy. All rights reserved.
//

#import "AspectsViewController.h"
#import "HotFix.h"
#import "Dog.h"
#import <objc/runtime.h>
#import "Aspects.h"

@interface AspectsViewController ()

@end

@implementation AspectsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self testDog];
    
}

- (void) testDog {
    
//     要先读取类，再截取类方法，再执行
    NSString *className = NSStringFromClass(Dog.class);
    //    CLS_CLASS (0x1L) 表示该类为普通 class ，其中包含实例方法和变量；
    //    CLS_META (0x2L) 表示该类为 metaclass，其中包含类方法；
    Class dogClass = objc_getMetaClass(className.UTF8String);
    [dogClass aspect_hookSelector:@selector(run) withOptions:1 usingBlock:^(id info){
        NSLog(@"截取run方法 🐶就不能跑了");
        
    } error:NULL];
    
    [Dog run];
    
    Dog *eatDog = [Dog new];
    // NSSelectorFromString(@"your method")
    SEL eatSel =  NSSelectorFromString(@"eat");
    
    [eatDog aspect_hookSelector:eatSel withOptions:1 usingBlock:^(id info){
        NSLog(@"截取eat方法");
        
    } error:NULL];
    [eatDog eat];
}




@end
