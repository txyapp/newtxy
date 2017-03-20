//
//  QPanoramaView.h
//  QPanoramaKit_Debug
//
//  Created by xfang on 15/2/12.
//  Copyright (c) 2015年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "QPanorama.h"
#import "QPanoramaCamera.h"
#import "QPanoramaCameraUpdate.h"
#import "QOrientation.h"
#import "QPanoAnnotation.h"
#import "QPanoAnnotationView.h"

/** 偏航角动画key [-180, 180). */
extern NSString *const kQLayerPanoramaHeadingKey;

/** 俯仰角动画key [-90, 10]. */
extern NSString *const kQLayerPanoramaPitchKey;

/** 缩放级别key [0, 2], 默认 0. */
extern NSString *const kQLayerPanoramaZoomKey;

@protocol QPanoramaViewDelegate;

/*!
 *   @brief  承载街景的view,提供添加标注,切换场景,视角变换,动画等功能
 */
@interface QPanoramaView : UIView



@property (nonatomic, strong) QPanorama *panorama;

@property (nonatomic, weak) id<QPanoramaViewDelegate> delegate;

/*!
 *  @brief  同时设置拖动缩放手势
 *
 *  @param enabled 是否允许手势操作
 */
- (void)setAllGesturesEnabled:(BOOL)enabled;

/*!
 *  @brief  是否允许手势拖动来改变街景视角
 */
@property (nonatomic, getter=isOrientationEnabled) BOOL orientationEnabled;

/*!
 *  @brief  是否支持手势缩放场景(双指放大/缩小, 单指双击放大)
 */
@property (nonatomic, getter=isZoomEnabled) BOOL zoomEnabled;

/*!
 *  @brief  场景导航链接是否可点击
 */
@property (nonatomic, getter=isNavigationEnable) BOOL navigationEnable;

/*!
 *  @brief  是否隐藏场景内景链接
 */
@property (nonatomic, getter=isIndoorLinksHidden) BOOL indoorLinksHidden;

/*!
 *  @brief  是否隐藏场景导航链接
 */
@property (nonatomic, getter=isNavigationLinksHidden) BOOL navigationLinksHidden;

/*!
 *  @brief  是否隐藏道路名
 */
@property (nonatomic, getter=isStreetNamesHidden) BOOL streetNamesHidden;

/*!
 *  @brief  是否隐藏内景场景选择栏(保留退出按钮)
 */
@property (nonatomic, getter=isParkViewHidden) BOOL parkViewHidden;

/*!
 *  @brief  是否隐藏内景场景选择栏(不保留退出按钮)
 */
@property (nonatomic, getter=isAllParkViewHidden) BOOL allParkViewHidden;

/*!
 *  @brief  是否使用方向传感器自动移动视角
 */
@property (nonatomic, getter=isMotionEnable) BOOL motionEnable;

/*!
 *  @brief  QCamera对象,控制场景视角
 */
@property (nonatomic, strong) QPanoramaCamera *camera;

/*!
 *  @brief  指定视角变换 俯仰角Pitch区间 -90 到 10, 偏航角heading -180 到 180
 *
 *  @param camera   视角
 *  @param duration 动画时间
 */
- (void)animateToCamera:(QPanoramaCamera *)camera animationDuration:(NSTimeInterval)duration;

/*!
 *  @brief  指定视角变换增量
 *
 *  @param cameraUpdate 视角增量
 *  @param duration     动画时间
 */
- (void)updateCamera:(QPanoramaCameraUpdate *)cameraUpdate animationDuration:(NSTimeInterval)duration;

/*!
 *  @brief  移动到指定的位置
 *
 *  @param coordiante 描述位置的经纬度
 */
- (void)moveToNearCoordinate:(CLLocationCoordinate2D)coordiante;

/*!
 *  @brief  移动到指定的位置
 *
 *  @param coordinate 描述位置的经纬度
 *  @param radius     吸附半径
 */
- (void)moveNearCoordinate:(CLLocationCoordinate2D)coordinate
                    radius:(NSUInteger)radius;

/*!
 *  @brief  移动到指定panoramaID的位置
 *
 *  @param panoramaID 街景ID
 */
- (void)moveToPanoramaID:(NSString *)panoramaID;


/*!
 *  @brief  根据经纬度吸附街景点
 *
 *  @param frame    尺寸
 *  @param coordinate 经纬度
 *
 *  @return 实例
 */
+ (instancetype)panoramaViewWithFrame:(CGRect)frame
                       nearCoordinate:(CLLocationCoordinate2D)coordinate;

/*!
 *  @brief  根据经纬度和吸附半径确定街景点
 *
 *  @param frame      尺寸
 *  @param coordinate 经纬度
 *  @param radius     吸附半径
 *
 *  @return 实例
 */
+ (instancetype)panoramaViewWithFrame:(CGRect)frame
                   nearCoordinate:(CLLocationCoordinate2D)coordinate
                           radius:(NSUInteger)radius;


/*!
 *  @brief  添加标注
 *
 *  @param annotation 标注
 */
- (void)addAnnotation:(id<QPanoAnnotation>)annotation;

