//
//  USStateDataTableViewController.m
//  CovidReport
//
//  Created by Gabriel Betancourt on 10/21/20.
//  Copyright © 2020 mau5atron. All rights reserved.
//

#import "USStateDataTableViewController.h"
#import "TableViewCell.h"
#import "StateDataViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface USStateDataTableViewController ()

@end

@implementation USStateDataTableViewController
@synthesize stateDataDict;

- (void)viewDidLoad {
    [super viewDidLoad];
//	fruits = @[@"Banana", @"Apple", @"Orange"];
	self.tableView.rowHeight = 100;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; // 1 section with all fruits
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return [stateDataDict count]; // number of cells
}

// setting up table view data cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	// setting up view cell
	TableViewCell *stateDataCell = [tableView dequeueReusableCellWithIdentifier: @"StateDataCell" forIndexPath:indexPath];
    
	// Configure the cell...
	//stateDataCell.tableCellDataLabel.text = stateDataArray[indexPath.row];
	NSString *key = [self.stateDataDict allKeys][indexPath.row];
	NSLog(@"Key val: %@", key);
	stateDataCell.tableCellDataLabel.text = key;
	stateDataCell.selectionStyle = UITableViewCellSelectionStyleNone;
	UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, stateDataCell.bounds.size.height - 0.5, stateDataCell.bounds.size.width, 1)];
	bottomLine.backgroundColor = [UIColor whiteColor];
	[stateDataCell.contentView addSubview:bottomLine];
	//[stateDataCell.layer setBorderColor:[UIColor redColor].CGColor];
	//[stateDataCell.layer setBorderWidth:1.0f];
	
	
	// try rendering this from viewdidload
	// creating bar within skeleton view
//	CALayer *barLayer = [CALayer layer];
//	barLayer.frame = CGRectMake(0, 0, 20.0f, stateDataCell.tableCellViewOutlet.bounds.size.height);
//	barLayer.backgroundColor = [UIColor blueColor].CGColor;
//	[stateDataCell.tableCellViewOutlet.layer addSublayer:barLayer];
//
//
//	// put this inside an animation block
//	[UIView animateWithDuration:5.0f delay:3.0f options:(UIViewAnimationOptions)UIViewAnimationCurveEaseIn animations:^{
////		barLayer.position = CGPointMake(stateDataCell.tableCellViewOutlet.bounds.size.width, stateDataCell.tableCellViewOutlet.bounds.size.height / 2);
//		barLayer.frame = CGRectMake(stateDataCell.tableCellViewOutlet.bounds.size.width, 0, 20.0f, stateDataCell.tableCellViewOutlet.bounds.size.height);
//	} completion:^(BOOL finished){
//		NSLog(@"Finished cell moving animation...");
//	}];
	
	
	return stateDataCell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	if ( [[segue identifier] isEqualToString:@"showStateData"] ){
		// if the sequence link (between cell StateDataViewController) -> showStateData
		// then do this
		
		StateDataViewController *stateDataView = [segue destinationViewController];
		NSIndexPath *idxPath = [self.tableView indexPathForSelectedRow];
		
		// NSDictionary *dict = fruits[idxPath.row];
		//stateDataView.stateDataTitle = stateDataArray[idxPath.row];
		NSString *key = [self.stateDataDict allKeys][idxPath.row];
		// this returns the object data {} for specific key state
		NSLog(@"Data from key: %@", [self.stateDataDict objectForKey:key]);
		//stateDataView.stateDataTitle = [self.stateDataDict allKeys][idxPath.row];
		// only send the object literal for the key, i.e. CA, FL
		stateDataView.stateDataDict = [(NSMutableDictionary *)self.stateDataDict objectForKey:key];
	}
}


@end
