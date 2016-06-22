//
//  InSiteOffSiteViewController.m
//

#import "InSiteOffSiteViewController.h"
#import "DataManager.h"
#import "Common.h"

@interface InSiteOffSiteViewController ()
- (IBAction)showProfilePressed:(id)sender;
@end

@implementation InSiteOffSiteViewController

- (IBAction)showProfilePressed:(id)sender {
    [self.dataManager storeData];
    [[NSNotificationCenter defaultCenter] postNotificationName:FirstLoginPerformedNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.apiManager connectionAvailable:self])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://users.celpax.com/#section_UserProfile"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataManager = [DataManager instance];
    self.apiManager = [[APIManager alloc] initWithDelegate:self];
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = NSLocalizedString(@"Choose Site", @"InSiteOffSiteViewController");
    
    self.questionLabel.text = NSLocalizedString(@"Where do you usually work?\nTap below to set it up.", @"InSiteOffSiteViewController");
    self.noteLabel.text = NSLocalizedString(@"Note: this information is used to set the site where your votes are stored. You can change this setting at any time.", @"InSiteOffSiteViewController");
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
