//
//  TaskInfo.h
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/29/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TaskInfo : NSManagedObject

@property (nonatomic, retain) NSString * cookingPot;
@property (nonatomic, retain) NSString * items;
@property (nonatomic, retain) NSString * stove;
@property (nonatomic, retain) NSString * kitchenIsland;
@property (nonatomic, retain) NSString * kitchensink;
@property (nonatomic, retain) NSString * sink;
@property (nonatomic, retain) NSString * kitchenFloor;
@property (nonatomic, retain) NSString * bathtub;
@property (nonatomic, retain) NSString * toiletSeat;

@end
