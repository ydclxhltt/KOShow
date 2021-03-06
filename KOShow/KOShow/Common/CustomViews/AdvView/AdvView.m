//
//  AdvView.m
//  XSHCar
//
//  Created by clei on 14/12/22.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#define LABEL_HEIGHT    20.0 * CURRENT_SCALE

#import "AdvView.h"
#import "CommonHeader.h"
#import "CreateViewTool.h"

@interface AdvView()<UIScrollViewDelegate>
{
    //滚动广告视图
    UIScrollView *advscrollview;
    float scrollwillendset_x;
    //总页数
    int totalPage;
    //当前页
    int curPage;
    // 存放当前滚动的三张广告
    NSMutableArray *curImages;
    NSTimer *timer;
}

@end

@implementation AdvView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        curPage = 1;
        advscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        advscrollview.pagingEnabled = YES;
        advscrollview.showsHorizontalScrollIndicator = NO;
        advscrollview.showsVerticalScrollIndicator = NO;
        advscrollview.contentOffset=CGPointMake(SCREEN_WIDTH, 0);
        advscrollview.scrollsToTop = NO;
        advscrollview.delegate=self;
        advscrollview.contentSize = CGSizeMake(SCREEN_WIDTH * 3,
                                               advscrollview.frame.size.height);
        [self addSubview:advscrollview];
        
        curImages=[[NSMutableArray alloc]init];
        
    }
    return self;
}

//设置广告数据
-(void)setAdvData:(id)advData
{
    [self createTimer];
    if (advData)
    {
        self.advArray = (NSMutableArray *)advData;
        if (self.advArray && [self.advArray count] > 0)
        {
            totalPage = (int)[self.advArray count];
            [self refreshScrollView];
        }
    }
}

//刷新广告视图
- (void)refreshScrollView
{
    NSArray *subViews = [advscrollview subviews];
    if([subViews count] != 0)
    {
        for (UIImageView *imageview in subViews)
        {
            [imageview removeFromSuperview];
        }
    }
    
    [self getDisplayImagesWithCurpage:curPage];
    
    for (int i = 0; i < 3; i++)
    {
        NSDictionary *dic = [curImages objectAtIndex:i];
        NSString *imageUrl = [[KOShowShareApplication shareApplication] makeImageUrlWithRightHalfString:dic[@"max_img_path"]];
        NSString *title = [NSString stringWithFormat:@"  %@",dic[@"title"]];
        UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(advscrollview.frame.size.width * i, 0, advscrollview.frame.size.width, advscrollview.frame.size.height) placeholderImage:nil];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"adv_default.jpg"]];
        //NSLog(@"IMAGE_SERVER_URL===%@",[NSURL URLWithString:url]);
        imageView.tag = i + 1;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
        [imageView addGestureRecognizer:tapGesture];
        [advscrollview addSubview:imageView];
        
        UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(0, imageView.frame.size.height - LABEL_HEIGHT, imageView.frame.size.width, LABEL_HEIGHT) textString:title textColor:[UIColor whiteColor] textFont:FONT(14.0)];
        label.backgroundColor = RGBA(0.0, 0.0, 0.0, 0.6);
        [imageView addSubview:label];
    }
    [advscrollview setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    advscrollview.contentSize = CGSizeMake(SCREEN_WIDTH * [self.advArray count],
                                           advscrollview.frame.size.height);
}


///点击广告
- (void)tapGestureHandle:(UITapGestureRecognizer *)tapGesture
{
    UIImageView *imageView = (UIImageView *)tapGesture.view;
    int index = (int)[self.advArray indexOfObject:curImages[imageView.tag - 1]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(advView:clickedAtIndex:)])
    {
        [self.delegate advView:self clickedAtIndex:index];
    }
}

//设置当前滚动的3张广告
- (void)getDisplayImagesWithCurpage:(int)page
{
    
    int pre = [self validPageValue:curPage-1];
    int last = [self validPageValue:curPage+1];
    
    if([curImages count] != 0)
    {
        [curImages removeAllObjects];
    }
    [curImages addObject:[self.advArray objectAtIndex:pre-1]];
    [curImages addObject:[self.advArray objectAtIndex:curPage-1]];
    [curImages addObject:[self.advArray objectAtIndex:last-1]];
}

- (int)validPageValue:(NSInteger)value
{
    // value＝1为第一张，value = 0为前面一张
    if(value == 0) value = totalPage;
    if(value == totalPage + 1) value = 1;
    return value;
}


//定时器移动scrollview
-(void)createTimer
{
    [self cancelTimer];
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(moveAdvscrollview) userInfo:nil repeats:YES];
}

//取消定时器
-(void)cancelTimer
{
    if (timer && [timer isValid])
    {
        [timer invalidate];
        timer = nil;
    }
}

//滚动scrollview
-(void)moveAdvscrollview
{
    [advscrollview setContentOffset:CGPointMake(advscrollview.contentOffset.x + SCREEN_WIDTH, 0) animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    
    int x = aScrollView.contentOffset.x;
    //int y = aScrollView.contentOffset.y;
    //NSLog(@"did  x=%d  y=%d", x, y);
    
    // 往下翻一张
    if(x >= (2 * SCREEN_WIDTH))
    {
        curPage = [self validPageValue:curPage+1];
        [self refreshScrollView];
    }
    if(x <= 0)
    {
        curPage = [self validPageValue:curPage-1];
        [self refreshScrollView];
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView
{
    [advscrollview setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
}


- (void)dealloc
{
    [self cancelTimer];
}


@end
