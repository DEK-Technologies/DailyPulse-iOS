//
//  InSiteOffSiteViewController.h
//

#import <UIKit/UIKit.h>
#import "APIManager.h"

@class DataManager;

@interface InSiteOffSiteViewController : UIViewController <APIManagerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *questionLabel, *noteLabel;
@property (nonatomic, weak) IBOutlet UIButton *showProfileButton;
@property (nonatomic, strong) DataManager *dataManager;
@property (nonatomic, strong) APIManager *apiManager;

@end
