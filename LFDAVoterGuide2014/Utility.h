//
//  Utility.h
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 9/5/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//
//  Some utility methods

#import <Foundation/Foundation.h>

@interface Utility : NSObject {
    
}

+(BOOL)isValidEmail:(NSString *)checkString;
+(BOOL)IsInternetConnected;
+(BOOL)isTimeToClearPhotoCache;
+(void)clearPhotoCache;
+(NSString *)capitalizeWords:(NSString *)str;

@end
