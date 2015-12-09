//
//  NewTaskViewController.m
//  HTM
//
//  Created by Prathamesh N. Saraf on 12/1/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import "NewTaskViewController.h"
#import "NewTaskTableViewCell.h"
#import "Groups.h"
#import "AppDelegate.h"
#include <QuartzCore/QuartzCore.h>

@interface NewTaskViewController ()

@end

@implementation NewTaskViewController

NSMutableArray *taskInfo;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTaskCategory:(NSString *) cat
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        category = cat;
        groupList = [NSMutableArray array];
        if([cat isEqual:@"COOKING"]) {
            taskInfo = [NSMutableArray arrayWithObjects:@"cookingpot",@"stove",@"items", nil];
        } else if ([cat isEqual:@"REST ROOMS"]) {
            taskInfo = [NSMutableArray arrayWithObjects:@"bathtub",@"toiletseat",@"sink", nil];
        } else {
            taskInfo = [NSMutableArray arrayWithObjects:@"kitchenfloor",@"platform", @"kitchensink", nil];
        }
        
        infoArrayResult = [NSMutableArray arrayWithCapacity:[taskInfo count]];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.taskInfo registerNib:[UINib nibWithNibName:@"NewTaskTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    for(int i = 0; i < [taskInfo count] ; i++) {
        [infoArrayResult addObject:[NSNumber numberWithInt:0]];
    }
    
    self.category.text = category;
    [self.taskInfo setBackgroundColor:[UIColor clearColor]];
    
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    
    self.assignedby.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user"];
    self.assignedby.enabled = NO;
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Groups" inManagedObjectContext:del.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"groupID" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSError *error;
    groupList = [del.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped)];
    [self.view addGestureRecognizer:gest];
    gest.cancelsTouchesInView = NO;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0.79 green:0.69 blue:0.52 alpha:1]];
    
    [create setTitleColor:[UIColor colorWithRed:0.9 green:0.86 blue:0.8 alpha:1] forState:UIControlStateNormal];
    
    [create.layer setBorderWidth:1.0f];
    [create.layer setCornerRadius:7.0f];
    [create.layer setBorderColor:[UIColor colorWithRed:0.4 green:0 blue:0 alpha:1].CGColor];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)screenTapped
{
    [self.view endEditing:YES];
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

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([textField isEqual:self.groups]) {
        UIPickerView *picker = [[UIPickerView alloc] init];
        picker.showsSelectionIndicator = YES;
        textField.inputView = picker;
        picker.dataSource = self;
        picker.delegate = self;
    }

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

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //    NSMutableArray *array = ([activeTextField isEqual:self.drinking]) ? drinkChoice : food;
    Groups *grp = [groupList objectAtIndex:row];
    self.groups.text = grp.groupName;
    selectedGrp = grp;
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [groupList count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Groups *grp = [groupList objectAtIndex:row];
    return grp.groupName;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewTaskTableViewCell *cell = (NewTaskTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.checkbox.highlighted = !cell.checkbox.highlighted;
    infoArrayResult[indexPath.row] = [NSNumber numberWithBool:cell.checkbox.highlighted];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)createTask:(id)sender {
    
    NSMutableArray *vals = [NSMutableArray array];
    for(int i = 0 ; i < [taskInfo count]; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if([[infoArrayResult objectAtIndex:i] integerValue]) {
            [dict setValue:@"NOT CLEAN" forKey:[taskInfo objectAtIndex:i]];
        } else {
            [dict setValue:@"CLEAN" forKey:[taskInfo objectAtIndex:i]];
        }
        [vals addObject:dict];
    }
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:vals options:NSJSONWritingPrettyPrinted error:&error];
    

    NSString *values = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSString *reqBody = [NSString stringWithFormat:@"{\"assignedTo\":\"%@\",\"assignedBy\":\"%@\",\"taskCategory\":\"%@\",\"taskName\":\"%@\",\"groupId\":\"%@\",\"values\":\%@\}",self
                         .assignedTo.text,[[NSUserDefaults standardUserDefaults] valueForKey:@"user"],category,self.taskName.text,selectedGrp.groupID,values];
    
    NSData *postData = [reqBody dataUsingEncoding:NSUTF8StringEncoding];
    
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:8081/createTask"]];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:postData];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[reqBody length]] forHTTPHeaderField:@"Content-length"];
    
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [con start];

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
   
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog([error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finished loading");
 
}

@end
