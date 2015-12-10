//
//  LiveRoomViewController.m
//  KOShow
//
//  Created by 陈磊 on 15/12/5.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define ADD_Y           5.0
#define SPACE_X         5.0
#define ADD_X           15.0
#define ADD_X1          10.0
#define LABEL_HEIGHT    20.0
#define LABEL_WIDTH     200.0
#define R_LABEL_WIDTH   20.0
#define R_LABEL_HEIGHT  20.0
#define ICON_WIDTH      45.0
#define ICON_HEIGHT     20.0
#define ROW_HEIGHT      44.0
#define CHAT_ROW_HEIGHT 20.0
#define HEADER_HEIGHT   50.0


#import "LiveRoomViewController.h"
#import "AnchorDetailView.h"

@interface LiveRoomViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) UITableView *rankTableView;
@property (nonatomic, strong) AnchorDetailView *anchorDetailView;

@end

@implementation LiveRoomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark  功能按钮响应事件
- (void)buttonBarButtonPressed:(UIButton *)sender
{
    int tag = (int)sender.tag - 100;
    sender.selected = YES;
    self.roomToolBarView.hidden = (tag == 0) ? NO : YES;
    for (int i = 0; i < 3; i++)
    {
        UIButton *button = (UIButton *)[self.downSideView viewWithTag:100 + i];
        UIView *view = (UIView *)[self.downSideView viewWithTag:1000 + i];
        if (i != tag)
        {
            if (button)
            {
                button.selected = NO;
            }
            if (view)
            {
                view.hidden = YES;
            }
        }
        else
        {
            if (view)
            {
                view.hidden = NO;
            }
        }
    }
    [self addViewWithIndex:tag];
}

#pragma mark 添加视图
- (void)addViewWithIndex:(int)index
{
    if (index == 0)
    {
        [self addChatTable];
    }
    else if (index == 1)
    {
        [self addAnchorView];
    }
    else if (index == 2)
    {
        [self addRankView];
    }
}

- (void)addChatTable
{
    if (_chatTableView)
    {
        [_chatTableView reloadData];
        return;
    }
    _chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, BUTTON_BAR_HEIGHT + ADD_Y, self.view.frame.size.width, self.downSideView.frame.size.height - BUTTON_BAR_HEIGHT - TOOL_BAR_HEIGHT - ADD_Y) style:UITableViewStylePlain];
    _chatTableView.dataSource = self;
    _chatTableView.delegate = self;
    _chatTableView.backgroundColor = [UIColor clearColor];
    _chatTableView.tag = 1000;
    [self.downSideView addSubview:_chatTableView];
}

- (void)addAnchorView
{
    if (_anchorDetailView)
    {
        return;
    }
    _anchorDetailView = [[AnchorDetailView alloc] initWithFrame:CGRectMake(0, BUTTON_BAR_HEIGHT + ADD_Y, self.view.frame.size.width, self.downSideView.frame.size.height - BUTTON_BAR_HEIGHT - ADD_Y)];
    _anchorDetailView.tag = 1001;
    [self.downSideView addSubview:_anchorDetailView];
}

- (void)addRankView
{
    if (_rankTableView)
    {
        [_rankTableView reloadData];
        return;
    }
    _rankTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, BUTTON_BAR_HEIGHT + ADD_Y, self.view.frame.size.width, self.downSideView.frame.size.height - BUTTON_BAR_HEIGHT - ADD_Y) style:UITableViewStylePlain];
    _rankTableView.dataSource = self;
    _rankTableView.delegate = self;
    _rankTableView.backgroundColor = [UIColor clearColor];
    _rankTableView.tag = 1002;
    [self.downSideView addSubview:_rankTableView];
}

#pragma mark UITableViewDelegate&UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (tableView == self.chatTableView) ? 1000 : 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (tableView == self.chatTableView) ? CHAT_ROW_HEIGHT : ROW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIImage *image = [UIImage imageNamed:@"rank_header"];
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake((headerView.frame.size.width - image.size.width/3)/2, (headerView.frame.size.height - image.size.height/3)/2, image.size.width/3, image.size.height/3) placeholderImage:image];
    [headerView addSubview:imageView];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (tableView == self.rankTableView) ? HEADER_HEIGHT : 0.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID1 = @"CellID1";
    static NSString *cellID2 = @"CellID2";
    UITableViewCell *cell;
    if (tableView == self.chatTableView)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = @"1";
    }
    if (tableView == self.rankTableView)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellID2];
        UILabel *rankLabel = (UILabel *)[cell.contentView viewWithTag:100];
        UIImageView *iconImageView = (UIImageView *)[cell.contentView viewWithTag:101];
        UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:102];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            rankLabel = [CreateViewTool createLabelWithFrame:CGRectMake(SPACE_X, (cell.frame.size.height - R_LABEL_HEIGHT)/2, R_LABEL_WIDTH, R_LABEL_HEIGHT) textString:@"" textColor:[UIColor whiteColor] textFont:FONT(13.0)];
            rankLabel.tag = 100;
            rankLabel.adjustsFontSizeToFitWidth = YES;
            rankLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:rankLabel];
            
            iconImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(rankLabel.frame.origin.x + rankLabel.frame.size.width + ADD_X, (cell.frame.size.height - ICON_HEIGHT)/2, ICON_WIDTH, ICON_HEIGHT) placeholderImage:nil];
            iconImageView.tag = 101;
            [cell.contentView addSubview:iconImageView];
            
            nameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(iconImageView.frame.origin.x + iconImageView.frame.size.width + ADD_X1, (cell.frame.size.height - LABEL_HEIGHT)/2, LABEL_WIDTH, LABEL_HEIGHT) textString:@"" textColor:[UIColor blackColor] textFont:FONT(15.0)];
            nameLabel.tag = 102;
            [cell.contentView addSubview:nameLabel];
        }
        
        rankLabel.backgroundColor = (indexPath.row < 3) ? APP_MAIN_COLOR : [UIColor lightGrayColor];
        rankLabel.text = [NSString stringWithFormat:@"%d",(int)indexPath.row + 1];
        nameLabel.text = [NSString stringWithFormat:@"我是粉丝%d",(int)indexPath.row + 1];
        iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%d",((int)indexPath.row + 1) % 5 + 1 ]];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
