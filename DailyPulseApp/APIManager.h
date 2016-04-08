//
//  APIManager.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    VOTE_SAD,    // red
    VOTE_HAPPY   // green
} VoteEnum;

typedef enum {
    // GET
    REQ_NONE,
    REQ_TEST,
    REQ_SITES,
    REQ_OFFICE_MOOD,
    REQ_MOBILE_MOOD,
    REQ_PULSES,
    
    REQ_IMAGE,
    
    // POST
    REQ_DETAILS,
    REQ_VOTE
} RequestEnum;

@class DataManager;

@protocol APIManagerDelegate
- (void)apiManagerRequest:(RequestEnum)request success:(id)responseObject;

@optional
- (void)apiManagerRequest:(RequestEnum)request failure:(NSError *)error;
@end

@interface APIManager : NSObject

@property (nonatomic, strong) NSObject <APIManagerDelegate> *delegate;
@property (nonatomic) RequestEnum currentRequest;
@property (nonatomic, strong) DataManager *dataManager;

- (id)initWithDelegate:(NSObject <APIManagerDelegate> *)del;
- (void)performRequest:(RequestEnum)request object:(id)requestObject;
- (BOOL)connectionAvailable:(UIViewController *)viewController;
- (void)showWarning:(UIViewController *)viewController message:(NSString*)message title:(NSString*)title;

@end
