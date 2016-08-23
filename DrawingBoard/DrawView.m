//
//  DrawView.m
//  DrawingBoard
//
//  Created by zsq on 16/8/23.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "DrawView.h"
#import "MyBezierPath.h"
@interface DrawView()
@property (nonatomic,strong) UIBezierPath *path;
@property (nonatomic, strong) NSMutableArray *allPathArray;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIColor *color;
@end
@implementation DrawView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (NSMutableArray *)allPathArray{
    if (_allPathArray==nil) {
        _allPathArray = [NSMutableArray array];
    }
    return _allPathArray;
}

- (void)awakeFromNib{
    UIPanGestureRecognizer *pan= [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:pan];
    self.width = 1.0;
    self.color = [UIColor blackColor];
}

- (void)pan:(UIPanGestureRecognizer *)pan{
    //获取的当前手指的点
    CGPoint curP = [pan locationInView:self];
    //判断手势状态
    if (pan.state == UIGestureRecognizerStateBegan) {
        //创建路径
        MyBezierPath *path = [MyBezierPath bezierPath];
        self.path = path;
        
        //设置起点
        [path moveToPoint:curP];
        //设置宽度
        [path setLineWidth:self.width];
        //设置颜色
        path.color = self.color;
        
        [self.allPathArray addObject:path];
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        //绘制一跟线到当前手指所在的点
        [self.path addLineToPoint:curP];
        //重绘
        [self setNeedsDisplay];
    }
}
- (void)drawRect:(CGRect)rect{
    //绘制保存的所有路径
    for (MyBezierPath *path in self.allPathArray) {
        [path.color set];
        [path stroke];
    }
}

//清屏
- (void)clear{
    [self.allPathArray removeAllObjects];
    [self setNeedsDisplay];
}
//撤销
- (void)undo{
    [self.allPathArray removeLastObject];
    [self setNeedsDisplay];
}
//橡皮擦
- (void)erase{
    [self setLineColor:[UIColor whiteColor]];
}
//设置线的宽度
- (void)setLineWidth:(CGFloat)width{
    self.width = 10 * width;
}
////设置点的颜色
- (void)setLineColor:(UIColor *)color{
    self.color = color;
}

@end
