//
//  TaskForReviewViewController.m
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/20/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import "TaskForReviewViewController.h"
#import "TaskDetails.h"
#import "TaskInfo.h"
#import <objc/runtime.h>

@interface TaskForReviewViewController ()

@end


@implementation TaskForReviewViewController

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withObj:(TaskDetails *)_det
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        det = _det;
        infoAray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.taskInfo.backgroundColor = [UIColor clearColor];
    
    for(UIView *view in self.view.subviews) {
        if([view isKindOfClass:[UIImageView class]]) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
            tap.delegate = self;
            [view addGestureRecognizer:tap];
        }
    }
    
    [self.taskInfo registerClass:[UITableViewCell class]forCellReuseIdentifier:@"Cell"];
//    self.taskInfo set
    TaskInfo *info = det.task;
    
    unsigned int propCount =  0;
    objc_property_t *prop = class_copyPropertyList([TaskInfo class], &propCount);
    
    NSMutableArray *propNames = [NSMutableArray array];
    for(int i = 0; i < propCount ; i++) {
        objc_property_t currProp = prop[i];
         [propNames addObject:[NSString stringWithUTF8String:property_getName(currProp)]];
    }
    
   infoDict = [info dictionaryWithValuesForKeys:propNames];
    
    NSSet *set = [infoDict keysOfEntriesPassingTest:^(id key,id obj,BOOL *stop) {
        if([obj isKindOfClass:[NSNull class]]) {
            return NO;
        } else
            return YES;
    }];
    
    infoAray = [set allObjects];
    
    self.assignedTo.text = det.assignedTo;
    self.category.text = det.taskCategory;
    self.name.text = det.taskname;
    
//    self.parentScrollView ca
    // Do any additional setup after loading the view from its nib.
    
}



-(void)imageTapped:(UIGestureRecognizer *)gst
{
    UIImageView *img = (UIImageView *)gst.view;
    
    BOOL flag = img.highlighted;
    for(UIView *view in self.view.subviews) {
        if([view isKindOfClass:[UIImageView class]]) {
            if(!flag) {
                if(view.tag <= img.tag) {
                    UIImageView *image = (UIImageView *)view;
                    image.highlighted = YES;
                }
            } else {
                if(view.tag >= img.tag) {
                    UIImageView *image = (UIImageView *)view;
                    image.highlighted = NO;
                }
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [infoAray count];
}



-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell = [cell initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [[infoAray objectAtIndex:indexPath.row] uppercaseString];
    cell.detailTextLabel.text = [infoDict objectForKey:[infoAray objectAtIndex:indexPath.row]];
    [cell.detailTextLabel setTextColor:[UIColor blackColor]];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
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
