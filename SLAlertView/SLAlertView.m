//
//  SLAlertView.m
//  SLAlertView
//

#import "SLAlertView.h"


#define SLDefaultMaskLayerBGColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f]
#define SLDefaultContentHorizontalMargin 18
#define SLDefaultContentVerticalMargin 15
#define SLDefaultContentWidth 120
#define SLDefaultFadeDuration 0.2f


@implementation SLAlertView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // 点击到界面，隐藏提示框
    [self viewFadeOutWithDuration:SLDefaultFadeDuration];
}

- (void)viewFadeInWithDuration:(NSTimeInterval)duration {
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
    [UIView animateWithDuration:duration
                     animations:^{
                         contentView.frame = originalFrame;
                     } completion:^(BOOL finished) {
                         for (UIView *subView in contentView.subviews) {
                             subView.hidden = NO;
                         }
                     }
     ];
}

- (void)viewFadeOutWithDuration:(NSTimeInterval)duration {
    // 开始动画
    [UIView animateWithDuration:duration
                     animations:^{
                         // 渐隐效果
                         self.layer.opacity = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }
     ];
}


+ (void)showCustomAlertViewInSuperview:(UIView *)superview withView:(UIView *)view viewBGColor:(UIColor *)bgColor delayHide:(NSTimeInterval)delay {
    // 作为遮罩层
    SLAlertView *alertView = [[SLAlertView alloc] initWithFrame:CGRectMake(0, 0, superview.frame.size.width, superview.frame.size.height)];
    alertView.backgroundColor = bgColor;
    alertView.userInteractionEnabled = YES;
    [superview addSubview:alertView];
    
    // 内容视图（居中显示）
    CGFloat contentViewWidth = view.frame.size.width + SLDefaultContentHorizontalMargin * 2;
    CGFloat contentViewHeight = view.frame.size.height + SLDefaultContentVerticalMargin * 2;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(
                                                                   (alertView.frame.size.width - contentViewWidth) / 2,
                                                                   (alertView.frame.size.height - contentViewHeight) / 2,
                                                                   contentViewWidth,
                                                                   contentViewHeight
                                                                   )];
    contentView.backgroundColor = [UIColor blackColor];
    contentView.layer.cornerRadius = 10;
    contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    contentView.layer.shadowOpacity = 0.8f;
    contentView.layer.shadowOffset = CGSizeMake(0, 0);
    [alertView addSubview:contentView];
    
    // 添加具体内容
    view.frame = CGRectMake(18, 15, view.frame.size.width, view.frame.size.height);
    [contentView addSubview:view];
    
    //显示提示框
    [alertView viewFadeInWithDuration:SLDefaultFadeDuration];
    // 是否延时自动消失
    if (delay) {
        [alertView performSelector:@selector(viewFadeOutWithDuration:) withObject:[NSString stringWithFormat:@"%f", SLDefaultFadeDuration] afterDelay:delay + SLDefaultFadeDuration];
    }
}

+ (void)showDefaultAlertViewInSuperview:(UIView *)superview withType:(SLAlertViewType)type Text:(NSString *)text viewSize:(CGSize)viewSize delayHide:(NSTimeInterval)delay {
    [SLAlertView showDefaultAlertViewInSuperview:superview withType:type Text:text viewSize:viewSize viewBGColor:SLDefaultMaskLayerBGColor delayHide:delay];
}

+ (void)showDefaultAlertViewInSuperview:(UIView *)superview withType:(SLAlertViewType)type Text:(NSString *)text viewSize:(CGSize)viewSize viewBGColor:(UIColor *)bgColor delayHide:(NSTimeInterval)delay {
    // 内容视图
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width ? viewSize.width : SLDefaultContentWidth, viewSize.height)];
    contentView.backgroundColor = [UIColor clearColor];
    
    // 类别图片
    CGFloat lblTextY = 0;
    switch (type) {
        case SLAlertViewTypeLoading: {
            // 加载中
            UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            loadingView.frame = CGRectMake((contentView.frame.size.width - loadingView.frame.size.width) / 2, 0, loadingView.frame.size.width, loadingView.frame.size.height);
            [loadingView startAnimating];
            [contentView addSubview:loadingView];
            
            lblTextY = loadingView.frame.size.height + 10;
            break;
        }
        case SLAlertViewTypeSuccess: {
            // 成功
            UIImageView *successView = [[UIImageView alloc] initWithFrame:CGRectMake((contentView.frame.size.width - 32) / 2, 0, 32, 32)];
            successView.image = [UIImage imageNamed:@"checkmark"];
            [contentView addSubview:successView];
            
            lblTextY = successView.frame.size.height + 8;
            break;
        }
        case SLAlertViewTypeError: {
            // 错误
            UIImageView *errorView = [[UIImageView alloc] initWithFrame:CGRectMake((contentView.frame.size.width - 32) / 2, 0, 32, 32)];
            errorView.image = [UIImage imageNamed:@"cross"];
            [contentView addSubview:errorView];
            
            lblTextY = errorView.frame.size.height + 8;
            break;
        }
        case SLAlertViewTypeWarning: {
            // 警告
            UIImageView *warningView = [[UIImageView alloc] initWithFrame:CGRectMake((contentView.frame.size.width - 32) / 2, 0, 32, 32)];
            warningView.image = [UIImage imageNamed:@"warning"];
            [contentView addSubview:warningView];
            
            lblTextY = warningView.frame.size.height + 8;
            break;
        }
            
        default:
            // SLAlertViewTypeText
            break;
    }
    
    // 文字
    UILabel *lblText = [[UILabel alloc] initWithFrame:CGRectMake(0, lblTextY, contentView.frame.size.width, 0)];
    lblText.text = text;
    lblText.numberOfLines = 0;
    lblText.textAlignment = NSTextAlignmentCenter;
    lblText.textColor = [UIColor whiteColor];
    lblText.font = [UIFont systemFontOfSize:16];
    [lblText sizeToFit];
    lblText.frame = CGRectMake(lblText.frame.origin.x, lblText.frame.origin.y, contentView.frame.size.width, lblText.frame.size.height);
    [contentView addSubview:lblText];
    
    // 调整内容视图高度
    if (!viewSize.height) {
        contentView.frame = CGRectMake(contentView.frame.origin.x, contentView.frame.origin.y, contentView.frame.size.width, lblText.frame.origin.y + lblText.frame.size.height);
    }
    
    // 显示提示框
    [SLAlertView showCustomAlertViewInSuperview:superview withView:contentView viewBGColor:bgColor delayHide:delay];
}

@end
