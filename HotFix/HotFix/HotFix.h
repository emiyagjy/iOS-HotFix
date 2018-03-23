//
//  HotFix.h
//  HotFix
//
//  Created by GujyHy on 2018/3/22.
//  Copyright © 2018年 Gujy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HotFix :NSObject
+ (HotFix *)sharedInstance;
+ (void)fixIt;
+ (void)evalString:(NSString *)javascriptString;

@end
