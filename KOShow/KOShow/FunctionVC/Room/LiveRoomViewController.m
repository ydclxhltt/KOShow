//
//  LiveRoomViewController.m
//  KOShow
//
//  Created by 陈磊 on 15/12/5.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define ADD_Y               5.0
#define SPACE_X             5.0
#define ADD_X               15.0
#define ADD_X1              10.0
#define LABEL_HEIGHT        20.0
#define LABEL_WIDTH         200.0
#define R_LABEL_WIDTH       20.0
#define R_LABEL_HEIGHT      20.0
#define ICON_WIDTH          45.0
#define ICON_HEIGHT         20.0
#define ROW_HEIGHT          44.0
#define CHAT_ROW_HEIGHT     20.0
#define HEADER_HEIGHT       50.0
//chat
#define CHAT_HEADER_HEIGHT  35.0
#define HEADER_SPACE_X      15.0
#define LABEL_WIDTH         200.0
#define DETAIL_LINE_COLOR   RGB(233.0,233.0,233.0)
#define FOCUS_BUTTON_WH     20.0


#import "LiveRoomViewController.h"
#import "AnchorDetailView.h"
#import "BarrageHeader.h"
#import "BarrageSpriteUtility.h"
#import "UIImage+Barrage.h"
#import "KOShowSocketTool.h"

@interface LiveRoomViewController()<UITableViewDataSource,UITableViewDelegate>
{
    NSTimer * timer;
    NSInteger count;
    KOShowSocketTool *socketTool;
}
@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) UITableView *rankTableView;
@property (nonatomic, strong) AnchorDetailView *anchorDetailView;
@property (nonatomic, strong) BarrageRenderer *barrageRenderer;

@end

@implementation LiveRoomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    socketTool = [[KOShowSocketTool alloc] init];
    [socketTool contentServerWithIp:@"1.192.105.180" port:5600];
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
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    [socketTool sendLoginRoomRequestWithUserID:@"17603769285176037692851760376928" nickName:@"17603769285clei哈哈" roomID:@"1234"];
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


#pragma mark 设置弹幕
- (void)setBarrageRendererView
{
    if (!_barrageRenderer)
    {
        _barrageRenderer = [[BarrageRenderer alloc]init];
        [self.upSideView addSubview:_barrageRenderer.view];
    }
    
    if (self.playerViewSize == PlayerViewSizeFullScreen)
    {
        [_barrageRenderer start];
    }
    else
    {
        [_barrageRenderer stop];
    }
    [self setTimer];
}

- (void)setTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(autoSendBarrage) userInfo:nil repeats:YES];
    if (self.playerViewSize == PlayerViewSizeSmallScreen)
    {
        [timer invalidate];
        timer = nil;
    }

}

- (void)autoSendBarrage
{
    [_barrageRenderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L]];
}

#pragma mark - 弹幕描述符生产方法

/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = [NSString stringWithFormat:@" 过场文字弹幕:%ld ",(long)count++];
    descriptor.params[@"textColor"] = [UIColor whiteColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    return descriptor;
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, (tableView == self.rankTableView) ? HEADER_HEIGHT : CHAT_HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor whiteColor];
    if (tableView == self.rankTableView)
    {
        UIImage *image = [UIImage imageNamed:@"rank_header"];
        UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake((headerView.frame.size.width - image.size.width/3)/2, (headerView.frame.size.height - image.size.height/3)/2, image.size.width/3, image.size.height/3) placeholderImage:image];
        [headerView addSubview:imageView];
    }
    else if (tableView == self.chatTableView)
    {
        float y = 0;
        float x = HEADER_SPACE_X;
        UILabel *nameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, headerView.frame.size.width, headerView.frame.size.height) textString:@"炉石传说的直播间" textColor:DETAIL_TEXT_COLOR textFont:FONT(14.0)];
        [headerView addSubview:nameLabel];
        
        UIButton *collectButton = [CreateViewTool createButtonWithFrame:CGRectMake(headerView.frame.size.width -  x - FOCUS_BUTTON_WH, (nameLabel.frame.size.height - FOCUS_BUTTON_WH)/2, FOCUS_BUTTON_WH, FOCUS_BUTTON_WH) buttonImage:@"icon_focus" selectorName:@"" tagDelegate:self];
        [headerView addSubview:collectButton];
        
        y += nameLabel.frame.size.height;
        UIImageView *lineImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, y, headerView.frame.size.width, 1.0) placeholderImage:nil];
        lineImageView.backgroundColor = DETAIL_LINE_COLOR;
        [headerView addSubview:lineImageView];

    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (tableView == self.rankTableView) ? HEADER_HEIGHT : CHAT_HEADER_HEIGHT;
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
            cell.imageView.transform = CGAffineTransformScale(cell.imageView.transform, .5, .5);
        }
        
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"level%d",((int)indexPath.row + 1) % 5 + 1 ]];
        cell.textLabel.font = FONT(12.0);
        NSString *text = @"我是观众: 这个直播间太精彩了";
        NSMutableAttributedString *textString = [[NSMutableAttributedString alloc] initWithString:text];
        [CommonTool makeString:text toAttributeString:textString withString:@"我是观众:" withTextColor:DETAIL_TEXT_COLOR withTextFont:FONT(12.0)];
        [CommonTool makeString:text toAttributeString:textString withString:@"这个直播间太精彩了" withTextColor:MAIN_TEXT_COLOR withTextFont:FONT(12.0)];
        cell.textLabel.attributedText = textString;
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
