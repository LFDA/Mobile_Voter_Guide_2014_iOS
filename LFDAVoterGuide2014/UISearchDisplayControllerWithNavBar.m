//
//  UISearchDisplayControllerWithNavBar.m
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 9/7/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//
//  Implements a SearchDisplayController that does NOT hide the NavBar when active!
//  Unfortunately though it successfully keeps the NavBar, when coming back from a segue-pop
//  the search bar ends up hidden! Can't figure out how to re-align without further coding
//  probably repositioning the search bar and possibly also subclassing the search bar!

#import "UISearchDisplayControllerWithNavBar.h"

@implementation UISearchDisplayControllerWithNavBar

- (void)setActive:(BOOL)visible animated:(BOOL)animated
{
    // Super
    [super setActive:visible animated:animated];
    
    // The next statement will retain the navigation bar on search active BUT on pop from the detail view, the layout is messed up
    // and the search bar gets palced under the navigation bar.
//    [self.searchContentsController.navigationController setNavigationBarHidden:YES animated:NO];
    [self.searchContentsController.navigationController setNavigationBarHidden:NO animated:NO];
}

@end
