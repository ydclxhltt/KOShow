//
//  ISEmojiView.m
//  ISEmojiViewSample
//
//  Created by isaced on 14/12/25.
//  Copyright (c) 2014 Year isaced. All rights reserved.
//

#define FACE_ICON_WH   30.0
#define ROW_ADD_Y      15.0
#define ROW_NUMBER     4.0

#import "EmojiView.h"

@interface EmojiView()<UIScrollViewDelegate>

/**
 *  All emoji characters
 */
@property (nonatomic, strong) NSDictionary *emojisDataDic;

@end

@implementation EmojiView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // init emojis
        self.emojisDataDic = [KOShowShareApplication shareApplication].emojiDictionary;
        
        //
        NSInteger rowNum = ROW_NUMBER;
        NSInteger colNum = (CGRectGetWidth(frame) / FACE_ICON_WH) - 3;
        NSInteger numOfPage = ceil((float)[[self.emojisDataDic allKeys] count] / (float)(rowNum * colNum - 1));
        
        // init scrollview
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.delegate = self;
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(frame) * numOfPage,
                                                 CGRectGetHeight(frame));
        [self addSubview:self.scrollView];
        
        // add emojis
        
        NSInteger row = 0;
        NSInteger column = 0;
        NSInteger page = 0;
        
        NSInteger emojiPointer = 0;

        for (int i = 0; i < [[self.emojisDataDic allKeys] count] + numOfPage; i++)
        {
            // Pagination
            if (i % (rowNum * colNum) == 0)
            {
                page ++;    // Increase the number of pages
                row = 0;    // the number of lines is 0
                column = 0; // the number of columns is 0
            }
            else if (i % colNum == 0)
            {
                // NewLine
                row += 1;   // Increase the number of lines
                column = 0; // The number of columns is 0
            }
            float add_x = (self.scrollView.frame.size.width - colNum * FACE_ICON_WH)/(colNum + 1);
            float x = ((page - 1) * frame.size.width) + (column * FACE_ICON_WH) + (column + 1) * add_x;
            float y = row * FACE_ICON_WH + ROW_ADD_Y * (row + 1);
            CGRect currentRect = CGRectMake(x,
                                            y,
                                            FACE_ICON_WH,
                                            FACE_ICON_WH);
    
            if ((row == (rowNum - 1) && column == (colNum - 1)) || (i == [[self.emojisDataDic allKeys] count] + numOfPage - 1))
            {
                // last position of page, add delete button
                UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [deleteButton setImage:[UIImage imageNamed:@"face_del_up"] forState:UIControlStateNormal];
                [deleteButton addTarget:self action:@selector(deleteButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                deleteButton.frame = currentRect;
                [self.scrollView addSubview:deleteButton];
            }
            else
            {
                NSString *emojiName = [self.emojisDataDic allKeys][emojiPointer++];
                UIImage *emojiImage = [UIImage imageNamed:emojiName];
                // init Emoji Button
                UIButton *emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
                emojiButton.frame = currentRect;
                [emojiButton setTitle:self.emojisDataDic[[self.emojisDataDic allKeys][emojiPointer - 1]] forState:UIControlStateNormal];
                [emojiButton setImage:emojiImage forState:UIControlStateNormal];
                [emojiButton addTarget:self action:@selector(emojiButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [self.scrollView addSubview:emojiButton];
            }
        
            column++;
        }
        
        // add PageControl
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.hidesForSinglePage = YES;
        self.pageControl.currentPage = 0;
        self.pageControl.backgroundColor = [UIColor clearColor];
        self.pageControl.numberOfPages = numOfPage;
        self.pageControl.pageIndicatorTintColor = [UIColor blackColor];
        self.pageControl.currentPageIndicatorTintColor = APP_MAIN_COLOR;
        CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:numOfPage];
        self.pageControl.frame = CGRectMake(CGRectGetMidX(frame) - (pageControlSize.width / 2),
                                            CGRectGetHeight(frame) - pageControlSize.height + 5,
                                            pageControlSize.width,
                                            pageControlSize.height);
        [self.pageControl addTarget:self action:@selector(pageControlTouched:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.pageControl];
        
        // default allow animation
        self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return self;
}

- (void)pageControlTouched:(UIPageControl *)sender
{
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * sender.currentPage;
    [self.scrollView scrollRectToVisible:bounds animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(scrollView.frame);
    NSInteger newPageNumber = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (self.pageControl.currentPage == newPageNumber)
    {
        return;
    }
    self.pageControl.currentPage = newPageNumber;
}

- (void)emojiButtonPressed:(UIButton *)button
{
    // Callback
    if ([self.delegate respondsToSelector:@selector(emojiView:didSelectEmoji:)])
    {
        [self.delegate emojiView:self didSelectEmoji:button.titleLabel.text];
    }
}

- (void)deleteButtonPressed:(UIButton *)button
{
    // Callback
    if ([self.delegate respondsToSelector:@selector(emojiView:didPressDeleteButton:)])
    {
        [self.delegate emojiView:self didPressDeleteButton:button];
    }
}

@end

