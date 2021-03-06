//
//  ViewController.m
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/19/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import "ViewController.h"
#import "SignUpController.h"
#import "PendingTaskViewController.h"
#import "UserDetails.h"
#import "Groups.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController



- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
    
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Login";
    
    self.username.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user"];
    signUpcontrlr = [[SignUpController alloc] initWithNibName:@"SignUpController" bundle:[NSBundle mainBundle]];
    
    self.username.delegate = self;
    self.password.delegate = self;
    
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped:)];
    
    [self.view addGestureRecognizer:gest];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.79 green:0.69 blue:0.52 alpha:1]];
    
    [self.login setTitleColor:[UIColor colorWithRed:0.9 green:0.86 blue:0.8 alpha:1] forState:UIControlStateNormal];
    
    [self.login.layer setBorderWidth:1.0f];
    [self.login.layer setCornerRadius:7.0f];
    [self.login.layer setBorderColor:[UIColor colorWithRed:0.4 green:0 blue:0 alpha:1].CGColor];
    
    [self.signUp setTitleColor:[UIColor colorWithRed:0.9 green:0.86 blue:0.8 alpha:1] forState:UIControlStateNormal];
    
    [self.signUp.layer setBorderWidth:1.0f];
    [self.signUp.layer setCornerRadius:7.0f];
    [self.signUp.layer setBorderColor:[UIColor colorWithRed:0.4 green:0 blue:0 alpha:1].CGColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)screenTapped:(UIGestureRecognizer *)gest
{
    [self.view endEditing:YES];
}

- (IBAction)loginPressed:(UIButton *)sender {
    
    if([self.username.text  isEqual: @""] || [self.password.text isEqual:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Username or Password field cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
//    self.actIndic.hidden = NO;
    [self.actIndic startAnimating];
    
    NSString *reqBody = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}",self.username.text,self.password.text];
    
    NSData *postData = [reqBody dataUsingEncoding:NSUTF8StringEncoding];
    
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:8081/validateUser"]];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:postData];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[reqBody length]] forHTTPHeaderField:@"Content-length"];
    
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [con start];
}

-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSDictionary *recieved = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    if([recieved[@"Validations"] isEqual:@"SUCCESS"]) {
        
        pendingcontlr = [[PendingTaskViewController alloc] initWithNibName:@"PendingTaskViewController" bundle:[NSBundle mainBundle]];
        
        AppDelegate *del = [UIApplication sharedApplication].delegate;
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"UserDetails" inManagedObjectContext:del.managedObjectContext];
        [fetchRequest setEntity:entity];
        [fetchRequest setFetchBatchSize:20];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"username = %@",recieved[@"username"]]];
                                       
                                       
        NSError *error;
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setValue:self.username.text forKey:@"user"];
        [def synchronize];
        if(![[del.managedObjectContext executeFetchRequest:fetchRequest error:&error] count]) {
            UserDetails *details = [NSEntityDescription insertNewObjectForEntityForName:@"UserDetails" inManagedObjectContext:del.managedObjectContext];

            
            details.username = recieved[@"username"];
            details.firstname = recieved[@"firstname"];
            details.lastname = recieved[@"lastname"];
            details.meateaters = recieved[@"meateaters"];
            details.foodChoice = recieved[@"foodchoice"];
            details.drinking = recieved[@"drinking"];
            details.smoking = recieved[@"smoking"];

            
            NSArray *grps = recieved[@"groups"];
            for(NSDictionary *dict in grps) {
                Groups *group = [NSEntityDescription insertNewObjectForEntityForName:@"Groups" inManagedObjectContext:del.managedObjectContext];
                NSString *val = [NSString stringWithFormat:@"%@",dict[@"groupId"]];
                group.groupID = [NSNumber numberWithLong:[val longLongValue]];
                group.groupName = dict[@"groupName"];
            }
            
            
            [del.managedObjectContext save:&error];
            
            
        }
        
        [self.actIndic stopAnimating];
        [self.navigationController pushViewController:pendingcontlr animated:YES];
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.actIndic stopAnimating];
    NSLog([error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finished loading");
}

- (IBAction)signUpPressed:(UIButton *)sender {
    [self.navigationController pushViewController:signUpcontrlr animated:YES];
}
@end
