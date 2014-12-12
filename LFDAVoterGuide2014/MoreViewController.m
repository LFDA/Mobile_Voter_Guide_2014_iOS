#import <MessageUI/MessageUI.h>
#import "MailHelper.h"
#import "MoreViewController.h"
#import "DataHelper.h"

@interface MoreViewController () <MFMailComposeViewControllerDelegate>


@end

@implementation MoreViewController {

}

#pragma mark -
#pragma mark Initialisation

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
        // This view is inside a TabBar Navigation Controller, so we set some titles and labels as needed
		self.title = @"More"; // Sets the Tab Bar Button (bottom)
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
    self.screenName = @"More";
    
    // Set the various screen fields/outlets
    [self.textAbout setTextWithGrowingFrame:[GlobalAppData appStrings:@"AboutApp"]];
    self.textAppLog.text = [NSString stringWithFormat:@"%@\nDB MD5:\n%@",[GlobalAppData appVersionString],[DataHelper getDbMd5]];
}

#pragma mark -
#pragma mark Handle Actions

- (IBAction)handleVoterResources:(id)sender {
    // Log the action
    [GAIUtility logButtonPress:@"button-VoterResources" forScreen:self.screenName];
    // Redirect
    NSURL *url = [NSURL URLWithString:[GlobalAppData appStrings:@"LfdaVoterResourcesURL"]];
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

- (IBAction)handleVotingRights:(id)sender {
    // Log the action
    [GAIUtility logButtonPress:@"button-VoterResources" forScreen:self.screenName];
    // Redirect
    NSURL *url = [NSURL URLWithString:[GlobalAppData appStrings:@"SosVotingRightsURL"]];
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

- (IBAction)handleProvideFeedback:(id)sender {
    // Log the action
    [GAIUtility logButtonPress:@"button-ProvideFeedback" forScreen:self.screenName];
    
    // Bring up the email view
    [MailHelper sendMailTo:[NSArray arrayWithObject:[GlobalAppData appStrings:@"FeedbackRecipient"]] withSubject:[GlobalAppData appStrings:@"FeedbackSubject"] andBody:[NSString stringWithFormat:[GlobalAppData appStrings:@"FeedbackBody"],self.textAppLog.text] fromView:self];
}

- (IBAction)handleAppHelpPage:(id)sender {
    // Log the action
    [GAIUtility logButtonPress:@"button-AppHelpPage" forScreen:self.screenName];
    // Redirect
    NSURL *url = [NSURL URLWithString:[GlobalAppData appStrings:@"AppHelpPageUrl"]];
    if (![[UIApplication sharedApplication] openURL:url]) {
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
    }
}

#pragma mark -
#pragma mark MFMailComposeViewController Delegates

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // Handle the mailComposeController didFinishWithResult message - handing it over to our helper
    [MailHelper mailComposeController:controller didFinishWithResult:result error:error fromView:self];
}

@end

