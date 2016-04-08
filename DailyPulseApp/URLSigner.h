//
//  URLSigner.h
//

#import <Foundation/Foundation.h>

@interface URLSigner : NSObject

+ (NSString *)signWithUrl:(NSString *)url andSecret:(NSString *)secret;

@end
