//
//  ViewController.m
//  HotFix
//
//  Created by GujyHy on 2018/3/20.
//  Copyright © 2018年 Gujy. All rights reserved.
//

#import "ViewController.h"
#import "JavaScriptCoreDemoVC.h"
#import "AspectsViewController.h"
#import "Dog.h"
#import "Aspects.h"
#import "TestCrash.h"
#import <objc/runtime.h>
#import "HotFix.h"


@interface ViewController ()

@property (nonatomic,strong) UIButton *localButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
 
    [self configureControls];
    /*
     不加载的话，就会崩溃
     */
    // 加载本地js
//    [self loadJSFileWithLocal];
    
    // 网络下载图片进行下载
//    __weak typeof(self) weakSelf = self;
//    [self downloadJsHotFile:^(NSString *path){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if(path) {
//                [self.localButton setTitle:@"js修复网络下载加载成功" forState:UIControlStateNormal];
//                [weakSelf loadJSFileWithPath:path];
//            }
//
//        });
//    }];
    
    
}

#pragma mark - UI
- (void) configureControls {
    
    CGPoint center = [self.view center];
 
    // crash button
    self.localButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.localButton];
    self.localButton.frame     = CGRectMake(0, 0, 300, 50);
    self.localButton.backgroundColor = [UIColor whiteColor];
    self.localButton.center =  CGPointMake(center.x, center.y - 150);
    self.localButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.localButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.localButton.enabled = NO;
    [self.localButton setTitle:@"js修复文件未加载" forState:UIControlStateNormal];

//    [localButton addTarget:self action:@selector(localButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // crash button from internet
    UIButton *crashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:crashButton];
    crashButton.frame     = CGRectMake(0, 0, 250, 50);
    crashButton.backgroundColor = [UIColor redColor];
    crashButton.center =  CGPointMake(center.x, center.y - 50);
    crashButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    crashButton.titleLabel.textColor     = [UIColor blackColor];
    [crashButton setTitle:@"test crash" forState:UIControlStateNormal];
    [crashButton addTarget:self action:@selector(crashButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // js button
    UIButton *jsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:jsButton];
    jsButton.frame     = CGRectMake(0, 0, 300, 50);
    jsButton.backgroundColor = [UIColor redColor];
    jsButton.center =  CGPointMake(center.x, center.y + 50);
    jsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    jsButton.titleLabel.textColor     = [UIColor blackColor];
    [jsButton setTitle:@"test javaScriptCore" forState:UIControlStateNormal];
    [jsButton addTarget:self action:@selector(jsbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // aspets button
    UIButton *aspetsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:aspetsButton];
    aspetsButton.frame     = CGRectMake(0, 0, 300, 50);
    aspetsButton.backgroundColor = [UIColor redColor];
    aspetsButton.center =  CGPointMake(center.x, center.y + 150);
    aspetsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    aspetsButton.titleLabel.textColor     = [UIColor blackColor];
    [aspetsButton setTitle:@"test Aspects" forState:UIControlStateNormal];
    [aspetsButton addTarget:self action:@selector(aspetsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - Hot Fix
- (void) testCrash {
    // 测试 crash
    TestCrash *crash = [[TestCrash alloc] init];
    NSString  *result = [crash getArrayValue:nil]; // nil
    NSLog(@"返回值 = %@",result);
    NSLog(@"我不崩溃了");
}

- (void) loadJSFileWithLocal {
    //  读取本地文件
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fixInstanceMethodReplace" ofType:@"txt"];
    if(path) {
        [self.localButton setTitle:@"js修复文件加载成功" forState:UIControlStateNormal];
        [self loadJSFileWithPath:path];
    }
   
}
// 替换
- (void) loadJSFileWithPath:(NSString *) path {
    NSError *error;
    NSString *fixScriptString1 = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding    error:&error];
    NSLog(@"error is %@",[error description]);
    NSLog(@"fixScriptString is %@",fixScriptString1);
    // 建议在每次启动的加载，不然的话会加载多次 js
    [HotFix fixIt];
    [HotFix evalString:fixScriptString1];
}

// 从网络下载 热修复文件 保存沙盒中
- (void) downloadJsHotFile:(void(^)(NSString *)) block {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",@"http://milai.starmetal.cn/milai/download/fixInstanceMethodReplace"];
//    在 iOS 程序访问 HTTP 资源时需要对 URL 进行 Encode，比如像拼出来的 http://unmi.cc?p1=%+&sd f&p2=中文，其中的中文、特殊符号&％和空格都必须进行转译才能正确访问。现在以"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "字符串为例子，用stringByAddingPercentEncodingWithAllowedCharacters取代CFURLCreateStringByAddingPercentEscapes
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDownloadTask *downlaodTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // location 是临时保存路径，需要保存到指定的目录下
        NSLog(@"location is %@",location);
        [weakSelf savePathWithLocation:location block:block];
    }];
    
    // 恢复线程 启动任务
    [downlaodTask resume];

}

- (void) savePathWithLocation:(NSURL *) location
                        block:(void(^)(NSString *)) block {
    
    NSString *fileName = @"/fixInstanceMethodReplace";
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES).lastObject;
    NSString *savePath  = [cachePath stringByAppendingString:fileName];
    NSURL *saveUrl      = [NSURL fileURLWithPath:savePath];
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    if(![manager fileExistsAtPath:savePath]) {
        [manager  copyItemAtURL:location toURL:saveUrl error:nil];
        if(!error) {
            
            block(savePath);
          
        }else {
            NSLog(@"保存失败 error is %@",[error description]);
        }
    }else{
         block(savePath);
    }

}


#pragma mark - Events
- (void) crashButtonAction:(UIButton *) button {
      [self testCrash];
}

- (void) jsbuttonAction:(UIButton *) button {
    JavaScriptCoreDemoVC *vc = [[JavaScriptCoreDemoVC alloc] init];
    vc.title = button.titleLabel.text;
    [self.navigationController pushViewController:vc animated:true];
}

- (void) aspetsButtonAction:(UIButton *) button {
    AspectsViewController *vc = [[AspectsViewController alloc] init];
    vc.title = button.titleLabel.text;
    [self.navigationController pushViewController:vc animated:true];
}


#pragma mark - Getters
//- (UISwitch *) mySwitch {
//    if(_mySwitch == nil) {
//        _mySwitch = [UISwitch new];
//    }
//    return _mySwitch;
//}


@end
