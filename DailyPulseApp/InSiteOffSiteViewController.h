//
//  InSiteOffSiteViewController.h
//

#import <UIKit/UIKit.h>

@class DataManager;

@interface InSiteOffSiteViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *questionLabel, *orLabel, *noteLabel;
@property (nonatomic, weak) IBOutlet UIButton *inSiteButton, *offSiteButton;
@property (nonatomic, strong) DataManager *dataManager;

@end
