//
//  AppDelegate.m
//  KOShow
//
//  Created by 陈磊 on 15/11/25.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "AppDelegate.h"
#import "IndexViewController.h"
#import "LiveViewController.h"
#import "VideoViewController.h"
#import "MineViewController.h"

@interface UITabBarController (category)

@end

@implementation UITabBarController (category)

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return  UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}


@end

@interface AppDelegate ()<UITabBarControllerDelegate,UINavigationControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window = window;
    [self.window makeKeyAndVisible];
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : FONT(12.0),NSForegroundColorAttributeName : RGB(124.0, 124.0, 124.0)} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : FONT(12.0),NSForegroundColorAttributeName : RGB(227.0, 127.0, 31.0)} forState:UIControlStateSelected];

    [self addMianView];

    return YES;
}

#pragma mark 添加主视图
- (void)addMianView
{
    IndexViewController *indexViewController = [[IndexViewController alloc] init];
    LiveViewController *liveViewController = [[LiveViewController alloc] init];
    liveViewController.videoType = VideoTypeLive;
    VideoViewController *videoViewController = [[VideoViewController alloc] init];
    videoViewController.videoType = VideoTypeMovie;
    MineViewController *mineViewController = [[MineViewController alloc] init];
    
    UINavigationController *indexNav = [[UINavigationController alloc] initWithRootViewController:indexViewController];
    indexNav.delegate = self;
    UINavigationController *liveNav = [[UINavigationController alloc] initWithRootViewController:liveViewController];
    liveNav.delegate = self;
    UINavigationController *videoNav = [[UINavigationController alloc] initWithRootViewController:videoViewController];
    videoNav.delegate = self;
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineViewController];
    videoNav.delegate = self;
    
    UITabBarItem *homeTabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[CommonTool getOriginalImageWithImageName:@"tab_home1"] selectedImage:[CommonTool getOriginalImageWithImageName:@"tab_home2"]];
    UITabBarItem *liveTabBarItem = [[UITabBarItem alloc]initWithTitle:@"直播" image:[CommonTool getOriginalImageWithImageName:@"tab_live1"] selectedImage:[CommonTool getOriginalImageWithImageName:@"tab_live2"]];
    UITabBarItem *videoTabBarItem = [[UITabBarItem alloc]initWithTitle:@"视频" image:[CommonTool getOriginalImageWithImageName:@"tab_video1"] selectedImage:[CommonTool getOriginalImageWithImageName:@"tab_video2"]];
    UITabBarItem *mineTabBarItem = [[UITabBarItem alloc]initWithTitle:@"我的" image:[CommonTool getOriginalImageWithImageName:@"tab_mine1"] selectedImage:[CommonTool getOriginalImageWithImageName:@"tab_mine2"]];
    [indexNav setTabBarItem:homeTabBarItem];
    [liveNav setTabBarItem:liveTabBarItem];
    [videoNav setTabBarItem:videoTabBarItem];
    [mineNav setTabBarItem:mineTabBarItem];
    
    UITabBarController *tabBarViewController = [[UITabBarController alloc] init];
    tabBarViewController.delegate = self;
    tabBarViewController.viewControllers = @[indexNav,liveNav,videoNav,mineNav];
    //tabBarViewController.tabBar.tintColor = APP_MAIN_COLOR;
    self.window.rootViewController = tabBarViewController;
    NSLog(@"====%@",NSStringFromCGSize(tabBarViewController.tabBar.frame.size));
}


//- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
//{
//    return UIInterfaceOrientationMaskLandscape | UIInterfaceOrientationPortrait;
//    //return [[navigationController.viewControllers lastObject] supportedInterfaceOrientations];
//}
//
//- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController
//{
//    return UIInterfaceOrientationPortrait;
//    //return [[navigationController.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
//}

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
}

@end


