//
//  ViewController.h
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/19/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SignUpController;
@class PendingTaskViewController;

@interface ViewController : UIViewController <NSURLConnectionDelegate,UITextFieldDelegate>
{
    SignUpController *signUpcontrlr;
    NSMutableURLRequest *request;
    PendingTaskViewController *pendingcontlr;
}

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actIndic;

@property (strong, nonatomic) IBOutlet UIButton *login;
@property (strong, nonatomic) IBOutlet UIButton *signUp;

- (IBAction)loginPressed:(UIButton *)sender;

- (IBAction)signUpPressed:(UIButton *)sender;

@end

