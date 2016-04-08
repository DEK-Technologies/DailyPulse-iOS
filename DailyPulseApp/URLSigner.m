//
//  URLSigner.m
//

#import "URLSigner.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@interface URLSigner ()
+ (NSString *)getFormattedDate;
@end

@implementation URLSigner

//
// Signs the URL using the HMAC SHA512 algorithm
//
// @param url    : the URL to be signed
// @param secret : the key in Base64 format
// @return       : the signed URL
//

+ (NSString *)signWithUrl:(NSString *)url andSecret:(NSString *)secret {
    
    NSData *key1 = [[NSData alloc] initWithBase64EncodedString:secret options:0];
    NSData *data1  = [[URLSigner getFormattedDate] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *macOut1 = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA512, key1.bytes, key1.length, data1.bytes, data1.length, macOut1.mutableBytes);
    
    NSData *data2  = [url dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *macOut2 = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA512, macOut1.bytes, macOut1.length, data2.bytes, data2.length, macOut2.mutableBytes);
    
    NSString *signatureString = [macOut2 base64EncodedStringWithOptions:0];
    
    return signatureString;
}


//
// Returns the UTC date in YYYYMMDD format
//

+ (NSString *)getFormattedDate {
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSString *formattedDate = [dateFormatter stringFromDate:now];
    
    return formattedDate;
}

@end
