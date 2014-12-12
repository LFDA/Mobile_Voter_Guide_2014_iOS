//
//  DataHelper.m
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 8/23/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//

#import <FMDatabase.h>
#import <STHTTPRequest.h>
#import <FileMD5Hash/FileHash.h>
#import "DataHelper.h"
#import "City.h"
#import "Office.h"
#import "Candidate.h"
#import "Preferences.h"
#import "GlobalAppData.h"
#import "Utility.h"
#import "Position.h"

static NSString *_DbMd5 = nil;

@implementation DataHelper

#pragma mark Constants
// Some constatns
NSString static *const dbFileName = @"Data.sqlite";
NSString static *const letters = @"abcdefghijklmnopqrstuvwxyz";

#pragma mark Static properties
// Static class properties
static NSString* _appDataDir = nil;

#pragma mark -
#pragma mark Prepare content for UITableView
// Loads the data for a City List in an object usable for a TableView (with groups of cities by first letter)
+ (NSArray *) loadCityTableViewObject {
    NSMutableArray *content = [NSMutableArray new];
    
    // Pull up the list of cities
    NSArray *cityList = [DataHelper getCityList];
    if (cityList==nil){
        return nil;
    }
    // Setup an object to hold the filtered lists (we separate by letter of the alphabet)
    NSArray *cityNameListFilteredForLetter;
    
    // Loop through the letters string, one character at a time (the letters of the alphabet)
    for (int i = 0; i < [letters length]; i++ ) {
        NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
        // Use a predicate to identify entries in the target NSArray that match
        // The ^BOOL predicate basically checks for city name starting with the letter of the alphabet we're currently working on!
        // Note, we're now using an NSArray of the City custom class, which holds all info about each city
        NSIndexSet *matching = [cityList indexesOfObjectsPassingTest:^BOOL(City *aCity, NSUInteger idx, BOOL *stop) {
            return ([[aCity.cityName lowercaseString] characterAtIndex:0]==[letters characterAtIndex:i]);
        }];
        // Now filter for the matches
        cityNameListFilteredForLetter = [cityList objectsAtIndexes:matching];

        // Setup the row correctly for the return (this is for 1 letter and all it's cities)
        char currentLetter[2] = { toupper([letters characterAtIndex:i]), '\0'};
        [row setValue:[NSString stringWithCString:currentLetter encoding:NSASCIIStringEncoding]
               forKey:@"headerTitle"];
        [row setValue:cityNameListFilteredForLetter forKey:@"rowValues"];
        // Add it to the return
        [content addObject:row];
    }
    // return
    return content;
}

// Loads the data for a Candidate List (for a City) in an object usable for a TableView (with groups of Offices the candidates are running in)
+ (NSArray *) loadCityCandidatesTableViewForCity:(City *)city {
    NSMutableArray *content = [NSMutableArray new];
    
    // Pull up the list of cityCandidates
    NSArray *cityCandidateList = [self getCandidateListForCity:city];
    if (cityCandidateList==nil){
        return nil;
    }
    // Setup an object to hold the filtered lists (we separate by Office)
    NSArray *cityCandidateListFilteredForOffice;
    
    // Loop through the officeList NSArray, one office at a time
    for (int i = 0; i < [[GlobalAppData officeList] count]; i++ ) {
        NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
        NSString *officeName = [[[GlobalAppData officeList] objectAtIndex:i] officeName];
        // Use a predicate to identify entries in the target NSArray that match
        // The ^BOOL predicate basically checks for office we're currently working on!
        // Note, we're now using an NSArray of the Office custom class, which holds all info about each office
        NSIndexSet *matching = [cityCandidateList indexesOfObjectsPassingTest:^BOOL(Candidate *aCandidate, NSUInteger idx, BOOL *stop) {
            return ([[aCandidate.office lowercaseString] isEqualToString: [officeName lowercaseString]]);
        }];
        // Now filter for the matches
        cityCandidateListFilteredForOffice = [cityCandidateList objectsAtIndexes:matching];
        
        // Setup the row correctly for the return (this is for 1 office and all it's candidates)
        [row setValue:officeName forKey:@"headerTitle"];
        if (cityCandidateListFilteredForOffice.count==0) {
            NSArray *noCandidatesArray;
            Candidate *noCandidate = [Candidate new];
            noCandidate.lastName = @"<None This Cycle>";
            noCandidatesArray = [NSArray arrayWithObject:noCandidate];
            [row setValue:noCandidatesArray forKey:@"rowValues"];
        } else {
            [row setValue:cityCandidateListFilteredForOffice forKey:@"rowValues"];
        }
        
        // Add it to the return
        [content addObject:row];
    }
    // return
    return content;
}

