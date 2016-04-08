//
//  SiteMoodKPIViewController.h
//

#import <UIKit/UIKit.h>
#import "APIManager.h"

@class DataManager;

@interface SiteMoodKPIViewController : UIViewController <APIManagerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *happyLabel, *sadLabel, *siteLabel, *errorLabel;
@property (nonatomic, weak) IBOutlet UIImageView *happyImage, *sadImage;
@property (nonatomic, strong) DataManager *dataManager;
@property (nonatomic, strong) APIManager *apiManager;
@property (nonatomic) RequestEnum currentRequest;

- (void)setInitData:(RequestEnum)request;

@end
