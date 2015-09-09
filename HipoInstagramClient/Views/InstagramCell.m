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
#import <DateTools/DateTools.h>

@interface InstagramCell ()

@property (nonatomic) UIView *headerContainer;
@property (nonatomic) UILabel *loadingLabel;

@property (nonatomic) NSLayoutConstraint *aspectRatioConstraint;

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
    _avatar.layer.cornerRadius = [InstagramCell avatarSize].height / (CGFloat)2.0;
    _avatar.clipsToBounds = YES;
    [_headerContainer addSubview:_avatar];

    _username = [[UILabel alloc] initForAutoLayout];
    _username.adjustsFontSizeToFitWidth = YES;
    _username.minimumScaleFactor = 0.5;
    [_headerContainer addSubview:_username];

    _relativeTimestamp = [[UILabel alloc] initForAutoLayout];
    _relativeTimestamp.font = [UIFont systemFontOfSize:11];
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
    self.relativeTimestamp.text = asset.postDate.timeAgoSinceNow;

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

    
    [self.aspectRatioConstraint autoRemove];
    
    [NSLayoutConstraint autoSetPriority:999 forConstraints:^{
        self.aspectRatioConstraint = [self.photo autoMatchDimension:ALDimensionHeight
                                                        toDimension:ALDimensionWidth
                                                             ofView:self.photo
                                                     withMultiplier:(CGFloat)1.0 / [asset.image aspectRatio]];
    }];
}

- (void)setupConstraints
{
    [[_headerContainer autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero
                                                excludingEdge:ALEdgeBottom]
        autoIdentifyConstraints:@"header"];

    [[_avatar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5, 10, 5, 5)
                                       excludingEdge:ALEdgeTrailing]
        autoIdentifyConstraints:@"avatar"];
    [[_avatar autoSetDimensionsToSize:[InstagramCell avatarSize]]
        autoIdentifyConstraints:@"avatar size"];

    [[_username autoAlignAxisToSuperviewAxis:ALAxisHorizontal] autoIdentify:@"username"];
    [[_username autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:_avatar withOffset:10]
        autoIdentify:@"username"];
    [_username autoConstrainAttribute:ALAttributeTrailing toAttribute:ALAttributeLeading ofView:_relativeTimestamp withMultiplier:1 relation:NSLayoutRelationLessThanOrEqual];

    [[_relativeTimestamp autoAlignAxisToSuperviewAxis:ALAxisHorizontal]
        autoIdentify:@"relative timestamp"];
    [[_relativeTimestamp autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:10]
        autoIdentify:@"relative timestamp"];

    [[_photo autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop]
        autoIdentifyConstraints:@"photo 3 sides"];
    [[_photo autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_headerContainer]
        autoIdentify:@"photo top"];

    [[_loadingLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_photo]
        autoIdentify:@"loading label"];
    [[_loadingLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:_photo]
        autoIdentify:@"loading label"];
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
