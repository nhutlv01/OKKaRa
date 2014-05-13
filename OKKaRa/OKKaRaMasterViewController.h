//
//  OKKaRaMasterViewController.h
//  OKKaRa
//
//  Created by Nhut on 3/11/14.
//  Copyright (c) 2014 Bean. All rights reserved.
//
#import "OKKaRaTableViewCell.h"

@interface OKKaRaMasterViewController : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate, NSFetchedResultsControllerDelegate ,OKKaRaTableViewCellDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, strong) UISearchDisplayController *searchDisplayController;
@property(nonatomic, strong) NSArray *fetchedObjects;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property int selectedRowIndex;
@property BOOL isKeyboardShow;

@end
