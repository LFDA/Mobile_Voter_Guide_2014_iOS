//
//  GlobalAppData.h
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 8/28/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//
//  A library used to return global data (strings, lists, etc) from a single source
//  Note, this class is static and does not require an instance. However, because +load
//  is implemented, we do get to hydrate the static class with values of interest!

#import <Foundation/Foundation.h>
#import "Office.h"

@interface GlobalAppData : NSObject {
    
}

+(void)load;
+(NSString *)appVersion;
+(NSString *)appVersionString;
+(NSArray *)officeList;
+(NSString *)appStrings:(NSString *)stringKey;
+(UIImage *)getIssueImage:(NSString *)position;

@end
