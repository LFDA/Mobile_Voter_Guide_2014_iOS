//
//  Preferences.h
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 8/25/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//
//  A class to deal with setting and reading preferences for the App

#import <Foundation/Foundation.h>

@interface Preferences : NSObject

+(BOOL)shouldRefreshData;
+(NSDate*)lastDataUpdate;
+(void)setLastDataUpdate:(NSDate*)withDate;
+(NSDate*)lastPhotoCacheClear;
+(void)setLastPhotoCacheClear:(NSDate*)withDate;
+(NSString*)remoteDataUrl;
+(void)setDefaults;

@end
