//
//  GiftListView.h
//  KOShow
//
//  Created by 陈磊 on 15/12/8.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GiftListViewDelegate;

@interface GiftListView : UIView

@property (nonatomic, assign) id<GiftListViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame giftArray:(NSArray *)giftArray;

@end

@protocol GiftListViewDelegate <NSObject>

- (void)giftListView:(GiftListView *)giftView didSelectedGiftAtIndex:(int)index;

@end