// Loads the data for a Candidate List (for a City) in an object usable for a TableView (with groups of Offices the candidates are running in)
+ (NSArray *) loadCandidatesTableView {
    NSMutableArray *content = [NSMutableArray new];
    
    // Pull up the list of cityCandidates
    NSArray *candidateList = [self getCandidateList];
    if (candidateList==nil){
        return nil;
    }
    
    NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
    // Setup the row correctly for the return (all candidates in a single group)
    [row setValue:@"All Candidates" forKey:@"headerTitle"];
    [row setValue:candidateList forKey:@"rowValues"];
    // Add it to the return
    [content addObject:row];
    // return
    return content;
}

// Loads the data for a Position List (for a Candidate) in an object usable for a TableView (with only 1 group of positions)
+ (NSArray *) loadPositionsTableViewForCandidate:(Candidate *)candidate {
    NSMutableArray *content = [NSMutableArray new];
    
    // Pull up the list of cityCandidates
    NSArray *positionList = [self getPositionListForCandidate:candidate];
    if (positionList==nil){
        return nil;
    }
    
    NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
    // Setup the row correctly for the return (this is for 1 office and all it's candidates)
    [row setValue:@"Issues & Positions" forKey:@"headerTitle"];
    [row setValue:positionList forKey:@"rowValues"];
    // Add it to the return
    [content addObject:row];
    // return
    return content;
}

#pragma mark -
#pragma mark Retrieve Sqlite data
// Gets a CityName Array of NSString from Data.sqlite
+ (NSArray *) getCityNameList {
    NSMutableArray *cityList = [NSMutableArray new];
 
    NSString *dbPath = [DataHelper getDbPath];
    if (dbPath==nil) {
        return nil;
    }

    FMDatabase *db2 = [FMDatabase databaseWithPath:dbPath];
    
    // Attempt to open it
    if(![db2 open])
    {
        NSLog(@"An error has occured: %@",[db2 lastErrorMessage]);
        return nil;
    }
    
    // ASSERT: DB is good and opened!
    
    @try {
        
        // Prepare our query sql
        NSString *sql = @"SELECT CityName FROM Cities ORDER BY CityName";
        FMResultSet *rs = [db2 executeQuery:sql];
        
        // Prepare it and read/lopp
        while ([rs next]) {
            // Just add to an array of strings
            [cityList addObject:[rs stringForColumn:@"CityName"]];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"getCityNameList threw an error:  %@", [db2 lastErrorMessage]);
    }
    @finally {
        [db2 close];
        // Return the data we might have retrieved
        return cityList;
    }
    
}

// Gets an NSArray of Cities (a custom class) from Data.sqlite
+ (NSArray *) getCityList{
    NSMutableArray *cityList = [NSMutableArray new];
    
    NSString *dbPath = [DataHelper getDbPath];
    if (dbPath==nil) {
        return nil;
    }
    
    FMDatabase *db2 = [FMDatabase databaseWithPath:dbPath];
    
    // Attempt to open it
    if(![db2 open])
    {
        NSLog(@"An error has occured: %@",[db2 lastErrorMessage]);
        return nil;
    }
    
    // ASSERT: DB is good and opened!
    
    @try {
        
        // Prepare our query sql
        NSString *sql = @"select CityName, CongressDistrictList, ExecutiveDistrictList, SenateDistrictList, HouseDistrictList, CountyName, CityType from Cities order by CityName";
        FMResultSet *rs = [db2 executeQuery:sql];
        
        // Prepare it and read/lopp
        while ([rs next]) {
            City *thisCity = [City new];
            thisCity.cityName = [rs stringForColumn:@"CityName"];
            thisCity.congressDistrictList = [rs stringForColumn:@"CongressDistrictList"];
            thisCity.executiveDistrictList = [rs stringForColumn:@"ExecutiveDistrictList"];
            thisCity.senateDistrictList = [rs stringForColumn:@"SenateDistrictList"];
            thisCity.houseDistrictList = [rs stringForColumn:@"HouseDistrictList"];
            thisCity.countyName = [rs stringForColumn:@"CountyName"];
            thisCity.cityType = [rs stringForColumn:@"CityType"];
            // Just add to an array
            [cityList addObject: thisCity];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"getCityList threw an error:  %@", [db2 lastErrorMessage]);
    }
    @finally {
        [db2 close];
        // Return the data we might have retrieved
        return cityList;
    }
    
}

