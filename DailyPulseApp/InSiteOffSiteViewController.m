//
//  InSiteOffSiteViewController.m
//

#import "InSiteOffSiteViewController.h"
#import "DataManager.h"
#import "Common.h"

@interface InSiteOffSiteViewController ()
- (IBAction)inSiteButtonPressed:(id)sender;
- (IBAction)offSiteButtonPressed:(id)sender;
@end

@implementation InSiteOffSiteViewController

- (IBAction)inSiteButtonPressed:(id)sender {
    self.dataManager.data.userWorkSite = IN_SITE;
    [self.dataManager storeData];
    [[NSNotificationCenter defaultCenter] postNotificationName:FirstLoginPerformedNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)offSiteButtonPressed:(id)sender {
    self.dataManager.data.userWorkSite = OFF_SITE;
    [self.dataManager storeData];
    [[NSNotificationCenter defaultCenter] postNotificationName:FirstLoginPerformedNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataManager = [DataManager instance];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = NSLocalizedString(@"Choose Site", @"LoginViewController");
    
    self.questionLabel.text = NSLocalizedString(@"Where do you usually work?", @"InSiteOffSiteViewController");
    self.orLabel.text = NSLocalizedString(@"Or", @"InSiteOffSiteViewController");
    self.noteLabel.text = NSLocalizedString(@"Note: this information is used to set the site where your votes are stored. You can change this setting at any time.", @"InSiteOffSiteViewController");
    
    [self.inSiteButton setTitle:NSLocalizedString(@"In-Site (in your company's office)", @"InSiteOffSiteViewController") forState:UIControlStateNormal];
    [self.offSiteButton setTitle:NSLocalizedString(@"Off-Site (at a customer's office or from home)", @"InSiteOffSiteViewController") forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
