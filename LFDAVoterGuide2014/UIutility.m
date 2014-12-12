//
//  UIutility.m
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 9/5/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//
//  A class that vies us some utility methods to tweak the UI

#import "UIutility.h"

@implementation UIutility

+(void)styleNavbarComposerAppearance
{
    // Take care of customization of the Navigation Bar (in composer, we clear any Background image!)
    [[UINavigationBar appearance] setBackgroundImage:Nil forBarMetrics:UIBarMetricsDefault]; // Set a custom background
}

+(void)styleNavbarGlobalAppearance
{
    // Take care of customization of the Navigation Bar (in particular, we add the LFDA Logo, Right Justified)
    UIImage *navBarImg = [UIImage imageNamed:@"Nav Bar Bg"];
    [[UINavigationBar appearance] setBackgroundImage:navBarImg forBarMetrics:UIBarMetricsDefault]; // Set a custom background
}

+(void)showAlertDialogWithOKonly:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

@end
