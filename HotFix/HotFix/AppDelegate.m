//
//  AppDelegate.m
//  HotFix
//
//  Created by GujyHy on 2018/3/20.
//  Copyright © 2018年 Gujy. All rights reserved.
//

#import "AppDelegate.h"
#import "Aspects.h"
#import "ViewController.h"
#import "Dog.h"
#import "HotFix.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
//    [self hookViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window setRootViewController:[[UINavigationController alloc] initWithRootViewController:[ViewController new]]];
    [self.window makeKeyAndVisible];

    return YES;
}

- (void) hookViewController {
    //     对 UIViewController 的 viewDidload 方法进行拦截
 
    // AspectPositionAfter   /// Called after the original implementation (default) 原有代码逻辑之后执行
    // AspectPositionInstead = 1, /// Will replace the original implementation.  替换原有代码逻辑
    // AspectPositionBefore  = 2, /// Called before the original 在原有代码逻辑之前执行
    
    [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:1 usingBlock:^(id<AspectInfo> info){
        UIViewController *vc = info.instance;
        NSString *classname = NSStringFromClass([vc class]);
        NSLog(@"%@ 对象的 viewDidLoad方法 被调用了",classname);
    } error:NULL];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
