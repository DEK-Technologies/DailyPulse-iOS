//
//  Data.h
//

#import <Foundation/Foundation.h>

typedef enum {
    IN_SITE,
    OFF_SITE
} UserWorkSiteType;

@interface Data : NSObject <NSCoding>

@property (nonatomic, copy) NSString *username, *submissionId, *officeSiteId, *mobileSiteId, *userOffice, *officePanelId, *mobilePanelId, *accessKeyId, *secretAccessKey;
@property (nonatomic) UserWorkSiteType userWorkSite;
@property (nonatomic) BOOL userAlreadyLogged;
@property (nonatomic) NSTimeInterval lastVoteDate;

- (void)resetData;

@end
