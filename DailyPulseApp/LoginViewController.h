//
//  LoginViewController.h
//

#import <UIKit/UIKit.h>
#import "APIManager.h"

@class DataManager, WaitMessageView;

@interface LoginViewController : UIViewController <APIManagerDelegate>

@property (nonatomic, weak) IBOutlet UITextField *userNameTextField, *passwordTextField;
@property (nonatomic, weak) IBOutlet UILabel *signInLabel, *createUserLabel, *infoLabel;
@property (nonatomic, weak) IBOutlet UIButton *signInButton, *forgotPasswordButton, *createUserButton;
@property (nonatomic, strong) DataManager *dataManager;
@property (nonatomic, strong) APIManager *apiManager;
@property (nonatomic, strong) WaitMessageView *messageView;

@end
