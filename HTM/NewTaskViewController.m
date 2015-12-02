//
//  NewTaskViewController.m
//  HTM
//
//  Created by Prathamesh N. Saraf on 12/1/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import "NewTaskViewController.h"
#import "NewTaskTableViewCell.h"

@interface NewTaskViewController ()

@end

@implementation NewTaskViewController

NSMutableArray *taskInfo;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTaskCategory:(NSString *) cat
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        [self.category setText:cat];
        
        if([cat isEqual:@"COOKING"]) {
            taskInfo = [NSMutableArray arrayWithObjects:@"cookingpot",@"stove",@"items", nil];
        } else if ([cat isEqual:@"REST ROOMS"]) {
            taskInfo = [NSMutableArray arrayWithObjects:@"bathtub",@"toiletseat",@"sink", nil];
        } else {
            taskInfo = [NSMutableArray arrayWithObjects:@"kitchenfloor",@"platform", @"kitchensink", nil];
        }
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.taskInfo registerNib:[UINib nibWithNibName:@"NewTaskTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    [self.taskInfo setBackgroundColor:[UIColor clearColor]];
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
    return [taskInfo count];
}


-(NewTaskTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    cell.infoItem.text = [taskInfo objectAtIndex:indexPath.row];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.imageView.tag = indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewTaskTableViewCell *cell = (NewTaskTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    cell.checkbox.highlighted = !cell.checkbox.highlighted;
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
