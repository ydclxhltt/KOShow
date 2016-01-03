//
//  AnchorDetailView.h
//  KOShow
//
//  Created by 陈磊 on 15/12/9.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnchorDetailView : UIView

- (void)setAnchorDataWithImageUrl:(NSString *)imageUrl anchorName:(NSString *)name roomName:(NSString *)roomName anchorDetailText:(NSString *)detailText;

- (void)setDetailText:(NSString *)detailText;


@end
