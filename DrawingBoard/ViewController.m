//
//  ViewController.m
//  DrawingBoard
//
//  Created by zsq on 16/8/23.
//  Copyright © 2016年 zsq. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"
#import "HandleImageView.h"
@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,HandleImageViewDelegate>
@property (weak, nonatomic) IBOutlet DrawView *drawView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//属于谁的东西, 应该在谁里面写
- (IBAction)clear:(id)sender {
    [self.drawView clear];
}

- (IBAction)undo:(id)sender {
    [self.drawView undo];
}
- (IBAction)erase:(id)sender {
    [self.drawView erase];
}
- (IBAction)setLineWidth:(UISlider *)sender {
    [self.drawView setLineWidth:sender.value];
}
- (IBAction)setLineColor:(UIButton *)sender {
    [self.drawView setLineColor:sender.backgroundColor];
}
- (IBAction)photo:(id)sender {
    //从系统相册中选择一张图片
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    //设置照片的来源
    pickerVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pickerVC.delegate = self;
    [self presentViewController:pickerVC animated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    
    HandleImageView *handleV = [[HandleImageView alloc] init];
    handleV.backgroundColor = [UIColor clearColor];
    handleV.frame = self.drawView.frame;
    handleV.image = image;
    handleV.delegate = self;
    [self.view addSubview:handleV];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (IBAction)save:(id)sender {
    //1.开启一个位图上下文
    UIGraphicsBeginImageContextWithOptions(self.drawView.frame.size, NO, 0);
    //2.把画板上的内容渲染到上下文当中
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.drawView.layer renderInContext:ctx];
    //3.从上下文中取出一张图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //4.关闭上下文
    UIGraphicsEndImageContext();
    //5.把图片保存到系统相册中
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    
}
//保存完毕时调用
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"Success");
}
- (void)handleImageView:(HandleImageView *)handleImageView newImage:(UIImage *)image{
    self.drawView.image = image;
}
@end
