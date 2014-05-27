//
//  NSData+Speakable.m
//  SpeakableStrings
//
//  Created by Andrew Dunn on 5/15/14.
//  Copyright (c) 2014 Andrew Dunn. All rights reserved.
//

#import "NSData+Speakable.h"


@implementation NSData (Speakable)

const char *brandNames[32] = {  "Camry",   "Nikon",   "Apple",   "Ford",        // 0-3
                                "Audi",    "Google",  "Nike",    "Amazon",      // 4-7
                                "Honda",   "Mazda",   "Buick",   "Fiat",        // 8-11
                                "Jeep",    "Lexus",   "Volvo",   "Fuji",        // 12-15
                                "Sony",    "Delta",   "Focus",   "Puma",        // 16-19
                                "Samsung", "Tivo",    "Halo",    "Sting",       // 20-23
                                "Shrek",   "Avatar",  "Shell",   "Visa",        // 24-27
                                "Vogue",   "Twitter", "Lego",    "Pepsi"};      // 28-31

- (NSString *)encodeAsSpeakableString
{
    NSMutableString *encodedString = [NSMutableString string];
    
    
    
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
        /*
        for(int i = 0; i < 8; i++) {
            printf("%c",buffer[i]);
        }
        printf("\n");
        */
        
        NSUInteger firstBit    = buffer[0]-48;
        NSUInteger secondBit   = buffer[1]-48;
        NSUInteger thirdBit    = buffer[2]-48;
        NSUInteger fourthBit   = buffer[3]-48;
        NSUInteger fifthBit    = buffer[4]-48;
        NSUInteger sixthBit    = buffer[5]-48;
        NSUInteger seventhBit  = buffer[6]-48;
        NSUInteger eigththBit  = buffer[7]-48;
        
        unsigned long leadingNumber   =   ((firstBit * 2 * 2) + (secondBit * 2) + (thirdBit * 1)) + 2; // add 2 because 0-7 is 2-9
        
        NSUInteger trailingNumber  =   (fourthBit       * 2 * 2 * 2 * 2)
                                        + (fifthBit     * 2 * 2 * 2)
                                        + (sixthBit     * 2 * 2)
                                        + (seventhBit   * 2)
                                        + (eigththBit   * 1);
        
        NSString *s = [[NSNumber numberWithInteger:leadingNumber] stringValue];
        [encodedString appendString: s];
        [encodedString appendString: @" "];
        [encodedString appendString: [NSString stringWithUTF8String:brandNames[trailingNumber]]];
        [encodedString appendString: @" "];
        
    
    }
    return encodedString;
}
    
