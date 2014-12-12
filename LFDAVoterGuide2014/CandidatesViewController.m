// Header File
#import "CandidatesViewController.h"
#import "CandidateProfileViewController.h"
#import "DataHelper.h"
#import "Candidate.h"

@interface CandidatesViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation CandidatesViewController {
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
		self.title = @"Candidates";
        
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
    self.screenName = @"CandidatesForCityList";
    
    // Set the view's topLabel
    self.viewTopLabel.text = [NSString stringWithFormat:@"%@ (%@)",self.forCity.cityName, self.forCity.countyName];
    
    // Load our data for the view headers and cities
    content = [DataHelper loadCityCandidatesTableViewForCity: self.forCity];
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

// To set the background color and text color of the Table Headers
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithRed:0.329 green:0.557 blue:0.827 alpha:1.000];

    // Save the header view
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    // Text Color & Alignment
    [header.textLabel setTextColor:[UIColor whiteColor]];
    [header.textLabel setTextAlignment:NSTextAlignmentCenter];
    // Text Font
    UIFont *saveFont = header.textLabel.font;
    [header.textLabel setFont:[UIFont fontWithName:saveFont.fontName size:18.0]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == _tableView1) {
        return [[content objectAtIndex:section] objectForKey:@"headerTitle"];
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (tableView == _tableView1) {
        static NSString *CellIdentifier = @"tableView1CellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:CellIdentifier];
        }
        // For the content, we are using a complex object storing an NSArray of Candidate
        Candidate *aCandidate = [[[content objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
        // Extract the candidate name for the UITableViewCell (but only if present - just in case)
        if ([aCandidate respondsToSelector:@selector(lastName)]){
            if ([aCandidate.lastName isEqualToString:@"<None This Cycle>"]){
                // No candidates for this one, so disable the cell tap and show this one differently
                cell.textLabel.text = [GlobalAppData appStrings:@"NoCandidatesForGroup"];
                cell.detailTextLabel.text = @"";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.userInteractionEnabled = NO;
                cell.textLabel.textColor = [UIColor grayColor];
            } else {
                // We have a candidate, so display it on the cell, and ensure it's shown in normal-form
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ (%@)",aCandidate.firstName, aCandidate.lastName, [aCandidate.party uppercaseString]];
                if (aCandidate.incumbent & aCandidate.floterial) {
                    cell.detailTextLabel.text = @"(Incumbent, Floterial)";
                } else if (aCandidate.incumbent) {
                    cell.detailTextLabel.text = @"(Incumbent)";
                } else if (aCandidate.floterial) {
                    cell.detailTextLabel.text = @"(Floterial)";
                } else {
                    // Needs to be a SPACE for iOS8 to handle correctly (otherwise, some detailTextLabel
                    // don't display correctly even thought they may be set
                    cell.detailTextLabel.text = @" "; // Needs to be a SPACE for iOS8 to handle correctly
                }
                cell.selectionStyle = UITableViewCellSeparatorStyleSingleLine;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.userInteractionEnabled = YES;
                cell.textLabel.textColor = [UIColor blackColor];
            }

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
#pragma mark Segue

// Pass some data to the called controller on segue
// Note, for the storyboard segue to fire, the CellIdentifier needs to be the same in
// cellForRowAtIndexPath and in the Storyboard for the Cell.
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showCandidateProfileViewSegue"]){
        
//#if DEBUG
//        NSLog(@"indexPathForSelectedRow: %@",self.tableView1.indexPathForSelectedRow);
//#endif
        
        // Map the selected ROW on UITableView against the content NSArray
        NSIndexPath *indexPath = self.tableView1.indexPathForSelectedRow;
        Candidate *selectedCandidate = [[[content objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
        
        // Setup the dest view controller for the destination view
        CandidateProfileViewController *controller = segue.destinationViewController;
        // And pass the data we need to pass (Candidate in this case, note we're passing the custom Candidate instance - a custom class)
        controller.forCandidate = selectedCandidate;
        controller.forCity = self.forCity;
    }
}

@end

