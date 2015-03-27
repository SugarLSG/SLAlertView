//
//  SLAlertMaskView.m
//  SLAlertView
//

#import "SLAlertMaskView.h"


@interface SLAlertMaskView ()

@property (nonatomic, assign) CGFloat fadeInDuration;
@property (nonatomic, assign) CGFloat fadeOutDuration;

@end


@implementation SLAlertMaskView

- (instancetype)initWithFrame:(CGRect)frame fadeInDuration:(CGFloat)fadeInDuration fadeOutDuration:(CGFloat)fadeOutDuration {
    if (self = [self initWithFrame:frame]) {
        self.fadeInDuration = fadeInDuration;
        self.fadeOutDuration = fadeOutDuration;
        self.userInteractionEnabled = YES;
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // 点击到界面，隐藏提示框
    [self viewFadeOut];
}

- (void)viewFadeIn {
    //  获取内容视图
    UIView *contentView = (UIView *)self.subviews[0];
    CGRect originalFrame = contentView.frame;   // 记录原始位置、大小
    
    // 动画效果，由最中间一点放大
    contentView.frame = CGRectMake(self.frame.size.width / 2, self.frame.size.height / 2, 0, 0);
    // 放大完成后再显示其子视图
    for (UIView *subView in contentView.subviews) {
        subView.hidden = YES;
    }
    
    // 开始动画
    [UIView animateWithDuration:self.fadeInDuration
                     animations:^{
                         contentView.frame = originalFrame;
                     } completion:^(BOOL finished) {
                         for (UIView *subView in contentView.subviews) {
                             subView.hidden = NO;
                         }
                     }
     ];
}

- (void)viewFadeOut {
    // 开始动画
    [UIView animateWithDuration:self.fadeOutDuration
                     animations:^{
                         // 渐隐效果
                         self.layer.opacity = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }
     ];
}

@end
