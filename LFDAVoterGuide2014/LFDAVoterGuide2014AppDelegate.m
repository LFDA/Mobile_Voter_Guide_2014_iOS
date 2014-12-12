#import "LFDAVoterGuide2014AppDelegate.h"
#import "GlobalAppData.h"
#import "Preferences.h"
#import "DataHelper.h"
#import "UIutility.h"
#import "Utility.h"

@interface LFDAVoterGuide2014AppDelegate()

@end

@implementation LFDAVoterGuide2014AppDelegate

#pragma mark -
#pragma mark Application Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after app launch
    NSString *version = [GlobalAppData appVersion];
    
    // Initialize Google Analytics Tracking
#if DEBUG
    [GAI sharedInstance].trackUncaughtExceptions = YES;
//    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelError];
    [GAI sharedInstance].dispatchInterval = 20;
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-11088348-5"];
    [tracker set:kGAIAppVersion value:version];
#else
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelError];
    [GAI sharedInstance].dispatchInterval = 120;
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-11088348-6"];
    [tracker set:kGAIAppVersion value:version];
#endif
    
    // DONE -> Initialize Google Analytics Tracking
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        // This is the first launch ever
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // Set some defaults
        [Preferences setDefaults];
        // Ensure we have the db in AppData (by copying from the bundle if needed)
        // This should only be necessary on first app install (or re-install after delete)
        // But it is harmless otherwise as it first checks for an existing DB
        [DataHelper ensureDbInAppData];
        // If we're on "first app launch" we need to force reload the Global App Data so that officeList is picked up!
        [GlobalAppData load];
    }
    
    // Refresh the data if it's time and it's enabled in preferences
    // On first launch, this should happen also since preferences are set to defaults
    if([Preferences shouldRefreshData] && [DataHelper isTimeToUpdate]){
        [DataHelper updateDbFromRemote];
        // If we're just refreshing the db we need to force reload the Global App Data so that officeList is picked up!
        [GlobalAppData load];
    };
    
    if ([Utility isTimeToClearPhotoCache]){
        [Utility clearPhotoCache];
    }
    
    // Take care of customization of the Navigation Bar globally
    [UIutility styleNavbarGlobalAppearance];
    
    // Standard response for AppDelegate if all is well.
	return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


@end

