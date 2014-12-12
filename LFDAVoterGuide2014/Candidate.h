//
//  Candidate.h
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 8/28/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//
//  Represents a single Candidate object

#import <Foundation/Foundation.h>

@interface Candidate : NSObject {
    
}

@property (nonatomic) NSString *lastName;
@property (nonatomic) NSString *firstName;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *website;
@property (nonatomic) NSString *phone;
@property (nonatomic) NSString *party;
@property (nonatomic) NSString *office;
@property (nonatomic) NSString *district;
@property (nonatomic) NSString *county;
@property (nonatomic) NSString *floterialDistrictList;
@property (nonatomic) BOOL incumbent;
@property (nonatomic) BOOL floterial;
@property (nonatomic) NSString *lfdaProfileUrl;
@property (nonatomic) NSString *lfdaPhotoUrl;
@property (nonatomic) NSString *experience;
@property (nonatomic) NSString *education;
@property (nonatomic) NSString *family;

@end