// Gets an NSArray of Offices (a custom class) from Data.sqlite
+ (NSArray *) getOfficeList{
    NSMutableArray *officeList = [NSMutableArray new];
    
    NSString *dbPath = [DataHelper getDbPath];
    if (dbPath==nil) {
        return nil;
    }
    
    FMDatabase *db2 = [FMDatabase databaseWithPath:dbPath];
    
    // Attempt to open it
    if(![db2 open])
    {
        NSLog(@"An error has occured: %@",[db2 lastErrorMessage]);
        return nil;
    }
    
    // ASSERT: DB is good and opened!
    
    @try {
        
        // Prepare our query sql
        NSString *sql = @"select OfficeName, DistrictColumnNameInCities from Offices order by SortOrder";
        FMResultSet *rs = [db2 executeQuery:sql];
        
        // Prepare it and read/lopp
        while ([rs next]) {
            Office *thisOffice = [Office new];
            thisOffice.officeName = [rs stringForColumn:@"OfficeName"];
            thisOffice.districtColumnNameInCities = [rs stringForColumn:@"DistrictColumnNameInCities"];
            // Just add to an array
            [officeList addObject: thisOffice];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"getOfficeList threw an error:  %@", [db2 lastErrorMessage]);
    }
    @finally {
        [db2 close];
        // Return the data we might have retrieved
        return officeList;
    }
    
}

// Gets an NSArray of Candidates (a custom class) for a City from Data.sqlite
+ (NSArray *) getCandidateListForCity:(City *)city {
    NSMutableArray *candidateList = [NSMutableArray new];

    NSString *dbPath = [DataHelper getDbPath];
    if (dbPath==nil) {
        return nil;
    }
    
    FMDatabase *db2 = [FMDatabase databaseWithPath:dbPath];
    
    // Attempt to open it
    if(![db2 open])
    {
        NSLog(@"An error has occured: %@",[db2 lastErrorMessage]);
        return nil;
    }
    
    // ASSERT: DB is good and opened!
    
    @try {
        
        // Prepare our query sql
        // For performance, we only load the few fields needed for the UITableView that shows candidates for a city
        // Note, key is LastName + FirstName
        
        NSString *sql = @"select LastName, FirstName, Party, Office, Incumbent, District FROM Candidates WHERE Office='Governor' OR ( Office='Executive Councilor' and District in (%@) ) OR ( Office='State Representative' and District in (%@) and County='%@' ) OR ( Office='State Senator' and District in (%@) ) OR ( Office='U.S. Representative' and District in (%@) ) OR ( Office='U.S. Senate' ) ORDER BY Office, District, LastName, FirstName";
        
        // Replace parameters
        // Extract the first house district from the City record (this is the main district, the other(s) are floterial)
        NSArray *houseDistrictArray = [city.houseDistrictList componentsSeparatedByString:@","];
        NSString *mainHouseDistrictForCity = houseDistrictArray[0];

        // Search for candidates. Note, for HOUSE, we're searching for candidates in the ALL districts (first one is MAIN, second is floterial.)
        sql = [NSString stringWithFormat:sql,city.executiveDistrictList,city.houseDistrictList,city.countyName,city.senateDistrictList,city.congressDistrictList];
        
        FMResultSet *rs = [db2 executeQuery:sql];
        
        // Prepare it and read/lopp
        while ([rs next]) {
            Candidate *thisCandidate = [Candidate new];
            thisCandidate.lastName = [rs stringForColumn:@"LastName"];
            thisCandidate.firstName = [rs stringForColumn:@"FirstName"];
            thisCandidate.office = [rs stringForColumn:@"Office"];
            // If the candidate is running for State Houst, we need to see if they're floterial (the candidates MAIN district does not match the MAIN for the city)
            if([[rs stringForColumn:@"Office"] isEqualToString:@"State Representative"] &&
               (![[rs stringForColumn:@"District"] isEqualToString:mainHouseDistrictForCity])
               )
            {
                thisCandidate.floterial = YES;
            } else {
                thisCandidate.floterial = NO;
            }
            thisCandidate.party = [rs stringForColumn:@"Party"];
            thisCandidate.incumbent = [[rs stringForColumn:@"Incumbent"] isEqualToString:@"1"];
            // Just add to an array
            [candidateList addObject: thisCandidate];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"getCandidateListForCity threw an error:  %@", [db2 lastErrorMessage]);
    }
    @finally {
        [db2 close];
        // Return the data we might have retrieved
        return candidateList;
    }
}

