//
//  TaskDetails.h
//  HTM
//
//  Created by Prathamesh N. Saraf on 12/1/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TaskInfo;

@interface TaskDetails : NSManagedObject

@property (nonatomic, retain) NSString * assignedBy;
@property (nonatomic, retain) NSString * assignedTo;
@property (nonatomic, retain) NSNumber * review;
@property (nonatomic, retain) NSString * taskCategory;
@property (nonatomic, retain) NSNumber * taskID;
@property (nonatomic, retain) NSString * taskname;
@property (nonatomic, retain) NSString * submitted;
@property (nonatomic, retain) NSString * feedback;
@property (nonatomic, retain) TaskInfo *task;

@end
