//
//  IndexViewController.m
//  KOShow
//
//  Created by 陈磊 on 15/11/26.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define ADVVIEW_HEIGHT              225.0 * CURRENT_SCALE
#define HEADER_HEIGHT               10.0
#define SEARCH_PLACEHOLDER          @"直播、视频主题、主播名"
#define SEARCH_SPACE_X              36.0 * CURRENT_SCALE
#define SEARCH_ADD_X                5.0 * CURRENT_SCALE
#define SEARCH_PLACEHOLDER_COLOR    RGB(202.0,202.0,202.0)
#define SEARCH_PLACEHOLDER_FONT     FONT(13.0)
#define SEARCH_BG_COLOR             RGB(50.0,50.0,50.0)
#define SEARCH_WIDTH                233.0
#define SEARCH_HEIGHT               27.0
#define SEARCH_RADIUS               15.0

#define LOADING_TIP                 @"正在加载..."
#define LOADING_SUCESS              @"加载成功"
#define LOADING_FAIL                @"加载失败"

#import "IndexViewController.h"
#import "AdvView.h"
#import "HeaderViewCell.h"
#import "AnchorListCell.h"
#import "VideoListCell.h"
#import "LiveRoomViewController.h"

@interface IndexViewController ()<UITableViewDataSource,UITableViewDelegate,AdvViewClickedDelegate,AnchorListViewDelegate>

@property (nonatomic, strong) AdvView *advView;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *bannerListArray;
@property (nonatomic, strong) NSArray *anchorListArray;
@property (nonatomic, strong) NSArray *liveRoomListArray;
@property (nonatomic, assign) BOOL isLoading;

@end

@implementation IndexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavBarItemWithImageName:@"nav_logo" navItemType:LeftItem selectorName:@""];
    [self setNavBarItemWithImageName:@"nav__icon_Channel" navItemType:RightItem selectorName:@""];
    //_titleArray = @[@"推荐主播",@"热门直播",@"热门视频"];
    //_imageArray = @[@"icon_hot_anchor",@"icon_hot_live",@"icon_hot_video"];
    _titleArray = @[@"推荐主播",@"热门直播"];
    _imageArray = @[@"icon_hot_anchor",@"icon_hot_live"];
    [self initUI];
    [self getIndexPageDataRequestWithType:0];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addSearchView];
    [self addTableView];
    [self addHeaderView];
    [self addRefreshHeaderView];
}

//添加搜索条
- (void)addSearchView
{
    UIImageView *bgImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SEARCH_WIDTH, SEARCH_HEIGHT) placeholderImage:nil];
    bgImageView.backgroundColor = SEARCH_BG_COLOR;
    [CommonTool clipView:bgImageView withCornerRadius:SEARCH_RADIUS];
    
    UIImage *searchIconImage = [UIImage imageNamed:@"nav_icon_search"];
    float x = SEARCH_SPACE_X;
    float iconWidth = searchIconImage.size.width/3;
    float iconHeight = searchIconImage.size.height/3;
    UIImageView *iconImagView = [CreateViewTool createImageViewWithFrame:CGRectMake(x, (bgImageView.frame.size.height - iconHeight)/2, iconWidth, iconHeight) placeholderImage:searchIconImage];
    [bgImageView addSubview:iconImagView];
    
    x += iconWidth + SEARCH_ADD_X;
    UILabel *tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, 0, bgImageView.frame.size.width - x, bgImageView.frame.size.height) textString:SEARCH_PLACEHOLDER textColor:SEARCH_PLACEHOLDER_COLOR textFont:SEARCH_PLACEHOLDER_FONT];
    [bgImageView addSubview:tipLabel];
    self.navigationItem.titleView = bgImageView;
}

//添加表
- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) tableType:UITableViewStylePlain tableDelegate:self];
    if ([self.table respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.table setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.table respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.table setLayoutMargins:UIEdgeInsetsZero];
    }
}

//添加广告
- (void)addHeaderView
{
    if (!self.advView)
    {
        _advView = [[AdvView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ADVVIEW_HEIGHT)];
        _advView.backgroundColor = [UIColor whiteColor];
    }
    if (self.bannerListArray && [self.bannerListArray count] > 0)
    {
        _advView.delegate = self;
        [_advView setAdvData:self.bannerListArray];
    }
    [self.table setTableHeaderView:_advView];
}

#pragma mark 刷新数据
- (void)refreshData
{
    if (!self.isLoading)
    {
        [self getIndexPageDataRequestWithType:1];
    }
}