// Gets an NSArray of Candidates (a custom class) for a City from Data.sqlite
+ (NSArray *) getCandidateList {
    NSMutableArray *candidateList = [NSMutableArray new];
    
    NSString *dbPath = [DataHelper getDbPath];
    if (dbPath==nil) {
        return nil;
    }
    
    FMDatabase *db2 = [FMDatabase databaseWithPath:dbPath];
    
    // Attempt to open it
    if(![db2 open])
    {
        NSLog(@"An error has occured: %@",[db2 lastErrorMessage]);
        return nil;
    }
    
    // ASSERT: DB is good and opened!
    
    @try {
        
        // Prepare our query sql
        // For performance, we only load the few fields needed for the UITableView that shows candidates for a city
        // Note, key is LastName + FirstName
        
        NSString *sql = @"select LastName, FirstName, Party, Office FROM Candidates ORDER BY LastName, FirstName";
        
        // Replace parameters
        //sql = [NSString stringWithFormat:sql,city.executiveDistrictList,city.houseDistrictList,city.senateDistrictList,city.congressDistrictList,city.congressDistrictList];
        
        FMResultSet *rs = [db2 executeQuery:sql];
        
        // Prepare it and read/lopp
        while ([rs next]) {
            Candidate *thisCandidate = [Candidate new];
            thisCandidate.lastName = [rs stringForColumn:@"LastName"];
            thisCandidate.firstName = [rs stringForColumn:@"FirstName"];
            thisCandidate.office = [rs stringForColumn:@"Office"];
            thisCandidate.party = [rs stringForColumn:@"Party"];
            // Just add to an array
            [candidateList addObject: thisCandidate];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"getCandidateList threw an error:  %@", [db2 lastErrorMessage]);
    }
    @finally {
        [db2 close];
        // Return the data we might have retrieved
        return candidateList;
    }
}

// Gets an NSArray of Positions (a custom class) for a Candidate from Data.sqlite
+ (NSArray *) getPositionListForCandidate:(Candidate *)candidate {
    NSMutableArray *positionList = [NSMutableArray new];
    
    NSString *dbPath = [DataHelper getDbPath];
    if (dbPath==nil) {
        return nil;
    }
    
    FMDatabase *db2 = [FMDatabase databaseWithPath:dbPath];
    
    // Attempt to open it
    if(![db2 open])
    {
        NSLog(@"An error has occured: %@",[db2 lastErrorMessage]);
        return nil;
    }
    
    // ASSERT: DB is good and opened!
    
    @try {
        
        // Prepare our query sql
        // Note, key is LastName + FirstName
        
        NSString *sql = @"SELECT Issue, Position FROM Positions WHERE LastName='%@' AND FirstName='%@' ORDER BY Issue";
        
        // Replace parameters, note the replacement of single char (', possible in names like "O'Brien") with ('') two single chars so that we don't confuse Sqlite.
        sql = [NSString stringWithFormat:sql, [candidate.lastName stringByReplacingOccurrencesOfString:@"'" withString:@"''"], [candidate.firstName stringByReplacingOccurrencesOfString:@"'" withString:@"''"]];
        
        FMResultSet *rs = [db2 executeQuery:sql];
        
        // Prepare it and read/lopp
        while ([rs next]) {
            Position *thisPosition = [Position new];
            thisPosition.issue = [rs stringForColumn:@"Issue"];
            thisPosition.position = [rs stringForColumn:@"Position"];
            // Note, issue position might be empty in the data, so we do some cleanup
            if (!thisPosition.position.length) {
                // Empty, so we use a default string!
                thisPosition.position = [GlobalAppData appStrings:@"PositionNotAvailableMessage"];
            } else {
                // Not empty, so we make sure it's in Uppercase each first letter format
                thisPosition.position = [Utility capitalizeWords:thisPosition.position.lowercaseString];
            }
            // Just add to an array
            [positionList addObject: thisPosition];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"getPositionListForCandidate threw an error:  %@", [db2 lastErrorMessage]);
    }
    @finally {
        [db2 close];
        // Return the data we might have retrieved
        return positionList;
    }
}

