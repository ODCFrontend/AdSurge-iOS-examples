//
//  SceneDelegate.m
//  AdSurgeDemo
//
//  Created by andrew taylor on 2025/3/17.
//

#import "SceneDelegate.h"
#import "ViewController.h"
#import <AdSurgeSDK/AdSurgeSDK.h>

@interface SceneDelegate ()

@end

@implementation SceneDelegate

- (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    if (![scene isKindOfClass:[UIWindowScene class]]) {
        return;
    }
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    UIWindow *window = [[UIWindow alloc] initWithWindowScene:windowScene];

    ViewController *rootViewController = [[ViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    window.rootViewController = navigationController;

    UIColor *barTintColor = [UIColor colorWithRed:10/255.0 green:131/255.0 blue:170/255.0 alpha:1.0];

    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        appearance.backgroundColor = barTintColor;
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
        appearance.largeTitleTextAttributes = @{NSForegroundColorAttributeName: UIColor.whiteColor};
        appearance.backgroundEffect = nil;

        navigationController.navigationBar.standardAppearance = appearance;
        navigationController.navigationBar.scrollEdgeAppearance = appearance;

        if (@available(iOS 15.0, *)) {
            navigationController.navigationBar.compactAppearance = appearance;
        }
    }

    [UINavigationBar appearance].tintColor = UIColor.whiteColor;

    self.window = window;
    [window makeKeyAndVisible];
    
    UILabel *label = [self addLoadingView];
    
    // 初始化 AdSurgeSDK
    AdSurgeSDKConfig *config = [[AdSurgeSDKConfig alloc] init];
    config.appId = @"10037";
    [[AdSurgeAdSdk shared] initializeWithConfig:config completionHandler:^(BOOL success, AdSurgeError * _Nonnull error) {
        NSLog(@"AdSurge initialize - %@ - %@",success?@"success":@"fail", error);
        label.text = success?@"success":@"fail";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [label.superview removeFromSuperview];
        });
    }];
    
}

- (UILabel *)addLoadingView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor secondaryLabelColor];
    view.alpha = 1;
    view.layer.cornerRadius = 20;
    
    UIActivityIndicatorViewStyle style;
    if (@available(iOS 13.0, *)) {
        style = UIActivityIndicatorViewStyleLarge;
    } else {
        style = UIActivityIndicatorViewStyleWhiteLarge;
    }
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator startAnimating];
    activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:activityIndicator];
    [NSLayoutConstraint activateConstraints:@[
        [activityIndicator.centerXAnchor constraintEqualToAnchor:view.centerXAnchor],
        [activityIndicator.centerYAnchor constraintEqualToAnchor:view.centerYAnchor constant:-10],
    ]];
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18];
    label.text = @"Initializing";
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [label.leadingAnchor constraintEqualToAnchor:view.leadingAnchor],
        [label.rightAnchor constraintEqualToAnchor:view.rightAnchor],
        [label.topAnchor constraintEqualToAnchor:activityIndicator.bottomAnchor constant:20],
        [label.heightAnchor constraintEqualToConstant:20],
    ]];
    UIWindow *window = self.window;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [window addSubview:view];
    [NSLayoutConstraint activateConstraints:@[
        [view.centerXAnchor constraintEqualToAnchor:window.centerXAnchor],
        [view.topAnchor constraintEqualToAnchor:window.topAnchor constant:200],
        [view.heightAnchor constraintEqualToConstant:150],
        [view.widthAnchor constraintEqualToConstant:150],
    ]];
    return label;
}


- (void)sceneDidDisconnect:(UIScene *)scene {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
}


- (void)sceneDidBecomeActive:(UIScene *)scene {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
}


- (void)sceneWillResignActive:(UIScene *)scene {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
}


- (void)sceneWillEnterForeground:(UIScene *)scene {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
}


- (void)sceneDidEnterBackground:(UIScene *)scene {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
}


@end
