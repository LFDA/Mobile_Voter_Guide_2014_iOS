//
//  Mail.h
//  NH Voter Guide
//
//  Created by Eric A. Soto on 9/15/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface MailHelper : NSObject

+(void)sendMailTo:(NSArray*)recipients withSubject:(NSString*)subject andBody:(NSString*) body fromView:(id) view;
+(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error fromView:(id) view;

@end
