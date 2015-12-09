//
//  MyTaskViewController.m
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/29/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import "MyTaskViewController.h"
#import "TaskDetails.h"
#import "AppDelegate.h"
#import "PendingTaskTableViewCell.h"
#import "TaskForReviewViewController.h"

@interface MyTaskViewController ()


@property (strong,nonatomic) NSFetchedResultsController *fetchResultsController;

@end

@implementation MyTaskViewController


-(NSFetchedResultsController *)fetchResultsController
{
    if (_fetchResultsController != nil) {
        return _fetchResultsController;
    }
    
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"TaskDetails" inManagedObjectContext:del.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"taskID" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.review = 0 && SELF.assignedTo = %@ && SELF.submitted = \"NO\"",[[NSUserDefaults standardUserDefaults] valueForKey:@"user"]];
    [fetchRequest setPredicate:pred];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:del.managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:nil];
    self.fetchResultsController = theFetchedResultsController;
    _fetchResultsController.delegate = self;
    
    return _fetchResultsController;
}


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        
    }
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    [self.mytasktable registerNib:[UINib nibWithNibName:@"PendingTaskTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    self.mytasktable.backgroundColor = [UIColor clearColor];
    
    self.title = @"My tasks";
    [self.view setBackgroundColor:[UIColor colorWithRed:0.79 green:0.69 blue:0.52 alpha:1]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    NSError *error;
    if(self.fetchResultsController) {
        self.fetchResultsController = nil;
    }
    if(![[self fetchResultsController] performFetch:&error]) {
        NSLog(@"Error in fecthing data");
    }
    
    [self.mytasktable reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id sectInfo =[[self.fetchResultsController sections] objectAtIndex:section];
    return [sectInfo numberOfObjects];
}

-(PendingTaskTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PendingTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(!cell) {
        cell = [[PendingTaskTableViewCell alloc] init];
    }
    
    TaskDetails *det = [self.fetchResultsController objectAtIndexPath:indexPath];
    cell.task.text = [NSString stringWithFormat:@"Task: %@",det.taskname];
    cell.assignment.text = [NSString stringWithFormat:@"Assigned To:%@   Assigned By:%@",det.assignedTo,det.assignedBy];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskDetails *det = [self.fetchResultsController objectAtIndexPath:indexPath];
    
    TaskForReviewViewController *taskRev = [[TaskForReviewViewController alloc] initWithNibName:@"TaskForReviewViewController" bundle:[NSBundle mainBundle] withObj:det forReview:NO];
    
    [self.navigationController pushViewController:taskRev animated:YES];
}

@end
