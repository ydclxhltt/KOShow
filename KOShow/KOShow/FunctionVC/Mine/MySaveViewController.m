//
//  MySaveViewController.m
//  KOShow
//
//  Created by 陈磊 on 15/12/14.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "MySaveViewController.h"
#import "VideoRoomViewController.h"
#import "VideoListCell.h"

@implementation MySaveViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:self action:nil];
//    self.navigationItem.backBarButtonItem = backItem;
    self.title = @"我的收藏";
    [self initUI];
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTableView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) tableType:UITableViewStylePlain tableDelegate:self];
}

#pragma mark UITableViewDelegate&UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  ROOM_LIST_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = (VideoListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[VideoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [((VideoListCell *)cell).leftView.clickButton addTarget:self action:@selector(clickButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [((VideoListCell *)cell).rightView.clickButton addTarget:self action:@selector(clickButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 点击进入房间
- (void)clickButtonPressed:(UIButton *)sender
{
    VideoRoomViewController *videoRoomViewController = [[VideoRoomViewController alloc] init];
    videoRoomViewController.playerViewType = PlayerViewTypeLive;
    videoRoomViewController.hidesBottomBarWhenPushed = YES;
    [videoRoomViewController setVideoUrl:@"http://183.232.54.230:1935/vod/sycf/2015/11/17/yl1116lxcp01_zqbz.mp4/playlist.m3u8?sessionID=d9ffcbe9b9fa4bb5861612def1df6552"];
    [self.navigationController pushViewController:videoRoomViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
