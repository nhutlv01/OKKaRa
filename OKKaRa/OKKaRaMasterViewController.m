
//  OKKaRaMasterViewController.m
//  OKKaRa
//
//  Created by Nhut on 3/11/14.
//  Copyright (c) 2014 Bean. All rights reserved.
//

#import "OKKaRaMasterViewController.h"
#import "Songs.h"
#import "OKKaRaSettingViewController.h"

@implementation OKKaRaMasterViewController

@synthesize fetchedObjects;
@synthesize searchDisplayController;
@synthesize fetchedResultsController;
@synthesize selectedRowIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedRowIndex = -1;
    //Can't scroll at the bottom
    self.searchDisplayController.searchResultsTableView.bounces = NO;
    self.tableView.bounces = NO;
    
    //Add gesture to table view
    
    UIScreenEdgePanGestureRecognizer *leftSwipe = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToSettingViewController:)];
    leftSwipe.edges = UIRectEdgeLeft;
    leftSwipe.delegate = self;
    [self.tableView addGestureRecognizer:leftSwipe];
    
    UIScreenEdgePanGestureRecognizer *rightSwipe = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToFavoriteViewController:)];
    rightSwipe.edges = UIRectEdgeRight;
    rightSwipe.delegate = self;
    [self.tableView addGestureRecognizer:rightSwipe];

    //Create UISearchBar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    [searchBar sizeToFit];
    searchBar.delegate = self;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.tintColor = [UIColor clearColor];
    searchBar.backgroundColor = [UIColor blueColor];
    
    //Create UISearchDisplayController
    self.searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController: self];
    self.searchDisplayController.delegate = self;
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;    
    [searchDisplayController.searchBar becomeFirstResponder];
    [self.searchDisplayController.searchBar setFrame:CGRectMake(0, 0, 100, 44)];

    //Clear the separator between cell
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //Add observer to notices when keyboard show or hide
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationItem setHidesBackButton:YES];
    //Set background
    UIImageView *backGroundView = [[UIImageView alloc] initWithImage:
                                   [(OKKaRaAppDelegate *)[[UIApplication sharedApplication] delegate] backgroundImage]];
    [self.tableView setBackgroundView:backGroundView];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - OKKaRaTableViewCellDelegate


- (void)cellDidTap:(OKKaRaTableViewCell *)cell {
    //Add song to favorite songs
    NSMutableArray *favoriteSongs = [[OKKaRaDataController sharedDataController] shareFavoriteSongs];
    
    //don't add if song already exists in favorite songs
    for (NSDictionary *dict in favoriteSongs) {
        if ([[dict objectForKey:@"code"] isEqualToString:cell.code.text]) {
            return;
        }
    }
    NSDictionary *song = [NSDictionary dictionaryWithObjectsAndKeys:cell.title.text, @"title", cell.lyric.text, @"lyric", cell.code.text, @"code", cell.source.text, @"source", nil];
    [favoriteSongs addObject:song];
}

- (UIColor*) colorOfCell {
    return [UIColor greenColor];    
}


#pragma mark - UISearchBarDelegate


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self killScroll];
    self.selectedRowIndex = -1;
    //unexpand before search
    [self updateTable];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:
                                   [(OKKaRaAppDelegate *)[[UIApplication sharedApplication] delegate] backgroundImage]];
    [self.searchDisplayController.searchResultsTableView setBackgroundView:backgroundView];
}



