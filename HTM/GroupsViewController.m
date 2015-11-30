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
    
    self.title = @"Groups info";
}


-(void)createGroupTapped:(UIBarButtonItem *)button
{
    
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
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}


@end
