//
//  QOrientation.h
//  QPanoramaKit_Debug
//
//  Created by xfang on 15/3/5.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#ifndef QORIENTATION_H
#define QORIENTATION_H

/*!
 *  @brief  偏航俯仰角结构体
 */
typedef struct {

    //偏航角
    const CLLocationDirection heading;
    
    //俯仰角
    const double pitch;
    
} QOrientation;

#ifdef __cplusplus
extern "C"{
#endif
    
static inline QOrientation QOrientationMake(CLLocationDirection heading, double pitch)
{
    QOrientation orientation = {heading, pitch};
    return orientation;
}
    
#ifdef __cplusplus
}
#endif

#endif