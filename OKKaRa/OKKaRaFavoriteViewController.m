//
//  OKKaRaSearchViewController.m
//  OKKaRa
//
//  Created by Nhut on 3/11/14.
//  Copyright (c) 2014 Bean. All rights reserved.
//

#import "OKKaRaTableViewCell.h"
#import "OKKaRaFavoriteViewController.h"

@implementation OKKaRaFavoriteViewController {
    UILabel *label;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.tableView.bounces = NO;
    self.navigationItem.title = @"Bài hát yêu thích";
    self.selectedRowIndex = -1;
    //Add gesture to table view
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToMasterViewController:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    leftSwipe.delegate = self;
    [self.tableView addGestureRecognizer:leftSwipe];
    
    //Clear the separator between cell
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self showNoticeWhenNothingToDisplay];
    //Set background
    UIImage *image = [(OKKaRaAppDelegate *)[[UIApplication sharedApplication] delegate] backgroundImage];
    UIImageView *backGroundView = [[UIImageView alloc] initWithImage:image];
    [self.tableView setBackgroundView:backGroundView];
}


#pragma mark - OKKaRaTableViewCellDelegate


- (void)cellDidTap:(OKKaRaTableViewCell *)cell {
    //Delete song in favorite songs
    self.selectedRowIndex = -1;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [[[OKKaRaDataController sharedDataController] shareFavoriteSongs] removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    [self showNoticeWhenNothingToDisplay];
}

- (UIColor*)colorOfCell {
    return [UIColor redColor];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[OKKaRaDataController sharedDataController] shareFavoriteSongs] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    OKKaRaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[OKKaRaTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Create a empty cell at the bottom, it's make a white line at the bottom
    if (indexPath.row == [[[OKKaRaDataController sharedDataController] shareFavoriteSongs] count]) {
        OKKaRaTableViewCell *emptyCell = [[OKKaRaTableViewCell alloc] init];
        emptyCell.userInteractionEnabled = NO;
        return emptyCell;
    }
    NSDictionary *song = [[[OKKaRaDataController sharedDataController] shareFavoriteSongs] objectAtIndex:indexPath.row];
    cell.title.text = [song objectForKey:@"title"];
    cell.title.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    cell.title.textColor = [UIColor whiteColor];

    cell.code.text = [song objectForKey:@"code"];
    cell.code.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    cell.code.textColor = [UIColor whiteColor];
    
    cell.source.text = [song objectForKey:@"source"];
    cell.source.font = [UIFont fontWithName:@"Helvetica" size:15];
    cell.source.textColor = [UIColor whiteColor];
    
    cell.lyric.text = [song objectForKey:@"lyric"];
    cell.lyric.font = [UIFont fontWithName:@"Helvetica" size:15];
    cell.lyric.textColor = [UIColor whiteColor];
    cell.delegate = self;
    //set the style when the TableViewCell selected
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - Table view delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    }
    [self updateTable];
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


#pragma mark - Helper


- (void)updateTable {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void)swipeToMasterViewController:(UIScreenEdgePanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)showNoticeWhenNothingToDisplay {
    //show notice when nothing to display
    if ([[[OKKaRaDataController sharedDataController] shareFavoriteSongs] count] == 0) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height/2 -40, 480, 40)];
        label.text = @"Nhấn và giữ để thêm hoặc xoá bài hát yêu thích";
        label.font= [UIFont fontWithName:@"Helvetica" size:14];
        label.textColor = [UIColor whiteColor];
        [self.tableView addSubview:label];
    } else {
        [label removeFromSuperview];
    }
}
@end
