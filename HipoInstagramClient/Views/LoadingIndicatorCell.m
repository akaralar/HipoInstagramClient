//
//  LoadingIndicatorCell.m
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 08/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "LoadingIndicatorCell.h"
#import <PureLayout/PureLayout.h>

@implementation LoadingIndicatorCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (!self) {
        return nil;
    }

    _loadingIndicator = [[UIActivityIndicatorView alloc]
        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_loadingIndicator startAnimating];

    [self.contentView addSubview:_loadingIndicator];

    [_loadingIndicator autoPinEdge:ALEdgeTop
                            toEdge:ALEdgeTop
                            ofView:self.contentView
                        withOffset:10];
    [_loadingIndicator autoPinEdge:ALEdgeBottom
                            toEdge:ALEdgeBottom
                            ofView:self.contentView
                        withOffset:-10];
    [_loadingIndicator autoAlignAxis:ALAxisVertical toSameAxisOfView:self.contentView];


    return self;
}

- (void)prepareForReuse
{
    [self.loadingIndicator startAnimating];
}

@end
