//
//  NSString+JackpotRising.h
//  JackpotRising
//
//  Created by Prethush on 08/08/16.
//  Copyright © 2016 Jackpot Rising Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JackpotRising)

- (NSData*)SHA1DigestWithKey:(NSString*)key;
- (NSString*) MD5HashString;

@end

@interface CustomFont : NSObject
+ (void)loadCustomFont:(NSString*)fontName;
@end