// Header File
#import "SearchViewController.h"
#import "DataHelper.h"
#import "Candidate.h"
#import "CandidateProfileViewController.h"

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>


@end

@implementation SearchViewController {
    // local instance variables to hold the UITableView data
    NSArray *content;
    NSArray *indices;
    NSMutableArray *filteredContent;
}

#pragma mark -
#pragma mark Initialisation

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
        // This view is inside a TabBar Navigation Controller, so we set some titles and labels as needed
		self.title = @"Search"; // Sets the Tab Bar Button (bottom)
        self.navigationItem.title = [GlobalAppData appStrings:@"AppTitle"]; // Sets the View Title (top)


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

-(void)viewDidAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
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
    
    // Load our data for the view headers and cities
    content = [DataHelper loadCandidatesTableView];
    // Setup the filteredContent array also
    filteredContent = [NSMutableArray arrayWithCapacity:[content count]];
}


#pragma mark -
#pragma mark TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Check to see whether the normal table or search results table is being displayed and use the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [[[filteredContent objectAtIndex:section] objectForKey:@"rowValues"] count];
    } else {
        return [[[content objectAtIndex:section] objectForKey:@"rowValues"] count];
    }

	return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Check to see whether the normal table or search results table is being displayed and use the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [filteredContent count];
    } else {
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

    static NSString *CellIdentifier = @"tableView1CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // For the content, we are using a complex object storing an NSArray of Candidate
    Candidate *aCandidate;
    
    // Check to see whether the normal table or search results table is being displayed and use the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        // We're displaying search results
        aCandidate = [[[filteredContent objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
        
        // Style the Row and Cell for Search Results, which we can't do in IB (for the normal table view, we do this in IB)
        UIFont *saveFont = cell.textLabel.font;
        tableView.rowHeight = 49.0; // TODO: Find a better place to set rowHeight ONCE instead of on every cell!
        [cell.textLabel setFont:[UIFont fontWithName:saveFont.fontName size:22.0]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:saveFont.fontName size:14.0]];
        cell.textLabel.adjustsFontSizeToFitWidth=YES;
        [cell.textLabel setMinimumScaleFactor:0.5];

    } else {
        // We're displaying the normal table with all entries
        aCandidate = [[[content objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
    }
    
    // Extract the candidate name for the UITableViewCell (but only if present - just in case)
    if ([aCandidate respondsToSelector:@selector(lastName)]){
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ (%@)",aCandidate.firstName, aCandidate.lastName, [aCandidate.party uppercaseString]];
        cell.detailTextLabel.text = aCandidate.office;
    }
    
    return cell;
}

// For the Search Results to fire off the segue, we need to detect the touch and fire off the segue
// ALSO the Segue in IB should be MANUAL (that is, from the ViewController and NOT the table cell) to prevent the segue
// from firing off TWICE when in "normal" (non search results) view
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Perform segue to candy detail
    [self performSegueWithIdentifier:@"showCandidateProfileViewManualSegue" sender:tableView];
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -
#pragma mark Segue

// Pass some data to the called controller on segue
// Note, for the storyboard segue to fire, the CellIdentifier needs to be the same in
// cellForRowAtIndexPath and in the Storyboard for the Cell.
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showCandidateProfileViewManualSegue"]){
        
        //#if DEBUG
        //        NSLog(@"indexPathForSelectedRow: %@",self.tableView1.indexPathForSelectedRow);
        //#endif
        
        // A Placeholder for the selected row
        NSIndexPath *indexPath;
        // Placeholder for the right object
        Candidate *selectedCandidate;

        // Now, let's map the touched ROW against the underlying data object
        // Check to see whether the normal table or search results table triggered the segue and use the appropriate array
        if(sender == self.searchDisplayController.searchResultsTableView) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            selectedCandidate = [[[filteredContent objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
        } else {
            indexPath = [self.tableView1 indexPathForSelectedRow];
            selectedCandidate = [[[content objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
        }
        
        // Setup the dest view controller for the destination view
        CandidateProfileViewController *controller = segue.destinationViewController;
        // And pass the data we need to pass (Candidate in this case, note we're passing the custom Candidate instance - a custom class)
        controller.forCandidate = selectedCandidate;
        controller.forCity = nil;
    }
}

#pragma mark -
#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    // Update the filtered array based on the search text and scope.
    // Remove all objects from the filtered search array
    [filteredContent removeAllObjects];
    
    // Extract just the candidates from our object
    NSArray *candidateList = [[content objectAtIndex:0] objectForKey:@"rowValues"];
    // Create a placeholder for the filtered Candidates
    NSMutableArray *filteredCandidateList;
    
    // Filter the array using NSPredicate (searchtext contained in LastName or FirstName)
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"lastName contains[c] %@ or firstName contains[c] %@",searchText, searchText];
    filteredCandidateList = [NSMutableArray arrayWithArray:[candidateList filteredArrayUsingPredicate:predicate]];
    
    // Put the filtered list back into the right object
    NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
    // Setup the row correctly for the return
    [row setValue:@"Filtered Candidates" forKey:@"headerTitle"];
    [row setValue:filteredCandidateList forKey:@"rowValues"];
    // Add it to the return
    [filteredContent addObject:row];
}

@end