#pragma mark -
#pragma mark Expansion methods

// Given a Candidate object, expands the properties from Data.sqlite
// Note, this is intended to receive a partially loaded Candidate object
// (like the partially loaded Candidate that the Candidate Table View would hold)
// and it then returns a FULLY loaded Candidate object (for use in a detail view)
+ (Candidate *) expandCandidate:(Candidate *)candidate {
    
    NSString *dbPath = [DataHelper getDbPath];
    if (dbPath==nil) {
        return nil;
    }
    
    FMDatabase *db2 = [FMDatabase databaseWithPath:dbPath];
    
    // Attempt to open it
    if(![db2 open])
    {
        NSLog(@"An error has occured: %@",[db2 lastErrorMessage]);
        return nil;
    }
    
    // ASSERT: DB is good and opened!
    
    @try {
        
        // Prepare our query sql
        // For performance, we only load the few fields needed for the UITableView that shows candidates for a city
        // Note, key is LastName + FirstName
        
        NSString *sql = @"select Email, Website, Phone, District, County, FloterialDistrictList, Incumbent, LFDAProfileURL, LFDAPhotoUrl, Experience, Education, Family FROM Candidates WHERE LastName='%@' and FirstName='%@'";
        
        // Replace parameters
        sql = [NSString stringWithFormat:sql, [candidate.lastName stringByReplacingOccurrencesOfString:@"'" withString:@"''"], [candidate.firstName stringByReplacingOccurrencesOfString:@"'" withString:@"''"]];
        
        FMResultSet *rs = [db2 executeQuery:sql];
        
        // Prepare it and read/lopp
        while ([rs next]) {
            candidate.email = [rs stringForColumn:@"Email"];
            candidate.website = [rs stringForColumn:@"Website"];
            candidate.Phone = [rs stringForColumn:@"Phone"];
            candidate.District = [rs stringForColumn:@"District"];
            candidate.FloterialDistrictList = [rs stringForColumn:@"FloterialDistrictList"];
            candidate.Incumbent = [[rs stringForColumn:@"Incumbent"] isEqualToString:@"1"];
            candidate.lfdaProfileUrl = [rs stringForColumn:@"lfdaProfileUrl"];
            candidate.lfdaPhotoUrl = [rs stringForColumn:@"lfdaPhotoUrl"];
            candidate.Experience = [rs stringForColumn:@"Experience"];
            candidate.Education = [rs stringForColumn:@"Education"];
            candidate.Family = [rs stringForColumn:@"Family"];
            candidate.county = [rs stringForColumn:@"County"];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"expandCandidate threw an error:  %@", [db2 lastErrorMessage]);
    }
    @finally {
        [db2 close];
        // Return the data we might have retrieved
        return candidate;
    }
}

#pragma mark -
#pragma mark Other implementation methods

// Calculates an MD5 hash signature on the Sqlite db file (to serve as an identity for the file)
// This depends on the pod <FileMD5Hash/FileHash.h>
// For syntax and docs, see https://github.com/JoeKun/FileMD5Hash
+ (NSString *) getDbMd5{
    if (!_DbMd5){
        NSString *executablePath = self.getDbPath;
        NSString *executableFileMD5Hash = [FileHash md5HashOfFileAtPath:executablePath];
        _DbMd5 = executableFileMD5Hash ? executableFileMD5Hash : @"Error";
    }
    return _DbMd5;
}

