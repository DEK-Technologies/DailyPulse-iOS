//
//  ResultsViewController.h
//

#import <UIKit/UIKit.h>
#import "APIManager.h"

@class DataManager;

@interface ResultsViewController : UIViewController <APIManagerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *officeLabel;
@property (nonatomic, weak) IBOutlet UIButton *accountButton;
@property (nonatomic, strong) DataManager *dataManager;
@property (nonatomic, strong) APIManager *apiManager;
@property (nonatomic) BOOL justStarted;

@end
