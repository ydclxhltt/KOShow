//
//  VideoRoomViewController.m
//  KOShow
//
//  Created by 陈磊 on 15/12/5.
//  Copyright © 2015年 chenlei. All rights reserved.
//
#define ADD_Y               5.0
#define HEADER_SPACE_X1     5.0
#define HEADER_SPACE_X      15.0
#define LABEL_HEIGHT        44.0
#define LABEL_WIDTH         200.0
#define HEADER_HEIGHT       80.0
#define DETAIL_LINE_COLOR   RGB(233.0,233.0,233.0)

#import "CommentListCell.h"
#import "VideoRoomViewController.h"

@interface VideoRoomViewController()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *commentTableView;
@property (nonatomic, strong) UITextView *roomDetailView;

@end

@implementation VideoRoomViewController

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
    for (int i = 0; i < 2; i++)
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
        [self addCommentTable];
    }
    else if (index == 1)
    {
        [self addDetailView];
    }
}

- (void)addCommentTable
{
    if (_commentTableView)
    {
        [_commentTableView reloadData];
        return;
    }
    _commentTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, BUTTON_BAR_HEIGHT + ADD_Y, self.view.frame.size.width, self.downSideView.frame.size.height - BUTTON_BAR_HEIGHT - TOOL_BAR_HEIGHT - ADD_Y) style:UITableViewStylePlain];
    _commentTableView.dataSource = self;
    _commentTableView.delegate = self;
    _commentTableView.backgroundColor = [UIColor clearColor];
    _commentTableView.tag = 1000;
    [self.downSideView addSubview:_commentTableView];
}

- (void)addDetailView
{
    if (_roomDetailView)
    {
        return;
    }

    
    _roomDetailView = [[UITextView alloc] initWithFrame:CGRectMake(HEADER_SPACE_X1, BUTTON_BAR_HEIGHT + ADD_Y, self.view.frame.size.width - 2 * HEADER_SPACE_X1, self.downSideView.frame.size.height - BUTTON_BAR_HEIGHT - ADD_Y)];
    _roomDetailView.tag = 1001;
    _roomDetailView.textColor = MAIN_TEXT_COLOR;
    _roomDetailView.editable = NO;
    _roomDetailView.font = MAIN_TEXT_FONT;
    NSString *text =  @"\n    视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍\n\n关键词: 视频介绍,视频介绍";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    [CommonTool makeString:text toAttributeString:string withString:@"关键词: 视频介绍,视频介绍" withTextColor:DETAIL_TEXT_COLOR withTextFont:DETAIL_TEXT_FONT];
    [CommonTool makeString:text toAttributeString:string withString:@"    视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍视频介绍" withTextColor:MAIN_TEXT_COLOR withTextFont:MAIN_TEXT_FONT];
    [CommonTool makeString:text toAttributeString:string withString:text withLineSpacing:10.0];
    _roomDetailView.attributedText = string;
    [self.downSideView addSubview:_roomDetailView];
}


#pragma mark UITableViewDelegate&UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return COMMENT_ROW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    float y = 0;
    float x = HEADER_SPACE_X;
    UILabel *nameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, headerView.frame.size.width, LABEL_HEIGHT) textString:@"视频名称" textColor:DETAIL_TEXT_COLOR textFont:FONT(14.0)];
    [headerView addSubview:nameLabel];
    
    y += nameLabel.frame.size.height;
    UIImageView *lineImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, y, headerView.frame.size.width, 1.0) placeholderImage:nil];
    lineImageView.backgroundColor = DETAIL_LINE_COLOR;
    [headerView addSubview:lineImageView];
    
    x = HEADER_SPACE_X1;
    float height = headerView.frame.size.height - y;
    UIImage *image = [UIImage imageNamed:@"anchor_detail_line"];
    float iconWidth = image.size.width/3;
    float iconHeight = image.size.height/3;
     y += (height - iconHeight)/2;
    UIImageView *detailImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(x, y, iconWidth, iconHeight) placeholderImage:image];
    [headerView addSubview:detailImageView];
    x += HEADER_SPACE_X1;
    y -= (height - iconHeight)/2;
    UILabel *titleLable = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, headerView.frame.size.width - x, height) textString:@" 评论列表" textColor:MAIN_TEXT_COLOR textFont:FONT(15.0)];
    [headerView addSubview:titleLable];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellID";
    CommentListCell *cell = (CommentListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[CommentListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [(CommentListCell *)cell setCommentDataWithImageUrl:@"" rankLevel:(int)indexPath.row % 5 + 1 userName:@"爱坦克的楼主" commentContent:@"精彩内容，不容错过～" lastTime:@"1小时前"];
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
