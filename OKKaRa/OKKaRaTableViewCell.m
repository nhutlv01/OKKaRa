//
//  OKKaRaTableViewCell.m
//  OKKaRa
//
//  Created by Nhut on 3/11/14.
//  Copyright (c) 2014 Bean. All rights reserved.
//

#import "OKKaRaTableViewCell.h"

@implementation OKKaRaTableViewCell
@synthesize lyric, code, title, source;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // change size as you need.
        UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 0.8)];

        // you can also put image here or transparent color as required in your case.
        separatorLineView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:separatorLineView];
        
        // Initialization code
        self.contentView.backgroundColor = [UIColor clearColor];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 480, 25)];
        code = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 80, 30)];
        source = [[UILabel alloc] initWithFrame:CGRectMake(10, 145, 480, 30)];
        lyric = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 300, 30)];

        [self addSubview:title];
        [self addSubview:lyric];
        [self addSubview:code];
        [self addSubview:source];

        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
        gesture.minimumPressDuration = 0.5;
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)gestureAction:(UILongPressGestureRecognizer*) gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self setBackgroundColor:[self.delegate colorOfCell]];
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self.delegate cellDidTap:self];
    }
}


@end
