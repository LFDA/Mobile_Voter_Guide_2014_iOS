//
//  Office.h
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 8/28/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//
//  Represents a single Office object (the office the candidate is running for)

#import <Foundation/Foundation.h>

@interface Office : NSObject {
    
}

@property (nonatomic) NSString *officeName;
@property (nonatomic) NSString *districtColumnNameInCities;

@end
