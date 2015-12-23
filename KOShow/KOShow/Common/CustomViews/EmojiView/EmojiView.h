//
//  ISEmojiView.h
//  ISEmojiViewSample
//
//  Created by isaced on 14/12/25.
//  Copyright (c) 2014 Year isaced. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EmojiViewDelegate;

/**
 *  The custom keyboard view
 */
@interface EmojiView : UIView

/**
 *  ISEmojiView Delegate
 */
@property (nonatomic, assign) id<EmojiViewDelegate> delegate;

/**
 *  Emoji container used to store all the elements
 */
@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  UIPageControl for next page
 */
@property (nonatomic, strong) UIPageControl *pageControl;



@end

/**
 *  ISEmojiView Delegate
 *
 *  Used to respond to some of the operations callback
 */
@protocol EmojiViewDelegate <NSObject>

/**
 *  When you choose a Emoji
 *
 *  @param emojiView The emoji keyboard view
 *  @param emoji     The selected emoji character
 */
-(void)emojiView:(EmojiView *)emojiView didSelectEmoji:(NSString *)emoji;

/**
 *  When the touch bottom right corner of the delete key
 *
 *  You should remove the last character(emoji) in the text box
 *  @param emojiView    The emoji keyboard view
 *  @param deletebutton The delete button
 */
-(void)emojiView:(EmojiView *)emojiView didPressDeleteButton:(UIButton *)deletebutton;

@end

