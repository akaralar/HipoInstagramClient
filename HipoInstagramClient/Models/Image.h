//
//  Image.h
//  HipoInstagramClient
//
//  Created by Ahmet Karalar on 09/09/15.
//  Copyright (c) 2015 akaralar. All rights reserved.
//

#import "BaseModel.h"
#import <Mantle/MTLJSONAdapter.h>
#import <CoreGraphics/CGGeometry.h>

@interface Image : BaseModel <MTLJSONSerializing>

@property (nonatomic) NSURL *imageURL;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

- (CGFloat)aspectRatio; // width / height

@end
