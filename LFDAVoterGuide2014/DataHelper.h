//
//  DataHelper.h
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 8/23/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//
//  A class that handles all our data operations

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "City.h"
#import "Candidate.h"

@interface DataHelper : NSObject {
 
}

+(NSArray *)loadCityTableViewObject;
+(NSArray *)loadCityCandidatesTableViewForCity:(City *)city;
+(NSArray *)loadCandidatesTableView;
+(NSArray *)loadPositionsTableViewForCandidate:(Candidate *)candidate;
+(NSArray *)getOfficeList;
+(Candidate *)expandCandidate:(Candidate *)candidate;
+(NSString *)getDbMd5;
+(void)updateDbFromRemote;
+(void)ensureDbInAppData;
+(BOOL)isTimeToUpdate;

@end
