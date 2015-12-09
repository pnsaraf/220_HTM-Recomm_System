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
#import "RecommViewController.h"
#import "MyTaskViewController.h"
#import "GroupsViewController.h"
#import "CreateTaskViewController.h"
#import <QuartzCore/QuartzCore.h>

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
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.review = 0 && SELF.assignedTo != %@ && SELF.submitted = \"YES\"",[[NSUserDefaults standardUserDefaults] valueForKey:@"user"]];
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

- (IBAction)mytaskPressed:(id)sender {
    MyTaskViewController *mytask = [[MyTaskViewController alloc] initWithNibName:@"MyTaskViewController" bundle:[NSBundle mainBundle]];
    
    [self.navigationController pushViewController:mytask animated:YES];
    
}

- (IBAction)recommPressed:(id)sender {
    RecommViewController *recomm = [[RecommViewController alloc] initWithNibName:@"RecommViewController" bundle:[NSBundle mainBundle]];
    
    [self.navigationController pushViewController:recomm animated:YES];
}

- (IBAction)groupsTapped:(id)sender {
    GroupsViewController *grps = [[GroupsViewController alloc] initWithNibName:@"GroupsViewController" bundle:[NSBundle mainBundle]];
    
    [self.navigationController pushViewController:grps animated:YES];
}

- (IBAction)createTaskTapped:(id)sender {
    
    CreateTaskViewController *create = [[CreateTaskViewController alloc] initWithNibName:@"CreateTaskViewController" bundle:[NSBundle mainBundle]];
    
    [self.navigationController pushViewController:create animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self.taskList registerNib:[UINib nibWithNibName:@"PendingTaskTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"Cell"];
    
    self.taskList.backgroundColor = [UIColor clearColor];
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutTapped:)];
    self.navigationItem.rightBarButtonItem = logout;
    
    self.title = @"Profile";
    
    refcontrol = [[UIRefreshControl alloc] initWithFrame:self.taskList.frame];
    [self.taskList addSubview:refcontrol];
    
    actIndicator.backgroundColor = [UIColor clearColor];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.79 green:0.69 blue:0.52 alpha:1]];
    
    [grps.layer setBorderWidth:1.0f];
    [grps.layer setCornerRadius:7.0f];
    [grps.layer setBorderColor:[UIColor colorWithRed:0.4 green:0 blue:0 alpha:1].CGColor];

    [srchRoomies.layer setBorderWidth:1.0f];
    [srchRoomies.layer setCornerRadius:7.0f];
    [srchRoomies.layer setBorderColor:[UIColor colorWithRed:0.4 green:0 blue:0 alpha:1].CGColor];

    [self.tasks.layer setBorderWidth:1.0f];
    [self.tasks.layer setCornerRadius:7.0f];
    [self.tasks.layer setBorderColor:[UIColor colorWithRed:0.4 green:0 blue:0 alpha:1].CGColor];

    [createTask.layer setBorderWidth:1.0f];
    [createTask.layer setCornerRadius:7.0f];
    [createTask.layer setBorderColor:[UIColor colorWithRed:0.4 green:0 blue:0 alpha:1].CGColor];
    
    [grps setTitleColor:[UIColor colorWithRed:0.9 green:0.86 blue:0.8 alpha:1] forState:UIControlStateNormal];
    [createTask setTitleColor:[UIColor colorWithRed:0.9 green:0.86 blue:0.8 alpha:1] forState:UIControlStateNormal];
    [self.tasks setTitleColor:[UIColor colorWithRed:0.9 green:0.86 blue:0.8 alpha:1] forState:UIControlStateNormal];
    [srchRoomies setTitleColor:[UIColor colorWithRed:0.9 green:0.86 blue:0.8 alpha:1] forState:UIControlStateNormal];
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
    
    [self.taskList reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    if(![[[_fetchResultsController sections] objectAtIndex:0] numberOfObjects]) {
        [actIndicator startAnimating];
        [self getTaskListFromDatabase];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [actIndicator stopAnimating];
    NSLog([error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finished loading");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSMutableArray *recieved = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    __block BOOL needRefresh = FALSE;

    NSFetchRequest *req = [[NSFetchRequest alloc] init];
    [req setEntity:[NSEntityDescription entityForName:@"TaskDetails" inManagedObjectContext:del.managedObjectContext]];
    
    [req setFetchBatchSize:20];
    NSError *error;
    NSArray *arr = [del.managedObjectContext executeFetchRequest:req error:&error];
    
    [recieved enumerateObjectsUsingBlock:^(NSDictionary *obj,NSUInteger index,BOOL *stop){
        if(![arr count]||![[arr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.taskID = %@",obj[@"taskId"]]] count]) {
            TaskDetails *det = [NSEntityDescription insertNewObjectForEntityForName:@"TaskDetails" inManagedObjectContext:del.managedObjectContext];
            NSString *val = [NSString stringWithFormat:@"%@",obj[@"taskId"]];
            det.taskID = [NSNumber numberWithLong:[val longLongValue]];
            det.assignedTo = obj[@"assignedTo"];
            det.assignedBy = obj[@"assignedBy"];
            det.taskCategory = obj[@"taskCategory"];
            det.taskname = obj[@"taskName"];
            det.review = obj[@"review"];
            det.submitted = obj[@"submitted"];
            det.feedback = ([obj[@"feedback"] isKindOfClass:[NSNull class]]) ? NULL : obj[@"feedback"];
            
            needRefresh = TRUE;
            
        } else if ([[arr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.taskID = %@ && self.submitted = 'NO'",obj[@"taskId"]]] count]) {
            TaskDetails *det = [[arr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.taskID = %@ && self.submitted = 'NO'",obj[@"taskId"]]] objectAtIndex:0];
            if([det.submitted isEqual:@"NO"] && [obj[@"submitted"] isEqual:@"YES"]){
                det.submitted = @"YES";
                needRefresh = TRUE;
            }
            

        }
    }];
    
    
    if(needRefresh) {
        [del saveContext];
        
        self.fetchResultsController = nil;
        NSError *error;
        [self.fetchResultsController performFetch:&error];
        [self.taskList reloadData];
    }
    
    [actIndicator stopAnimating];
    [refcontrol endRefreshing];
    
    
}


-(void)getTaskListFromDatabase
{
    if(request) {
        request = nil;
    }
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.resultType = NSDictionaryResultType;
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Groups" inManagedObjectContext:del.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"groupID" ascending:YES];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];

    NSError *error;
    NSArray *groups = [del.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:groups options:NSJSONWritingPrettyPrinted error:&error];
    
    
    NSString *values = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *reqBody = [NSString stringWithFormat:@"{\"groups\":%@}",values];
    NSData *postData = [reqBody dataUsingEncoding:NSUTF8StringEncoding];
    
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:8081/getTaskList"]];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:postData];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[reqBody length]] forHTTPHeaderField:@"Content-length"];
    
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [con start];
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
    TaskForReviewViewController *task = [[TaskForReviewViewController alloc] initWithNibName:@"TaskForReviewViewController" bundle:[NSBundle mainBundle] withObj:det forReview:YES];
    
    [self.navigationController pushViewController:task animated:YES];
}


-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"It ends");
    [self getTaskListFromDatabase];
}
@end
