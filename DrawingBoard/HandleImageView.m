//
//  HandleImageView.m
//  DrawingBoard
//
//  Created by zsq on 16/8/24.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "HandleImageView.h"
@interface HandleImageView() <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIImageView *imageV;
@end
@implementation HandleImageView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)setImage:(UIImage *)image{
    
    _image = image;
    self.imageV.image = image;
    [self addGes];
}

- (UIImageView *)imageV{
    if (_imageV == nil) {
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        imageV.userInteractionEnabled = YES;
        _imageV = imageV;
        [self addSubview:imageV];
    }
    return _imageV;
}

- (void)addGes{
    
    
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    [_imageV addGestureRecognizer:pan];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    pinch.delegate = self;
    [_imageV addGestureRecognizer:pinch];
    
    UILongPressGestureRecognizer *longP = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longP:)];
    [_imageV addGestureRecognizer:longP];
    
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotation:)];
    rotation.delegate = self;
    [_imageV addGestureRecognizer:rotation];
}
- (void)rotation:(UIRotationGestureRecognizer *)rotation{
    rotation.view.transform = CGAffineTransformRotate(rotation.view.transform, rotation.rotation);
    [rotation setRotation:0];
}
- (void)pan:(UIPanGestureRecognizer *)pan{
    CGPoint transP = [pan translationInView:pan.view];
    pan.view.transform = CGAffineTransformTranslate(pan.view.transform, transP.x, transP.y);
    
    //复位
    [pan setTranslation:CGPointZero inView:pan.view];
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch{
    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
    [pinch setScale:1];
}
- (void)longP:(UILongPressGestureRecognizer *)longP{
    if (longP.state == UIGestureRecognizerStateBegan) {
        //先让图片闪一下, 把图片绘制到画板当中
        longP.view.alpha = 0;
        [UIView animateWithDuration:0.5 animations:^{
            longP.view.alpha = 0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                longP.view.alpha = 1;
            } completion:^(BOOL finished) {
                //把图片绘制到画板当中
                UIGraphicsBeginImageContextWithOptions(longP.view.bounds.size, NO, 0);
                CGContextRef ctx =  UIGraphicsGetCurrentContext();
                [self.layer renderInContext:ctx];
                
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                //调用代理
                if (self.delegate && [self.delegate respondsToSelector:@selector(handleImageView:newImage:)]) {
                    [self.delegate handleImageView:self newImage:newImage];
                }
                
                [self removeFromSuperview];
            }];
        }];
    }
}

//同时支持多个手势

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
