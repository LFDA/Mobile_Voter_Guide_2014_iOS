//
//  Utility.m
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 9/5/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//

#import "Utility.h"
#import "Reachability.h"
#import "Preferences.h"
#import "RemoteImageView.h"

@implementation Utility

// Uses a regex to validate an email address
+(BOOL)isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

// Returns TRUE if the internet is reachable. Depends on Reachability.h (an Apple sample library)
// Also requires the SystemConfiguration.framework
+(BOOL)IsInternetConnected{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return !(networkStatus == NotReachable);
}

// Returns true if the last clear of the photo cache was more than 1 day ago
// This effectively fetches new emails at least daily
+(BOOL)isTimeToClearPhotoCache{
    NSDate *lastClear = [Preferences lastPhotoCacheClear];
    // If no lastClear, we want an update, so it's time and we return true
    if (!lastClear) return TRUE;
    
    // Assert: We have a lastClear
    
    // Calculate time since lastClear
    NSDate *nowDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:lastClear toDate:nowDate options:0];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    NSInteger days = [components day];
#pragma clang diagnostic pop
    
#if DEBUG
    // We're in DEBUG, so force the clear!
    return true;
#else
    // Decide (>1, we want to clear and return true, otherwise, return false)
    return (days>=1);
#endif
}

// Clears the photo cache for the RemoteImageView class
+(void)clearPhotoCache{
    [RemoteImageView clearCache];
}

// Returns a string where each word is capitalized
+(NSString *)capitalizeWords:(NSString *)str{
    NSMutableString *result = [str mutableCopy];
    [result enumerateSubstringsInRange:NSMakeRange(0, [result length])
                               options:NSStringEnumerationByWords
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                [result replaceCharactersInRange:NSMakeRange(substringRange.location, 1)
                                                      withString:[[substring substringToIndex:1] uppercaseString]];
                            }];
    return result;
}
@end
