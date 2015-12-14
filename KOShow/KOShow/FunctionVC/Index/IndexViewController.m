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

#import "IndexViewController.h"
#import "AdvView.h"
#import "HeaderViewCell.h"
#import "AnchorListCell.h"
#import "VideoListCell.h"
#import "VideoRoomViewController.h"

@interface IndexViewController ()<UITableViewDataSource,UITableViewDelegate,AdvViewClickedDelegate>

@property (nonatomic, strong) AdvView *advView;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation IndexViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavBarItemWithImageName:@"nav_logo" navItemType:LeftItem selectorName:@""];
    [self setNavBarItemWithImageName:@"nav__icon_Channel" navItemType:RightItem selectorName:@""];
    _titleArray = @[@"推荐主播",@"热门直播",@"热门视频"];
    _imageArray = @[@"icon_hot_anchor",@"icon_hot_live",@"icon_hot_video"];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addSearchView];
    [self addTableView];
    [self addHeaderView];
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
    self.table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

//添加广告
- (void)addHeaderView
{
    _advView = [[AdvView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ADVVIEW_HEIGHT)];
    _advView.backgroundColor = [UIColor whiteColor];
    [_advView setAdvData:@[@"",@""]];
    [self.table setTableHeaderView:_advView];
}

#pragma mark UITableViewDelegate&UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
            [((AnchorListCell *)cell).anchorListView setDataWithArray:@[@"Mark",@"Jerry",@"Jim",@"Sophia"]];
        }
        else
        {
            cell = (VideoListCell *)[tableView dequeueReusableCellWithIdentifier:cellID3];
            if (!cell)
            {
                cell = [[VideoListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID3];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [((VideoListCell *)cell).leftView.clickButton addTarget:self action:@selector(clickButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [((VideoListCell *)cell).rightView.clickButton addTarget:self action:@selector(clickButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
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
    videoRoomViewController.playerViewType = PlayerViewTypeVideo;
    videoRoomViewController.hidesBottomBarWhenPushed = YES;
    [videoRoomViewController setVideoUrl:@"http://183.232.54.230:1935/vod/sycf/2015/11/17/yl1116lxcp01_zqbz.mp4/playlist.m3u8?sessionID=d9ffcbe9b9fa4bb5861612def1df6552"];
    [self.navigationController pushViewController:videoRoomViewController animated:YES];
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
