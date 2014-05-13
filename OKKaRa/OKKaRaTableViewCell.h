//
//  OKKaRaTableViewCell.h
//  OKKaRa
//
//  Created by Nhut on 3/11/14.
//  Copyright (c) 2014 Bean. All rights reserved.
//

@protocol OKKaRaTableViewCellDelegate;

@interface OKKaRaTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel *code;
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UILabel *lyric;
@property(nonatomic, strong) UILabel *source;
@property(assign) id<OKKaRaTableViewCellDelegate> delegate;

@end

//Declare protocol
@protocol OKKaRaTableViewCellDelegate <NSObject>
@required
- (void)cellDidTap:(OKKaRaTableViewCell*)cell;
- (UIColor *)colorOfCell;
@end
