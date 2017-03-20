/*
 ============================================================================
 Name           : QGeometry.h
 Author         : 腾讯SOSO地图
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QGeometry declaration
 ============================================================================
 */

/**    @file QGeometry.h     */

#ifndef SOSOMapAPI_QGeometry_h
#define SOSOMapAPI_QGeometry_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

/*!
 *  @brief  定义了以CLLocationDegree为单位的矩形
 *
 *  一单位纬度(latitudeDelta)大约为111公里; 单位经度和纬度相关,一单位经度值(latitudeDelta)赤道时大约是111公里, 到极地为0
 */
typedef struct {
    CLLocationDegrees latitudeDelta;    ///< 纬度区域
    CLLocationDegrees longitudeDelta;   ///< 经度区域
} QCoordinateSpan;

/*!
 * @brief 定义了地图的某一部份的数据结构
 */
typedef struct {
	CLLocationCoordinate2D center;  ///<    中心点
	QCoordinateSpan span;           ///<    区域
} QCoordinateRegion;


/*!
 *  @brief  平面投影坐标结构定义
 */
typedef struct {
    double x;   ///< x坐标. 经度的mercator表示
    double y;   ///< y坐标. 纬度的mercator表示
} QMapPoint;

/*!
 *  @brief  平面投影大小结构定义
 */
typedef struct {
    double width;   ///< 宽值
    double height;  ///< 高值
} QMapSize;

/*!
 *  @brief  平面投影矩形结构定义
 */
typedef struct {
    QMapPoint origin;       ///< 原点坐标。左上角
    QMapSize size;          ///< 区域大小
} QMapRect;

/*!
 *  @brief  地图缩放比例, 提供了地图上的点和屏幕上的点缩放关系
 */
typedef CGFloat QZoomScale;

/*!
 *  @brief  经过投影后的世界范围大小，与经纬度（-85，180）投影后的坐标值对应
 */
UIKIT_EXTERN const QMapSize QMapSizeWorld;

/*!
 *  @brief  经过投影后的世界范围对应的矩形
 */
UIKIT_EXTERN const QMapRect QMapRectWorld;

/*!
 *  @brief  空的直角坐标矩形
 */
UIKIT_EXTERN const QMapRect QMapRectNull;

/*!
 *  @brief  判断经纬度区域是不是合理的
 *
 *  @param region region
 *
 *  @return 是否有效
 */
BOOL QCoordinateRegionIsValid(QCoordinateRegion region);

/*!
 *  @brief  判断大小是不是合理的
 *
 *  @param mapSize mapSize
 *
 *  @return 是否有效
 */
BOOL QMapSizeIsValid(QMapSize mapSize);

/*!
 *  @brief  判断地图区域是不是合理的
 *
 *  @param mapRect mapRect
 *
 *  @return 是否有效
 */
BOOL QMapRectIsValid(QMapRect mapRect);


/*!
 *  @brief  构造QCoordinateSpan类型数据
 *
 *  @param latitudeDelta  纬度值
 *  @param longitudeDelta 经度值
 *
 *  @return 构造的span数据
 */
UIKIT_STATIC_INLINE QCoordinateSpan QCoordinateSpanMake(double latitudeDelta, double longitudeDelta)
{
    QCoordinateSpan span;
    span.latitudeDelta = latitudeDelta;
    span.longitudeDelta = longitudeDelta;
    return span;
}

/*!
 *  @brief  构造QCoordinateRegion类型数据
 *
 *  @param centerCoordinate 中心点经纬度坐标
 *  @param span             span大小
 *
 *  @return 构造的region数据
 */
UIKIT_STATIC_INLINE QCoordinateRegion QCoordinateRegionMake(CLLocationCoordinate2D centerCoordinate, QCoordinateSpan span)
{
	QCoordinateRegion region;
	region.center = centerCoordinate;
    region.span = span;
	return region;
}

/*!
 *  @brief  生成一个新的QCoordinateRegion
 *
 *  @param centerCoordinate   中心点坐标
 *  @param latitudinalMeters  垂直跨度(单位 米)
 *  @param longitudinalMeters 水平跨度(单位 米)
 *
 *  @return QCoordinateRegion
 */
QCoordinateRegion QCoordinateRegionMakeWithDistance(CLLocationCoordinate2D centerCoordinate, CLLocationDistance latitudinalMeters, CLLocationDistance longitudinalMeters);

