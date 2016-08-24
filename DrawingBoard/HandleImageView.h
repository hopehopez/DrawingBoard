//
//  HandleImageView.h
//  DrawingBoard
//
//  Created by zsq on 16/8/24.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HandleImageView;
@protocol HandleImageViewDelegate <NSObject>

- (void)handleImageView:(HandleImageView *)handleImageView newImage:(UIImage *)image;

@end

@interface HandleImageView : UIView
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id<HandleImageViewDelegate> delegate;

@end
