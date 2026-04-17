//
//  SettingManager.m
//  AdSurgeDevDemo
//
//  Created by katie on 2025/5/22.
//

#import "SettingManager.h"

@implementation SettingManager

+ (instancetype)sharedManager {
    static SettingManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SettingManager alloc] init];
    });
    return manager;
}

@end
