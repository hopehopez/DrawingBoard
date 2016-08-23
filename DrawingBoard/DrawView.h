//
//  DrawView.h
//  DrawingBoard
//
//  Created by zsq on 16/8/23.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView
//清屏
- (void)clear;
//撤销
- (void)undo;
//橡皮擦
- (void)erase;
//设置线的宽度
- (void)setLineWidth:(CGFloat)width;
//设置点的颜色
- (void)setLineColor:(UIColor *)color;
@end
