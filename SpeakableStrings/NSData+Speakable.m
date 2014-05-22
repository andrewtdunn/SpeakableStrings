//
//  NSData+Speakable.m
//  SpeakableStrings
//
//  Created by Andrew Dunn on 5/15/14.
//  Copyright (c) 2014 Andrew Dunn. All rights reserved.
//

#import "NSData+Speakable.h"

@implementation NSData (Speakable)

- (NSString *)encodeAsSpeakableString
{
    NSMutableString *encodedString = [NSMutableString string];
    NSArray *array = [NSArray arrayWithObjects: @"Camry",   @"Nikon",   @"Apple",   @"Ford",
                                                @"Audi",    @"Google",  @"Nike",    @"Amazon",
                                                @"Honda",   @"Mazda",   @"Buick",   @"Fiat",
                                                @"Jeep",    @"Lexus",   @"Volvo",   @"Fuji",
                                                @"Sony",    @"Delta",   @"Focus",   @"Puma",
                                                @"Samsung", @"Tivo",    @"Halo",    @"Sting",
                                                @"Shrek",   @"Avatar",  @"Shell",   @"Visa",
                                                @"Vogue",   @"Twitter", @"Lego",    @"Pepsi", nil];
    
    
    
    const char *byte = [self bytes];
    NSUInteger length = [self length];
    for (int i=0; i<length; i++) {
        char n = byte[i];
        char buffer[9];
        buffer[8] = 0; //for null
        int j = 8;
        
        while(j > 0)
        {
            if(n & 0x01)
            {
                buffer[--j] = '1';
            } else
            {
                buffer[--j] = '0';
            }
            n >>= 1;
        }
        NSUInteger firstBit    = buffer[0]-48;
        NSUInteger secondBit   = buffer[1]-48;
        NSUInteger thirdBit    = buffer[2]-48;
        NSUInteger fourthBit   = buffer[3]-48;
        NSUInteger fifthBit    = buffer[4]-48;
        NSUInteger sixthBit    = buffer[5]-48;
        NSUInteger seventhBit  = buffer[6]-48;
        NSUInteger eigththBit  = buffer[7]-48;
        
        unsigned long leadingNumber   =   ((firstBit * 2 * 2) + (secondBit * 2) + (thirdBit * 1)) + 2;
        
        NSUInteger trailingNumber  =   (fourthBit * 2 * 2 * 2 * 2)
                                        + (fifthBit * 2 * 2 * 2)
                                        + (sixthBit * 2 * 2)
                                        + (seventhBit * 2)
                                        + (eigththBit * 1);
        
        NSString *s = [[NSNumber numberWithInteger:leadingNumber] stringValue];
        [encodedString appendString: s];
        [encodedString appendString: @" "];
        [encodedString appendString: array[trailingNumber]];
        [encodedString appendString: @" "];
        
    
    }
    return encodedString;
}
    
- (NSData *)dataWithSpeakableString: (NSString *)s error:(NSError **)e
{
    NSLog(@"input string: %@", s);
    NSData *dataString = @"cool";
    return dataString;
}
@end
