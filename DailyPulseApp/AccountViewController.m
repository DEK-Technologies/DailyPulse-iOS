//
//  AccountViewController.m
//

#import "AccountViewController.h"
#import "DataManager.h"

@interface AccountViewController ()
- (IBAction)signOutButtonPressed:(id)sender;
- (void)workingSitePressed:(id)sender;
- (void)doneButtonPressed;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataManager = [DataManager instance];
    
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
    
    self.userLabel.text = self.dataManager.data.username;
    self.officeLabel.text = self.dataManager.data.userOffice;
    
    if (self.dataManager.data.userWorkSite == IN_SITE)
         self.workingSiteControl.selectedSegmentIndex = 0;
    else
         self.workingSiteControl.selectedSegmentIndex = 1;
          
    [self.workingSiteControl addTarget:self
                                action:@selector(workingSitePressed:)
                      forControlEvents:UIControlEventValueChanged];
}

- (void)workingSitePressed:(id)sender {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:NSLocalizedString(@"Working site", @"AccountViewController")
                                message:NSLocalizedString(@"Changing working site. Continue?\nNote: this information is used to set the site where your votes are stored.\nIn-Site (in your company's office)\nOff-Site (at a customer's office or from home)", @"AccountViewController")
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", @"AccountViewController")
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   if (self.workingSiteControl.selectedSegmentIndex == 0)
                                                       self.dataManager.data.userWorkSite = IN_SITE;
                                                   else
                                                       self.dataManager.data.userWorkSite = OFF_SITE;;
                                                       
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"AccountViewController")
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action){
                                                       if (self.dataManager.data.userWorkSite == IN_SITE)
                                                           self.workingSiteControl.selectedSegmentIndex = 0;
                                                       else
                                                           self.workingSiteControl.selectedSegmentIndex = 1;
                                                       
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    [alert addAction:cancel];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
