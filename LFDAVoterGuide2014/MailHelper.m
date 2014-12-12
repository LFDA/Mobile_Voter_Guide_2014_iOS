//
//  Mail.m
//  NH Voter Guide
//
//  Created by Eric A. Soto on 9/15/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//

#import "MailHelper.h"
#import <MessageUI/MessageUI.h>

@implementation MailHelper {
    
}

//// Initializes the static class Mail
//+(void)load {
//    // To resolve an issue where the simluator fails to send mail
//    // see https://stackoverflow.com/questions/15159412/issue-when-using-mfmailcomposeviewcontroller
//    // and https://stackoverflow.com/questions/25604552/i-have-real-misunderstanding-with-mfmailcomposeviewcontroller-in-swift-ios8-in
//    mc = [MFMailComposeViewController new];
//}

+(void)sendMailTo:(NSArray*)recipients withSubject:(NSString*)subject andBody:(NSString*) body fromView:(id) view{
    if ([MFMailComposeViewController canSendMail]){
        
        // Before we create the composer controller, we need to customize the NavBar
        [UIutility styleNavbarComposerAppearance];
        
        MFMailComposeViewController *mc;
        mc = [MFMailComposeViewController new];
        mc.mailComposeDelegate = view;
        
        if (body) [mc setMessageBody:body isHTML:NO];
        if (subject) [mc setSubject:subject];
        [mc setToRecipients:recipients];
        
        // Present mail view controller on screen
        [view presentModalViewController:mc animated:YES];
    }
}

#pragma mark -
#pragma mark Handler for MFMailComposeViewController Delegates passed over

+(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error fromView:(id)view
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [view dismissViewControllerAnimated:YES completion:NULL];
    
    // Set the NavBar back to whatever we use globally
    [UIutility styleNavbarGlobalAppearance];
}

@end
