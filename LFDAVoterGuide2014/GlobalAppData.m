//
//  GlobalAppData.m
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 8/28/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//

#import "GlobalAppData.h"
#import "DataHelper.h"

static NSArray *_officeList = nil;
static NSDictionary *_stringList = nil;
static NSString *_appVersion = nil;

@implementation GlobalAppData {
    
}

// The load method will fire when the class is first used (loaded into memory)
// Therefore, we initialize the values we're interested in holding here, and
// the items will all load once.
+(void)load {

    // Load the list of Offices in the election
    _officeList = [DataHelper getOfficeList];

    // Add our strings to the _stringList (note, syntax is [value,key])
    // Note, this method is custom via the category NSDictionary+Ovverlay.h
    _stringList = [NSDictionary dictionaryWithObjectsAndLowercasedKeys:
                   @"NH Voter Guide 2014",@"AppTitle",
                   @"Information Not Available", @"InfoNotAvailable",
                   @"\n\n\n\nSent via the\nNH Voter Guide 2014 App\nAvailable in the Apple AppStore!", @"EmailCandidateBody",
                   @"Email copied to your pasteboard!", @"copyEmail",
                   @"Website copied to your pasteboard!", @"copyWebsite",
                   @"Office:",@"OfficeLabel",
                   @"Distr:",@"DistrictLabel",
                   @"Do you want to view the candidate's website in Safari?", @"ExitToWebsitePrompt",
                   @"Incumbent:",@"IncumbentLabel",
                   @"Do you want to call %@?",@"CallPhonePrompt",
                   @"Your device does not support making calls!",@"CallNotSupportedOnDevice",
                   @"Error Report for:\n%@\n\nPlease tell us what data needs to be corrected:\n\n",@"ReportErrorBody",
                   @"Data Error Report (NHVoterGuide2014)",@"ReportErrorSubject",
                   @"AppSupport@LiveFreeOrDieAlliance.org",@"ReportErrorRecipient",
                   @"Do you want to view the LFDA's candidate profile in Safari?", @"ExitToProfilePrompt",
                   @"Oops! We don't have a profile URL for this candidate!",@"LfdaProfileMissingMessage",
                   @"No Info",@"PositionNotAvailableMessage",
                   @"http://www.livefreeordiealliance.org/VoterResources/ElectionCandidates/tabid/2205/Default.aspx",@"LfdaVoterResourcesURL",
                   @"http://sos.nh.gov/WorkArea/DownloadAsset.aspx?id=12413",@"SosVotingRightsURL",
                   @"Tell us below how we may help or improve:\n\n\n\n\n\n\n\n\nPlease don't remove the following App Diagnostics:\n%@",@"FeedbackBody",
                   @"App Feedback, NHVoterGuide2014 (iOS)",@"FeedbackSubject",
                   @"AppSupport@LiveFreeOrDieAlliance.org",@"FeedbackRecipient",
                   @"(none running this cycle)",@"NoCandidatesForGroup",
                   @"The NH Voter Guide 2014 is a free public service of the Live Free or Die Alliance, a non-partisan 501(c)3 nonprofit servicing New Hampshire citizens. Learn more at http://LFDA.ORG.",@"AboutApp",
                   @"http://www.livefreeordiealliance.org/ElectionCentral/Candidates_Position/tabid/3319/Default.aspx",@"LfdaMoreOnPositions",
                   @"http://www.livefreeordiealliance.org/About/AppSupportIos.aspx",@"AppHelpPageUrl",
                   nil];
}

// Returns the current AppVersion
+(NSString*)appVersion{
    if (!_appVersion) {
        NSString *appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        NSString *appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        _appVersion = [NSString stringWithFormat:@"%@ (%@)", appVersionString, appBuildString];
    }
    return _appVersion;
}

+(NSString*)appVersionString{
    return [NSString stringWithFormat:@"%@ v%@ for iOS",[self appStrings:@"AppTitle"], self.appVersion];
}

// A method to retrieve the officeList
+(NSArray*)officeList{
    return _officeList;
}

// A method to return application strings held in the _stringList dictionary
+(NSString*)appStrings:(NSString *)stringKey{
    NSString *retVal = _stringList[stringKey.lowercaseString];
    return !retVal ? @"": retVal;
}

// Decide which image matches an issue position!
+(UIImage*)getIssueImage:(NSString*)position {
    if (!position) return [UIImage imageNamed:@"issue_noresponse"];
    if ([[position lowercaseString] isEqualToString:@"for"]) return [UIImage imageNamed:@"issue_thumbup"];
    if ([[position lowercaseString] isEqualToString:@"against"]) return [UIImage imageNamed:@"issue_thumbsdown"];
    if ([[position lowercaseString] isEqualToString:@"other"]) return [UIImage imageNamed:@"issue_undecided"];
    if ([[position lowercaseString] isEqualToString:@"undecided"]) return [UIImage imageNamed:@"issue_undecided"];
    return [UIImage imageNamed:@"issue_noresponse"];
}

@end
