//
//  AnchorListView.h
//  KOShow
//
//  Created by 陈磊 on 15/11/26.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnchorListViewDelegate;

@interface AnchorListView : UIView

- (void)setDataWithArray:(NSArray *)array;

@property (nonatomic, assign) id<AnchorListViewDelegate> delegate;

@end

@protocol AnchorListViewDelegate <NSObject>

@optional

- (void)anchorListView:(AnchorListView *)anchorListView didSelectedAnchorAtIndex:(int)index;

@end