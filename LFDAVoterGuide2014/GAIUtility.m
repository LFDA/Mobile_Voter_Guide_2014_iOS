//
//  GAIUtility.m
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 9/7/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//

#import "GAIUtility.h"
#import "GAIDictionaryBuilder.h"

@implementation GAIUtility

+(void)logButtonPress:(NSString *)buttonName forScreen:(NSString *)screenName{
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UX"
                                                          action:@"touch"
                                                           label:buttonName
                                                           value:nil] build]];
    [tracker set:kGAIScreenName value:nil];
}

@end
