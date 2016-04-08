//
//  ResultsViewController.m
//

#import "ResultsViewController.h"
#import "DataManager.h"
#import "Common.h"
#import "SiteMoodKPIViewController.h"
#import "LoginViewController.h"


@interface ResultsViewController ()
- (void)checkConnection;
- (void)appWillEnterForeground;
@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [DataManager instance];
    self.apiManager = [[APIManager alloc] initWithDelegate:self];
    self.justStarted = YES;
    
    [self.accountButton setTitle:NSLocalizedString(@"Account", @"ResultsViewController") forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(appWillEnterForeground)
                                                name:UIApplicationWillEnterForegroundNotification
                                              object:nil];
    
    self.officeLabel.text = self.dataManager.data.userOffice;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.dataManager.data.userAlreadyLogged) {
        if (![self.dataManager isVoteAlreadySent] && self.justStarted) {
            [self performSegueWithIdentifier: @"SubmitViewControllerSegue" sender:self];
            self.justStarted = NO;
        }
        else
            [self performSelector:@selector(checkConnection) withObject:nil afterDelay:2];
    }
    else {
        UINavigationController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginNavigationController"];
        
        [self presentViewController:ctrl animated:YES completion:nil];
    }
}

- (void)appWillEnterForeground {
    if (self.dataManager.data.userAlreadyLogged) {
        [self performSelector:@selector(checkConnection) withObject:nil afterDelay:2];
    }
}

- (void)checkConnection {
    if ([self.apiManager connectionAvailable:self])
        NSLog(@"Connection OK!");
}

- (void)apiManagerRequest:(RequestEnum)request success:(id)responseObject {
    NSLog(@"Request %d Success!", (int)request);
}

- (void)apiManagerRequest:(RequestEnum)request failure:(NSError *)error {
    NSLog(@"Request %d Failure!", (int)request);
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     SiteMoodKPIViewController *siteMoodKPIVC = [segue destinationViewController];
     if ([segue.identifier isEqualToString:@"InSiteMoodKPISegue"])
         [siteMoodKPIVC setInitData:REQ_OFFICE_MOOD];
     else if ([segue.identifier isEqualToString:@"OffSiteMoodKPISegue"])
         [siteMoodKPIVC setInitData:REQ_MOBILE_MOOD];
 }
 

@end
