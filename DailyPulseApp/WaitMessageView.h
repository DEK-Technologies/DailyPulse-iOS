//
//  WaitMesgView.h
//

#import <UIKit/UIKit.h>

@interface WaitMessageView : UIView

@property (strong) UIView *centerView;
@property (strong) UILabel *messageLabel;
@property (strong) UIActivityIndicatorView *activityView;

- (void)setMessage:(NSString *)message showActivity:(BOOL)activity;

@end
