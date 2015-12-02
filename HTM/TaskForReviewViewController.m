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
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface TaskForReviewViewController ()

@end


@implementation TaskForReviewViewController

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withObj:(TaskDetails *)_det forReview:(BOOL) flag
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        det = _det;
        infoAray = [[NSMutableArray alloc] init];
        rev = flag;
        submission = FALSE;
        revCount = 0;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Task Details";
    self.taskInfo.backgroundColor = [UIColor clearColor];
    
    for(UIView *view in self.view.subviews) {
        if([view isKindOfClass:[UIImageView class]]) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
            tap.delegate = self;
            [view addGestureRecognizer:tap];
        }
    }
    
    
    UITapGestureRecognizer *screentap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screentapped)];
    [self.view addGestureRecognizer:screentap];
    [self.taskInfo registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
//    self.taskInfo set
    TaskInfo *info = det.task;
    if(info) {
        [self getvalues:info];
    }
    
    
    self.assignedTo.text = det.assignedTo;
    self.category.text = det.taskCategory;
    self.name.text = det.taskname;
    
    CGSize size = self.parentScrollView.frame.size;
    size.height += 100;
    [self.parentScrollView setContentSize:size];
    
    [[self.feedback layer] setBorderColor:[UIColor blackColor].CGColor];
    [[self.feedback layer] setBorderWidth:1.0f];
    [[self.feedback layer] setCornerRadius:2.5f];
    
    if(rev) {
        feedbacklabel.hidden = NO;
        ratinglabel.hidden = NO;
        self.feedback.hidden = NO;
        
        for(UIView *view in self.view.subviews) {
            if([view isKindOfClass:[UIImageView class]]) {
                view.hidden = NO;
            }
        }
    }
    
//    self.parentScrollView ca
    // Do any additional setup after loading the view from its nib.
    
}

-(void)screentapped
{
    [self.view endEditing:YES];
}

-(void)getvalues:(TaskInfo *)info
{
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
}

-(void) viewDidAppear:(BOOL)animated
{
    if(!det.task) {
        [self.actInd startAnimating];
        
        NSString *reqBody = [NSString stringWithFormat:@"{\"taskId\":\"%@\"}",det.taskID];
        
        NSData *postData = [reqBody dataUsingEncoding:NSUTF8StringEncoding];
        
        request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://localhost:8081/getTaskInfo"]];
        
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        [request setHTTPBody:postData];
        [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[reqBody length]] forHTTPHeaderField:@"Content-length"];
        
        NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [con start];
    }
}

-(void)imageTapped:(UIGestureRecognizer *)gst
{
    UIImageView *img = (UIImageView *)gst.view;
    BOOL flag = img.highlighted;
    revCount = (flag) ? revCount : 0;
    for(UIView *view in self.view.subviews) {
        if([view isKindOfClass:[UIImageView class]]) {
            if(!flag) {
                if(view.tag <= img.tag) {
                    UIImageView *image = (UIImageView *)view;
                    image.highlighted = YES;
                    revCount++;
                }

            } else {
                if(view.tag >= img.tag) {
                    UIImageView *image = (UIImageView *)view;
                    image.highlighted = NO;
                    revCount--;
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



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSMutableArray *recommItem = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    AppDelegate *del = [UIApplication sharedApplication].delegate;
    
    if(!submission) {
        TaskInfo *info = [NSEntityDescription insertNewObjectForEntityForName:@"TaskInfo" inManagedObjectContext:det.managedObjectContext];
        

       
        [recommItem enumerateObjectsUsingBlock:^(NSDictionary *obj,NSUInteger ind,BOOL *stop){
            info.items = ([obj[@"items"] isKindOfClass:[NSNull class]]) ? NULL : obj[@"items"] ;
            info.stove = ([obj[@"stove"] isKindOfClass:[NSNull class]]) ? NULL : obj[@"stove"] ;
            info.cookingPot = ([obj[@"cookingpot"] isKindOfClass:[NSNull class]]) ? NULL : obj[@"cookingpot"] ;
            info.kitchensink = ([obj[@"kitchensink"] isKindOfClass:[NSNull class]]) ? NULL : obj[@"kitchensink"] ;
            info.kitchenIsland = ([obj[@"platform"] isKindOfClass:[NSNull class]]) ? NULL : obj[@"platform"] ;
            info.kitchenFloor = ([obj[@"kitchenfloor"] isKindOfClass:[NSNull class]]) ? NULL : obj[@"kitchenfloor"] ;
            info.sink = ([obj[@"sink"] isKindOfClass:[NSNull class]]) ? NULL : obj[@"sink"] ;
            info.toiletSeat = ([obj[@"toiletseat"] isKindOfClass:[NSNull class]]) ? NULL : obj[@"toiletseat"] ;
            info.bathtub = ([obj[@"bathtub"] isKindOfClass:[NSNull class]]) ? NULL : obj[@"bathtub"] ;
        
        }];
        
        det.task = info;
       
        [del saveContext];
        [self getvalues:info];
        
        //        NSArray *arr = [recommItem allKeys];
        [self.taskInfo reloadData];
    } else {
        if(rev)
            det.review = [NSNumber numberWithInt:revCount];
        else {
            det.submitted = @"YES";
        }
        
        [del saveContext];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog([error description]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"finished loading");
    [self.actInd stopAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)submit:(id)sender {
    submission = TRUE;
    
    if(revCount <= 0 && rev) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Task not rated yet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        submission = FALSE;
        return;
    }
    [self.actInd startAnimating];
    
    NSString *reqBody = (rev) ? [NSString stringWithFormat:@"{\"review\":%ld,\"taskId\":\"%@\",\"feedback\":\"%@\"}",(long)revCount,det.taskID,self.feedback.text] : [NSString stringWithFormat:@"{\"taskId\":\"%@\"}",det.taskID];
    
    NSData *postData = [reqBody dataUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = (rev) ? [NSURL URLWithString:@"http://localhost:8081/review"] : [NSURL URLWithString:@"http://localhost:8081/submitTask"];
    
    if(request) {
        request = nil;
    }
    
    request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPBody:postData];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[reqBody length]] forHTTPHeaderField:@"Content-length"];
    
    NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [con start];
    
}
@end
