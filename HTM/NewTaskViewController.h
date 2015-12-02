//
//  NewTaskViewController.h
//  HTM
//
//  Created by Prathamesh N. Saraf on 12/1/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewTaskViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withTaskCategory:(NSString *) cat;

@property (strong, nonatomic) IBOutlet UITextField *assignedby;
@property (strong, nonatomic) IBOutlet UITextField *assignedTo;
@property (strong, nonatomic) IBOutlet UILabel *category;
@property (strong, nonatomic) IBOutlet UITableView *taskInfo;

@end
