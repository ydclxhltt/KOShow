//
//  CommentListCell.h
//  KOShow
//
//  Created by 陈磊 on 15/12/10.
//  Copyright © 2015年 chenlei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentListCell : UITableViewCell
- (void)setCommentDataWithImageUrl:(NSString *)imageUrl rankLevel:(int)level  userName:(NSString *)name commentContent:(NSString *)content  lastTime:(NSString *)time;
@end