/*!
 *  @brief  经纬度坐标转平面投影坐标
 *
 *  @param coordinate 要转化的经纬度坐标
 *
 *  @return 平面投影坐标
 */
QMapPoint QMapPointForCoordinate(CLLocationCoordinate2D coordinate);

/*!
 *  @brief  平面投影坐标转经纬度坐标
 *
 *  @param mapPoint 要转化的平面投影矩形
 *
 *  @return 经纬度坐标
 */
CLLocationCoordinate2D QCoordinateForMapPoint(QMapPoint mapPoint);

/*!
 *  @brief  在特定纬度单位mapPoint代表的距离, 单位:米
 *
 *  @param latitude 纬度参数
 *
 *  @return 距离大小
 */
CLLocationDistance QMetersPerMapPointAtLatitude(CLLocationDegrees latitude);

/*!
 *  @brief  在特定纬度每米代表的mapPoint值
 *
 *  @param latitude 纬度参数
 *
 *  @return mapPoint个数
 */
double QMapPointsPerMeterAtLatitude(CLLocationDegrees latitude);

/*!
 *  @brief  返回两个QMapPoint之间的距离 单位:米
 *
 *  @param a 点a
 *  @param b 点b
 *
 *  @return 距离值
 */
double QMetersBetweenMapPoints(QMapPoint a, QMapPoint b);

/*!
 *  @brief  根据x,y坐标构建QMapPoint
 *
 *  @param x 横轴坐标
 *  @param y 纵轴坐标
 *
 *  @return mapPoint
 */
UIKIT_STATIC_INLINE QMapPoint QMapPointMake(double x, double y) {
    return (QMapPoint){x, y};
}

/*!
 *  @brief  根据长宽构建QMapSize
 *
 *  @param width  宽
 *  @param height 长
 *
 *  @return mapSize
 */
UIKIT_STATIC_INLINE QMapSize QMapSizeMake(double width, double height) {
    return (QMapSize){width, height};
}

/*!
 *  @brief  构建QMapRect
 *
 *  @param x      横轴顶点坐标
 *  @param y      纵轴顶点坐标
 *  @param width  宽
 *  @param height 长
 *
 *  @return mapRect
 */
UIKIT_STATIC_INLINE QMapRect QMapRectMake(double x, double y, double width, double height) {
    return (QMapRect){ QMapPointMake(x, y), QMapSizeMake(width, height) };
}

/*!
 *  @brief  获取QMapRect左上点x值
 *
 *  @param rect QMapRect数据
 *
 *  @return 顶点x值
 */
UIKIT_STATIC_INLINE double QMapRectGetMinX(QMapRect rect) {
    return rect.origin.x;
}

/*!
 *  @brief  获取QMapRect左上点y值
 *
 *  @param rect QMapRect数据
 *
 *  @return 顶点y值
 */
UIKIT_STATIC_INLINE double QMapRectGetMinY(QMapRect rect) {
    return rect.origin.y;
}

/*!
 *  @brief  获取QMapRect中心点x值
 *
 *  @param rect QMapRect数据
 *
 *  @return 中心点x值
 */
UIKIT_STATIC_INLINE double QMapRectGetMidX(QMapRect rect) {
    return rect.origin.x + rect.size.width / 2.0;
}

/*!
 *  @brief  获取QMapRect中心点y值
 *
 *  @param rect QMapRect数据
 *
 *  @return 中心点y值
 */
UIKIT_STATIC_INLINE double QMapRectGetMidY(QMapRect rect) {
    return rect.origin.y + rect.size.height / 2.0;
}

/*!
 *  @brief  获取QMapRect右下角x值
 *
 *  @param rect QMapRect数据
 *
 *  @return 右下角x值
 */
UIKIT_STATIC_INLINE double QMapRectGetMaxX(QMapRect rect) {
    return rect.origin.x + rect.size.width;
}

/*!
 *  @brief  获取QMapRect右下角y值
 *
 *  @param rect QMapRect数据
 *
 *  @return 右下角y值
 */
UIKIT_STATIC_INLINE double QMapRectGetMaxY(QMapRect rect) {
    return rect.origin.y + rect.size.height;
}

/*!
 *  @brief  获取QMapRect宽度
 *
 *  @param rect QMapRect数据
 *
 *  @return 宽度值
 */
