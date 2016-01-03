//
//  LiveViewController.m
//  KOShow
//
//  Created by 陈磊 on 15/11/26.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define TITLEVIEW_HEIGHT    30.0
#define TITLEVIEW_WIDTH     140.0 * CURRENT_SCALE
#define ADVVIEW_HEIGHT      105.0 * CURRENT_SCALE

#define LOADING_TIP         @"正在加载..."
#define LOADING_SUCESS      @"加载成功"
#define LOADING_FAIL        @"加载失败"


#import "LiveViewController.h"
#import "LiveRoomViewController.h"
#import "VideoListCell.h"
#import "SegmentView.h"
#import "AdvView.h"

@interface LiveViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) AdvView *advView;
@property (nonatomic, strong) NSMutableArray *liveRoomListArray;
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation LiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavBarItemWithImageName:@"nav_logo" navItemType:LeftItem selectorName:@""];
    [self setNavBarItemWithImageName:@"nav_search" navItemType:RightItem selectorName:@""];
    
    _liveRoomListArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.pageIndex = 0;
    
    [self initUI];
    [self getRoomListRequest];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTitleView];
    [self addTableView];
//    if (VideoTypeLive == self.videoType)
//    {
//        [self addHeaderView];
//    }
    [self addRefreshHeaderView];
    [self addRefreshFooterView];
}

//添加titleView
- (void)addTitleView
{
    SegmentView *segmentView = [[SegmentView alloc] initWithFrame:CGRectMake(0, 0, TITLEVIEW_WIDTH, TITLEVIEW_HEIGHT)];
    [segmentView setItemTitleWithArray:@[@"人气",@"分类"]];
    self.navigationItem.titleView = segmentView;
    
}

//添加表
- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)addHeaderView
{
    _advView = [[AdvView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ADVVIEW_HEIGHT)];
    _advView.backgroundColor = [UIColor whiteColor];
    [_advView setAdvData:@[@"",@""]];
    [self.table setTableHeaderView:_advView];
}

#pragma mark 刷新
- (void)refreshData
{
    if (!self.isLoading)
    {
        self.pageIndex = 1;
        [self getRoomListRequest];
    }
}

#pragma mark 加载更多
- (void)getMoreData
{
    if (!self.isLoading)
    {
        self.pageIndex++;
        [self getRoomListRequest];
    }
}

#pragma mark 获取直播列表
- (void)getRoomListRequest
{
    __weak typeof(self) weakSelf = self;
    if (self.pageIndex == 0)
    {
        [SVProgressHUD showWithStatus:LOADING_TIP];
    }
    NSString *urlString = LIVE_ROOM_LIST_URL;
    //(self.videoType == VideoTypeLive) ? LIVE_ROOM_LIST_URL : @"";
    if (urlString.length == 0)
    {
        return;
    }
    self.isLoading = YES;
    NSDictionary *requestDic = @{@"pageIdx":@(self.pageIndex == 0 ? 1 : self.pageIndex)};
    [[RequestTool alloc] requestWithUrl:urlString
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"LIVE_ROOM_LIST_URL===%@",responseDic);
         NSDictionary *dataDic = (NSDictionary *)responseDic;
         int errorCode = [dataDic[@"errorCode"] intValue];
         NSString *errorMessage = dataDic[@"errorMessage"];
         errorMessage = errorMessage ? errorMessage : LOADING_FAIL;
         weakSelf.isLoading = NO;
         [weakSelf.refreshFooterView endRefreshing];
         [weakSelf.refreshHeaderView endRefreshing];
         if (errorCode == 200)
         {
             if (weakSelf.pageIndex == 0)
             {
                 weakSelf.pageIndex = 1;
                 [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
             }
             [weakSelf setDataWithDictionary:dataDic];
         }
         else
         {
             if (weakSelf.pageIndex == 0)
             {
                 [SVProgressHUD showErrorWithStatus:errorMessage];
             }
             
             if (weakSelf.pageIndex != 1)
             {
                 weakSelf.pageIndex--;
             }
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         weakSelf.isLoading = NO;
         [weakSelf.refreshFooterView endRefreshing];
         [weakSelf.refreshHeaderView endRefreshing];
         NSLog(@"LIVE_ROOM_LIST_URL==%@",error);
         if (weakSelf.pageIndex == 0)
         {
             [SVProgressHUD showErrorWithStatus:LOADING_FAIL];
         }
         if (weakSelf.pageIndex != 1)
         {
             weakSelf.pageIndex--;
         }
     }];
}

#pragma mark 设置数据
- (void)setDataWithDictionary:(NSDictionary *)dataDic
{
    if (!dataDic)
    {
        return;
    }
    if (self.pageIndex == 1)
    {
        [self.liveRoomListArray removeAllObjects];
    }
    
    int totalCount = [dataDic[@"total_cnt"] intValue];
    int totalPage = ceil(totalCount/10.0);
    
    if (self.pageIndex == totalPage)
    {
        [self.refreshFooterView removeFromSuperview];
    }
    else
    {
        [self.table addSubview:self.refreshFooterView];
    }
    
    NSArray *roomListArray = (NSArray *)dataDic[@"result"][@"list"];
    if (!roomListArray || [roomListArray count] == 0)
    {
        return;
    }
    [self.liveRoomListArray addObjectsFromArray:roomListArray];
    [self.table reloadData];
}


#pragma mark UITableViewDelegate&UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil([self.liveRoomListArray count]/2.0);
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
    
    int index = (int)indexPath.row * 2;
    NSDictionary *leftDic = self.liveRoomListArray[index];
    NSDictionary *rightDic = (index + 1 < [self.liveRoomListArray count]) ? self.liveRoomListArray[index + 1] : nil;
    [((VideoListCell *)cell) setLeftViewData:leftDic rightViewData:rightDic];
    
    ((VideoListCell *)cell).leftView.clickButton.tag = index + 1;
    [((VideoListCell *)cell).leftView.clickButton addTarget:self action:@selector(clickButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
     ((VideoListCell *)cell).rightView.clickButton.tag = index + 2;
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
    NSDictionary *dataDic = self.liveRoomListArray[sender.tag - 1];
    LiveRoomViewController *liveRoomViewController = [[LiveRoomViewController alloc] init];
    liveRoomViewController.playerViewType = PlayerViewTypeLive;
    liveRoomViewController.hidesBottomBarWhenPushed = YES;
    liveRoomViewController.playDataDic = dataDic;
    NSString *videoUrl = dataDic[@"ios_play_url"];
    videoUrl = videoUrl ? videoUrl : @"";
    [liveRoomViewController setVideoUrl:videoUrl];
     //@"http://182.18.61.8:1935/live/4869/playlist.m3u8"
    //@"http://183.232.54.230:1935/vod/sycf/2015/11/17/yl1116lxcp01_zqbz.mp4/playlist.m3u8?sessionID=d9ffcbe9b9fa4bb5861612def1df6552"
    //@"http://live.wonhot.mobi:8935/live/hcctv_115/playlist.m3u8?keysession=a8352b434ff1495bd23c0f69e6dac743&sessionID=e560ab579e5348a3be18c2fd00c41ef0"
    [self.navigationController pushViewController:liveRoomViewController animated:YES];
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
