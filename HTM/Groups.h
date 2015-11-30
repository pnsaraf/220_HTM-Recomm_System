//
//  Groups.h
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/29/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Groups : NSManagedObject

@property (nonatomic, retain) NSNumber * groupID;
@property (nonatomic, retain) NSString * groupName;

@end
