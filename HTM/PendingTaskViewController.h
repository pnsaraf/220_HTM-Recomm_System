//
//  PendingTaskViewController.h
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/19/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class PendingTaskTableViewCell;


@interface PendingTaskViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    UIRefreshControl *refcontrol;
    IBOutlet UIActivityIndicatorView *actIndicator;
    NSMutableURLRequest *request;
}

@property (strong, nonatomic) IBOutlet UITableView *taskList;
@property (strong,nonatomic) NSFetchedResultsController *fetchResultsController;
- (IBAction)mytaskPressed:(id)sender;

- (IBAction)recommPressed:(id)sender;
- (IBAction)groupsTapped:(id)sender;

@end
