//
//  RecommViewController.m
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/27/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import "RecommViewController.h"
#import "AppDelegate.h"
#import "UserDetails.h"
#import "UserDetViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RecommViewController ()

@end

NSMutableArray *filterarray;
@implementation RecommViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.recommTale registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped:)];
    
    [self.view addGestureRecognizer:gest];
    
    [self.recommTale setBackgroundColor:[UIColor clearColor]];
    
    self.title = @"Search Room Mates";

    [self.view setBackgroundColor:[UIColor colorWithRed:0.79 green:0.69 blue:0.52 alpha:1]];
    
    [search setTitleColor:[UIColor colorWithRed:0.9 green:0.86 blue:0.8 alpha:1] forState:UIControlStateNormal];
    
    [search.layer setBorderWidth:1.0f];
    [search.layer setCornerRadius:7.0f];
    [search.layer setBorderColor:[UIColor colorWithRed:0.4 green:0 blue:0 alpha:1].CGColor];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [actInd startAnimating];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"UserDetails" inManagedObjectContext:del.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];

    
    UserDetails *det;
    NSMutableArray *array;
    NSError *error;
    if(![ array = [del.managedObjectContext executeFetchRequest:fetchRequest error:&error] count]) {
        det = [array objectAtIndex:0];
    }

    NSString *reqBody = [NSString stringWithFormat:@"{\"username\":\"%@\"}",[[NSUserDefaults standardUserDefaults] valueForKey:@"user"]];
    
    NSData *postData = [reqBody dataUsingEncoding:NSUTF8StringEncoding];
    
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:8081/getRecomm"]];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:postData];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[reqBody length]] forHTTPHeaderField:@"Content-length"];
    
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [con start];

    
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
    return [recommItem count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    if(!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    [cell setBackgroundColor:[UIColor clearColor]];

    cell.textLabel.text = [recommItem objectAtIndex:indexPath.row][@"firstname"];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserDetViewController *det = [[UserDetViewController alloc] initWithNibName:@"UserDetViewController" bundle:[NSBundle mainBundle] withUser:[recommItem objectAtIndex:indexPath.row][@"username"] ];
    
    [self.navigationController pushViewController:det animated:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    recommItem = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    recommItem = [recommItem filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(firstname).length > 0"]];
    
//        NSArray *arr = [recommItem allKeys];
    [self.recommTale reloadData];
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog([error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finished loading");
    [actInd stopAnimating];
}

-(void)screenTapped:(UIGestureRecognizer *)gest
{
    [self.view endEditing:YES];
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //[recommItem removeAllObjects];
    
    return YES;
}
@end
