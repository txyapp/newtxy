 /*
 ============================================================================
 Name           : QMapView.h
 Author         : 腾讯SOSO地图
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QMapView declaration
 ============================================================================
 */

/**    @file QMapView.h     */

#import <UIKit/UIKit.h>
#import "QOverlay.h"
#import "QOverlayView.h"
#import "QGeometry.h"
#import "QTypes.h"
#import "QUserLocation.h"
#import "QRoute.h"
#import "QRouteSearch.h"
#import "QOverlay.h"
#import "QTileOverlay.h"

#import "QAnnotation.h"
#import "QAnnotationView.h"

@class QRouteResult;
@class QOPointAnnotation;
@protocol QMapViewDelegate;
@protocol QMapNavigationDelegate;

/*!
 *  @brief  地图view主类
 */
@interface QMapView : UIView

/*!
 *  @brief  地图view的delegate
 */
@property(nonatomic, assign) id <QMapViewDelegate> delegate;

/*!
 *  @brief  导航专用的Delegate
 */
@property(nonatomic, assign) id <QMapNavigationDelegate> navDelegate;

/*!
 *  @brief  地图类型, 默认为 QMapTypeStandard
 */
@property(nonatomic, assign) QMapType mapType;

/*!
 *  @brief  是否显示交通, 默认为NO
 */
@property(nonatomic)BOOL showTraffic;

/*!
 *  @brief  是否3D模式显示地图, 默认为NO.
 * @note 有动画，非立即生效
 */
@property(nonatomic)BOOL show3D;

/*!
 *  @brief  楼块是否显示2D效果, 默认为NO
 */
@property (nonatomic, assign, getter = isDisable3DBuildingEffect) BOOL disable3DBuildingEffect;

/*!
 *  @brief  缩放级别, 可使用的级别为3-19级
 */
@property(nonatomic, assign) NSInteger zoomLevel;

/*!
 *  @brief  是否显示指南针, 默认为YES.
 */
@property(nonatomic) BOOL showsCompass;

/*!
 *  @brief  定位用户位置的模式
 */
@property (nonatomic) QMUserTrackingMode userTrackingMode;

/*!
 *  @brief  设备更新位置信息的最小距离
 */
@property(assign, nonatomic) CLLocationDistance distanceFilter;

/*!
 *  @brief  位置数据的精度
 */
@property(assign, nonatomic) CLLocationAccuracy desiredAccuracy;

/*!
 *  @brief  当前地图的经纬度范围，设定的该范围可能会被调整为适合地图窗口显示的范围
 */
@property(nonatomic) QCoordinateRegion region;

/*!
 * @brief 是否显示比例尺
 */
@property (nonatomic, assign) BOOL  showScale;

/*!
 * @brief 获取旋转角度. 0-360之间.(正北为0,逆时针为正向)
 */
@property (nonatomic, readonly) CGFloat rotation;

/**
 * @brief 设置地图Logo偏移
 *
 * @param offset Logo中心的偏移量. 如果offset为CGPointZeor则为默认位置
 */
- (void)setLogoOffSet:(CGPoint)offset;

/*!
 *  @brief  设置当前地图可见范围的region
 *
 *  @param mapRect  目标region
 *  @param animated 是否采用动画
 */
- (void)setRegion:(QCoordinateRegion)region animated:(BOOL)animated;

/*!
 *  @brief  当前地图的中心点经纬度坐标，改变该值时，地图缩放级别不会发生变化
 */
@property(nonatomic) CLLocationCoordinate2D centerCoordinate;

/*!
 *  @brief  设定地图中心点经纬度
 *
 *  @param coordinate 要设定的地图中心点经纬度
 *  @param animated   是否采用动画
 */
- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;

/*!
 *  @brief  设定地图中心点经纬度
 *
 *  @param coordinate 要设定的地图中心点经纬度
 *  @param zoomLevel  要设定的地图的比例尺级别
 *  @param animated   是否采用动画
 */
- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate zoomLevel:(int)zoomLevel animated:(BOOL)animated;

/**
 * @brief 设定地图旋转角度
 *
 * @param rotationDegree	旋转角度 (正北为0,逆时针为正向)
 * @param animated	是否有动画效果。
 */
- (void)setRotate:(CGFloat)rotationDegree animated:(BOOL)animated;

/*!
 *  @brief  在显示MapView的Controlller的ViewWillAppear中调用，进行地图的显示
 */
- (void)viewWillAppear ;

