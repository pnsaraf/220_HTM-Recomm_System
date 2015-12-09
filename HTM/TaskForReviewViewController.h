//
//  TaskForReviewViewController.h
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/20/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TaskDetails;

@interface TaskForReviewViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    TaskDetails *det;
    NSMutableArray *infoAray;
    NSMutableDictionary *infoDict;
    NSMutableURLRequest *request;
    IBOutlet UILabel *feedbacklabel;
    IBOutlet UILabel *ratinglabel;
    IBOutlet UIButton *submit;
    BOOL rev;
    BOOL submission;
    NSInteger revCount;
}


@property (strong, nonatomic) IBOutlet UILabel *name;
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withObj:(TaskDetails *)_det forReview:(BOOL) flag;
@property (strong, nonatomic) IBOutlet UILabel *category;
@property (strong, nonatomic) IBOutlet UIScrollView *parentScrollView;

@property (strong, nonatomic) IBOutlet UILabel *assignedTo;
@property (strong, nonatomic) IBOutlet UITableView *taskInfo;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actInd;

@property (strong, nonatomic) IBOutlet UITextView *feedback;
- (IBAction)submit:(id)sender;

@end
