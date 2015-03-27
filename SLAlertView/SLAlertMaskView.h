//
//  SLAlertMaskView.h
//  SLAlertView
//

#import <UIKit/UIKit.h>


@interface SLAlertMaskView : UIView

/**
 @param fadeInDuration 渐显时间
 @param fadeOutDuration 渐隐时间
 **/
- (instancetype)initWithFrame:(CGRect)frame fadeInDuration:(CGFloat)fadeInDuration fadeOutDuration:(CGFloat)fadeOutDuration;

/**
 界面渐显
 **/
- (void)viewFadeIn;
/**
 界面渐隐
 **/
- (void)viewFadeOut;

@end
