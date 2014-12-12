//
//  City.h
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 8/24/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//
//  Represents a single City object

#import <Foundation/Foundation.h>

@interface City : NSObject {

}

@property (nonatomic) NSString *cityName;
@property (nonatomic) NSString *countyName;
@property (nonatomic) NSString *congressDistrictList;
@property (nonatomic) NSString *executiveDistrictList;
@property (nonatomic) NSString *senateDistrictList;
@property (nonatomic) NSString *houseDistrictList;
@property (nonatomic) NSString *cityType;

//- (id)initWithName:(NSString *)cityName;

@end
