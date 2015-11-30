//
//  SignUpController.m
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/19/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import "SignUpController.h"

@interface SignUpController ()

@end

@implementation SignUpController

NSMutableArray *drinkChoice;
NSMutableArray *food, *gender;


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        
    }
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Sign Up Page";
    
    drinkChoice = [NSMutableArray arrayWithObjects:@"NO",@"OCCASSIONAL",@"HEAVY", nil];
    food = [NSMutableArray arrayWithObjects:@"VEGETARIAN",@"NON-VEGETARIAN", nil];
    gender = [NSMutableArray arrayWithObjects:@"MALE",@"FEMALE",nil];
    
    CGRect frame = self.masterScrollView.bounds;
    frame.size.height += 500;
    [self.masterScrollView setContentSize:frame.size];
    
    
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTapped:)];
    
    [self.masterScrollView addGestureRecognizer:gest];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardDidShowNotification object:nil];
//    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
//    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)screenTapped:(UIGestureRecognizer *)gest
{
    [self.view endEditing:YES];
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize currentKeyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //you need replace your textfield instance here
    CGPoint textFieldOrigin = activeTextField.frame.origin;
    CGFloat textFieldHeight = activeTextField.frame.size.height;
    
    CGRect visibleRect = self.view.frame;
    visibleRect.size.height -= currentKeyboardSize.height;
    
    if (!CGRectContainsPoint(visibleRect, textFieldOrigin))
    {
        //you can add yor desired height how much you want move keypad up, by replacing "textFieldHeight" below
        
        CGPoint scrollPoint = CGPointMake(0.0, textFieldOrigin.y - visibleRect.size.height  + textFieldHeight); //replace textFieldHeight to currentKeyboardSize.height, if you want to move up with more height
        [self.masterScrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    CGPoint point = self.firstName.frame.origin;
    point.x = 0;
    [self.masterScrollView setContentOffset:point animated:YES];
//    [self.masterScrollView scrollRectToVisible:self.firstName.frame animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)viewWillAppear:(BOOL)animated
{
//    [self.firstName becomeFirstResponder];
}

- (IBAction)registerTapped:(UIButton *)sender {
    if([self.firstName.text  isEqual: @""] || [self.lastName.text isEqual:@""] || [self.userName.text isEqual:@""] || [self.password.text isEqual:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Mandatory fields cannot be empty" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    if(![self.password.text isEqual:self.confirmPassword.text]) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Passwords do not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    NSString *reqBody = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\",\"firstname\":\"%@\",\"lastname\":\"%@\",\"drinking\":\"%@\",\"smoking\":\"%@\",\"foodchoice\":\"%@\",\"meateaters\":\"%@\",\"gender\":\"%@\",\"occupation\":\"%@\",\"location\":\"%@\",\"age\":\"%@\",\"employed\":\"%@\"}",self.userName.text,self.password.text,self.firstName.text,self.lastName.text,self.drinking.text,[self.smoking titleForSegmentAtIndex:self.smoking.selectedSegmentIndex],self.foodChoice.text,[self.meateaters titleForSegmentAtIndex:self.meateaters.selectedSegmentIndex],self.gender.text,self.occupation.text,self.location.text,self.age.text,[self.employed titleForSegmentAtIndex:self.employed.selectedSegmentIndex]];
    
    NSData *postData = [reqBody dataUsingEncoding:NSUTF8StringEncoding];
    
    request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://127.0.0.1:8081/addUser"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:postData];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[reqBody length]] forHTTPHeaderField:@"Content-length"];
    
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [con start];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSDictionary *recieved = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    if([recieved[@"update"] isEqual:@"success"]) {
        for(UIView *v in self.view.subviews) {
            if([v isKindOfClass:[UITextField class]]) {
                UITextField *field = (UITextField *)v;
                field.text = @"";
            }
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    UIPickerView *picker;
    activeTextField = textField;
    if([textField isEqual:self.drinking] || [textField isEqual:self.foodChoice] || [textField isEqual:self.gender]) {
        picker = [[UIPickerView alloc] init];
        picker.showsSelectionIndicator = YES;
        textField.inputView = picker;
        picker.dataSource = self;
        picker.delegate = self;
    }

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField isEqual:self.drinking] || [textField isEqual:self.foodChoice] || [textField isEqual:self.gender]) {
        return NO;
    }
    
    return YES;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    NSMutableArray *array;
    if([activeTextField isEqual:self.drinking]) {
        array = drinkChoice;
    } else if ([activeTextField isEqual:self.gender]) {
        array = gender;
    } else {
        array = food;
    }
    
//    NSMutableArray *array = ([activeTextField isEqual:self.drinking]) ? drinkChoice : food;

    activeTextField.text = [array objectAtIndex:row];
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([activeTextField isEqual:self.drinking]) {
        return 3;
    } else if([activeTextField isEqual:self.foodChoice]) {
        return 2;
    } else {
        return 2;
    }
    
    return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSMutableArray *array;
    if([activeTextField isEqual:self.drinking]) {
        array = drinkChoice;
    } else if ([activeTextField isEqual:self.gender]) {
        array = gender;
    } else {
        array = food;
    }
    
    return [array objectAtIndex:row];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog([error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finished loading");
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end
