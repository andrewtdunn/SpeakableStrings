//
//  NSData+Speakable.h
//  SpeakableStrings
//
//  Created by Andrew Dunn on 5/15/14.
//  Copyright (c) 2014 Andrew Dunn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Speakable)

- (NSString *)encodeAsSpeakableString;
- (NSData *)dataWithSpeakableString: (NSString *)s error:(NSError **)e;
@end
