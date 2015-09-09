//
//  InstagramCell.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 08/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "InstagramCell.h"
#import "Asset.h"
#import "User.h"
#import "Image.h"

#import <PureLayout/PureLayout.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

static NSDateFormatter *kRelativeTimestampFormatter = nil;

@interface InstagramCell ()

@property (nonatomic) UIView *headerContainer;
@property (nonatomic) UILabel *loadingLabel;

//@property (nonatomic) NSLayoutConstraint *aspectRatioConstraint;

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

    if (!kRelativeTimestampFormatter) {

        kRelativeTimestampFormatter = [[NSDateFormatter alloc] init];
        kRelativeTimestampFormatter.timeStyle = NSDateFormatterMediumStyle;
        kRelativeTimestampFormatter.dateStyle = NSDateFormatterMediumStyle;
        kRelativeTimestampFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];

        kRelativeTimestampFormatter.doesRelativeDateFormatting = YES;
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

- (void)bindAsset:(Asset *)asset
{
    NSURLRequest *avatarRequest = [NSURLRequest requestWithURL:asset.owner.avatarURL];
    __weak typeof(self) weakSelf = self;
    [self.avatar setImageWithURLRequest:avatarRequest
                       placeholderImage:nil
                                success:^(NSURLRequest *__nonnull request,
                                          NSHTTPURLResponse *__nonnull response,
                                          UIImage *__nonnull image) {

                                    __strong typeof(self) strongSelf = weakSelf;
                                    strongSelf.avatar.image = image;
                                    [UIView animateWithDuration:0.2
                                                     animations:^{  //
                                                         strongSelf.avatar.alpha = 1;
                                                     }];

                                }
                                failure:nil];

    self.username.text = asset.owner.username;
    self.relativeTimestamp.text = [kRelativeTimestampFormatter stringFromDate:asset.postDate];

    NSURLRequest *photoRequest = [NSURLRequest requestWithURL:asset.image.imageURL];
    [self.photo setImageWithURLRequest:photoRequest
                      placeholderImage:nil
                               success:^(NSURLRequest *__nonnull request,
                                         NSHTTPURLResponse *__nonnull response,
                                         UIImage *__nonnull image) {

                                   __strong typeof(self) strongSelf = weakSelf;
                                   strongSelf.photo.image = image;
                                   [UIView animateWithDuration:0.2
                                                    animations:^{  //
                                                        strongSelf.photo.alpha = 1;
                                                        strongSelf.loadingLabel.hidden = YES;
                                                    }];
                               }
                               failure:nil];
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
    self.avatar.alpha = 0;
    self.photo.image = nil;
    self.photo.alpha = 0;

    self.loadingLabel.hidden = NO;
    self.loadingLabel.text = NSLocalizedString(@"LOADING", nil);
}

@end
