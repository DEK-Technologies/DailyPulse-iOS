//
//  DataManager.m
//

#import "DataManager.h"
#import "Common.h"
#import "UIKit/UIKit.h"

@interface DataManager ()
- (void)getData;
@end

@implementation DataManager

+ (DataManager *)instance {
    static DataManager *sharedPointer = nil;
    @synchronized([DataManager class]) {
        if (sharedPointer == nil)
            sharedPointer = [[self alloc] init];
    }
    return sharedPointer;
}

-(id)init {
    if ((self = [super init])) {
        [self getData];
    }
    
    return self;
}

- (void)storeData {
    NSData *nsdata = [NSKeyedArchiver archivedDataWithRootObject:self.data];
    [[NSUserDefaults standardUserDefaults] setObject:nsdata forKey:@"Data"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getData {
    NSData *nsdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"Data"];
    if (IS_VALID(nsdata))
        self.data = [NSKeyedUnarchiver unarchiveObjectWithData:nsdata];
    else {
        self.data = [[Data alloc] init];
        [self.data resetData];
    }
}

- (void)voteSent {
    NSDate *now = [NSDate date];
    self.data.lastVoteDate = [now timeIntervalSince1970];
}

- (BOOL)isVoteAlreadySent {
    NSDate *last = [NSDate dateWithTimeIntervalSince1970:self.data.lastVoteDate];
    if (IS_VALID(last)) {
        NSDate *now = [NSDate date];
        return [[NSCalendar currentCalendar] isDate:now inSameDayAsDate:last];
    }
    else
        return NO;
}

- (NSString *)getCurrentPanelId {
    if (self.data.userWorkSite == IN_SITE)
        return self.data.officePanelId;
    else
        return self.data.mobilePanelId;
}

- (void)resetData {
    [self.data resetData];
}

@end
