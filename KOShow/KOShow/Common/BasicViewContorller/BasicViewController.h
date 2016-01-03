//
//  BasicViewController.h
//  GeniusWatch
//
//  Created by 陈磊 on 15/8/22.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//
@interface UINavigationController (category)

@end

@implementation UINavigationController (category)

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
    //return  UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
    //return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end

@interface UITabBarController (category)

@end

@implementation UITabBarController (category)

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.selectedViewController.supportedInterfaceOrientations;
    //return  UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return self.selectedViewController.preferredInterfaceOrientationForPresentation;
    //return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end

typedef enum : NSUInteger
{
    LeftItem,
    RightItem,
} NavItemType;

typedef enum : NSUInteger {
    PushTypeRegister = 0,
    PushTypeNewPassword = 1,
    PushTypeChagePassword = 2,
} PushType;

typedef enum : NSUInteger {
    ShowTypePush,
    ShowTypePresent,
} ShowType;

typedef enum : NSUInteger {
    VideoTypeLive,
    VideoTypeMovie,
} VideoType;


#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface BasicViewController : UIViewController
{
    float start_y;
}

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) MJRefreshHeaderView *refreshHeaderView;
@property (nonatomic, strong) MJRefreshFooterView *refreshFooterView;

/*
 *  设置导航条Item
 *
 *  @param title     按钮title
 *  @param type      NavItemType 设置左或右item的标识
 *  @param selName   item按钮响应方法名
 */
- (void)setNavBarItemWithTitle:(NSString *)title navItemType:(NavItemType)type selectorName:(NSString *)selName;

/*
 *  设置导航条Item
 *
 *  @param imageName 图片名字
 *  @param type      NavItemType 设置左或右item的标识
 *  @param selName   item按钮响应方法名
 */
- (void)setNavBarItemWithImageName:(NSString *)imageName navItemType:(NavItemType)type selectorName:(NSString *)selName;

/*
 *  设置导航条Item back按钮
 */
- (void)addBackItem;

/*
 *  添加表视图，如：tableView
 *
 *  @param frame     tableView的frame
 *  @param type      UITableViewStyle
 *  @param delegate  tableView的委托对象
 *
 */
- (void)addTableViewWithFrame:(CGRect)frame tableType:(UITableViewStyle)type tableDelegate:(id)delegate;

/*
 *  设置刷新视图
 */
- (void)addRefreshHeaderView;

/*
 *  设置加载更多视图
 */
- (void)addRefreshFooterView;

@end
