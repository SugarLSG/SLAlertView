//
//  SLAlertView.h
//  SLAlertView
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, SLAlertViewType) {
    SLAlertViewTypeText,         // 纯文字
    SLAlertViewTypeLoading,     // 加载中
    SLAlertViewTypeSuccess,    // 成功
    SLAlertViewTypeError,        // 错误
    SLAlertViewTypeWarning     // 警告
};


@interface SLAlertView : NSObject

// 父级视图
@property (nonatomic, strong) UIView *superview;

/**
 单例模式
 **/
+ (instancetype)sharedSLAlertView;


/**
 显示自定义提示框
 @param contentView 具体内容视图
 @param bgColor 遮罩层颜色
 @param delay 延时自动消失时间 -> 0标示不消失
 **/
- (void)showCustomAlertViewWithContentView:(UIView *)contentView bgColor:(UIColor *)bgColor delayHide:(NSTimeInterval)delay;

/**
 根据类型显示默认提示框
 @param type 提示框类型
 @param text 文字
 @param viewSize 视图大小 -> 若宽度为0表示使用默认宽度，若高度为0表示按实际内容高度自动调整
 @param delay 延时自动消失时间 -> 0表示不消失
 **/
- (void)showDefaultAlertViewWithType:(SLAlertViewType)type Text:(NSString *)text viewSize:(CGSize)viewSize delayHide:(NSTimeInterval)delay;
/**
 根据类型显示默认提示框
 @param type 提示框类型
 @param text 文字
 @param viewSize 视图大小 -> 若宽度为0表示使用默认宽度，若高度为0表示按实际内容高度自动调整
 @param bgColor 遮罩层颜色
 @param delay 延时自动消失时间 -> 0表示不消失
 **/
- (void)showDefaultAlertViewWithType:(SLAlertViewType)type Text:(NSString *)text viewSize:(CGSize)viewSize bgColor:(UIColor *)bgColor delayHide:(NSTimeInterval)delay;

@end
