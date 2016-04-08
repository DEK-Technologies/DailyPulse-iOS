//
//  APIManager.m
//

#import "APIManager.h"
#import "AFNetworking.h"
#import "URLSigner.h"
#import "Common.h"
#import "DataManager.h"

#define API_ENDPOINT        @"https://api.celpax.com:4443"
#define WEST_ENDPOINT       @"https://users.celpax.com:443"

@interface APIManager ()
- (void)performGET:(NSString *)url sign:(NSString *)sign;
- (void)performPOST:(NSString *)url sign:(NSString *)sign params:(NSDictionary *)params;
- (void)submitVote:(NSDictionary *)params;
- (void)getBackgroundImage;
@end

@implementation APIManager

- (id)initWithDelegate:(NSObject <APIManagerDelegate> *)del {
    self = [super init];
    if (self) {
        self.delegate = del;
        self.currentRequest = REQ_NONE;
        self.dataManager = [DataManager instance];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

- (void)performGET:(NSString *)url sign:(NSString *)sign {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:self.dataManager.data.accessKeyId forHTTPHeaderField:@"X-Celpax-Access-Key-Id"];
    [requestSerializer setValue:sign forHTTPHeaderField:@"X-Celpax-Signature"];
    
    manager.requestSerializer = requestSerializer;
    
    [manager GET:url
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             if ( IS_VALID(self.delegate) && ([self.delegate respondsToSelector:@selector(apiManagerRequest:success:)]) )
                 [self.delegate apiManagerRequest:self.currentRequest success:responseObject];
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             if ( IS_VALID(self.delegate) && ([self.delegate respondsToSelector:@selector(apiManagerRequest:failure:)]) )
                 [self.delegate apiManagerRequest:self.currentRequest failure:error];
         }
     ];
}

- (void)performPOST:(NSString *)url sign:(NSString *)sign params:(NSDictionary *)params {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:self.dataManager.data.accessKeyId forHTTPHeaderField:@"X-Celpax-Access-Key-Id"];
    [requestSerializer setValue:sign forHTTPHeaderField:@"X-Celpax-Signature"];
    
    manager.requestSerializer = requestSerializer;
    
    [manager POST:url
       parameters:params
         progress:nil
          success:^(NSURLSessionTask *task, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
              if ( IS_VALID(self.delegate) && ([self.delegate respondsToSelector:@selector(apiManagerRequest:success:)]) )
                  [self.delegate apiManagerRequest:self.currentRequest success:responseObject];
          } failure:^(NSURLSessionTask *operation, NSError *error) {
              NSLog(@"Error: %@", error);
              if ( IS_VALID(self.delegate) && ([self.delegate respondsToSelector:@selector(apiManagerRequest:failure:)]) )
                  [self.delegate apiManagerRequest:self.currentRequest failure:error];
          }
     ];
}

- (void)performRequest:(RequestEnum)request object:(id)requestObject {
    self.currentRequest = request;
    if (request < REQ_IMAGE) {
        NSString *url = @"";
        switch (request) {
            case REQ_TEST:
                if (STRING_IS_VALID(requestObject))
                    url = [NSString stringWithFormat:@"/test/echo/%@", requestObject];
                break;
            case REQ_SITES:
                url = @"/profile/sites";
                break;
            case REQ_OFFICE_MOOD:
            case REQ_MOBILE_MOOD:
                if (STRING_IS_VALID(requestObject))
                    url = [NSString stringWithFormat:@"/latest/mood/%@", requestObject];
                break;
            case REQ_PULSES:
                if (STRING_IS_VALID(requestObject))
                    url = [NSString stringWithFormat:@"/latest/pulsesperday/%@", requestObject];
                break;
            default:
                break;
        }
        
        [self performGET:[NSString stringWithFormat:@"%@%@", API_ENDPOINT, url]
                    sign:[URLSigner signWithUrl:url andSecret:self.dataManager.data.secretAccessKey]];
    }
    else if (request == REQ_IMAGE) {
        [self getBackgroundImage];
    }
    else {
        NSDictionary *params = nil;
        switch (request) {
            case REQ_DETAILS:
                if (DICTIONARY_IS_VALID(requestObject)) {
                    if (STRING_IS_VALID([requestObject objectForKey:@"username"]) &&
                        STRING_IS_VALID([requestObject objectForKey:@"password"])) {
                        
                        NSString *url = @"/ws/submitreq";
                        params = @{@"j_username": [requestObject objectForKey:@"username"],
                                   @"j_password": [requestObject objectForKey:@"password"],
                                   @"remember_me": @false};
                        
                        [self performPOST:[NSString stringWithFormat:@"%@%@", WEST_ENDPOINT, url]
                                     sign:[URLSigner signWithUrl:url andSecret:self.dataManager.data.secretAccessKey]
                                   params:params];
                    }
                }
                break;
            case REQ_VOTE:
                if (DICTIONARY_IS_VALID(requestObject)) {
                    if (STRING_IS_VALID([requestObject objectForKey:@"panelId"]) &&
                        NUMBER_IS_VALID([requestObject objectForKey:@"vote"]) &&
                        STRING_IS_VALID([requestObject objectForKey:@"submissionId"]) &&
                        NUMBER_IS_VALID([requestObject objectForKey:@"duplicated"])) {
                        
                        double utc_timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
                        NSArray *votesArray = @[@{@"vote": [requestObject objectForKey:@"vote"],
                                                  @"submitionDate": [NSNumber numberWithDouble:utc_timestamp],
                                                  @"dayDuplicated": [requestObject objectForKey:@"duplicated"]}];
                        params = @{@"submitionId": [requestObject objectForKey:@"submissionId"],
                                   @"panelId": [requestObject objectForKey:@"panelId"],
                                   @"votes": votesArray};
                        
                        [self submitVote:params];
                    }
                }
                break;
            default:
                break;
        }
    }
}

