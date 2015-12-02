//
//  CreateTaskViewController.m
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/22/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import "CreateTaskViewController.h"
#import "NewTaskViewController.h"

@interface CreateTaskViewController ()

@end


NSMutableArray *categories;

@implementation CreateTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.createTask registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.createTask setBackgroundColor:[UIColor clearColor]];
    
    categories = [NSMutableArray arrayWithObjects:@"COOKING",@"REST ROOMS",@"KITCHEN", nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [categories count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [categories objectAtIndex:indexPath.row];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewTaskViewController *task = [[NewTaskViewController alloc] initWithNibName:@"NewTaskViewController" bundle:[NSBundle mainBundle] withTaskCategory:[categories objectAtIndex:indexPath.row]];
    
    [self.navigationController pushViewController:task animated:YES];
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
