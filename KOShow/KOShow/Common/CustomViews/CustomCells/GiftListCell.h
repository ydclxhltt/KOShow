//
//  GiftListCell.h
//  KOShow
//
//  Created by 陈磊 on 15/12/24.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GIFT_ROW_HEIGHT     35.0

@interface GiftListCell : UITableViewCell

- (void)setMessageWithUserNickName:(NSString *)nickName anchorName:(NSString *)anchorName giftName:(NSString *)giftName giftImage:(UIImage *)image;

- (void)setMessageWithUserNickName:(NSString *)nickName anchorName:(NSString *)anchorName giftName:(NSString *)giftName giftImageUrl:(NSString *)imageUrl;

@end