/*!
 *  @brief  在显示MapView的Controlller的ViewDidDisppear中调用, 停止地图显示
 */
- (void)viewDidDisappear;

/*!
 *  @brief  根据当前地图View的窗口大小调整传入的region，返回适合当前地图窗口显示的region，调整过程会保证中心点不改变
 *  @param region  待调整的经纬度范围
 *  @return 调整后适合当前地图窗口显示的经纬度范围
 */
- (QCoordinateRegion)regionThatFits:(QCoordinateRegion)region;

/*!
 *  @brief  当前地图可见范围的mapRect
 */
@property(nonatomic) QMapRect visibleMapRect;

/*!
 *  @brief  设置当前地图可见范围的mapRect
 *
 *  @param mapRect  目标mapRect
 *  @param animated 是否采用动画
 */
- (void)setVisibleMapRect:(QMapRect)mapRect animated:(BOOL)animated;

/*!
 *  @brief  规格化mapRect
 *
 *  @param mapRect  要调整的mapRect
 *
 *  @return 规格化后的mapRect
 */
- (QMapRect)mapRectThatFits:(QMapRect)mapRect;

/*!
 *  @brief  设置当前地图可见范围的mapRect
 *
 *  @param mapRect  目标mapRect
 *  @param insets   要嵌入的边界
 *  @param animated 是否采用动画
 */
- (void)setVisibleMapRect:(QMapRect)mapRect edgePadding:(UIEdgeInsets)insets animated:(BOOL)animated;

/*!
 *  @brief  规格化mapRect
 *
 *  @param mapRect  要调整的mapRect
 *  @param insets   嵌入尺寸
 *
 *  @return 规格化后的mapRect
 */
- (QMapRect)mapRectThatFits:(QMapRect)mapRect edgePadding:(UIEdgeInsets)insets;

/*!
 *  @brief  将经纬度坐标转化为相对于指定view的坐标
 *
 *  @param coordinate 要转化的经纬度坐标
 *  @param view       point所基于的view
 *
 *  @return 源经纬度在目标view上的坐标
 */
- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(UIView *)view;

/*!
 *  @brief  将相对于view的坐标转化为经纬度坐标
 *
 *  @param point 要转化的坐标
 *  @param view  point所基于的view
 *
 *  @return 源point转化后的经纬度
 */
- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(UIView *)view;

/*!
 *  @brief  将地图上的region转化为相对于view的rectangle
 *
 *  @param region 要转化的region
 *  @param view   rectangle所基于的view
 *
 *  @return 转化后的rectangle
 */
- (CGRect)convertRegion:(QCoordinateRegion)region toRectToView:(UIView *)view;

/*!
 *  @brief  将相对于view的rectangle转化为region
 *
 *  @param rect 要转化的rectangle
 *  @param view rectangle所基于的view
 *
 *  @return 转化后的region
 */
- (QCoordinateRegion)convertRect:(CGRect)rect toRegionFromView:(UIView *)view;

/*!
 *  @brief  是否支持缩放, 默认为YES
 */
@property(nonatomic, getter=isZoomEnabled) BOOL zoomEnabled;

/*!
 *  @brief  是否支持平移, 默认为YES
 */
@property(nonatomic, getter=isScrollEnabled) BOOL scrollEnabled;

/*!
 *  @brief  是否支持手势进入3D模式. 默认为YES.
 */
@property (nonatomic, assign, getter=isPitchEnabled) BOOL pitchEnabled;

/*!
 *  @brief  是否支持按照中心点缩放, 默认为NO.
 */
@property (nonatomic, assign, getter=isStayCenteredDuringZoom) BOOL stayCenteredDuringZoom;

/*!
 *  @brief  是否显示用户位置, 默认为NO
 */
@property(nonatomic) BOOL showsUserLocation;

/*!
 *  @brief  是否隐藏定位精度圈. 默认为NO.
 */
@property(nonatomic, assign) BOOL hideAccuracyCircle;

/*!
 *  @brief  当前用户位置数据
 */
@property(nonatomic, readonly) QUserLocation *userLocation;


#pragma mark -

/*!
 *  @brief  启动导航
 */
-(BOOL)startNavigation;

/*!
 *  @brief  地图是否在导航状态
 */
@property(assign, nonatomic, readonly) BOOL isNavigation;

/*!
 *  @brief  根据搜索结果绘制导航路线
 *
 *  @param routeResult navRouteSearchWithLocation 回调方法返回的RouteResult
 *  @param routeColor 绘制线路颜色
 */