/*!
 *  @brief  添加一组标注
 *
 *  @param annotations 标注数组
 */
- (void)addAnnotations:(NSArray *)annotations;

/*!
 *  @brief  删除标注
 *
 *  @param annotation 待删除的标注
 */
- (void)removeAnnotation:(id<QPanoAnnotation>)annotation;

/*!
 *  @brief  删除一组标注
 *
 *  @param annotations 待删除的标注数组
 */
- (void)removeAnnotations:(NSArray *)annotations;

/*!
 *  @brief  街景当前标注数组
 */
@property (nonatomic, readonly) NSArray *annotations;

/*!
 *  @brief  获取标注视图
 *
 *  @param annotation 视图对应标注
 *
 *  @return 标注视图
 */
- (QPanoAnnotationView *)viewForAnnotation:(id<QPanoAnnotation>)annotation;

/*!
 *  @brief  根据复用id获取annotation view
 *
 *  @param identifier 复用标识
 *
 *  @return 标注视图
 */
- (QPanoAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier;

@end

@interface QPanoramaView (Coordinate)

/*!
 *  @brief  根据经纬度和高度获取所在屏幕坐标
 *
 *  @param coordinate 经纬度
 *  @param height     高度
 *
 *  @return 屏幕坐标
 */
- (CGPoint)pointFromCoordinate:(CLLocationCoordinate2D)coordinate height:(CGFloat)height;

@end


@protocol QPanoramaViewDelegate <NSObject>

@optional

#pragma mark - Annotation
/*!
 *  @brief  根据annotation生成对应的view
 *
 *  @param panoramaView 街景视图
 *  @param annotation   指定的标注
 *
 *  @return 标注对应view
 */
- (QPanoAnnotationView *)panoramaView:(QPanoramaView *)panoramaView viewForAnnotation:(id<QPanoAnnotation>)annotation;

/*!
 *  @brief  当panoramaView新添加annotationViews时, 调用此接口
 *
 *  @param panoramaView 街景view
 *  @param views        添加的annotation views
 */
- (void)panoramaView:(QPanoramaView *)panoramaView didAddAnnotationViews:(NSArray *)views;

/*!
 *  @brief  当选中一个annotation view的时候调用此接口
 *
 *  @param panoramaView 街景view
 *  @param view         选中的annotation view
 */
- (void)panoramaView:(QPanoramaView *)panoramaView didSelectAnnotationView:(QPanoAnnotationView *)view;

/*!
 *  @brief  当取消选中一个annotation view的时候调用此接口
 *
 *  @param panoramaView 街景view
 *  @param view         被取消选中的annotation view
 */
- (void)panoramaView:(QPanoramaView *)panoramaView didDeselectAnnotationView:(QPanoAnnotationView *)view;

/*!
 *  @brief  标注view的accessory view(必须继承自UIControl)被点击时，触发该回调
 *
 *  @param panoramaView 街景view
 *  @param view         callout所属标注view
 *  @param control      对应control
 */
- (void)panoramaView:(QPanoramaView *)panoramaView annotationView:(QPanoAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;

#pragma mark - Others

/*!
 *  @brief  当场景即将发生变化的时候调用 调用时view.panorama依然是旧的panorama
 *
 *  @param panoramaView
 *  @param panoramaID   街景id
 */
- (void)panoramaView:(QPanoramaView *)panoramaView willMoveToPanoramaID:(NSString *)panoramaID;

/*!
 *  @brief  当panoramaView的panorama属性变化时调用
 *
 */
- (void)panoramaView:(QPanoramaView *)panoramaView didMoveToPanorama:(QPanorama *)panorama;

/*!
 *  @brief  当场景发生变化时调用
 *
 *  @param panoramaView panoramaView
 *  @param panorama     panorama数据
 *  @param coordinate   经纬度
 */
- (void)panoramaView:(QPanoramaView *)panoramaView didMoveToPanorama:(QPanorama *)panorama nearCoordinate:(CLLocationCoordinate2D)coordinate;

/*!
 *  @brief  当场景发生变化出错时调用 包括初始化时
 *
 *  @param view       QPanoramaView
 *  @param error      错误信息
 *  @param coordinate 经纬度
 */
- (void)panoramaView:(QPanoramaView *)view
               error:(NSError *)error
onMoveNearCoordinate:(CLLocationCoordinate2D)coordinate;


/*!
 *  @brief  当调用(moveToPanoramaID)场景发生变化出错时调用
 *
 *  @param view       QPanoramaView
 *  @param error      错误信息
 *  @param panoramaID 街景id
 */
- (void)panoramaView:(QPanoramaView *)view
               error:(NSError *)error
  onMoveToPanoramaID:(NSString *)panoramaID;

/*!
 *  @brief  当camera发生变化的时候调用
 *
 */
- (void)panoramaView:(QPanoramaView *)panoramaView
       didMoveCamera:(QPanoramaCamera *)camera;

/*!
 *  @brief  街景视图被点击是调用
 *
 *  @param panoramaView 街景view
 *  @param point        点击位置
 */
- (void)panoramaView:(QPanoramaView *)panoramaView didTap:(CGPoint)point;


@end