//
//  Common.h
//

#ifndef Common_h
#define Common_h

#import "../../ExternalFiles/DailyPulseApp_SecretData.h"
// Create your own external file and add here it's path.
// The following strings must be defined:
//#define MOBILE_SITE_ID        @"My-Mobile-Site-Id"
//#define OFFICE_PANEL_ID       @"My-Office-Panel-Id"
//#define MOBILE_PANEL_ID       @"My-Mobile-Panel-Id"
//#define ACCESS_KEY_ID         @"My-Access-Key-Id"
//#define SECRET_ACCESS_KEY     @"My-Secret-Access-Key"

#define IS_VALID(x)             ( ( ((x) != nil) && ![(x) isKindOfClass:[NSNull class]] ) ? YES : NO )
#define ARRAY_IS_VALID(x)       ( ( ((x) != nil) && [(x) isKindOfClass:[NSArray class]] ) ? YES : NO )
#define NUMBER_IS_VALID(x)      ( ( ((x) != nil) && [(x) isKindOfClass:[NSNumber class]] ) ? YES : NO )
#define DICTIONARY_IS_VALID(x)  ( ( ((x) != nil) && [(x) isKindOfClass:[NSDictionary class]] ) ? YES : NO )
#define STRING_IS_VALID(x)      ( ( ((x) != nil) && [(x) isKindOfClass:[NSString class]] && ![(x) isEqualToString:@""] ) ? YES : NO )
#define FirstLoginPerformedNotification @"FirstLoginPerformedNotification"

#endif /* Common_h */
