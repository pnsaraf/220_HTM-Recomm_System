//
//  NewTaskTableViewCell.m
//  HTM
//
//  Created by Prathamesh N. Saraf on 12/1/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import "NewTaskTableViewCell.h"

@implementation NewTaskTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkboxTapped:)];
    
    //[self.imageView addGestureRecognizer:gest];
}


-(void)checkboxTapped:(UITapGestureRecognizer *)gest
{
    UIImageView *img = (UIImageView *)gest.view;
    img.highlighted = !img.highlighted;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
