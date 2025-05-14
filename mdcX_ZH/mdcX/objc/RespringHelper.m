//
//  RespringHelper.m
//  mdcX
//
//  Created by 이지안 on 5/12/25.
//

#import "RespringHelper.h"
#import <CoreFoundation/CoreFoundation.h>

@implementation RespringHelper

+ (void)attemptDarwinRespring {
    NSLog(@"[RespringHelper] 尝试向Darwin通知中心发送com.apple.springboard.respring");
    
    CFNotificationCenterRef darwinNotifyCenter = CFNotificationCenterGetDarwinNotifyCenter();
    if (darwinNotifyCenter) {
        CFStringRef notificationName = CFSTR("com.apple.springboard.respring");
        
        CFNotificationCenterPostNotification(darwinNotifyCenter,
                                             notificationName,
                                             NULL, 
                                             NULL,
                                             TRUE);
        
        NSLog(@"[RespringHelper] 通知'com.apple.springboard.respring'已发送。");
    } else {
        NSLog(@"[RespringHelper] 获取Darwin通知中心失败。");
    }
}

@end
