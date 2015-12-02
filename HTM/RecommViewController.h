//
//  RecommViewController.h
//  HTM
//
//  Created by Prathamesh N. Saraf on 11/27/15.
//  Copyright (c) 2015 Prathamesh N. Saraf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate>
{
    NSMutableURLRequest *request;
    IBOutlet UIActivityIndicatorView *actInd;
    NSMutableArray *recommItem;
}
@property (strong, nonatomic) IBOutlet UITableView *recommTale;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
