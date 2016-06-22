//
//  DataManager.h
//

#import <Foundation/Foundation.h>
#import "Data.h"

@interface DataManager : NSObject

@property (nonatomic, strong) Data *data;

+ (DataManager *)instance;
- (void)storeData;
- (void)voteSent;
- (BOOL)isVoteAlreadySent;
- (void)resetData;

@end
