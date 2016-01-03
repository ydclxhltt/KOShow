//
//  GiftListCell.m
//  KOShow
//
//  Created by 陈磊 on 15/12/24.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define GIFT_ICON_WH   GIFT_ROW_HEIGHT
#define SPACE_Y        0.0
#define ADD_X          5.0
#define SPACE_X        15.0
#define MESSAGE_FONT   FONT(14.0)

#import "GiftListCell.h"

@interface GiftListCell()

@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *giftImageView;

@end

@implementation GiftListCell

- (void)awakeFromNib {
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
    _messageLabel = [CreateViewTool createLabelWithFrame:CGRectMake(SPACE_X, SPACE_Y, 150.0, GIFT_ROW_HEIGHT) textString:@"向主播发送礼物" textColor:MAIN_TEXT_COLOR textFont:MESSAGE_FONT];
    //_messageLabel.textAlignment = NSTextAlignment
    [self.contentView addSubview:_messageLabel];
    
    float x = _messageLabel.frame.origin.x + _messageLabel.frame.size.width + ADD_X;
    _giftImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(x, SPACE_Y, GIFT_ICON_WH, GIFT_ICON_WH) placeholderImage:nil];
    [self.contentView addSubview:_giftImageView];
}

- (void)setMessageWithUserNickName:(NSString *)nickName anchorName:(NSString *)anchorName giftName:(NSString *)giftName
{
    NSString *message = [NSString stringWithFormat:@"%@向主播%@赠送%@",nickName,anchorName,giftName];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:message];
    [attrString addAttributes:@{NSForegroundColorAttributeName:APP_MAIN_COLOR} range:[message rangeOfString:nickName]];
    [attrString addAttributes:@{NSForegroundColorAttributeName:APP_MAIN_COLOR} range:[message rangeOfString:anchorName]];
    [attrString addAttributes:@{NSForegroundColorAttributeName:APP_MAIN_COLOR} range:[message rangeOfString:giftName]];
    self.messageLabel.attributedText = attrString;
    
    CGSize size = [message sizeWithAttributes:@{NSFontAttributeName:MESSAGE_FONT}];
    CGRect frame = self.messageLabel.frame;
    frame.size.width = size.width;
    self.messageLabel.frame = frame;
    
    CGRect imageFrame = self.giftImageView.frame;
    imageFrame.origin.x = _messageLabel.frame.origin.x + _messageLabel.frame.size.width + ADD_X;
    self.giftImageView.frame = imageFrame;
}

- (void)setMessageWithUserNickName:(NSString *)nickName anchorName:(NSString *)anchorName giftName:(NSString *)giftName giftImage:(UIImage *)image
{
    [self setMessageWithUserNickName:nickName anchorName:anchorName giftName:giftName];
    self.giftImageView.image = [UIImage imageNamed:giftName];
}

- (void)setMessageWithUserNickName:(NSString *)nickName anchorName:(NSString *)anchorName giftName:(NSString *)giftName giftImageUrl:(NSString *)imageUrl
{
    imageUrl = imageUrl ? imageUrl : @"";
    [self setMessageWithUserNickName:nickName anchorName:anchorName giftName:giftName];
    [self.giftImageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
