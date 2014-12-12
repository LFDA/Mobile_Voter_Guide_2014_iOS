//
//  MainTabBarViewController.m
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 8/24/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//
//  A custom TabBarViewController that allows us to style the TabBar as we like
//  see the embedded comments for details

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     Specifically, we want to set a TINT color for the tab bar in IB, then we want to be able to set the
     font and image color for SELECTED vs UNSELECTED items. It seems IB has no way to do this correctly.
     More specifically, the colors we want are:
        we set the selected item font and image colors to BLACK
        we set the unselected items font and image colors to WHITE
    */
    
    // The below expect the Bar Tint to be set in IB to #548ED3 or RGB:85/142/211
    //self.tabBar.tintColor = [UIColor colorWithRed:0.333 green:0.557 blue:0.827 alpha:1.000];
    
    UIColor *unselectedColor = [UIColor whiteColor];
    UIColor *SelectedColor = [UIColor blackColor];
    
    // First, use the Appearance Proxy for UITabBarItem to set some GLOBAL settings
    // set color of unselected text to white
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:unselectedColor, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    // set color of selected text to black
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:SelectedColor, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    // Set the tab bar TINT (color) for selected items
    [[UITabBar appearance] setSelectedImageTintColor:SelectedColor];
    
    // Now, specifically for "this" tab bar!
    // Finally, loop through the images associated with each item in IB and apply our UIImage extension category imageWithColor to tint them white
    // Note, this does not work with the IB "built in" images. We have to use a CUSTOM BAR ITEM
    for(UITabBarItem *item in self.tabBar.items) {
        // use the UIImage category code for the imageWithColor: method
        item.image = [[item.selectedImage imageWithColor:unselectedColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
