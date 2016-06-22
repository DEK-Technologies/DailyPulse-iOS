//
//  SubmitViewController.m
//

#import "SubmitViewController.h"
#import "DataManager.h"
#import "Common.h"
#import "WaitMessageView.h"

@interface SubmitViewController ()
- (IBAction)happyButtonPressed:(id)sender;
- (IBAction)sadButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)showProfilePressed:(id)sender;
- (void)showMesg:(NSString *)msg showActivity:(BOOL)act;
- (void)hideMesg;
- (void)dismissMe;
- (void)showAlert;
@end

@implementation SubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataManager = [DataManager instance];
    self.apiManager = [[APIManager alloc] initWithDelegate:self];
    
    [self.showProfileButton setTitle:NSLocalizedString(@"Show/Edit Profile", @"SubmitViewController") forState:UIControlStateNormal];
    
    self.questionLabel.text = NSLocalizedString(@"How was your day?", @"SubmitViewController");
}

- (IBAction)happyButtonPressed:(id)sender {
    if ([self.apiManager connectionAvailable:self]) {
        [self showMesg:@"Submitting ..." showActivity:YES];
        [self.apiManager performRequest:REQ_VOTE object:@{@"vote": @1,
                                                          @"submissionId": self.dataManager.data.submissionId,
                                                          @"duplicated": [NSNumber numberWithBool:[self.dataManager isVoteAlreadySent]]}];
    }
}

- (IBAction)sadButtonPressed:(id)sender {
    if ([self.apiManager connectionAvailable:self]) {
        [self showMesg:@"Submitting ..." showActivity:YES];
        [self.apiManager performRequest:REQ_VOTE object:@{@"vote": @0,
                                                          @"submissionId": self.dataManager.data.submissionId,
                                                          @"duplicated": [NSNumber numberWithBool:[self.dataManager isVoteAlreadySent]]}];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)apiManagerRequest:(RequestEnum)request success:(id)responseObject {
    [self.dataManager voteSent];
    [self showMesg:@"Thanks for voting!" showActivity:NO];
    [self performSelector:@selector(dismissMe) withObject:nil afterDelay:1.5];
}

- (void)apiManagerRequest:(RequestEnum)request failure:(NSError *)error {
    [self showAlert];
}

- (IBAction)showProfilePressed:(id)sender {
    if ([self.apiManager connectionAvailable:self])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://users.celpax.com/#section_UserProfile"]];
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

- (void)dismissMe {
    [self hideMesg];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlert {
    [self hideMesg];
    [self.apiManager showWarning:self
                         message:NSLocalizedString(@"Connection Error. Please retry.", @"SubmitViewController")
                           title:NSLocalizedString(@"Submitting Error!", @"SubmitViewController")];
}

@end
