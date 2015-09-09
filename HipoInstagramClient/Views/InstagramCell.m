//
//  InstagramCell.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 08/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "InstagramCell.h"

#import <PureLayout/PureLayout.h>

@interface InstagramCell ()

@property (nonatomic) UIView *headerContainer;
@property (nonatomic) UILabel *loadingLabel;

- (void)setupConstraints;

@end

@implementation InstagramCell

+ (CGSize)avatarSize
{
    return CGSizeMake(30, 30);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (!self) {
        return nil;
    }

    _headerContainer = [[UIView alloc] initForAutoLayout];
    [self.contentView addSubview:_headerContainer];

    _avatar = [[UIImageView alloc] initForAutoLayout];
    ;
    _avatar.layer.cornerRadius = [InstagramCell avatarSize].height / 2.0;
    [_headerContainer addSubview:_avatar];

    _username = [[UILabel alloc] initForAutoLayout];
    [_headerContainer addSubview:_username];

    _relativeTimestamp = [[UILabel alloc] initForAutoLayout];
    [_headerContainer addSubview:_relativeTimestamp];

    _loadingLabel = [[UILabel alloc] initForAutoLayout];
    _loadingLabel.text = NSLocalizedString(@"LOADING", nil);
    [self.contentView addSubview:_loadingLabel];

    _photo = [[UIImageView alloc] initForAutoLayout];
    _photo.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_photo];

    [self setupConstraints];

    return self;
}

- (void)setupConstraints
{
    [_headerContainer autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                               excludingEdge:ALEdgeBottom];

    [_avatar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5, 10, 5, 5)
                                      excludingEdge:ALEdgeTrailing];
    [_avatar autoSetDimensionsToSize:[InstagramCell avatarSize]];
    
    [_username autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [_relativeTimestamp autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_relativeTimestamp autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:10];
    
    [_photo autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_headerContainer];
    [_photo autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];
    
    [_loadingLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_photo];
    [_loadingLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:_photo];
}

- (void)prepareForReuse
{
    self.avatar.image = nil;
    self.photo.image = nil;
    self.loadingLabel.alpha = 1;
}

@end
