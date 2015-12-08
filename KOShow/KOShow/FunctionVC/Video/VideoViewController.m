//
//  VideoViewController.m
//  KOShow
//
//  Created by 陈磊 on 15/11/26.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import "VideoViewController.h"
#import "VideoRoomViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark 点击进入房间
- (void)clickButtonPressed:(UIButton *)sender
{
    VideoRoomViewController *avPlayerViewController = [[VideoRoomViewController alloc] init];
    avPlayerViewController.playerViewType = PlayerViewTypeVideo;
    avPlayerViewController.hidesBottomBarWhenPushed = YES;
    [avPlayerViewController setVideoUrl:@"http://183.232.54.230:1935/vod/sycf/2015/11/17/yl1116lxcp01_zqbz.mp4/playlist.m3u8?sessionID=d9ffcbe9b9fa4bb5861612def1df6552"];
    [self.navigationController pushViewController:avPlayerViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
