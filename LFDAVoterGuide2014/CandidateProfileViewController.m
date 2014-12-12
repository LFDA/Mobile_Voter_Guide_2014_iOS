// Header File
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import "CandidateProfileViewController.h"
#import "DataHelper.h"
#import "Utility.h"
#import "UIAlertViewWithCallback.h"
#import "PositionsViewController.h"
#import "MailHelper.h"

@interface CandidateProfileViewController () <MFMailComposeViewControllerDelegate>


@end

@implementation CandidateProfileViewController

#pragma mark -
#pragma mark Initialisation

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		// Set the title for this view controller
		self.title = @"Candidate Profile";
        
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
    self.screenName = @"CandidateProfile";
    
    // Allow our scrollView to scroll
    [self.scrollView setScrollEnabled:YES];
    
    // Format some of our UI objects
    self.labelDistrict.contentMode = UIViewContentModeTop;
    self.labelCandidateName.contentMode = UIViewContentModeTop;
    
    // Expand the candidate data (we load just a few fields for the Candidate List)
    self.forCandidate = [DataHelper expandCandidate: self.forCandidate];
    // Save to a local to save on some typing
    Candidate *c = self.forCandidate;
    
    // Load the image, including a fallback image
    [RemoteImageView setDefaultGlobalImage:[UIImage imageNamed:@"nophoto"]];
    // Wire up an ERROR block
    self.imageCandidatePic.errorBlock = ^(NSError *error){
        NSLog(@"image failed to load with error : %@", error);
    };
    // If we have Internet, try to load the image, if we have one to load AND it's not "nophoto" (the ERROR block will fire if needed)
    if(c.lfdaPhotoUrl.length && [c.lfdaPhotoUrl rangeOfString:@"nophoto"].location == NSNotFound && [Utility IsInternetConnected]){
        // To resolve an issue with some images not resizing (the disk cache, which is the default, misbehaves)
        self.imageCandidatePic.cacheMode = RIURLCacheMode; // In memory caching only
        self.imageCandidatePic.imageURL = [NSURL URLWithString:c.lfdaPhotoUrl];
    }
    
    // Load the data
    self.labelCandidateName.text = [NSString stringWithFormat:@"%@ %@ (%@)",c.firstName, c.lastName, c.party];
    self.labelOffice.text = [NSString stringWithFormat:@"%@ %@",[GlobalAppData appStrings:@"OfficeLabel"],c.office];
    self.labelIncumbent.text = [NSString stringWithFormat:@"%@ %@",[GlobalAppData appStrings:@"IncumbentLabel"],c.incumbent?@"Yes":@"No"];
    if([c.office isEqual:@"Governor"]||[c.office isEqual:@"U.S. Senate"]) {
        self.labelDistrict.text = @"";
    } else {
        if (!self.forCity){
            NSString *county = (!c.county.length) ? @"" : [NSString stringWithFormat:@"(%@)",c.county];
            // We don't have city, so we don't try to use it (we are coming from the SEARCH view which does not pass forCity)
            self.labelDistrict.text = [NSString stringWithFormat:@"%@ %@ %@",[GlobalAppData appStrings:@"DistrictLabel"],c.district,county];
        } else {
            // We have city, so we use it
            self.labelDistrict.text = [NSString stringWithFormat:@"%@ %@, %@ (%@)",[GlobalAppData appStrings:@"DistrictLabel"],c.district, self.forCity.cityName, self.forCity.countyName];
        }
    }
    
    [self.textExperience setTextWithGrowingFrame:!c.experience.length ? [GlobalAppData appStrings:@"InfoNotAvailable"] : c.experience];
    [self.textEducation setTextWithGrowingFrame:!c.education.length ? [GlobalAppData appStrings:@"InfoNotAvailable"] : c.education];
    self.textFamily.text = !c.family.length ? [GlobalAppData appStrings:@"InfoNotAvailable"] : c.family;
    // Check to see if the email is valid
    if([Utility isValidEmail:c.email]){
        // it is, so show it
        self.textEmail.text = c.email;
        // And enable the "send mail" button but only IF the device is set to send email
        self.buttonSendEmail.enabled = [MFMailComposeViewController canSendMail];
        // And enable the "copy email" button
        self.buttonCopyEmail.enabled = TRUE;
    } else {
        // We don't have a valid email, so don't show whatever we have, nor the send email button
        self.textEmail.text = [GlobalAppData appStrings:@"InfoNotAvailable"];
        self.buttonSendEmail.enabled = FALSE;
        self.buttonCopyEmail.enabled = FALSE;
    }
    // Check to see if we have a website
    if(!c.website.length){
        [self.textWebsite setTextWithGrowingFrame:[GlobalAppData appStrings:@"InfoNotAvailable"]];
        self.buttonCopyWebsite.enabled = FALSE;
        self.buttonExitToWebsite.enabled = FALSE;
    } else {
        [self.textWebsite setTextWithGrowingFrame: c.website];
        self.buttonCopyWebsite.enabled = TRUE;
        self.buttonExitToWebsite.enabled = TRUE;
    }
    // If we have a phone, we output it and enable the "call" button
    if (!c.phone.length){
        self.textPhone.text = [GlobalAppData appStrings:@"InfoNotAvailable"];
        self.buttonCallPhone.enabled = FALSE;
    } else {
        self.textPhone.text = c.phone;
        self.buttonCallPhone.enabled = TRUE;
    }
    
    
}

