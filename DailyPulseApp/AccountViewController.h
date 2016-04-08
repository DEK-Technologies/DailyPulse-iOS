//
//  AccountViewController.h
//

#import <UIKit/UIKit.h>

@class DataManager;

@interface AccountViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *userTitleLabel, *userLabel, *officeTitleLabel, *officeLabel, *siteLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl *workingSiteControl;
@property (nonatomic, weak) IBOutlet UIButton *signOutButton;
@property (nonatomic, strong) DataManager *dataManager;

@end
