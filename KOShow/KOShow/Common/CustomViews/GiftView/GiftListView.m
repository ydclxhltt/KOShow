//
//  GiftListView.m
//  KOShow
//
//  Created by 陈磊 on 15/12/8.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define TIP_LABEL_HEIGHT        30.0
#define LABEL_HEIGHT            20.0
#define GIFT_ICON_WH            55.0
#define SPACE_X                 10.0
#define SPACE_Y                 10.0
#define PER_PAGE_ROW            2
#define PER_PAGE_COLUMN         3
#define PER_PAGE_COUNT          6
#define GIFT_VIEW_LINE_COLOR    RGB(233.0,233.0,233.0)

#import "GiftListView.h"

@interface GiftListView()

@property (nonatomic, strong) UIScrollView *giftScrollView;

@end

@implementation GiftListView

- (instancetype)initWithFrame:(CGRect)frame giftArray:(NSArray *)giftArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initViewWithGiftArray:giftArray];
    }
    return self;
}

- (void)initViewWithGiftArray:(NSArray *)giftArray
{
    self.giftArray = giftArray;
    if (!giftArray || [giftArray count] == 0)
    {
        return;
    }
    
    float y = 0;
    
    UIImageView *lineImageView1 = [CreateViewTool createImageViewWithFrame:CGRectMake(0, y, self.frame.size.width, 1.0) placeholderImage:nil];
    lineImageView1.backgroundColor = GIFT_VIEW_LINE_COLOR;
    [self addSubview:lineImageView1];
    
    UILabel *tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake(SPACE_X, y, self.frame.size.width - 2 * SPACE_X, TIP_LABEL_HEIGHT) textString:@"点击赠送" textColor:DETAIL_TEXT_COLOR textFont:FONT(14.0)];
    [self addSubview:tipLabel];
    
    y += tipLabel.frame.size.height;
    UIImageView *lineImageView2 = [CreateViewTool createImageViewWithFrame:CGRectMake(0, y, self.frame.size.width, 1.0) placeholderImage:nil];
    lineImageView2.backgroundColor = GIFT_VIEW_LINE_COLOR;
    [self addSubview:lineImageView2];
    
    
    _giftScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, y, self.frame.size.width, self.frame.size.height - y)];
    _giftScrollView.pagingEnabled = YES;
    _giftScrollView.showsHorizontalScrollIndicator = NO;
    _giftScrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_giftScrollView];
    
    [self addGiftView];
    
}

- (void)addGiftView
{
    int row = 0;
    int column = 0;
    int page = 0;
    
    float itemWidth = self.giftScrollView.frame.size.width/PER_PAGE_COLUMN;
    float itemHeight = self.giftScrollView.frame.size.height/PER_PAGE_ROW;
    
    for (int i = 0; i < [self.giftArray count]; i++)
    {
        // Pagination
        if (i % PER_PAGE_COUNT == 0)
        {
            page ++;    // Increase the number of pages
            row = 0;    // the number of lines is 0
            column = 0; // the number of columns is 0
        }
        else if (i % PER_PAGE_COLUMN == 0)
        {
            // NewLine
            row += 1;   // Increase the number of lines
            column = 0; // The number of columns is 0
        }
        
        NSDictionary *dic = self.giftArray[i];
        NSString *imageUrl = [[KOShowShareApplication shareApplication] makeImageUrlWithRightHalfString:dic[@"img_url"]];
        NSString *nameString = dic[@"gname"];
        nameString = nameString ? nameString : @"";
        NSString *levelName = dic[@"level_name"];
        levelName = levelName ? levelName : @"免费";
        
        float x = ((page - 1) * self.giftScrollView.frame.size.width) + (column * itemWidth) + (itemWidth - GIFT_ICON_WH)/2;
        float y = row * itemHeight + SPACE_Y;
        UIButton *giftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        giftButton.frame = CGRectMake(x, y, GIFT_ICON_WH, GIFT_ICON_WH);
        //[giftButton setBackgroundImage:[UIImage imageNamed:self.giftArray[i]] forState:UIControlStateNormal];
        [giftButton setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal];
        //[giftButton setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:imageUrl]];
        giftButton.tag = i + 1;
        [giftButton addTarget:self action:@selector(giftButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.giftScrollView addSubview:giftButton];
        
        x = ((page - 1) * self.giftScrollView.frame.size.width) + (column * itemWidth);
        y += giftButton.frame.size.height;
        float height = LABEL_HEIGHT;
        UILabel *nameLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, itemWidth, height) textString:nameString textColor:MAIN_TEXT_COLOR textFont:MAIN_TEXT_FONT];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.giftScrollView addSubview:nameLabel];
        
        y += nameLabel.frame.size.height;
        UILabel *freeLabel = [CreateViewTool createLabelWithFrame:CGRectMake(x, y, itemWidth, height) textString:levelName textColor:APP_MAIN_COLOR textFont:FONT(13.0)];
        freeLabel.textAlignment = NSTextAlignmentCenter;
        [self.giftScrollView addSubview:freeLabel];
        
        column++;
    }
    
}

#pragma mark 点击礼物按钮
- (void)giftButtonPressed:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(giftListView:didSelectedGiftAtIndex:)])
    {
        [self.delegate giftListView:self didSelectedGiftAtIndex:(int)sender.tag - 1];
    }
}

@end
