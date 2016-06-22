//
//  AccountViewController.m
//

#import "AccountViewController.h"
#import "DataManager.h"

@interface AccountViewController ()
- (IBAction)signOutButtonPressed:(id)sender;
- (IBAction)showProfilePressed:(id)sender;
- (void)doneButtonPressed;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataManager = [DataManager instance];
    self.apiManager = [[APIManager alloc] initWithDelegate:self];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    self.navigationItem.title = NSLocalizedString(@"Account", @"AccountViewController");
    
    UIBarButtonItem *rbarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    self.navigationItem.rightBarButtonItem = rbarBtn;
    
    self.userTitleLabel.text = NSLocalizedString(@"Username", @"AccountViewController");
    self.officeTitleLabel.text = NSLocalizedString(@"Office", @"AccountViewController");
    self.siteLabel.text = NSLocalizedString(@"Working site", @"AccountViewController");
    
    [self.signOutButton setTitle:NSLocalizedString(@"Sign Out", @"AccountViewController") forState:UIControlStateNormal];
    [self.showProfileButton setTitle:NSLocalizedString(@"Show/Edit Profile", @"AccountViewController") forState:UIControlStateNormal];
    
    self.userLabel.text = self.dataManager.data.username;
    self.officeLabel.text = self.dataManager.data.userOffice;
}

- (IBAction)showProfilePressed:(id)sender {
    if ([self.apiManager connectionAvailable:self])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://users.celpax.com/#section_UserProfile"]];
}

- (void)doneButtonPressed {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signOutButtonPressed:(id)sender {
    [self.dataManager resetData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)apiManagerRequest:(RequestEnum)request success:(id)responseObject {
    // empty
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
