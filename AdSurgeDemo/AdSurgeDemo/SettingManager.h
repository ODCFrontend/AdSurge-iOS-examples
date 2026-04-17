//
//  SettingManager.h
//  AdSurgeDevDemo
//
//  Created by katie on 2025/5/22.
//

#import <Foundation/Foundation.h>

@interface SettingManager : NSObject
@property (nonatomic, assign) BOOL isMuted;
+ (instancetype)sharedManager;
@end

