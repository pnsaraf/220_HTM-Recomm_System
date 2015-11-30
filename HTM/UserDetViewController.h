//
//  UserDetViewController.h
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/27/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetViewController : UIViewController
{
    NSMutableURLRequest *request;
    NSString *username;
    NSMutableDictionary *recommItem;
    IBOutlet UIActivityIndicatorView *actind;
    NSMutableArray *allkeys;
}
@property (strong, nonatomic) IBOutlet UITableView *userDet;


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withUser: (NSString *)usrnm;
@end
