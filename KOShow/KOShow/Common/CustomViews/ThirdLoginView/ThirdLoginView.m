//
//  ThirdLoginView.m
//  KOShow
//
//  Created by 陈磊 on 15/12/26.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#define TIP_TEXT                @"快捷登录方式"
#define TIP_LINE_COLOR          RGB(187.0,187.0,187.0)
#define TIP_TEXT_COLOR          TIP_LINE_COLOR
#define TIP_TEXT_FONT           FONT(16.0)
#define ADD_X                   10.0
#define LABEL_HEIGHT            20.0
#define LINE_HEIGHT             0.5
#define SPACE_X                 60 * CURRENT_SCALE

#import "ThirdLoginView.h"

@interface ThirdLoginView()

@property (nonatomic, assign) float y;

@end

@implementation ThirdLoginView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.y = 0.0;
        [self initUI];
    }
    return self;
}

#pragma mark 初始化UI
- (void)initUI
{
    [self addTipView];
    [self addButtons];
}

- (void)addTipView
{
    CGSize size = [TIP_TEXT sizeWithAttributes:@{NSFontAttributeName:TIP_TEXT_FONT}];
    float width = size.width + 2 * ADD_X;
    UILabel *tipLabel = [CreateViewTool createLabelWithFrame:CGRectMake((self.frame.size.width - width)/2, self.y, width, LABEL_HEIGHT) textString:TIP_TEXT textColor:TIP_TEXT_COLOR textFont:TIP_TEXT_FONT];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipLabel];
    
    self.y += (tipLabel.frame.size.height - LINE_HEIGHT)/2;
    
    UIImageView *leftLineView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, self.y, tipLabel.frame.origin.x, LINE_HEIGHT)placeholderImage:nil];
    leftLineView.backgroundColor = LINE_COLOR;
    [self addSubview:leftLineView];
    
    UIImageView *rightLineView = [CreateViewTool createImageViewWithFrame:CGRectMake(self.frame.size.width - leftLineView.frame.size.width, self.y, tipLabel.frame.origin.x, LINE_HEIGHT)placeholderImage:nil];
    rightLineView.backgroundColor = LINE_COLOR;
    [self addSubview:rightLineView];
    
    self.y += leftLineView.frame.size.height;
    
}

- (void)addButtons
{
    NSArray *array = @[@"icon_yht",@"icon_weibo",@"icon_qq",@"icon_wechat"];
    UIImage *image = [UIImage imageNamed:[array[0] stringByAppendingString:@"_up"]];
    float icon_WH = image.size.width/3.0 * CURRENT_SCALE;
    float totleHeight = self.frame.size.height - self.y;
    float x = SPACE_X;
    float y = (totleHeight - icon_WH)/2;
    float add_X = (self.frame.size.width - 2 * SPACE_X - 4 * icon_WH)/3;
    
    for (int i = 0; i < [array count]; i++)
    {
        UIButton *button = [CreateViewTool createButtonWithFrame:CGRectMake(x, y, icon_WH, icon_WH) buttonImage:array[i] selectorName:@"" tagDelegate:self];
        button.tag = 100 + i;
        [self addSubview:button];
        
        x += icon_WH + add_X;
    }
    
}

@end