+ (NSData *)dataWithSpeakableString:(NSString *)s
                              error:(NSError **)e
{
    
    //NSLog(@"input string: %@", s);
    NSInteger inLeadingNumber = 0;
    
    NSMutableString *brandName = [NSMutableString string];
    
    NSMutableString *bitString = [NSMutableString string];
    
    int byteValues[8];
    int k = 0;
    
    for (int i = 0; i < [s length]; i++)
    {
        char current = [s characterAtIndex:i];
        //NSLog(@"Value: %C", current);
        int bitVals[8];
        
        
        if (inLeadingNumber == 0){
            
            if (current == ' '){
                inLeadingNumber = 1;
            }
            else{
                NSInteger leadingNumber = [[NSNumber numberWithChar:current] intValue] - 48;
                //NSLog(@"%i Leading Number", leadingNumber);
                leadingNumber -= 2;
                NSMutableString *bin = [NSMutableString string];
                if (leadingNumber >= 4){
                    [bin appendString:@"1"];
                    leadingNumber -= 4;
                    bitVals[0] = 1;
                }
                else
                {
                    [bin appendString:@"0"];
                    bitVals[0] = 0;
                }
                if (leadingNumber >= 2){
                    [bin appendString:@"1"];
                    leadingNumber -= 2;
                    bitVals[1] = 1;
                }
                else
                {
                    [bin appendString:@"0"];
                    bitVals[1] = 0;
                }
                if (leadingNumber >= 1){
                    [bin appendString:@"1"];
                    leadingNumber -= 1;
                    bitVals[2] = 1;
                }
                else
                {
                    [bin appendString:@"0"];
                    bitVals[2] = 0;
                }
                //NSLog(@"%@", bin);
                [bitString appendString: bin];
                
            }
        }
        
        else{
            if ( current == ' ' ){
                //NSLog(@"the speakable string is %@\n",brandName);
                
                NSMutableString *bin2 = [NSMutableString string];
                
                // iterate through const char * array find match
                int i =0;
                int nameFound = 0;
                while (brandNames[i] != '\0'){
                    if([brandName isEqualToString:[NSString stringWithUTF8String:brandNames[i] ]])
                    {
                        nameFound = 1;
                        //printf("%s\n", brandNames[i]);
                        // encode i in binary.
                        int j = i;
                        
                        
                        if (j >= 16){
                            [bin2 appendString:@"1"];
                            j -= 16;
                            bitVals[3] = 1;
                        }
                        else
                        {
                            [bin2 appendString:@"0"];
                            bitVals[3] = 0;
                        }
                        
                        if (j >= 8){
                            [bin2 appendString:@"1"];
                            j -= 8;
                            bitVals[4] = 1;
                        }
                        else
                        {
                            [bin2 appendString:@"0"];
                            bitVals[4] = 0;
                        }
                        
                        if (j >= 4){
                            [bin2 appendString:@"1"];
                            j -= 4;
                            bitVals[5] = 1;
                        }
                        else
                        {
                            [bin2 appendString:@"0"];
                            bitVals[5] = 0;
                        }
                        
                        if (j >= 2){
                            [bin2 appendString:@"1"];
                            j -= 2;
                            bitVals[6] = 1;
                        }
                        else
                        {
                            [bin2 appendString:@"0"];
                            bitVals[6] = 0;
                        }
                        
                        if (j >= 1){
                            [bin2 appendString:@"1"];
                            j -= 1;
                            bitVals[7] = 1;
                        }
                        else
                        {
                            [bin2 appendString:@"0"];
                            bitVals[7] = 0;
                        }
                        //NSLog(@"%i speakable string in Binary %@", i, bin2);
                        
                        // calculate int value of byte.
                        // could be done recursively, but this is a relatively short iteration
                        int byteValue =
                        bitVals[0]  * 2 * 2 * 2 * 2 * 2 * 2 * 2 +
                        bitVals[1]  * 2 * 2 * 2 * 2 * 2 * 2 +
                        bitVals[2]  * 2 * 2 * 2 * 2 * 2 +
                        bitVals[3]  * 2 * 2 * 2 * 2 +
                        bitVals[4]  * 2 * 2 * 2 +
                        bitVals[5]  * 2 * 2 +
                        bitVals[6]  * 2 +
                        bitVals[7]  * 1;
                        
                        //printf("byteValue is %i\n", byteValue);
                        byteValues[k] = byteValue;
                        k++;
                        
                        
                    }
                    
                    i++;
                }
                if (nameFound == 0)
                {
                    
                    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Unable to Parse, brand name not found."};
                    *e = [NSError errorWithDomain:@"SpeakableBytes" code:1 userInfo:userInfo];
                    return nil;
                    
                }
                
                
                
                
                
                [bitString appendString:bin2];
                //NSLog(@"%@", bitString);
                //NSLog(@"- - - - - - - - - - -", bitString);
                [brandName setString:@""];
                inLeadingNumber = 0;
                
                
                
            }
            else
            {
                [brandName appendString:[NSString stringWithFormat:@"%c", current]];
            }
            
        }
        
    }
    
    
    /*
    for (int i = 0; i < 8; i ++)
    {
        printf("the int value of byte %i is %i\n", i, byteValues[i]);
    }
    */
    
    const unsigned char bytes2[] = { byteValues[0],byteValues[1],byteValues[2],
                                    byteValues[3],byteValues[4],byteValues[5],
                                    byteValues[6],byteValues[7] };
    
    NSData *data = [NSData dataWithBytes:bytes2 length:sizeof(bytes2)];
        
    return data;
}
@end
