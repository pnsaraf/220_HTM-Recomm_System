//
//  SignUpController.h
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/19/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpController : UIViewController <NSURLConnectionDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    NSMutableURLRequest *request;
    UITextField *activeTextField;
    IBOutlet UIButton *_register;
}
@property (strong, nonatomic) IBOutlet UITextField *firstName;
@property (strong, nonatomic) IBOutlet UITextField *lastName;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *userName;
@property (strong, nonatomic) IBOutlet UIScrollView *masterScrollView;
@property (strong, nonatomic) IBOutlet UITextField *drinking;
@property (strong, nonatomic) IBOutlet UITextField *foodChoice;
@property (strong, nonatomic) IBOutlet UISegmentedControl *smoking;
@property (strong, nonatomic) IBOutlet UISegmentedControl *meateaters;
@property (strong, nonatomic) IBOutlet UITextField *gender;
@property (strong, nonatomic) IBOutlet UITextField *occupation;
@property (strong, nonatomic) IBOutlet UISegmentedControl *employed;
@property (strong, nonatomic) IBOutlet UITextField *location;
@property (strong, nonatomic) IBOutlet UITextField *age;

@property (strong, nonatomic) IBOutlet UITextField *confirmPassword;
- (IBAction)registerTapped:(UIButton *)sender;
@end