#pragma mark -
#pragma mark Handle Actions

// Fires up an MFMailComposeViewController with some predefined values so that a user may email the candidate
- (IBAction)handleSendEmail:(id)sender {

    // Log the action
    [GAIUtility logButtonPress:@"button-CandidateSendEmail" forScreen:self.screenName];
    
    // Bring up the Email View
    [MailHelper sendMailTo:[NSArray arrayWithObject:self.forCandidate.email] withSubject:NULL andBody:[GlobalAppData appStrings:@"EmailCandidateBody"] fromView:self];
    
}

// Handles the COPY to the Pasteboard for either the candidate's emial or website
- (IBAction)handleCopy:(id)sender {
    // copy the email into the pasteboard
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    UIButton *btn = (UIButton *)sender;
//#if DEBUG
//    NSLog(@"sender: %@",btn.currentTitle);
//#endif
    if ([btn.currentTitle isEqualToString:@"CopyEmail"]) {
        // Log the action
        [GAIUtility logButtonPress:@"button-CopyEmail" forScreen:self.screenName];
        [board setString:self.forCandidate.email];
        [UIutility showAlertDialogWithOKonly:[GlobalAppData appStrings:@"CopyEmail"]];
        return;
    }
    if ([btn.currentTitle isEqualToString:@"CopyWebsite"]) {
        // Log the action
        [GAIUtility logButtonPress:@"button-CopyWebsite" forScreen:self.screenName];
        [board setString:self.forCandidate.website];
        [UIutility showAlertDialogWithOKonly:[GlobalAppData appStrings:@"CopyWebsite"]];
        return;
    }
}

// Prompts the user for confirmation, then sends them to the Candidate's URL in Safari
- (IBAction)handleExitToWebsite:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:[GlobalAppData appStrings:@"ExitToWebsitePrompt"] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    [UIAlertViewWithCallback showAlertView:alert withCallback:^(NSInteger buttonIndex) {
        // If index==1, ok button was selected and we redirect
        if (buttonIndex==1){
            // Log the action
            [GAIUtility logButtonPress:@"button-CandidateWebsite" forScreen:self.screenName];
            // Redirect
            NSURL *url = [NSURL URLWithString:self.forCandidate.website];
            if (![[UIApplication sharedApplication] openURL:url]) {
                NSLog(@"%@%@",@"Failed to open url:",[url description]);
            }
        }
        // Otherwise, we do nothing
    }];
}

