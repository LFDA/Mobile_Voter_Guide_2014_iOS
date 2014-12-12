//
//  Preferences.m
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 8/25/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//

#import "Preferences.h"

@implementation Preferences

// All our preferences read from UserDefaults as configured in the /Resources/Settings.bundle

// Reads preference for shouldRefreshData
+(BOOL)shouldRefreshData
{
    // Does preference exist...
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"shouldRefreshData"] != 0)
        return true;
    else
        return false;
}
// Represents the last date that the local data was successfully updated
+(NSDate*)lastDataUpdate{
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastDataUpdate"];
    return date;
}
// Sets the last date that the local data was successfully updated
+(void)setLastDataUpdate:(NSDate*)withDate {
    [[NSUserDefaults standardUserDefaults] setObject:withDate forKey:@"lastDataUpdate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// Represents the last date that the local photo cache was cleared
+(NSDate*)lastPhotoCacheClear{
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastPhotoCacheClear"];
    return date;
}
// Sets the last date that the local photo cache was cleared
+(void)setLastPhotoCacheClear:(NSDate*)withDate {
    [[NSUserDefaults standardUserDefaults] setObject:withDate forKey:@"lastPhotoCacheClear"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
// Gets the configured remoteDataUrl which will be used to load remote data when needed
+(NSString*)remoteDataUrl{
    NSString *remoteDataUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"remoteDataUrl"];
    return remoteDataUrl;
}
// Sets default user preferences, normally called on first app launch
+(void)setDefaults{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"shouldRefreshData"];
    [[NSUserDefaults standardUserDefaults] setObject:@"http://fs.livefreeordiealliance.com/Data2014.sqlite" forKey:@"remoteDataUrl"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
