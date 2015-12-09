//
//  GroupsViewController.m
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/22/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import "GroupsViewController.h"
#import "Groups.h"

@interface GroupsViewController ()

@end

@implementation GroupsViewController

-(NSFetchedResultsController *)fetchResultsController
{
    if (_fetchResultsController != nil) {
        return _fetchResultsController;
    }
    
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Groups" inManagedObjectContext:del.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"groupID" ascending:NO];
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
    
    [self.groupsTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    NSError *error;
    if(![[self fetchResultsController] performFetch:&error]) {
        NSLog(@"Error in fecthing data");
    }
    
    self.groupsTable.backgroundColor = [UIColor clearColor];
    
    UIBarButtonItem *logout = [[UIBarButtonItem alloc] initWithTitle:@"Create" style:UIBarButtonItemStylePlain target:self action:@selector(createGroupTapped:)];
    self.navigationItem.rightBarButtonItem = logout;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.79 green:0.69 blue:0.52 alpha:1]];
    
    self.title = @"Groups info";
}


-(void)createGroupTapped:(UIBarButtonItem *)button
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Create Group" message:@"Group Name" delegate:self cancelButtonTitle:@"Create" otherButtonTitles:@"Cancel",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0) {
        if([[[alertView textFieldAtIndex:0] text] isEqual:@""]) {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Group name cannot be empty" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            return;
        }
        
        NSString *reqBody = [NSString stringWithFormat:@"{\"groupName\":\"%@\",\"user\":\"%@\"}",[[alertView textFieldAtIndex:0] text],[[NSUserDefaults standardUserDefaults] valueForKey:@"user"]];
        
        NSData *postData = [reqBody dataUsingEncoding:NSUTF8StringEncoding];
        
        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:8081/createGroup"]];
        
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        [request setHTTPBody:postData];
        [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[reqBody length]] forHTTPHeaderField:@"Content-length"];
        
        NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [con start];
    }
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSDictionary *received = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    
    if([received[@"createGroup"] isEqual:@"SUCCESS"]) {
        Groups *grp = [NSEntityDescription insertNewObjectForEntityForName:@"Groups" inManagedObjectContext:del.managedObjectContext];
        grp.groupID = [NSNumber numberWithLongLong:[received[@"groupId"] longLongValue]];
        grp.groupName = received[@"groupName"];
        
        [del saveContext];
        self.fetchResultsController = nil;
        
        NSError *error;
        [[self fetchResultsController] performFetch:&error];
        [self.groupsTable reloadData];
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog([error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finished loading");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    Groups *det = [self.fetchResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = det.groupName;
    cell.textLabel.textColor = [UIColor colorWithRed:0.4 green:0 blue:0 alpha:1];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}


@end
