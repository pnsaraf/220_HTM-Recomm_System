//
//  PendingTaskTableViewCell.m
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/20/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import "PendingTaskTableViewCell.h"

@implementation PendingTaskTableViewCell

- (void)awakeFromNib {
    // Initialization code
        [self.contentView setBackgroundColor:[UIColor colorWithRed:0.9 green:0.86 blue:0.8 alpha:1]];
}


-(id) init {
    self = [super init];
    if(self) {
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
