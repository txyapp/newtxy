//
//  BaseViewController.h
//  TXYBaiDuNewApp
//
//  Created by yl on 15/9/23.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface BaseViewController : UIViewController<BMKMapViewDelegate,BMKPoiSearchDelegate>
{
    BMKMapView *_mapView;
    // annotation
    BMKPointAnnotation* myAnnotation;
    
    //搜索
    BMKPoiSearch* _search;//搜索要用到的
    UITextField *destinationText;
    CLLocationCoordinate2D startPt;
     
    //
    float localLatitude;
    float localLongitude;
}

@end
