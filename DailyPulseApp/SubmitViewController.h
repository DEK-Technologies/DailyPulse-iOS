//
//  SubmitViewController.h
//

#import <UIKit/UIKit.h>
#import "APIManager.h"

@class WaitMessageView, DataManager;

@interface SubmitViewController : UIViewController <APIManagerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *siteLabel, *questionLabel;
@property (nonatomic, strong) DataManager *dataManager;
@property (nonatomic, strong) APIManager *apiManager;
@property (nonatomic, strong) WaitMessageView *messageView;

@end
