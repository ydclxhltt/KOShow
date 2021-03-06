//
//  AnchorListView.m
//  KOShow
//
//  Created by 陈磊 on 15/11/26.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define SPACE_X             10.0 * CURRENT_SCALE
#define SPACE_Y             10.0 * CURRENT_SCALE
#define ADD_X               20.0 * CURRENT_SCALE
#define ADD_Y               5.0 * CURRENT_SCALE

#import "AnchorListView.h"

@interface AnchorListView()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation AnchorListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUI];
    }
    return self;
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addScrollView];
    
}

//添加ScrollView
- (void)addScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
}


#pragma mark 设置数据
- (void)setDataWithArray:(NSArray *)array
{
    if (!array || [array count] == 0)
    {
        return;
    }
    self.dataArray = array;
    float iconWidth = (self.scrollView.frame.size.width - 2 * SPACE_X - 3 * ADD_X)/4;
    float iconHeight = iconWidth;
    float labelWidth = iconWidth;
    float labelHeight = (self.scrollView.frame.size.height - 2 * SPACE_Y - iconHeight -  ADD_Y)/2;
    NSLog(@"===%.1f",labelHeight);
    for (int i = 0; i < [array count]; i ++)
    {
        float x = i * iconWidth + SPACE_X + ADD_X * i;
        float y = SPACE_Y;
        UIImageView *iconImageView = (UIImageView *)[self.scrollView viewWithTag:100 + i];
        UILabel *nameLabel = (UILabel *)[self.scrollView viewWithTag:1000 + i];
        UILabel *roomNameLabel = (UILabel *)[self.scrollView viewWithTag:10000 + i];
        if (!iconImageView)
        {
            iconImageView = [CreateViewTool createRoundImageViewWithFrame:CGRectMake(x, y, iconWidth, iconHeight) placeholderImage:nil borderColor:LAYER_COLOR imageUrl:@""];
            iconImageView.tag = 100 + i;
            [self.scrollView addSubview:iconImageView];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
            [iconImageView addGestureRecognizer:tapGesture];
     
            
            y += iconImageView.frame.size.height + ADD_Y;
            
            nameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(iconImageView.frame.origin.x, y, labelWidth, labelHeight) textString:@"" textColor:MAIN_TEXT_COLOR textFont:MAIN_TEXT_FONT];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            nameLabel.tag = 1000 + i;
            [self.scrollView addSubview:nameLabel];
            
             y += nameLabel.frame.size.height;
            
            roomNameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(iconImageView.frame.origin.x, y, labelWidth, labelHeight) textString:@"" textColor:DETAIL_TEXT_COLOR textFont:DETAIL_TEXT_FONT];
            roomNameLabel.textAlignment = NSTextAlignmentCenter;
            roomNameLabel.tag = 10000 + i;
            [self.scrollView addSubview:roomNameLabel];
        }
        [self setDataforIndex:i];
    }
    self.scrollView.contentSize = CGSizeMake( 2 * SPACE_X + ([array count] - 1) * ADD_X + [array count] * iconWidth, self.scrollView.frame.size.height);
}

- (void)setDataforIndex:(int)index
{
    NSDictionary *dataDic = self.dataArray[index];
    UIImageView *iconImageView = (UIImageView *)[self.scrollView viewWithTag:100 + index];
    UILabel *nameLabel = (UILabel *)[self.scrollView viewWithTag:1000 + index];
    UILabel *roomNameLabel = (UILabel *)[self.scrollView viewWithTag:10000 + index];
    [iconImageView setImageWithURL:[NSURL URLWithString:[[KOShowShareApplication shareApplication] makeImageUrlWithRightHalfString:dataDic[@"small_header_url"]]] placeholderImage:[UIImage imageNamed:@"anchor_default.jpg"]];
    NSString *name = dataDic[@"nickname"];
    nameLabel.text = (name) ? name : @"";
    NSString *title = dataDic[@"title"];
    roomNameLabel.text = (title) ? title : @"";
}

#pragma mark 点击主播头像
- (void)tapGestureHandle:(UITapGestureRecognizer *)tapGesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(anchorListView:didSelectedAnchorAtIndex:)])
    {
        [self.delegate anchorListView:self didSelectedAnchorAtIndex:(int)tapGesture.view.tag - 100];
    }
}


@end