// Updates the local data from a remote URL (if we have Internet Reachability)
// Note, for the fileMgr operations, the error codes are documented in
// https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Miscellaneous/Foundation_Constants/Reference/reference.html#//apple_ref/doc/c_ref/NSFileNoSuchFileError

+ (void) updateDbFromRemote{
    
    // Check that we have internet connectivity. If we don't we exit since there's no work to do
    if (![Utility IsInternetConnected]) return;
    
    NSError *error = nil;
    STHTTPRequest *req = [STHTTPRequest requestWithURLString:[Preferences remoteDataUrl]];
    
    // Fire off a SYNCHRONOUS request (this returns body which in this case, we don't need)
    NSString *body = [req startSynchronousWithError:&error];
    // If we have a good status, we process what we received
    if (req.responseStatus==200){
        @try {
            NSError *error;
            NSFileManager *fileMgr = [NSFileManager defaultManager];
            NSString *dbPathNew = [self.applicationDataDirectory  stringByAppendingPathComponent:[dbFileName stringByAppendingString:@".new"]];
            NSString *dbPath = [self.applicationDataDirectory stringByAppendingPathComponent:dbFileName];
            NSString *dbPathOld = [self.applicationDataDirectory stringByAppendingPathComponent:[dbFileName stringByAppendingString:@".old"]];
            
            // Remove any NEW file if present (would be a leftover from a prior failed attempt)
            if (![fileMgr removeItemAtPath:dbPathNew error:&error]){
                // Error code = 4 is "NSFileNoSuchFileError" which we can ignore since we actually should NOT have any NEW files sitting around
                if(error.code!=4) {
                    NSLog(@"Error deleting prior new file: %@", error.localizedDescription);
                    return;
                }
            }
            
            // Assert, any NEW download was deleted or was not present
            
            // Save the data to a NEW local file
            [req.responseData writeToFile:dbPathNew atomically:YES];
            
            // Verify the NEW file is out there
            if(![fileMgr fileExistsAtPath:dbPathNew])
            {
                NSLog(@"Cannot locate new file '%@'.", dbPathNew);
                return;
            }
            
            // Assert, NEW file is out there

            // Exclude the new DB file from backup
            [self addSkipBackupAttributeToItemAtPath:dbPathNew];
            
            // Remove any OLD file if present
            if (![fileMgr removeItemAtPath:dbPathOld error:&error]){
                // Error code = 4 is "NSFileNoSuchFileError" which we can ignore since we actually should NOT have any OLD files sitting around
                if(error.code!=4) {
                    NSLog(@"Error deleting prior old file: %@", error.localizedDescription);
                    return;
                }
            }
            
            // Assert, any previous OLD file is gone (or was not present)
            
            // Rename current file to OLD
            if (![fileMgr moveItemAtPath:dbPath toPath:dbPathOld error:&error]){
                NSLog(@"Error renaming current file: %@", error.localizedDescription);
                return;
            }
            
            // Exclude the old DB file from backup (in case this was missed before)
            [self addSkipBackupAttributeToItemAtPath:dbPathOld];
            
            // Rename NEW file to current
            if (![fileMgr moveItemAtPath:dbPathNew toPath:dbPath error:&error]){
                NSLog(@"Error renaming new file: %@", error.localizedDescription);
                // Since it failed, bring back the OLD file
                // TODO: This could use another round of error checking in case OLD fails also
                [fileMgr moveItemAtPath:dbPathOld toPath:dbPath error:&error];
                return;
            }
            
            // Exclude the new DB file 9renamed) from backup (in case this was missed before)
            [self addSkipBackupAttributeToItemAtPath:dbPath];
            
            [Preferences setLastDataUpdate:[NSDate date]];
        }
        @catch (NSException *exception) {
            NSLog(@"updateDbFromRemote threw an error:  %@", exception.reason);
        }
    }
    
}