-(void)showSearchRoute:(QRouteResult*) routeResult routeColor:(QMRouteColor)routeColor;

/*!
 *  @brief  根据搜索结果绘制导航路线,途经点算路
 *
 *  @param routeResult navRouteSearchWithLocation 回调方法返回的RouteResult
 *  @param lineArray 线路Array. 参考QRoutePassbySegment
 */
-(void)showSearchRoute:(QRouteResult*) routeResult lineArray:(NSArray*)lineArray;

/*!
 *  @brief  停止导航（导航启动后调用此方法）
 */
-(void)stopNavigation;

/*!
 *  @brief  清除路线规划
 *
 *  @return 是否成功，如返回为NO则表示当前正在导航中
 */
-(BOOL)removeRoute;

/*!
 *  @brief  继续导航
 */
- (void)continueNavigation;

/*!
 *  @brief  修改路线纹理绘制类型
 *
 *  @param routeDrawType 路线绘制类型
 *  @param routeIndex    同时绘制多条路线时的路线索引值
 */
- (void)setRouteDrawType:(QMRouteDrawType)routeDrawType routeIndex:(NSInteger)routeIndex;

/*!
 *  @brief  修改路线纹理图片
 *
 *  @param textureName 路线纹理图片文件名，需要工程载入图片资源
 *  @param routeIndex    同时绘制多条路线时的路线索引值
 *  @param routeDrawType 路线绘制类型
 */
- (void)setRouteDrawTexture:(NSString*)textureName routeIndex:(NSInteger)routeIndex routeDrawType:(QMRouteDrawType)routeDrawType;

@end

/*!
 *  @brief  QMapView的覆盖物相关方法
 */
@interface QMapView (OverlaysAPI)

/*!
 *  @brief  向地图窗口添加overlay，需要实现QMapViewDelegate的-mapView:viewForOverlay:函数来生成标注对应的view
 *
 *  @param overlay 要添加的overlay
 */
- (void)addOverlay:(id <QOverlay>)overlay;

/*!
 *  @brief  向地图窗口添加一组overlay，需要实现QMapViewDelegate的-mapView:viewForOverlay:函数来生成标注对应的view
 *
 *  @param overlays 要添加的overlay数组
 */
- (void)addOverlays:(NSArray *)overlays;

/*!
 *  @brief  移除overlay
 *
 *  @param overlay 要移除的overlay
 */
- (void)removeOverlay:(id <QOverlay>)overlay;

/*!
 *  @brief  移除一组overlay
 *
 *  @param overlays 要移除的overlay数组
 */
- (void)removeOverlays:(NSArray *)overlays;

/*!
 *  @brief  在指定的索引出添加一个overlay
 *
 *  @param overlay 要添加的overlay
 *  @param index   指定的索引
 */
- (void)insertOverlay:(id <QOverlay>)overlay atIndex:(NSUInteger)index;

/*!
 *  @brief  交换指定索引处的overlay
 *
 *  @param index1 索引1
 *  @param index2 索引2
 */
- (void)exchangeOverlayAtIndex:(NSUInteger)index1 withOverlayAtIndex:(NSUInteger)index2;

/*!
 *  @brief  在指定的overlay之上插入一个overlay
 *
 *  @param overlay 待添加的overlay
 *  @param sibling 用于指定位置的overlay
 */
- (void)insertOverlay:(id <QOverlay>)overlay aboveOverlay:(id <QOverlay>)sibling;

/*!
 *  @brief  在指定的overlay之下插入一个overlay
 *
 *  @param overlay 待添加的overlay
 *  @param sibling 用于指定位置的overlay
 */
- (void)insertOverlay:(id <QOverlay>)overlay belowOverlay:(id <QOverlay>)sibling;

/*!
 *  @brief  当前地图上的overlay数组
 */
@property (nonatomic, readonly) NSArray *overlays;

/*!
 *  @brief  查找指定overlay对应的View，如果该view尚未创建，返回nil
 *
 *  @param overlay 指定的overlay
 *
 *  @return 指定overlay的view
 */
- (QOverlayView *)viewForOverlay:(id <QOverlay>)overlay;

@end

/*!
 *  @brief  QMapView的瓦片自定义显示内容相关方法
 *
 */
@interface QMapView (TileOverlay)

/*!
 *  @brief  添加tileOverlay
 *
 *  @param tileOverlay 要添加的tileOverlay
 */
- (void)addTileOverlay:(QTileOverlay *)tileOverlay;

