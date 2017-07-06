//
//  NSString+JackpotRising.m
//  JackpotRising
//
//  Created by Prethush on 08/08/16.
//  Copyright © 2016 Jackpot Rising Inc. All rights reserved.
//

#import "NSString+JackpotRising.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CoreText/CoreText.h>

@implementation NSString (JackpotRising)

- (NSData*)SHA1DigestWithKey:(NSString*)key{
    
    const char *str = [self cStringUsingEncoding:NSUTF8StringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    const char *keyStr = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA1, keyStr, strlen(keyStr), str, strlen(str), cHMAC);
    
    return [[NSData alloc] initWithBytes:cHMAC
                                  length:sizeof(cHMAC)];
}

- (NSString*) MD5HashString {
    const char* pointer = [self UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(pointer, (CC_LONG)strlen(pointer), md5Buffer);
    
    NSMutableString *string = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i=0; i< CC_MD5_DIGEST_LENGTH; i++)
        [string appendFormat:@"%02x",md5Buffer[i]];
    
    return string;
}

@end

@implementation CustomFont
+ (void)loadCustomFont:(NSString*)fontName{
    NSString *fontPath = [[NSBundle bundleForClass:[self class]] pathForResource:fontName ofType:@"ttf"];
    NSData *inData = [NSData dataWithContentsOfFile:fontPath];
    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)inData);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    }
    CFRelease(font);
    CFRelease(provider);
}

@end
