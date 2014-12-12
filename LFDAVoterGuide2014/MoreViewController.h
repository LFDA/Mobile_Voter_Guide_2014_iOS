#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "UITextViewRounded.h"

@interface MoreViewController : GAITrackedViewController {

}

@property (weak, nonatomic) IBOutlet UITextViewRounded *textAppLog;
@property (weak, nonatomic) IBOutlet UITextViewRounded *textAbout;

- (IBAction)handleVoterResources:(id)sender;
- (IBAction)handleVotingRights:(id)sender;
- (IBAction)handleProvideFeedback:(id)sender;
- (IBAction)handleAppHelpPage:(id)sender;

@end

