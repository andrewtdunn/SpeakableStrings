//
//  main.m
//  SpeakableStrings
//
//  Created by Andrew Dunn on 5/15/14.
//  Copyright (c) 2014 Andrew Dunn. All rights reserved.
//

#import <Foundation/Foundation.h>

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // Generate 8 bits of random data
        srandom((unsigned int) time(NULL));
        int64_t randomBytes = (random() << 32) | random();
        
        // Pack it in an NSData
        NSData *inData = [NSData dataWithBytes:&randomBytes length:sizeof(int64_t)];
        
        NSLog(@"In Data = %@", inData);
        
        // Convert to a speakable string
        NSString *speakable = [inData encodeAsSpeakableString];
        NSLog(@"Got string \"%@\"", speakable);
        
        // Converting it back to an NSData
        NSError *err;
        NSData *outData = [NSData dataWithSpeakableString:speakable
                                                    error:&err];
        
        if (!outData) {
            NSLog(@"Unexpected Error: %@", [err localizedDescription]);
            return -1;
        }
        
        NSLog(@"Out data: %@", outData);
        
        // outData better be the same inData
        if (![outData isEqual:inData]){
            NSLog(@"Data coming out is not the same as what went in.");
            return -1;
        }
        
        // Test a mispelling ("Teevo" not "Tivo");
        speakable = @"2 Jeep 3 Halo 7 Teevo 2 Pepsi 2 Volvo";
        outData = [NSData dataWithSpeakableString:speakable
                                            error:&err];
        if (!outData) {
            NSLog(@"Unexpected error: %@", [err localizedDescription]);
        }
        else{
            NSLog(@"Missed bad string");
            return -1;
        }
        
    }
    return 0;
}

