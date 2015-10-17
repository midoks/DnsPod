//
//  AppDelegate.m
//  dnspod
//
//  Created by midoks on 14/10/26.
//  Copyright (c) 2014年 midoks. All rights reserved.
//

#import "AppDelegate.h"
#import "MLoginViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    
    //设置window属性(在AppDelegate中定义window属性),初始化windows的大小和位置
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //初始化ViewController
    MLoginViewController *c = [MLoginViewController sharedInstance];
    //设置自定义控制器大小和window相同,位置为(0,0)
    c.view.frame = _window.bounds;
    _window.rootViewController = [[SlideNavigationController sharedInstance] initWithRootViewController:c];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:8.0/255.0 green:57.0/255.0 blue:134.0/255.0 alpha:1]];
    [_window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

@end
