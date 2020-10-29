//
//  TableViewCell.h
//  CovidReport
//
//  Created by Gabriel Betancourt on 10/21/20.
//  Copyright © 2020 mau5atron. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell

@property (weak, atomic) IBOutlet UILabel *tableCellDataLabel;
@property (weak, atomic) IBOutlet UIView *tableCellViewOutlet;

@end

NS_ASSUME_NONNULL_END
