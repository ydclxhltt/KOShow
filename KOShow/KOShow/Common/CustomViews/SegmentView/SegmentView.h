//
//  SegmentView.h
//  KOShow
//
//  Created by 陈磊 on 15/11/28.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentViewDelegate;

@interface SegmentView : UIView

@property (nonatomic, assign) id<SegmentViewDelegate> delegate;

- (void)setItemTitleWithArray:(NSArray *)titleArray;

@end

@protocol SegmentViewDelegate <NSObject>

@optional

- (void)segmentView:(SegmentView *)segmentView  selectedItemAtIndex:(int)index;

@end
