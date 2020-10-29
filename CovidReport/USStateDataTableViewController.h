//
//  USStateDataTableViewController.h
//  CovidReport
//
//  Created by Gabriel Betancourt on 10/21/20.
//  Copyright © 2020 mau5atron. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface USStateDataTableViewController : UITableViewController

// error, cant be attached to repeating content
// @property (weak, nonatomic) IBOutlet UIView *skeletonViewOutlet;
@property (strong, nonatomic) NSDictionary *stateDataDict;

@end

NS_ASSUME_NONNULL_END
