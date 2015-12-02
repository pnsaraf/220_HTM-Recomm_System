//
//  UserDetails.h
//  HTM
//
//  Created by Prathamesh N. Saraf on 12/1/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserDetails : NSManagedObject

@property (nonatomic, retain) NSString * drinking;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * foodChoice;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * meateaters;
@property (nonatomic, retain) NSString * smoking;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * employed;
@property (nonatomic, retain) NSString * occupation;

@end
