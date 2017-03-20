//
//  GoogleMapTileImageOperation.m
//  TXYGoogleTest
//
//  Created by aa on 16/7/28.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "GoogleMapTileImageOperation.h"
#import "GoogleMapTileImageView.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@implementation GoogleMapTileImageOperation

+ (void)MapTileImageDownloadInit
{
    [SDWebImageManager sharedManager].imageDownloader.maxConcurrentDownloads = 6;
}

+ (void)loadMapTileImages:(NSArray *)googleMapTileImageViews
{
    for (GoogleMapTileImageView *imageView in googleMapTileImageViews) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageView.mapTileInfo.mapTileURLString]];
    }
}

+ (void)loadMapTileImagesCancel
{
    [[SDWebImageManager sharedManager] cancelAll];
}

+ (void)clearMapTileMemoryCache
{
    [[SDImageCache sharedImageCache] clearMemory];
}

+ (void)clearMapTileDiskCache
{
    [[SDImageCache sharedImageCache] clearDisk];
}

+ (NSString *)getMapTileCacheSize
{
    NSUInteger intg = [[SDImageCache sharedImageCache] getSize];
    return [self fileSizeWithInterge:intg];
}

+ (NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}

@end
