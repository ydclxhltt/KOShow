//
//  CommentListCell.m
//  KOShow
//
//  Created by 陈磊 on 15/12/10.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define SPACE_X             5.0
#define ICON_WH             40.0
#define ADD_X               10.0
#define LABEL_HEIGHT        20.0
#define TIME_LABEL_WIDTH    50.0
#define RANK_ICON_WIDTH     45.0
#define RANK_ICON_HEIGHT    20.0

#import "CommentListCell.h"

@interface CommentListCell()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *rankImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation CommentListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    return self;
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addIconImageView];
    [self addLabels];
}

- (void)addIconImageView
{
    _iconImageView = [CreateViewTool createRoundImageViewWithFrame:CGRectMake(SPACE_X, (COMMENT_ROW_HEIGHT - ICON_WH)/2, ICON_WH, ICON_WH) placeholderImage:[UIImage imageNamed:@"2.jpg"] borderColor:LAYER_COLOR  imageUrl:@""];
    [self.contentView addSubview:_iconImageView];
}

- (void)addLabels
{
    float x = _iconImageView.frame.origin.x + _iconImageView.frame.size.width + ADD_X;
    float y = _iconImageView.frame.origin.y;
    
    _rankImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(x, y, RANK_ICON_WIDTH, RANK_ICON_HEIGHT) placeholderImage:nil];
    [self.contentView addSubview:_rankImageView];
    
    x += _rankImageView.frame.size.width + SPACE_X;
    
    _nameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, SCREEN_WIDTH - x - TIME_LABEL_WIDTH - SPACE_X, LABEL_HEIGHT) textString:@"爱玩坦克的楼主" textColor:DETAIL_TEXT_COLOR textFont:DETAIL_TEXT_FONT];
    [self.contentView addSubview:_nameLabel];
    
    x = _iconImageView.frame.origin.x + _iconImageView.frame.size.width + ADD_X;
    y += _nameLabel.frame.size.height;
    _contentLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, SCREEN_WIDTH - x - TIME_LABEL_WIDTH - SPACE_X, LABEL_HEIGHT) textString:@"精彩内容,不容错过～" textColor:MAIN_TEXT_COLOR textFont:MAIN_TEXT_FONT];
    [self.contentView addSubview:_contentLabel];
    
    x = SCREEN_WIDTH - SPACE_X - TIME_LABEL_WIDTH;
    y = (COMMENT_ROW_HEIGHT - LABEL_HEIGHT)/2;
    _timeLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, TIME_LABEL_WIDTH, LABEL_HEIGHT) textString:@"1小时前" textColor:DETAIL_TEXT_COLOR textFont:DETAIL_TEXT_FONT];
    //_timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_timeLabel];
    
}

- (void)setCommentDataWithImageUrl:(NSString *)imageUrl rankLevel:(int)level  userName:(NSString *)name commentContent:(NSString *)content  lastTime:(NSString *)time
{
    [self.iconImageView setImageWithURL:[NSURL URLWithString:imageUrl ? imageUrl : @""] placeholderImage:[UIImage imageNamed:@"2.jpg"]];
    [self.rankImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"level%d.png",level]]];
    self.nameLabel.text = (name) ? name : @"";
    self.contentLabel.text = content ? content : @"";
    self.timeLabel.text = time ? time : @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
