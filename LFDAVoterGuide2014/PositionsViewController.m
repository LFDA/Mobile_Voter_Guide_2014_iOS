//
//  PositionsViewController.m
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 9/6/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//

#import "PositionsViewController.h"
#import "DataHelper.h"
#import "Position.h"

@interface PositionsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation PositionsViewController {
    // local instance variables to hold the UITableView data
    NSArray *content;
    NSArray *indices;
}

#pragma mark -
#pragma mark Initialisation

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		// Set the title for this view controller
		self.title = @"Position on Issues";
        
        // Set a custom BACK BUTTON for the DESTINATION views that this view might suege into
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backButton;
        
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
	}
	return self;
}

#pragma mark -
#pragma mark UIViewController Delegates

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
	// Update support iOS 7
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
		self.navigationController.navigationBar.translucent = NO;
	}
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
	// Revert to default settings
	if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
		self.edgesForExtendedLayout = UIRectEdgeAll;
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Set the GAI name
    self.screenName = @"CandidatePositions";
    
    // Set the view's topLabel
    self.viewTopLabel.text = [NSString stringWithFormat:@"%@ %@ (%@)",self.forCandidate.firstName, self.forCandidate.lastName, self.forCandidate.party];
    
    // Load our data for the view headers and cities
    content = [DataHelper loadPositionsTableViewForCandidate: self.forCandidate];
}

#pragma mark -
#pragma mark TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == _tableView1) {
        return [[[content objectAtIndex:section] objectForKey:@"rowValues"] count];
	}
	return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (tableView == _tableView1) {
        return [content count];
	}
	return 0;
}

//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//{
//    // Background color
//    view.tintColor = [UIColor colorWithRed:0.329 green:0.557 blue:0.827 alpha:1.000];
//    
//    // Text Color
//    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
//    [header.textLabel setTextColor:[UIColor whiteColor]];
//    [header.textLabel setTextAlignment:NSTextAlignmentLeft];
//    
//    // Another way to set the background color
//    // Note: does not preserve gradient effect of original header
//    // header.contentView.backgroundColor = [UIColor blackColor];
//}
//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    if (tableView == _tableView1) {
//        return [[content objectAtIndex:section] objectForKey:@"headerTitle"];
//    }
//    return @"";
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView == _tableView1) {
        static NSString *CellIdentifier = @"tableView1CellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
        }
        // For the content, we are using a complex object storing an NSArray of Position
        Position *aPosition = [[[content objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
        // Extract the Position name for the UITableViewCell (but only if present - just in case)
        if ([aPosition respondsToSelector:@selector(issue)]){
            cell.textLabel.text = [NSString stringWithFormat:@"%@",aPosition.issue];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@)", aPosition.position];
            // We have a UIImageView on the cell, so let's reference it
            UIImageView *positionIcon = (UIImageView*)[cell viewWithTag:1];
            positionIcon.image = [GlobalAppData getIssueImage:aPosition.position];
        }
        
        return cell;
	}
	// Add this row to remove warning direction
	return [[UITableViewCell alloc] init];
}

// Handle user selecting a row (we store the city selected and let the IB segue handle the rest)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (tableView == _tableView1) {
        
        // We're using a segway, so this code is not used
        //        // Pull up the selected cell
        //        UITableViewCell *cell = [_tableView1 cellForRowAtIndexPath:indexPath];
        //        // Store it's text label (the city name)
        //        NSString *selectedCity = cell.textLabel.text;
        //#if DEBUG
        //        NSLog(@"City selected: %@",selectedCity);
        //#endif
        
	}
}

#pragma mark -
#pragma mark Actions

- (IBAction)tapTopLabel:(id)sender {
    // User tapped on the label, so fire off SAFARI with the link to the "read more"
    
    NSString *lfdaMoreUrl=[GlobalAppData appStrings:@"LfdaMoreOnPositions"];
    // Verify we have a URL
    if (!lfdaMoreUrl.length){
        // We don't, so ignore
        return;
    }
    // ASSERT: We have a URL

    // Log the action
    [GAIUtility logButtonPress:@"button-LfdaMoreOnPositions" forScreen:self.screenName];
    // Redirect
    NSURL *url = [NSURL URLWithString:lfdaMoreUrl];
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}


@end
