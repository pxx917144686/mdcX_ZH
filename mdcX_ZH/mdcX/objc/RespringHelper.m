//
//  RespringHelper.m
//  mdcX
//
//  Created by 이지안 on 5/12/25.
//

#import "RespringHelper.h"
#import <CoreFoundation/CoreFoundation.h>
// 声明外部函数 CFNotificationCenterPostNotification(CFNotificationCenterRef center, CFStringRef name, const void *object, CFDictionaryRef userInfo, Boolean deliverImmediately);


@implementation RespringHelper

+ (void)attemptDarwinRespring {
    NSLog(@"[RespringHelper] 尝试发送 com.apple.springboard.respring 到 Darwin 通知中心");
    
    CFNotificationCenterRef darwinNotifyCenter = CFNotificationCenterGetDarwinNotifyCenter();
    if (darwinNotifyCenter) {
        CFStringRef notificationName = CFSTR("com.apple.springboard.respring");
        
        CFNotificationCenterPostNotification(darwinNotifyCenter,
                                             notificationName,
                                             NULL, 
                                             NULL,
                                             TRUE);
        
        NSLog(@"[RespringHelper] 通知 'com.apple.springboard.respring' 已发送。");
    } else {
        NSLog(@"[RespringHelper] 获取 Darwin 通知中心失败。");
    }
}

@end
