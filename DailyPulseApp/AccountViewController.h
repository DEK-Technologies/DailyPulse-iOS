//
//  AccountViewController.h
//

#import <UIKit/UIKit.h>
#import "APIManager.h"

@class DataManager;

@interface AccountViewController : UIViewController <APIManagerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *userTitleLabel, *userLabel, *officeTitleLabel, *officeLabel, *siteLabel;
@property (nonatomic, weak) IBOutlet UIButton *signOutButton, *showProfileButton;
@property (nonatomic, strong) DataManager *dataManager;
@property (nonatomic, strong) APIManager *apiManager;

@end
