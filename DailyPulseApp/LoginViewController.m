//
//  LoginViewController.m
//

#import "LoginViewController.h"
#import "DataManager.h"
#import "Common.h"
#import "InSiteOffSiteViewController.h"
#import "WaitMessageView.h"

@interface LoginViewController ()
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)newAccountButtonPressed:(id)sender;
- (IBAction)forgotPasswordButtonPressed:(id)sender;
- (void)showMesg:(NSString *)msg showActivity:(BOOL)act;
- (void)hideMesg;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataManager = [DataManager instance];
    self.apiManager = [[APIManager alloc] initWithDelegate:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.signInLabel.text = NSLocalizedString(@"Sign in (credentials are the same of the Celpax website)", @"LoginViewController");
    
    [self.userNameTextField setText:@""];
    [self.passwordTextField setText:@""];
    self.userNameTextField.placeholder = NSLocalizedString(@"you@example.com", @"LoginViewController");
    self.passwordTextField.placeholder = NSLocalizedString(@"Password", @"LoginViewController");
    
    [self.signInButton setTitle:NSLocalizedString(@"Sign in", @"LoginViewController") forState:UIControlStateNormal];
    [self.forgotPasswordButton setTitle:NSLocalizedString(@"Forgot password?", @"LoginViewController") forState:UIControlStateNormal];
    
    self.createUserLabel.text = NSLocalizedString(@"New user?", @"LoginViewController");
    [self.createUserButton setTitle:NSLocalizedString(@"Create account", @"LoginViewController") forState:UIControlStateNormal];
    self.infoLabel.text = NSLocalizedString(@"Note: the App requires the user to be logged in, but the vote expressed from the App is totally anonymous.", @"LoginViewController");
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.title = NSLocalizedString(@"Sign in", @"LoginViewController");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)loginButtonPressed:(id)sender {
    [self dismissKeyboard];
    
    if ( ([self.apiManager connectionAvailable:self]) &&
         (STRING_IS_VALID(self.userNameTextField.text)) &&
         (STRING_IS_VALID(self.passwordTextField.text)) ) {
        [self showMesg:@"Signing ..." showActivity:YES];
        [self.apiManager performRequest:REQ_DETAILS object:@{@"username": self.userNameTextField.text,
                                                             @"password": self.passwordTextField.text}];
    }
}

- (IBAction)newAccountButtonPressed:(id)sender {
    if ([self.apiManager connectionAvailable:self])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://users.celpax.com"]];
}

- (IBAction)forgotPasswordButtonPressed:(id)sender {
    if ([self.apiManager connectionAvailable:self])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://users.celpax.com"]];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)apiManagerRequest:(RequestEnum)request success:(id)responseObject {
    if (request == REQ_DETAILS) {
        self.dataManager.data.username = self.userNameTextField.text;
        if (DICTIONARY_IS_VALID(responseObject)) {
            if (STRING_IS_VALID([responseObject objectForKey:@"siteId"]) &&
                STRING_IS_VALID([responseObject objectForKey:@"submitionId"])) {
                self.dataManager.data.submissionId = [responseObject objectForKey:@"submitionId"];
                self.dataManager.data.officeSiteId = [responseObject objectForKey:@"siteId"];
                self.dataManager.data.userAlreadyLogged = YES;
            }
        }
        [self.apiManager performRequest:REQ_SITES object:nil];
    }
    else if (request == REQ_SITES) {
        if (ARRAY_IS_VALID(responseObject)) {
            NSUInteger numElements = [responseObject count];
            for (NSUInteger i = 0; i < numElements; i++) {
                if (DICTIONARY_IS_VALID([responseObject objectAtIndex:i])) {
                    NSDictionary *site = [responseObject objectAtIndex:i];
                    if (STRING_IS_VALID([site objectForKey:@"id"]) &&
                        [[site objectForKey:@"id"] isEqualToString:self.dataManager.data.officeSiteId]) {
                        if (STRING_IS_VALID([site objectForKey:@"description"])) {
                            self.dataManager.data.userOffice = [site objectForKey:@"description"];
                        }
                        break;
                    }
                }
            }
        }
        
        [self hideMesg];
        
        InSiteOffSiteViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"InSiteOffSiteViewController"];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

- (void)apiManagerRequest:(RequestEnum)request failure:(NSError *)error {
    [self hideMesg];
    if (request == REQ_DETAILS) {
        [self.apiManager showWarning:self
                             message:NSLocalizedString(@"Wrong Username or Password. Please retry.", @"LoginViewController")
                               title:NSLocalizedString(@"Login Error!", @"LoginViewController")];
    }
    else if (request == REQ_SITES) {
        [self.apiManager showWarning:self
                             message:NSLocalizedString(@"Connection Error. Please retry.", @"LoginViewController")
                               title:NSLocalizedString(@"Login Error!", @"LoginViewController")];
    }
}

- (void)showMesg:(NSString *)msg showActivity:(BOOL)act {
    if (self.messageView == nil) {
        self.messageView = [[WaitMessageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.messageView];
    }
    
    [self.messageView setMessage:msg showActivity:act];
}

- (void)hideMesg {
    if (IS_VALID(self.messageView)) {
        [self.messageView removeFromSuperview];
        self.messageView = nil;
    }
}

@end
