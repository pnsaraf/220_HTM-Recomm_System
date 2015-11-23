//
//  PendingTaskViewController.m
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/19/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import "PendingTaskViewController.h"
#import "PendingTaskTableViewCell.h"
#import "TaskDetails.h"
#import "TaskForReviewViewController.h"

@interface PendingTaskViewController ()

@end

@implementation PendingTaskViewController

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        
    }
    
    
    return self;
}

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
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:del.managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:nil];
    self.fetchResultsController = theFetchedResultsController;
    _fetchResultsController.delegate = self;
    
    return _fetchResultsController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSError *error;
    if(![[self fetchResultsController] performFetch:&error]) {
        NSLog(@"Error in fecthing data");
    }
    
    [self.taskList registerNib:[UINib nibWithNibName:@"PendingTaskTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    self.taskList.backgroundColor = [UIColor clearColor];
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutTapped:)];
    self.navigationItem.rightBarButtonItem = logout;
    
    self.title = @"Profile";
    
    refcontrol = [[UIRefreshControl alloc] initWithFrame:self.taskList.frame];
    [self.taskList addSubview:refcontrol];
    actIndicator.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [actIndicator startAnimating];
    [UIView animateWithDuration:3 animations:^(void){
        [actIndicator stopAnimating];
    }];
}

-(void)logoutTapped:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    id sectInfo =[[_fetchResultsController sections] objectAtIndex:section];
    return [sectInfo numberOfObjects];
}

-(PendingTaskTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PendingTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(!cell) {
        cell = [[PendingTaskTableViewCell alloc] init];
    }
    
    TaskDetails *det = [_fetchResultsController objectAtIndexPath:indexPath];
    cell.task.text = [NSString stringWithFormat:@"Task: %@",det.taskID];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskDetails *det = [_fetchResultsController objectAtIndexPath:indexPath];
    TaskForReviewViewController *task = [[TaskForReviewViewController alloc] initWithNibName:@"TaskForReviewViewController" bundle:[NSBundle mainBundle] withObj:det];
    
    [self.navigationController pushViewController:task animated:YES];
}


-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"It ends");
    [refcontrol endRefreshing];
}
@end