#pragma mark 获取首页数据
- (void)getIndexPageDataRequestWithType:(int)type
{
    __weak typeof(self) weakSelf = self;
    if (type == 0)
    {
        [SVProgressHUD showWithStatus:LOADING_TIP];
    }
    
    NSString *urlString = INDEX_PAGE_URL;
    self.isLoading = YES;
    NSDictionary *requestDic = nil;
    [[RequestTool alloc] requestWithUrl:urlString
                         requestParamas:requestDic
                            requestType:RequestTypeAsynchronous
                          requestSucess:^(AFHTTPRequestOperation *operation, id responseDic)
     {
         NSLog(@"INDEX_PAGE_URL===%@",responseDic);
         NSDictionary *dataDic = (NSDictionary *)responseDic;
         int errorCode = [dataDic[@"errorCode"] intValue];
         NSString *errorMessage = dataDic[@"errorMessage"];
         errorMessage = errorMessage ? errorMessage : LOADING_FAIL;
         weakSelf.isLoading = NO;
         [weakSelf.refreshHeaderView endRefreshing];
         if (errorCode == 200)
         {
             if (type == 0)
             {
                 [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS];
             }
             [weakSelf setDataWithDictionary:dataDic];
         }
         else
         {
             if (type == 0)
             {
                 [SVProgressHUD showErrorWithStatus:errorMessage];
             }
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         weakSelf.isLoading = NO;
         [weakSelf.refreshHeaderView endRefreshing];
         NSLog(@"INDEX_PAGE_URL==%@",error);
         if (type == 0)
         {
             [SVProgressHUD showErrorWithStatus:LOADING_FAIL];
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
    NSArray *bannerListArray = dataDic[@"result"][@"bannerList"];
    if (!bannerListArray || [bannerListArray count] == 0)
    {
        self.table.tableHeaderView = nil;
        _advView.delegate = nil;
    }
    else
    {
        self.bannerListArray = bannerListArray;
        [self addHeaderView];
    }
    
    NSArray *anchorListArray = dataDic[@"result"][@"anchorList"];
    if (anchorListArray && [anchorListArray count] > 0)
    {
        self.anchorListArray = anchorListArray;
    }
    
    NSArray *liveRoomListArray = dataDic[@"result"][@"liveRoomList"];
    if (liveRoomListArray && [liveRoomListArray count] > 0)
    {
        self.liveRoomListArray = liveRoomListArray;
    }
    [self.table reloadData];
}

#pragma mark UITableViewDelegate&UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }
    else if (section == 1)
    {
        return 1 + ceil([self.liveRoomListArray count]/2.0);
    }
    return (section == 0) ? 2 : 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        return ANCHORVIEW_HEIGHT;
    }
    return (indexPath.row == 0) ? HEADERVIEW_HEIGHT : ROOM_LIST_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEADER_HEIGHT) placeholderImage:nil];
    imageView.backgroundColor = [UIColor clearColor];
    return imageView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID1 = @"CellID1";
    static NSString *cellID2 = @"CellID2";
    static NSString *cellID3 = @"CellID3";
    UITableViewCell *cell;
    if (indexPath.row == 0)
    {
        cell = (HeaderViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID1];
        if (!cell)
        {
            cell = [[HeaderViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [((HeaderViewCell *)cell).headerView setDataWithIconName:self.imageArray[indexPath.section] tipText:self.titleArray[indexPath.section] isShowMore:(indexPath.section == 0)];
    }
    else
    {
        if (indexPath.section == 0 && indexPath.row == 1)
        {
            cell = (AnchorListCell *)[tableView dequeueReusableCellWithIdentifier:cellID2];
            if (!cell)
            {
                cell = [[AnchorListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (self.anchorListArray && [self.anchorListArray count] > 0)
            {
               ((AnchorListCell *)cell).anchorListView.delegate = self;
            }
            
            [((AnchorListCell *)cell).anchorListView setDataWithArray:self.anchorListArray];
        }
        else
        {
            cell = (VideoListCell *)[tableView dequeueReusableCellWithIdentifier:cellID3];
            if (!cell)
            {
                cell = [[VideoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            int index = (int)(indexPath.row - 1) * 2;
            NSDictionary *leftDic = self.liveRoomListArray[index];
            NSDictionary *rightDic = (index + 1 >= [self.liveRoomListArray count]) ? nil : self.liveRoomListArray[index + 1];
            [((VideoListCell *)cell) setLeftViewData:leftDic rightViewData:rightDic];
            
            ((VideoListCell *)cell).leftView.clickButton.tag = index + 1;
            [((VideoListCell *)cell).leftView.clickButton addTarget:self action:@selector(clickButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            ((VideoListCell *)cell).rightView.clickButton.tag = index + 2;
            [((VideoListCell *)cell).rightView.clickButton addTarget:self action:@selector(clickButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        UITabBarController *tabBarController = (UITabBarController *)[DELEGATE window].rootViewController;
        tabBarController.selectedIndex = indexPath.section;
        
    }
}


#pragma mark 点击广告
- (void)advView:(AdvView *)advView clickedAtIndex:(int)index
{
    NSDictionary *dataDic = self.bannerListArray[index];
    [self goToRoomViewWithData:dataDic];
}

#pragma mark 点击主播推荐
- (void)anchorListView:(AnchorListView *)anchorListView didSelectedAnchorAtIndex:(int)index
{
    NSDictionary *dataDic = self.anchorListArray[index];
    [self goToRoomViewWithData:dataDic];
}

#pragma mark 点击进入房间
- (void)clickButtonPressed:(UIButton *)sender
{
    NSDictionary *dataDic = self.liveRoomListArray[sender.tag - 1];
    [self goToRoomViewWithData:dataDic];
}


#pragma mark 进入房间
- (void)goToRoomViewWithData:(NSDictionary *)dataDic
{
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
