//
//  OKKaRaSettingViewController.m
//  OKKaRa
//
//  Created by Nhut on 4/4/14.
//  Copyright (c) 2014 Bean. All rights reserved.
//

#import "OKKaRaSettingViewController.h"

@implementation OKKaRaSettingViewController

- (id)init {
    self = [super init];
    if (self) {
        //Add scroller
        scroller = [[OKKaRaHorizontalScroller alloc] initWithFrame:CGRectMake(0, 60, self.tableView.frame.size.width, 120)];
        scroller.delegate = self;
        scroller.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.4];
        [self.tableView addSubview:scroller];
        [scroller reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Cài đặt";
    //Add gesture to view controller
    UIScreenEdgePanGestureRecognizer *rightSwipe = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToMasterViewController:)];
    rightSwipe.edges = UIRectEdgeRight;
    rightSwipe.delegate = self;
    [self.tableView addGestureRecognizer:rightSwipe];
    
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //Add Text View
    [self.tableView addSubview:[self textViewInit]];
}

- (void)viewWillAppear:(BOOL)animated {
    //Set background
    UIImage *image = [(OKKaRaAppDelegate *)[[UIApplication sharedApplication] delegate] backgroundImage];
    UIImageView *backGroundView = [[UIImageView alloc] initWithImage:image];
    [self.tableView setBackgroundView:backGroundView];
}


#pragma mark - OKKaRaHorizontalScrollerDelegate


- (NSInteger)numberOfViewsForHorizontalScroller:(OKKaRaHorizontalScroller *)scroller {
    return 7;
}

- (UIView*)horizontalScroller:(OKKaRaHorizontalScroller *)scroller viewAtIndex:(int)index {
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Background%d-568h@2x.png", index]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    return imageView;
}

- (void)horizontalScroller:(OKKaRaHorizontalScroller *)scroller clickedViewAtIndex:(int)index {
    //save current background index
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithInt:index] forKey:@"currentBackgroundIndex"];
    [userDefault synchronize];


    //set background image
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Background%d-568h@2x.png", index]];
    UIImageView *backGroundView = [[UIImageView alloc] initWithImage:image];
    [self.tableView setBackgroundView:backGroundView];
    [(OKKaRaAppDelegate *)[[UIApplication sharedApplication] delegate] setBackgroundImage:image];
}


#pragma mark - Helper


- (UITextView *)textViewInit {
    NSAttributedString *textString = [[NSAttributedString alloc] initWithString:@"o  Tìm kiếm theo tên bài hát: tên bài hát\n\n     VD: \"trai tim khong ngu yen\"\n\n     Hoặc: \"ttkny\"\n\n\no  Tìm kiếm bằng lời bài hát: dấu cách lời bài hát\n\n     VD: \" neu anh noi anh van chua yeu\"\n\n\no  Tìm kiếm nhạc Việt: dấu cách vn\n\n\no  Tìm kiếm nhạc nước ngoài: dấu cách en"
                                                                     attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:13], NSForegroundColorAttributeName:[UIColor whiteColor]}];
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:textString];
    NSLayoutManager *textLayout = [[NSLayoutManager alloc] init];
    // Add layout manager to text storage object
    [textStorage addLayoutManager:textLayout];
    // Create a text container
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.tableView.bounds.size];
    // Add text container to text layout manager
    [textLayout addTextContainer:textContainer];
    // Instantiate UITextView object using the text container
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 240,self.tableView.frame.size.width, self.tableView.frame.size.height - 284  ) textContainer:textContainer];
    // Add text view to the main view of the view controler
    textView.scrollEnabled = YES;
    textView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.4];
    textView.editable = NO;
    textView.bounces = NO;
    return textView;
}

- (void)swipeToMasterViewController:(UIScreenEdgePanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.navigationController pushViewController:[(OKKaRaAppDelegate *)[[UIApplication sharedApplication] delegate] masterViewController] animated:YES];
    }
}
@end