// Attempts to place a call to the candidate's number
- (IBAction)handleCallPhone:(id)sender {
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tel://"]])
    {
        // The device can open a "tel://" UrlScheme, so it can make calls
        NSString *phone = self.forCandidate.phone;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:[NSString stringWithFormat:[GlobalAppData appStrings:@"CallPhonePrompt"],phone] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
        [UIAlertViewWithCallback showAlertView:alert withCallback:^(NSInteger buttonIndex) {
            // If index==1, ok button was selected and we redirect
            if (buttonIndex==1){
                // Log the action
                [GAIUtility logButtonPress:@"button-CandidateCall" forScreen:self.screenName];
                // Redirect
                NSString *phoneNumber = [@"tel://" stringByAppendingString:phone];
                if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]]) {
                    NSLog(@"%@%@",@"Failed to open url:",[phoneNumber description]);
                }
            }
            // Otherwise, we do nothing
        }];
    } else {
        // The device can't make calls
        [UIutility showAlertDialogWithOKonly:[GlobalAppData appStrings:@"CallNotSupportedOnDevice"]];
    }
}

// Prompts the user for confirmation, then sends them to the Candidate's LFDA Profile URL in Safari
- (IBAction)handleViewFullProfile:(id)sender {
    NSString *lfdaProfileUrl=self.forCandidate.lfdaProfileUrl;
    // Verify we have a profile URL
    if (!lfdaProfileUrl.length){
        // We don't, so display a message and return
        [UIutility showAlertDialogWithOKonly:[GlobalAppData appStrings:@"LfdaProfileMissingMessage"]];
        return;
    }
    // ASSERT: We have a profile URL
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:[GlobalAppData appStrings:@"ExitToProfilePrompt"] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    [UIAlertViewWithCallback showAlertView:alert withCallback:^(NSInteger buttonIndex) {
        // If index==1, ok button was selected and we redirect
        if (buttonIndex==1){
            // Log the action
            [GAIUtility logButtonPress:@"button-CandidateLfdaProfile" forScreen:self.screenName];
            // Redirect
            NSURL *url = [NSURL URLWithString:lfdaProfileUrl];
            if (![[UIApplication sharedApplication] openURL:url]) {
                NSLog(@"%@%@",@"Failed to open url:",[url description]);
            }
        }
        // Otherwise, we do nothing
    }];
}

// Fires up an MFMailComposeViewController with some predefined values so that a user may report a data error
- (IBAction)handleReportErrors:(id)sender {
    // Log the action
    [GAIUtility logButtonPress:@"button-CandidateReportError" forScreen:self.screenName];
    
    // Bring up the Email View
    [MailHelper sendMailTo:[NSArray arrayWithObject:[GlobalAppData appStrings:@"ReportErrorRecipient"]] withSubject:[GlobalAppData appStrings:@"ReportErrorSubject"] andBody:[NSString stringWithFormat:[GlobalAppData appStrings:@"ReportErrorBody"], [NSString stringWithFormat:@"%@ %@", self.forCandidate.firstName, self.forCandidate.lastName]] fromView:self];
    
}

#pragma mark -
#pragma mark MFMailComposeViewController Delegates

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    // Handle the mailComposeController didFinishWithResult message - handing it over to our helper
    [MailHelper mailComposeController:controller didFinishWithResult:result error:error fromView:self];
}

#pragma mark -
#pragma mark Segue

// Pass some data to the called controller on segue
// Note, for the storyboard segue to fire, the CellIdentifier needs to be the same in
// cellForRowAtIndexPath and in the Storyboard for the Cell.
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showPositionsViewSegue"]){
        
        //#if DEBUG
        //        NSLog(@"indexPathForSelectedRow: %@",self.tableView1.indexPathForSelectedRow);
        //#endif
        
        // Setup the dest view controller for the destination view
        PositionsViewController *controller = segue.destinationViewController;
        // And pass the data we need to pass (Candidate in this case, note we're passing the custom Candidate instance - a custom class)
        controller.forCandidate = self.forCandidate;
    }
}

@end