UIKIT_STATIC_INLINE double QMapRectGetWidth(QMapRect rect) {
    return rect.size.width;
}

/*!
 *  @brief  获取QMapRect长度度
 *
 *  @param rect QMapRect数据
 *
 *  @return 长度值
 */
UIKIT_STATIC_INLINE double QMapRectGetHeight(QMapRect rect) {
    return rect.size.height;
}

/*!
 *  @brief  比较两个QMapPoint x, y值是否同时相等
 *
 *  @param point1 第一个点
 *  @param point2 第二个点
 *
 *  @return 是否相等
 */
UIKIT_STATIC_INLINE BOOL QMapPointEqualToPoint(QMapPoint point1, QMapPoint point2) {
    return point1.x == point2.x && point1.y == point2.y;
}

/*!
 *  @brief  判断两个QMapSize是否相等
 *
 *  @param size1 QMapSize1
 *  @param size2 QMapSize2
 *
 *  @return 是否相等
 */
UIKIT_STATIC_INLINE BOOL QMapSizeEqualToSize(QMapSize size1, QMapSize size2) {
    return size1.width == size2.width && size1.height == size2.height;
}

/*!
 *  @brief  判断两个QMapRect是否相等
 *
 *  @param rect1 QMapRect1
 *  @param rect2 QMapRect2
 *
 *  @return 是否相等
 */
UIKIT_STATIC_INLINE BOOL QMapRectEqualToRect(QMapRect rect1, QMapRect rect2) {
    return 
    QMapPointEqualToPoint(rect1.origin, rect2.origin) &&
    QMapSizeEqualToSize(rect1.size, rect2.size);
}

/*!
 *  @brief  判断QMapRect是否为NULL, x或y为无穷小是返回YES
 *
 *  @param rect QMapRect
 *
 *  @return 是否为NULL
 */
UIKIT_STATIC_INLINE BOOL QMapRectIsNull(QMapRect rect) {
    return isinf(rect.origin.x) || isinf(rect.origin.y);
}

/*!
 *  @brief  判断QMapRect是否为空
 *
 *  @param rect QMapRect
 *
 *  @return 是否为空
 */
UIKIT_STATIC_INLINE BOOL QMapRectIsEmpty(QMapRect rect) {
    return QMapRectIsNull(rect) || (rect.size.width == 0.0 && rect.size.height == 0.0);
}

/*!
 *  @brief  格式化输出QMapPoint类型数据
 *
 *  @param point QMapPoint
 *
 *  @return 格式化后的字符串
 */
UIKIT_STATIC_INLINE NSString *QStringFromMapPoint(QMapPoint point) {
    return [NSString stringWithFormat:@"{%f, %f}", point.x, point.y];
}

/*!
 *  @brief  格式化输出QMapSize类型数据
 *
 *  @param point QMapSize
 *
 *  @return 格式化后的字符串
 */
UIKIT_STATIC_INLINE NSString *QStringFromMapSize(QMapSize size) {
    return [NSString stringWithFormat:@"{%f, %f}", size.width, size.height];
}

/*!
 *  @brief  格式化输出QMapRect类型数据
 *
 *  @param point QMapRect
 *
 *  @return 格式化后的字符串
 */
UIKIT_STATIC_INLINE NSString *QStringFromMapRect(QMapRect rect) {
    return [NSString stringWithFormat:@"{%@, %@}", QStringFromMapPoint(rect.origin), QStringFromMapSize(rect.size)];
}

/*!
 *  @brief  返回两个矩形的并集
 *
 *  @param rect1 矩形1
 *  @param rect2 矩形2
 *
 *  @return 并集
 */
QMapRect QMapRectUnion(QMapRect rect1, QMapRect rect2);

/*!
 *  @brief  返回两个矩形的交集
 *
 *  @param rect1 矩形1
 *  @param rect2 矩形2
 *
 *  @return 交集, 无交集则返回QMapRectNull.
 */
QMapRect QMapRectIntersection(QMapRect rect1, QMapRect rect2);

/*!
 *  @brief  将矩形向内缩小dx，dy大小
 *
 *  @param rect 指定的矩形
 *  @param dx x轴的变化量
 *  @param dy y轴的变化量
 *
 *  @return 调整后的矩形
 */
QMapRect QMapRectInset(QMapRect rect, double dx, double dy);

