//
//  PositionsViewController.h
//  LFDA Voter Guide 2014
//
//  Created by Eric A. Soto on 9/6/14.
//  Copyright (c) 2014 lfda.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Candidate.h"
#import "GAITrackedViewController.h"

@interface PositionsViewController : GAITrackedViewController {
    
}

- (IBAction)tapTopLabel:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UILabel *viewTopLabel;
@property (nonatomic) Candidate *forCandidate;

@end
