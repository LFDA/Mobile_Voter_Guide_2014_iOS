#import <UIKit/UIKit.h>
#import "City.h"
#import "GAITrackedViewController.h"

@interface CandidatesViewController : GAITrackedViewController {

}

@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UILabel *viewTopLabel;
@property (nonatomic) City *forCity;

@end

