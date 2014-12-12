//
//  NSDictionary+Overlay.h
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 9/6/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Overlay)

+ (NSDictionary *)dictionaryWithObjectsAndLowercasedKeys:(NSString*) objectOrKey, ...;

@end
