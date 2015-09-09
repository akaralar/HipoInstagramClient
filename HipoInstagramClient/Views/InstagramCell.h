//
//  InstagramCell.h
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 08/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Asset;

@interface InstagramCell : UITableViewCell

@property (nonatomic) UIImageView *avatar;
@property (nonatomic) UILabel *username;
@property (nonatomic) UILabel *relativeTimestamp;
@property (nonatomic) UIImageView *photo;

- (void)bindAsset:(Asset *)asset;

@end
