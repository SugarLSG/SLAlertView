//
//  SLAlertView.m
//  SLAlertView
//

#import "SLAlertView.h"
#import "SLAlertMaskView.h"


#define SLDefaultMaskLayerBGColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f]
#define SLDefaultContentHorizontalMargin 18
#define SLDefaultContentVerticalMargin 15
#define SLDefaultContentWidth 120
#define SLDefaultFadeDuration 0.2f


@interface SLAlertView ()

@property (nonatomic, strong) SLAlertMaskView *alertMaskView;

@end


@implementation SLAlertView

static SLAlertView *slAlertView = nil;
+ (instancetype)sharedSLAlertView {
    @synchronized(self) {
        if(!slAlertView) {
            slAlertView = [[[self class] alloc] init];
        }
    }
    return slAlertView;
}


- (void)showCustomAlertViewWithContentView:(UIView *)contentView bgColor:(UIColor *)bgColor delayHide:(NSTimeInterval)delay {
    if (self.superview) {
        // 遮罩层
        if (self.alertMaskView) {
            [self.alertMaskView removeFromSuperview];
            self.alertMaskView = nil;
        }
        self.alertMaskView = [[SLAlertMaskView alloc] initWithFrame:CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.height) fadeInDuration:SLDefaultFadeDuration fadeOutDuration:SLDefaultFadeDuration];
        self.alertMaskView.backgroundColor = bgColor;
        [self.superview addSubview:self.alertMaskView];
        
        // 内容视图（居中显示）
        CGFloat contentSuperviewWidth = contentView.frame.size.width + SLDefaultContentHorizontalMargin * 2;
        CGFloat contentSuperviewHeight = contentView.frame.size.height + SLDefaultContentVerticalMargin * 2;
        UIView *contentSuperview = [[UIView alloc] initWithFrame:CGRectMake(
                                                                            (self.alertMaskView.frame.size.width - contentSuperviewWidth) / 2,
                                                                            (self.alertMaskView.frame.size.height - contentSuperviewHeight) / 2,
                                                                            contentSuperviewWidth,
                                                                            contentSuperviewHeight
                                                                            )];
        contentSuperview.backgroundColor = [UIColor blackColor];
        contentSuperview.layer.cornerRadius = 10;
        contentSuperview.layer.shadowColor = [UIColor blackColor].CGColor;
        contentSuperview.layer.shadowOpacity = 0.8f;
        contentSuperview.layer.shadowOffset = CGSizeMake(0, 0);
        [self.alertMaskView addSubview:contentSuperview];
        
        // 添加具体内容
        contentView.frame = CGRectMake(SLDefaultContentHorizontalMargin, SLDefaultContentVerticalMargin, contentView.frame.size.width, contentView.frame.size.height);
        [contentSuperview addSubview:contentView];
        
        //显示提示框
        [self.alertMaskView viewFadeIn];
        // 是否延时自动消失
        if (delay) {
            [self.alertMaskView performSelector:@selector(viewFadeOut) withObject:nil afterDelay:delay + SLDefaultFadeDuration];
        }
    }
}

- (void)showDefaultAlertViewWithType:(SLAlertViewType)type Text:(NSString *)text viewSize:(CGSize)viewSize delayHide:(NSTimeInterval)delay {
    [self showDefaultAlertViewWithType:type Text:text viewSize:viewSize bgColor:SLDefaultMaskLayerBGColor delayHide:delay];
}

- (void)showDefaultAlertViewWithType:(SLAlertViewType)type Text:(NSString *)text viewSize:(CGSize)viewSize bgColor:(UIColor *)bgColor delayHide:(NSTimeInterval)delay {
    if (self.superview) {
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
                successView.image = [UIImage imageNamed:[@"SLImages.bundle" stringByAppendingPathComponent:@"success.png"]];
                [contentView addSubview:successView];
                
                lblTextY = successView.frame.size.height + 8;
                break;
            }
            case SLAlertViewTypeError: {
                // 错误
                UIImageView *errorView = [[UIImageView alloc] initWithFrame:CGRectMake((contentView.frame.size.width - 32) / 2, 0, 32, 32)];
                errorView.image = [UIImage imageNamed:[@"SLImages.bundle" stringByAppendingPathComponent:@"error.png"]];
                [contentView addSubview:errorView];
                
                lblTextY = errorView.frame.size.height + 8;
                break;
            }
            case SLAlertViewTypeWarning: {
                // 警告
                UIImageView *warningView = [[UIImageView alloc] initWithFrame:CGRectMake((contentView.frame.size.width - 32) / 2, 0, 32, 32)];
                warningView.image = [UIImage imageNamed:[@"SLImages.bundle" stringByAppendingPathComponent:@"warning.png"]];
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
        [self showCustomAlertViewWithContentView:contentView bgColor:bgColor delayHide:delay];
    }
}

@end