/*!
 *  @brief  移除tileOverlay
 *
 *  @param tileOverlay 要移除的tileOverlay
 */
- (void)removeTileOverlay:(QTileOverlay *)tileOverlay;

/*!
 *  @brief  强制tileOverlay重新加载数据.
 *
 *  @param tileOverlay tileOverlay
 */
- (void)reloadTileOverlay:(QTileOverlay *)tileOverlay;

/*!
 *  @brief  当前地图上的tileOverlay数组
 */
@property (nonatomic, readonly) NSArray *tileOverlays;

@end

/*!
 *  @brief  QMapView的Annotation覆盖物相关方法
 *
 * @note 覆盖物均为UIView子类
 */
@interface QMapView (QAnnotationSystem)

/*!
 *  @brief  向地图窗口添加标注，需要实现MapViewDelegate的-mapView:viewForAnnotation:函数来生成标注对应的View
 *
 *  @param annotation 要添加的标注
 */
- (void)addAnnotation:(id <QAnnotation>)annotation;

/*!
 *  @brief  向地图窗口添加一组标注，需要实现MapViewDelegate的-mapView:viewForAnnotation:函数来生成标注对应的View
 *
 *  @param annotations 要添加的标注数组
 */
- (void)addAnnotations:(NSArray *)annotations;

/*!
 *  @brief  移除标注
 *
 *  @param annotation 要移除的标注
 */
- (void)removeAnnotation:(id <QAnnotation>)annotation;

/*!
 *  @brief  移除一组标注
 *
 *  @param annotations 要移除的标注数组
 */
- (void)removeAnnotations:(NSArray *)annotations;

/*!
 *  @brief  当前地图上的标注数组
 */
@property (nonatomic, readonly) NSArray *annotations;

/*!
 *  @brief  获取指定标注的view
 *
 *  @param annotation 指定的标注
 *
 *  @return 该标注的view
 */
- (QAnnotationView *)viewForAnnotation:(id <QAnnotation>)annotation;

/*!
 *  @brief  从复用内存池中获取制定复用标识的annotationView
 *
 *  @param identifier 复用标识
 *
 *  @return 一个标注view
 */
- (QAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier;

/*!
 *  @brief  处于选中状态的标注数据数据(其count == 0 或 1)
 */
@property (nonatomic, copy) NSArray *selectedAnnotations;

/*!
 *  @brief  选中标注对应的view
 *
 *  @param annotation 选择的标注
 *  @param animated   是否采用动画
 */
- (void)selectAnnotation:(id < QAnnotation >)annotation animated:(BOOL)animated;

/*!
 *  @brief  取消选中标注对应的view
 *
 *  @param annotation 选择的标注
 *  @param animated   是否采用动画
 */
- (void)deselectAnnotation:(id < QAnnotation >)annotation animated:(BOOL)animated;

@end


/*!
 *  @brief  QMapViewDelegate:MapView的Delegate,mapView通过此类来通知用户对应的事件
 */
@protocol QMapViewDelegate <NSObject>

@optional

/*!
 *  @brief  地图区域即将改变时会调用此接口
 *
 *  @param mapView  地图view
 *  @param animated 是否采用动画
 */
- (void)mapView:(QMapView *)mapView regionWillChangeAnimated:(BOOL)animated gesture:(BOOL)bGesture;

/*!
 *  @brief  地图区域改变完成时会调用此接口
 *
 *  @param mapView  地图view
 *  @param animated 是否采用动画
 */
- (void)mapView:(QMapView *)mapView regionDidChangeAnimated:(BOOL)animated gesture:(BOOL)bGesture;

/*!
 *  @brief  地图的视野区域变化时会持续调用此接口
 *
 *  @param mapView 地图View
 */
- (void)mapRegionChanged:(QMapView*)mapView;

/*!
 *  @brief  在地图view将要启动定位时，会调用此函数
 *
 *  @param mapView 地图view
 */
- (void)mapViewWillStartLocatingUser:(QMapView *)mapView;

/*!
 *  @brief  在地图view定位停止后，会调用此函数
 *
 *  @param mapView 地图view
 */
- (void)mapViewDidStopLocatingUser:(QMapView *)mapView;

/*!
 *  @brief  位置或者设备方向更新后，会调用此函数
 *
 *  @param mapView          地图view
 *  @param userLocation     用户定位信息(包括位置与设备方向等数据)
 */
- (void)mapView:(QMapView *)mapView didUpdateUserLocation:(QUserLocation *)userLocation;

/*!
 *  @brief  定位失败后，会调用此函数
 *
 *  @param mapView 地图view
 *  @param error   错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(QMapView *)mapView didFailToLocateUserWithError:(NSError *)error;

/*!
 *  @brief  根据overlay生成对应的view
 *
 *  @param mapView 地图view
 *  @param overlay 指定的overlay
 *
 *  @return 生成的覆盖物view
 */
- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id <QOverlay>)overlay;