// Convenience method to "extract" the DB from the app bundle if it's not in the Sandboxed App Data Directory
+ (void)ensureDbInAppData{
    NSString *dbPath = [self getDbPath];
    if (dbPath==nil) {
        // It's not in App Data, so we copy from the bundle, where we know it is present, since we package it in!
        NSError *error;
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dbPathInBundle = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:dbFileName];
        NSString *dbPath = [self.applicationDataDirectory stringByAppendingPathComponent:dbFileName];
        if (![fileMgr copyItemAtPath:dbPathInBundle toPath:dbPath error:&error]){
            NSLog(@"Error copying db from bundle to App Data: %@", error.localizedDescription);
            return;
        }
        // Exclude the DB file from backup
        [self addSkipBackupAttributeToItemAtPath:dbPath];
    }
}

// Get the path of where we expect the DB (and validate it's really there)
+ (NSString *)getDbPath{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    // NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"Data.sqlite"];
    NSString *dbPath = [self.applicationDataDirectory stringByAppendingPathComponent:dbFileName];
    // Check for the DB path
    if(![fileMgr fileExistsAtPath:dbPath])
    {
        NSLog(@"Cannot locate database file '%@'.", dbPath);
        return nil;
    }

    // return it (if it exists)
    return dbPath;
}

// Convenience method to pull the NSString path of the Sandboxed App Data Directory
+ (NSString*)applicationDataDirectory {
    // If we've already figured this out, we just return it. Otherwise, we figure it out and store it in a class static variable
    if (!_appDataDir) {
    
        NSFileManager* sharedFM = [NSFileManager defaultManager];
        NSArray* possibleURLs = [sharedFM URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
        NSURL* appSupportDir = nil;
        NSURL* appDirectory = nil;
        if ([possibleURLs count] >= 1) {
            // Use the first directory (if multiple are returned)
            appSupportDir = [possibleURLs objectAtIndex:0];
        }
        // If a valid app support directory exists, add the
        // app's bundle ID to it to specify the final directory.
        if (appSupportDir) {
            NSString* appBundleID = [[NSBundle mainBundle] bundleIdentifier];
            appDirectory = [appSupportDir URLByAppendingPathComponent:appBundleID];
        }
        
        // Ensure it exists
        BOOL isDir;
        if (![sharedFM fileExistsAtPath:[appDirectory path] isDirectory:&isDir]) {
            NSError *error;
            if (![sharedFM createDirectoryAtPath:[appDirectory path] withIntermediateDirectories:YES attributes:nil error:&error]){
                NSLog(@"Cannot create directory '%@'", [appDirectory path]);
            };
        }
    
#if DEBUG
        NSLog(@"applicationDataDirectory: '%@'", [appDirectory path]);
#endif
        
        // Save it to the static variable so we don't have to calculate this again
        _appDataDir = [appDirectory path];
        
    }
    
    // We return an NSString path!
    return _appDataDir;
}

// Returns true if the last update if the sqlite db was more than 1 day ago
+ (BOOL)isTimeToUpdate
{
    NSDate *lastUpdate = [Preferences lastDataUpdate];
    // If no lastUpdate, we want an update, so it's time and we return true
    if (!lastUpdate) return true;
    
    // Assert: We have a lastUpdate
    
    // Calculate time since lastUpdate
    NSDate *nowDate = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:lastUpdate toDate:nowDate options:0];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    NSInteger days = [components day];
#pragma clang diagnostic pop

    
#if DEBUG
    // We're in DEBUG, so force the udpate!
    return true;
#else
    // Decide (>1, we want an update and return true, otherwise, return false)
    return (days>=1);
#endif
}

// Exclude a file at a certian path from iCloud backup
+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString*)path
{
    return [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path]];
}

// Exclude a file at a certian NSURL from iCloud backup
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL*)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    
#if DEBUG
    [self verifyResourceValueIsExcludedFromBackup:URL];
#endif
    
    return success;
}

// Verify resource value NSURLIsExcludedFromBackupKey
+ (void)verifyResourceValueIsExcludedFromBackup:(NSURL*)URL{
    NSNumber *resourceValue;
    NSError *error = nil;
    [URL getResourceValue:&resourceValue forKey:NSURLIsExcludedFromBackupKey error:&error];
    NSLog(@"URL '%@' has NSURLIsExcludedFromBackupKey resourceValue=%@",[URL path],resourceValue);
}


@end
