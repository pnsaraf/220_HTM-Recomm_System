//
//  UserDetViewController.m
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/27/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import "UserDetViewController.h"

@interface UserDetViewController ()

@end

@implementation UserDetViewController



-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUser: (NSString *)usrnm
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        username = usrnm;
        allkeys = [NSMutableArray array];
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.userDet setBackgroundColor:[UIColor clearColor]];
    
    [self.userDet registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    // Do any additional setup after loading the view from its nib.
    
       self.title = @"User Details";
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [actind startAnimating];
    
    NSString *reqBody = [NSString stringWithFormat:@"{\"username\":\"%@\"}",username];
    
    NSData *postData = [reqBody dataUsingEncoding:NSUTF8StringEncoding];
    
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:8081/getUserDetails"]];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:postData];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[reqBody length]] forHTTPHeaderField:@"Content-length"];
    
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [con start];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    recommItem = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    allkeys = [recommItem  allKeys];
    //        NSArray *arr = [recommItem allKeys];
    
    [self.userDet reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog([error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finished loading");
    [actind stopAnimating];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allkeys count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell = [cell initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [allkeys[indexPath.row] uppercaseString];
    
     cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",recommItem[allkeys[indexPath.row]]];
    
    [cell.detailTextLabel setTextColor:[UIColor blackColor]];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;

    
    
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