/*!
 *  @brief  当mapView新添加overlay view时，调用此接口
 *
 *  @param mapView 地图view
 *  @param overlayView overlayView
 */
- (void)mapView:(QMapView *)mapView didAddOverlayView:(QOverlayView *)overlayView ;

/*!
 *  @brief  当mapView新添加overlay view 数组时，调用此接口
 *
 *  @param mapView 地图view
 *  @param overlayViews overlayView 数组
 */
- (void)mapView:(QMapView *)mapView didAddOverlayViews:(NSArray *)overlayViews ;

/*!
 *  @brief  当userTrackingMode改变时，调用此接口
 *
 *  @param mapView  地图view
 *  @param mode     改变后的mode
 *  @param animated 是否采用动画
 */
- (void)mapView:(QMapView *)mapView didChangeUserTrackingMode:(QMUserTrackingMode)mode animated:(BOOL)animated;


/*!
 *  @brief  点中底图标注后会回调此接口
 *
 *  @param mapview 地图View
 *  @param mapPoi 标注点信息
 */
- (void)mapView:(QMapView *)mapView onClickedMapPoi:(QMapPoi*)mapPoi;


#pragma mark - QAnnotationSystem

/*!
 *  @brief  根据annotation生成对应的view
 *
 *  @param mapView    地图view
 *  @param annotation 指定的标注
 *
 *  @return 指定标注对应的view
 */
- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id <QAnnotation>)annotation;

/*!
 *  @brief  当mapView新添加annotationViews时，调用此接口
 *
 *  @param mapView 地图view
 *  @param views   添加的annotationViews
 */
- (void)mapView:(QMapView *)mapView didAddAnnotationViews:(NSArray *)views;

/*!
 *  @brief  当选中一个annotationView时，调用此接口
 *
 *  @param mapView 地图view
 *  @param view    选中的annotationView
 */
- (void)mapView:(QMapView *)mapView didSelectAnnotationView:(QAnnotationView *)view;

/*!
 *  @brief  当取消选中一个annotationView时，调用此接口
 *
 *  @param mapView 地图view
 *  @param view    取消选中的annotationView
 */
- (void)mapView:(QMapView *)mapView didDeselectAnnotationView:(QAnnotationView *)view;

/*!
 *  @brief  拖动annotationView时view的状态变化，ios3.2以后支持
 *
 *  @param mapView  地图view
 *  @param view     目标annotationView
 *  @param newState 新状态
 *  @param oldState 旧状态
 */
- (void)mapView:(QMapView *)mapView annotationView:(QAnnotationView *)view didChangeDragState:(QAnnotationViewDragState)newState
   fromOldState:(QAnnotationViewDragState)oldState;

/*!
 *  @brief  标注view的accessory view(必须继承自UIControl)被点击时，触发该回调
 *
 *  @param mapView 地图view
 *  @param view    callout所属的标注view
 *  @param control 对应control
 */
- (void)mapView:(QMapView *)mapView annotationView:(QAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;

@end

/*!
 *  @brief 导航事件的Delegate, 导航时mapView通过此类来通知用户对应的事件
 */
@protocol QMapNavigationDelegate <NSObject>

/*!
 *  @brief 导航状态更新
 *
 *  @param reouteResult 导航状态
 */
- (void)updateRouteResult:(QRoute*)routeResult;

/*!
 *  @brief 返回TTS字符串
 *
 *  @param ttsValue TTS字符串
 */
- (void)returnTTSValue:(NSString*)ttsValue;

/*!
 *  @brief 算路定位出错
 *
 *  @param locationErr error标示
 */
- (void)userLocationErr:(NSString*)locationErr;

/*!
 *  @brief 导航结束
 *
 *  @param bFinished 结束状态
 */
- (void)userNavigationEnd:(BOOL)bFinished;

/*!
 *  @brief 显示路线结束
 */
- (void)showRouteFinished;

/*!
 *  @brief 用户追踪模式为None
 */
- (void)userTrackingModeNone;

@end
