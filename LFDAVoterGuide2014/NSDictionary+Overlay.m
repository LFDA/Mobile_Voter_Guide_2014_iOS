//
//  NSDictionary+Overlay.m
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 9/6/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//
//  Category for NSDictionary (a custom overlay)

#import "NSDictionary+Overlay.h"

@implementation NSDictionary (Overlay)

// Creates an NSDictionary from a Variadic method where the number of arguments is variable
// Expects the arguments in pairs, in the form [object, key]
// The arguments must be nil terminated
// This is meant to emulate the core method dictionaryWithObjectsAndKeys
+ (NSDictionary *)dictionaryWithObjectsAndLowercasedKeys:(NSObject*) objectOrKey, ... {
    NSMutableDictionary *result = [NSMutableDictionary new];
    NSString *key;
    NSObject *anObject;
    NSInteger lookForObjectOrKey=1; // 1=object, 2=key
    
    // Loop through the argument list and process each argument
    // In our case, we're interested in pairs, so we use the lookForObjectOrKey to hold state
    va_list args;
    va_start(args, objectOrKey);
    for (NSObject *arg = objectOrKey; arg != nil; arg = va_arg(args, NSObject*))
    {
        // If the current arg is nil, we're done, so break out
        if (!arg) break;
        // Decide what to do based on our current state
        if (lookForObjectOrKey==1) {
            // We're looking for an object
            anObject=arg;
            // Set the state so look for the key in the next arg
            lookForObjectOrKey=2;
        } else {
            // We're looking for a key and should have an object
            @try {
                key=[(NSString *)arg lowercaseString]; // We cast it to a string and make it lowercase
                // So add it, but ensure we have what we need
                if (anObject && key) [result setObject:anObject forKey:key];
            }
            @catch (NSException *exception) {
                // Just log it and ignore
                NSLog(@"dictionaryWithObjectsAndLowercasedKeys - Casting key to NSString failed. Error: %@",exception);
            }
            // And set that we're back to looking for a key (and clear the prior key)
            lookForObjectOrKey=1;
            key=nil;
            anObject=nil;
        }
    }
    va_end(args);
    
    return result;
}

@end
