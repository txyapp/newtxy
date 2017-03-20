//
//  MapTileConvert.h
//  GoogleTMS
//
//  Created by aa on 16/7/18.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#ifndef MapTileConvert_h
#define MapTileConvert_h

#include <stdio.h>
int long2tilex(double lon, int z);
int lat2tiley(double lat, int z);
double tilex2long(int x, int z);
double tiley2lat(int y, int z);


#endif /* MapTileConvert_h */
