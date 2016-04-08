//
//  WaitMessageView.m
//

#import "WaitMessageView.h"
#import "Common.h"

@interface WaitMessageView ()
- (void)setMsg:(NSString *)message;
@end

@implementation WaitMessageView

- (void)setMessage:(NSString*)message showActivity:(BOOL)activity {
    [self setMsg:message];
    
    if (activity) {
        [NSThread detachNewThreadSelector:@selector(startAnimating) toTarget:self.activityView withObject:nil];
        self.messageLabel.frame = CGRectMake(10.0, 33.0, self.centerView.frame.size.width-20.0, 50.0);
    }
    else {
        [self.activityView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0.1];
        self.messageLabel.frame = CGRectMake(10.0, 19.0, self.centerView.frame.size.width-20.0, 50.0);
    }
}

- (void)setMsg:(NSString *)message {
    [UIView transitionWithView:self
                      duration:0.2
                       options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        self.messageLabel.text = message;
                    }
                    completion:nil];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.bounds.size.width-20.0, 88.0)];
        self.centerView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.75];
        self.centerView.center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
        [self.centerView.layer setCornerRadius:3.0];
        [self.centerView.layer setBorderWidth:1.0];
        [self.centerView.layer setBorderColor:[UIColor whiteColor].CGColor];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 33.0, self.centerView.frame.size.width-20.0, 50.0)];
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.textColor = [UIColor whiteColor];
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.font = [UIFont systemFontOfSize:16.0];
        self.messageLabel.text = @"";
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activityView.center = CGPointMake(self.centerView.frame.size.width/2.0, 20.0);
        [self.activityView performSelector:@selector(startAnimating) withObject:nil];
        
        [self.centerView addSubview:self.messageLabel];
        [self.centerView addSubview:self.activityView];
        [self addSubview:self.centerView];
        
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75];
    }
    return self;
}

@end
