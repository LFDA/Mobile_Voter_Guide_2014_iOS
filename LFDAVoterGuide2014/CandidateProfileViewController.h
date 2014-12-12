#import <UIKit/UIKit.h>
#import "Candidate.h"
#import "City.h"
#import "UILabelPadded.h"
#import "UITextViewRounded.h"
#import "UITextFieldRounded.h"
#import "RemoteImageView.h"
#import "GAITrackedViewController.h"
#import "FXLabel.h"

@interface CandidateProfileViewController : GAITrackedViewController {

}

@property (nonatomic) City *forCity;
@property (nonatomic) Candidate *forCandidate;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet RemoteImageView *imageCandidatePic;
@property (weak, nonatomic) IBOutlet UILabel *labelCandidateName;
@property (weak, nonatomic) IBOutlet FXLabel *labelDistrict;
@property (weak, nonatomic) IBOutlet UILabel *labelOffice;
@property (weak, nonatomic) IBOutlet UILabel *labelIncumbent;
@property (weak, nonatomic) IBOutlet UITextViewRounded *textExperience;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTextExperienceHeight;
@property (weak, nonatomic) IBOutlet UITextViewRounded *textEducation;
@property (weak, nonatomic) IBOutlet UITextFieldRounded *textFamily;
@property (weak, nonatomic) IBOutlet UITextFieldRounded *textEmail;
@property (weak, nonatomic) IBOutlet UITextViewRounded *textWebsite;
@property (weak, nonatomic) IBOutlet UITextFieldRounded *textPhone;
@property (weak, nonatomic) IBOutlet UIButton *buttonSendEmail;
@property (weak, nonatomic) IBOutlet UIButton *buttonCopyEmail;
@property (weak, nonatomic) IBOutlet UIButton *buttonCopyWebsite;
@property (weak, nonatomic) IBOutlet UIButton *buttonExitToWebsite;
@property (weak, nonatomic) IBOutlet UIButton *buttonCallPhone;

- (IBAction)handleSendEmail:(id)sender;
- (IBAction)handleCopy:(id)sender;
- (IBAction)handleExitToWebsite:(id)sender;
- (IBAction)handleCallPhone:(id)sender;
- (IBAction)handleViewFullProfile:(id)sender;
- (IBAction)handleReportErrors:(id)sender;

@end

