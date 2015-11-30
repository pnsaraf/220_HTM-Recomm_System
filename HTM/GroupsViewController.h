//
//  GroupsViewController.h
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/22/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface GroupsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *groupsTable;
@property (strong, nonatomic) NSFetchedResultsController *fetchResultsController;
@end
