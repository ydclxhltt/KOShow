//
//  BookMarkViewController.m
//  KOShow
//
//  Created by 陈磊 on 15/12/14.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define SPACE_X                 15.0 * CURRENT_SCALE
#define SPACE_Y                 10.0
#define SEGMENTVIEW_HEIGHT      35.0
#define HEADER_HEIGHT           SEGMENTVIEW_HEIGHT + 2 * SPACE_Y


#import "BookMarkViewController.h"
#import "SegmentView.h"
#import "LiveRoomViewController.h"
#import "VideoRoomViewController.h"

@interface BookMarkViewController()<SegmentViewDelegate>

@property (nonatomic, assign) BOOL isLive;

@end

@implementation BookMarkViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isLive = YES;
    self.title = @"我的订阅";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *headerView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEADER_HEIGHT) placeholderImage:nil];
    headerView.backgroundColor = [UIColor whiteColor];
    SegmentView *segmentView = [[SegmentView alloc] initWithFrame:CGRectMake(SPACE_X, SPACE_Y, tableView.frame.size.width - 2 * SPACE_X, SEGMENTVIEW_HEIGHT)];
    segmentView.radius = 5.0;
    segmentView.delegate = self;
    [segmentView setItemTitleWithArray:@[@"直播中",@"暂停中"]];
    [headerView addSubview:segmentView];
    return headerView;
}


#pragma mark 点击进入房间
- (void)clickButtonPressed:(UIButton *)sender
{
    UIViewController *viewController;
    if (self.isLive)
    {
        viewController = [[LiveRoomViewController alloc] init];
        ((LiveRoomViewController *)viewController).playerViewType = PlayerViewTypeLive;
        viewController.hidesBottomBarWhenPushed = YES;
        [((LiveRoomViewController *)viewController) setVideoUrl:@"http://182.18.61.8:1935/live/4869/playlist.m3u8"];
        //@"http://183.232.54.230:1935/vod/sycf/2015/11/17/yl1116lxcp01_zqbz.mp4/playlist.m3u8?sessionID=d9ffcbe9b9fa4bb5861612def1df6552"

    }
    else
    {
        viewController = [[VideoRoomViewController alloc] init];
        ((VideoRoomViewController *)viewController).playerViewType = PlayerViewTypeVideo;
        viewController.hidesBottomBarWhenPushed = YES;
        [((VideoRoomViewController *)viewController) setVideoUrl:@"http://183.232.54.230:1935/vod/sycf/2015/11/17/yl1116lxcp01_zqbz.mp4/playlist.m3u8?sessionID=d9ffcbe9b9fa4bb5861612def1df6552"];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark SegmentViewDelegate
- (void)segmentView:(SegmentView *)segmentView  selectedItemAtIndex:(int)index
{
    self.isLive = (index == 0) ? YES : NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
