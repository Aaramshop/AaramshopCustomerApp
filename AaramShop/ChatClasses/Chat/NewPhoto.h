//
//  NewPhoto.h
//  SocialParty
//
//  Created by Shubhendu Shukla on 11/04/14.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    IMAGE_TYPE_DOWNLOAD_FROM_SERVER,
    IMAGE_TYPE_DOWNLOADING_FROM_SERVER,
    IMAGE_TYPE_DOWNLOADED,
    IMAGE_TYPE_UPLOAD_TO_SERVER,
    IMAGE_TYPE_UPLOADING_ON_SERVER,
    IMAGE_TYPE_UPLOADED
}ImageType;


@interface NewPhoto : NSObject

@property (nonatomic, strong) NSString *localId;
@property (nonatomic, strong) NSString *assetsId;
@property (nonatomic, strong) NSString *thumbUrl105px;
@property (nonatomic, strong) NSString *thumbUrl210px;
@property (nonatomic, strong) NSString *originalUrl;
@property (nonatomic, strong) NSString *imageBlur;
@property (nonatomic, strong) NSString *originalCompressImage;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) ImageType imageType;
@property (nonatomic, strong) UIImage *imgToUpload;
@property (nonatomic, strong) UIImage *imgThumbnail;
@property (nonatomic, strong) NSString *albumId;

@end