/*!
 *  @brief  将矩形原点偏移指定大小
 *
 *  @param rect 指定的矩形
 *  @param dx x轴的偏移量
 *  @param dy y轴的偏移量
 *
 *  @return 调整后的矩形
 */
QMapRect QMapRectOffset(QMapRect rect, double dx, double dy);

/**
 *矩形分割，将一个矩形分割为两个矩形
 *@param rect 待分割的矩形
 *@param slice 指针，用来保存分割后被移除的矩形
 *@param remainder 指针，用来保存分割后剩下的矩形
 *@param amount 指定分割的大小，如果设置为负数，则将自动调整为0
 *@param edge 用来指定要从那条边开始分割
 */

/*!
 *  @brief  矩形分割，将一个矩形分割为两个矩形
 *
 *  @param rect 待分割的矩形
 *  @param slice 指针，用来保存分割后被移除的矩形
 *  @param remainder 指针，用来保存分割后剩下的矩形
 *  @param amount 指定分割的大小，如果设置为负数，则将自动调整为0
 *  @param edge 用来指定要从那条边开始分割
 */
void QMapRectDivide(QMapRect rect, QMapRect *slice, QMapRect *remainder, double amount, CGRectEdge edge);

/*!
 *  @brief  判断点是否在矩形内
 *
 *  @param rect  矩形
 *  @param point 点
 *
 *  @return 是否在内
 */
BOOL QMapRectContainsPoint(QMapRect rect, QMapPoint point);

/*!
 *  @brief  判断rect1是否包含rect2
 *
 *  @param rect1 矩形1
 *  @param rect2 矩形2
 *
 *  @return 是否包含
 */
BOOL QMapRectContainsRect(QMapRect rect1, QMapRect rect2);

/*!
 *  @brief  判断两个矩形是否相交
 *
 *  @param rect1 矩形1
 *  @param rect2 矩形2
 *
 *  @return 是否相交
 */
BOOL QMapRectIntersectsRect(QMapRect rect1, QMapRect rect2);

/*!
 *  @brief  平面投影矩形转region
 *
 *  @param rect 要转化的平面投影矩形
 *
 *  @return region
 */
QCoordinateRegion QCoordinateRegionForMapRect(QMapRect rect);
QCoordinateRegion QMCoordinateRegionForMapRect(QMapRect rect);

/*!
 *  @brief  region转平面投影矩形
 *
 *  @param region 要转化的region
 *
 *  @return rect 平面投影矩形
 */
QMapRect QMapRectForCoordinateRegion(QCoordinateRegion region);

/*!
 *  @brief  判断指定的直角坐标矩形是否跨越了180度经线
 *
 *  @param rect 要转化的平面投影矩形
 *
 *  @return 如果跨越，返回YES，否则返回NO
 */
BOOL QMapRectSpans180thMeridian(QMapRect rect);

/*!
 *  @brief  对于跨越了180经线的矩形，本函数将世界之外的部分进行分割，并将分割下来的矩形转换到地球对面，
 *
 *  @param rect 待处理的矩形
 *
 *  @return 返回转换后的矩形
 */
QMapRect QMapRectRemainder(QMapRect rect);

/*!
 *  @brief  将CLLocationCoordinate2D格式化为字符串
 *
 *  @param point 指定的标点
 *
 *  @return 返回转换后的字符串
 */
UIKIT_STATIC_INLINE NSString* _QStringFromLocationCoordinate2D(CLLocationCoordinate2D point) {
    return [NSString stringWithFormat:@"{%f,%f}",point.latitude,point.longitude];
}

/*!
 *  @brief  将QCoordinateSpan格式化为字符串
 *
 *  @param span 指定的span
 *
 *  @return 返回转换后的字符串
 */
UIKIT_STATIC_INLINE NSString* _QStringFromCoordinateSpan(QCoordinateSpan span) {
    return [NSString stringWithFormat:@"{%f, %f}", span.latitudeDelta, span.longitudeDelta];
}

/*!
 *  @brief  将QCoordinateRegion格式化为字符串
 *
 *  @param region 指定的region
 *
 *  @return 返回转换后的字符串
 */
UIKIT_STATIC_INLINE NSString* _QStringFromCoordinateRegion(QCoordinateRegion region) {
    return [NSString stringWithFormat:@"{%@, %@}", _QStringFromLocationCoordinate2D(region.center), _QStringFromCoordinateSpan(region.span)];
}


#endif