#pragma mark - UISearchDisplayDelegate

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    NSPredicate *predicate;
    if ([searchText length] > 0) {
        if ([searchText characterAtIndex:0] == ' ') {
            if ([searchText isEqualToString:@" vn"] || [searchText isEqualToString:@" en"]) {
                predicate = [NSPredicate predicateWithFormat:@"SELF.lang CONTAINS[cd] %@", [searchText substringFromIndex:1]];
            }
            else {
                predicate = [NSPredicate predicateWithFormat:@"SELF.lyric CONTAINS[cd] %@", [searchText substringFromIndex:1]];
            }
        } else {
            predicate = [NSPredicate predicateWithFormat:@"(SELF.search BEGINSWITH %@) OR (SELF.stand CONTAINS %@)",searchText, searchText];
        }
        fetchedObjects = [[[self.fetchedResultsController.sections objectAtIndex:0] objects] filteredArrayUsingPredicate:predicate];
        NSSortDescriptor *searchSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"search" ascending:YES];
        fetchedObjects = [fetchedObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:searchSortDescriptor]];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    fetchedObjects = nil;
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
    [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    //scroll to top
    [self.searchDisplayController.searchResultsTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.tableView == tableView) {
        id  sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else {
        return [fetchedObjects count] + 1;
    }
}

- (void)configureCell:(OKKaRaTableViewCell *)cell forTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    Songs *song;
    if (self.tableView == tableView) {
        song = [self.fetchedResultsController objectAtIndexPath:indexPath];
    } else {
        song = [fetchedObjects objectAtIndex:indexPath.row];
    }
    
    cell.title.text = song.title;
    cell.title.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    cell.title.textColor = [UIColor whiteColor];
    
    cell.code.text = [NSString stringWithFormat:@"%@", song.code];
    cell.code.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    cell.code.textColor = [UIColor whiteColor];
    
    cell.source.text = [NSString stringWithFormat:@"%@", song.source];
    cell.source.font = [UIFont fontWithName:@"Helvetica" size:15];
    cell.source.textColor = [UIColor whiteColor];
    
    cell.lyric.text = [NSString stringWithFormat:@"%@", song.lyric];
    cell.lyric.font = [UIFont fontWithName:@"Helvetica" size:15];
    cell.lyric.textColor = [UIColor whiteColor];
    
    cell.delegate = self;
    //set the style when the TableViewCell selected
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    OKKaRaTableViewCell *cell = (OKKaRaTableViewCell*) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[OKKaRaTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Create a empty cell at the bottom, it's make a white line at the bottom
    if (indexPath.row == [fetchedObjects count] && self.tableView != tableView) {
        OKKaRaTableViewCell *emptyCell = [[OKKaRaTableViewCell alloc] init];
        emptyCell.userInteractionEnabled = NO;
        return emptyCell;
    }
    [self configureCell:cell forTableView:tableView atIndexPath:indexPath];
    return cell;
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isKeyboardShow) {
        [self.searchDisplayController.searchBar resignFirstResponder];
        return;
    }
    if (self.selectedRowIndex == indexPath.row) {
        self.selectedRowIndex = -1;
        [self updateTable];
    }
    else {
        //Update table to default before expand row
        self.selectedRowIndex = -1;
        [self updateTable];
        //Row is selected
        self.selectedRowIndex = indexPath.row;
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        if ([self.searchDisplayController isActive]) {
            [self.searchDisplayController.searchResultsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
        [self updateTable];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.selectedRowIndex) {
        return 200;
    }
    return 70;
}


#pragma mark - NSFetchedResultsControllerDelegate


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(OKKaRaTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] forTableView:self.tableView atIndexPath:newIndexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray
                                                    arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray
                                                    arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}


#pragma mark - Helper


- (void)killScroll
{
    //stop scrolling animation when taps to search bar
    CGPoint offset = self.searchDisplayController.searchResultsTableView.contentOffset;
    [self.searchDisplayController.searchResultsTableView setContentOffset:offset animated:NO];
}

- (void)keyboardWillShow {
    self.isKeyboardShow = YES;
}

- (void)keyboardWillHide {
    self.isKeyboardShow = NO;
}

- (void)swipeToFavoriteViewController:(UIScreenEdgePanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.selectedRowIndex = -1;
        [self updateTable];
        [self.navigationController pushViewController:[(OKKaRaAppDelegate *)[[UIApplication sharedApplication] delegate] favoriteViewController] animated:YES];
    }
}

- (void)swipeToSettingViewController:(UIScreenEdgePanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)updateTable {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    if ([self.searchDisplayController isActive]) {
        [self.searchDisplayController.searchResultsTableView beginUpdates];
        [self.searchDisplayController.searchResultsTableView endUpdates];
    }
}
@end
