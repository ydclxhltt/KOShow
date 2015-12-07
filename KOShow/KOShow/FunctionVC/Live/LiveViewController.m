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

#import "LiveViewController.h"
#import "AvPlayerViewController.h"
#import "VideoListCell.h"
#import "SegmentView.h"
#import "AdvView.h"

@interface LiveViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) AdvView *advView;

@end

@implementation LiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavBarItemWithImageName:@"nav_logo" navItemType:LeftItem selectorName:@""];
    [self setNavBarItemWithImageName:@"nav_search" navItemType:RightItem selectorName:@""];
    [self initUI];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTitleView];
    [self addTableView];
    if (VideoTypeLive == self.videoType)
    {
        [self addHeaderView];
    }
    
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
    AvPlayerViewController *avPlayerViewController = [[AvPlayerViewController alloc] init];
    avPlayerViewController.hidesBottomBarWhenPushed = YES;
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
