/*
 ============================================================================
 Name           : QShape.h
 Author         : 腾讯SOSO地图
 Version        : 1.0
 Copyright      : 腾讯
 Description    : QShape declaration
 ============================================================================
 */

/**    @file QShape.h     */

#import <Foundation/Foundation.h>
#import "QAnnotation.h"

/**
 *  @brief QShape:定义了基于QOAnnotation的QShape类的基本属性和行为，不能直接使用，必须子类化之后才能使用
 **/
@interface QShape : NSObject <QAnnotation>{
@package
    NSString *_title;
    NSString *_subtitle;
    UIView *_customCalloutView;
}
/**  @brief 标题**/
@property(nonatomic, copy) NSString *title;

/**  @brief 副标题**/
@property(nonatomic, copy) NSString *subtitle;

/** @brief 是否下落动画 **/
@property(nonatomic, assign) BOOL animationDidStop;


@end
