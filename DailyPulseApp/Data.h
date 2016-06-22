//
//  Data.h
//

#import <Foundation/Foundation.h>

@interface Data : NSObject <NSCoding>

@property (nonatomic, copy) NSString *username, *submissionId, *officeSiteId, *mobileSiteId, *userOffice, *accessKeyId, *secretAccessKey;
@property (nonatomic) BOOL userAlreadyLogged;
@property (nonatomic) NSTimeInterval lastVoteDate;

- (void)resetData;

@end