- (void)submitVote:(NSDictionary *)params {
    NSString *url = @"/submit/vote";
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@", API_ENDPOINT, url] parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [req setValue:self.dataManager.data.accessKeyId forHTTPHeaderField:@"X-Celpax-Access-Key-Id"];
    [req setValue:[URLSigner signWithUrl:url andSecret:self.dataManager.data.secretAccessKey] forHTTPHeaderField:@"X-Celpax-Signature"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[manager dataTaskWithRequest:req
                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"JSON: %@", responseObject);
            if ( IS_VALID(self.delegate) && ([self.delegate respondsToSelector:@selector(apiManagerRequest:success:)]) )
                [self.delegate apiManagerRequest:self.currentRequest success:responseObject];
        } else {
            NSLog(@"Error: %@ - %@ - %@", error, response, responseObject);
            if ( IS_VALID(self.delegate) && ([self.delegate respondsToSelector:@selector(apiManagerRequest:failure:)]) )
                [self.delegate apiManagerRequest:self.currentRequest failure:error];
        }
    }] resume];
}

- (void)getBackgroundImage {
    NSString *url = @"/profile/background";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestSerializer setValue:self.dataManager.data.accessKeyId forHTTPHeaderField:@"X-Celpax-Access-Key-Id"];
    [requestSerializer setValue:[URLSigner signWithUrl:url andSecret:self.dataManager.data.secretAccessKey] forHTTPHeaderField:@"X-Celpax-Signature"];
    manager.requestSerializer = requestSerializer;
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"image/jpeg"]];
    
    [manager GET:[NSString stringWithFormat:@"%@%@", API_ENDPOINT, url]
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
             if ([responseObject isKindOfClass:[NSData class]]) {
                 UIImage *image = [UIImage imageWithData:responseObject];
                 NSLog(@"image: %@", image);
             }
             if ( IS_VALID(self.delegate) && ([self.delegate respondsToSelector:@selector(apiManagerRequest:success:)]) )
                 [self.delegate apiManagerRequest:self.currentRequest success:responseObject];
         } failure:^(NSURLSessionTask *operation, NSError *error) {
             NSLog(@"Error: %@", error);
             if ( IS_VALID(self.delegate) && ([self.delegate respondsToSelector:@selector(apiManagerRequest:failure:)]) )
                 [self.delegate apiManagerRequest:self.currentRequest failure:error];
         }
     ];
}

- (BOOL)connectionAvailable:(UIViewController *)viewController {
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        [self showWarning:viewController
                  message:NSLocalizedString(@"Please, check your internet connection.", @"APIManager")
                    title:NSLocalizedString(@"Connection Error!", @"APIManager")];
        return NO;
    }
    else
        return YES;
}

- (void)showWarning:(UIViewController *)viewController message:(NSString*)message title:(NSString*)title {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:message
                                preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action){
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    
    [alert addAction:ok];
    
    [viewController presentViewController:alert animated:YES completion:nil];
}

@end
