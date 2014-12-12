// Header File
#import "City_ListViewController.h"
#import "CandidatesViewController.h"
#import "DataHelper.h"
#import "City.h"

@interface City_ListViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation City_ListViewController {
    // local instance variables to hold the UITableView data
    NSArray *content;
    NSArray *indices;
}

#pragma mark -
#pragma mark Initialisation

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
        // This view is inside a TabBar Navigation Controller, so we set some titles and labels as needed
		self.title = @"Candidates"; // Sets the Tab Bar Button (bottom)
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

	// Update support iOS 7 (forces elements in iOS 7 to start BELOW the status bar!
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
    self.screenName = @"CityList";
    
    // Load our data for the view headers and cities
    content = [DataHelper loadCityTableViewObject];
    indices = [content valueForKey:@"headerTitle"];
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
//    // Background color
//    view.tintColor = [UIColor colorWithRed:0.329 green:0.557 blue:0.827 alpha:1.000];

    // Save the header view
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;

//    // Text Color & Alignment
//    [header.textLabel setTextColor:[UIColor whiteColor]];
//    [header.textLabel setTextAlignment:NSTextAlignmentLeft];
    // Text Font
    UIFont *saveFont = header.textLabel.font;
    [header.textLabel setFont:[UIFont fontWithName:saveFont.fontName size:18.0]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == _tableView1) {
        return [content valueForKey:@"headerTitle"];
    }
    return [[NSArray alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if (tableView == _tableView1) {
        return [indices indexOfObject:title];
    }
    return 0;
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
        // For the content, we are using a complex object storing an NSArray of City
        City *aCity = [[[content objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
        // Extract the cityName for the UITableViewCell (but only if present - just in case)
        if ([aCity respondsToSelector:@selector(cityName)]){
            cell.textLabel.text = aCity.cityName;
        }
        
        return cell;
	}
	// Add this row to remove warning direction
	return [[UITableViewCell alloc] init];
}

#pragma mark -
#pragma mark Segue

// Pass some data to the called controller on segue
// Note, for the storyboard segue to fire, the CellIdentifier needs to be the same in
// cellForRowAtIndexPath and in the Storyboard for the Cell.
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showCandidatesViewSegue"]){
        
//#if DEBUG
//        NSLog(@"indexPathForSelectedRow: %@",self.tableView1.indexPathForSelectedRow);
//#endif
        
        // Map the selected ROW on UITableView against the content NSArray
        NSIndexPath *indexPath = self.tableView1.indexPathForSelectedRow;
        City *selectedCity = [[[content objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];

        // Setup the dest view controller for the destination view
        CandidatesViewController *controller = segue.destinationViewController;
        // And pass the data we need to pass (City in this case, note we're passing the custom City instance - a custom class)
        controller.forCity = selectedCity;
    }
}

@end

