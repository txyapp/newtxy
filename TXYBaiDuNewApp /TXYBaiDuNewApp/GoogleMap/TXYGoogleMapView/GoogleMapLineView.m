//
//  GoogleMapLineView.m
//  TXYGoogleTest
//
//  Created by aa on 16/8/15.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "GoogleMapLineView.h"
#import <CoreLocation/CLLocation.h>
#import "GoogleMapTileUtil.h"
#import "TXYGoogleService.h"

@implementation GoogleMapLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor clearColor];
        self.pointsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)stopDraw
{
    CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
    tiledLayer.contents=nil;
    tiledLayer.delegate=nil;
    [tiledLayer removeFromSuperlayer];
}

- (void)dealloc
{
}

- (void)drawRect:(CGRect)rect
{
    if (self.mapLineModel.mapLinePointCoordinateInfoArray.count != 0) {
        @try {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetLineWidth(context, 2);  //线宽
            CGContextSetAllowsAntialiasing(context, true);
            CGContextSetRGBStrokeColor(context, 255.0 / 255.0, 0.0 / 255.0, 0.0 / 255.0, 1.0);  //线的颜色
            CGContextBeginPath(context);
            
            
            BOOL isFirst = YES;
            
            for (NSValue *coordinateValue in self.pointsArray) {
                CGPoint p;
                [coordinateValue getValue:&p];
                if (isFirst) {
                    CGContextMoveToPoint(context, p.x, p.y);
                    isFirst = NO;
                }else{
                    CGContextAddLineToPoint(context, p.x, p.y);
                }
            }
            
/*            __block BOOL isFirst = YES;
            
            [self.pointsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSValue *pointValue = (NSValue *)obj;
                CGPoint p;
                [pointValue getValue:&p];
                if (isFirst) {
                    CGContextMoveToPoint(context, p.x, p.y);
                    isFirst = NO;
                }else{
                    CGContextAddLineToPoint(context, p.x, p.y);
                }
            }];*/
            
            /*NSArray *copyArray = [NSArray arrayWithArray:self.mapLineModel.mapLinePointCoordinateInfoArray];
            for (NSValue *coordinateValue in copyArray) {
                CLLocationCoordinate2D c;
                [coordinateValue getValue:&c];
                CGPoint point = [GoogleMapTileUtil getMapViewPointWithCoordinate:c andZoomLevel:[TXYGoogleService mapConfig].currentZoomLevel withMapTileSize:[[TXYGoogleService mapConfig] getScaledMapTileSize]];
                if (isFirst) {
                    CGContextMoveToPoint(context, point.x, point.y);
                    isFirst = NO;
                }else{
                    CGContextAddLineToPoint(context, point.x, point.y);
                }
            }*/
            CGContextStrokePath(context);
        }@catch (NSException *exception) {
            NSLog(@"exception %@",exception);
        }@finally {
            
        }
    }
}

- (void)clearContent
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.frame);
}

- (void)addMapLine:(GoogleMapLineModel *)mapLine
{
    self.mapLineModel = mapLine;
    [self calPointArray];
}

- (void)calPointArray
{
    NSArray *copyArray = [NSArray arrayWithArray:self.mapLineModel.mapLinePointCoordinateInfoArray];
    for (NSValue *coordinateValue in copyArray) {
        CLLocationCoordinate2D c;
        [coordinateValue getValue:&c];
        CGPoint point = [GoogleMapTileUtil getMapViewPointWithCoordinate:c andZoomLevel:[TXYGoogleService mapConfig].currentZoomLevel withMapTileSize:[[TXYGoogleService mapConfig] getScaledMapTileSize]];
        NSValue *valuep = [NSValue value:&point withObjCType:@encode(CGPoint)];
        [self.pointsArray addObject:valuep];
    }
}

+ (Class)layerClass
{
    return [CATiledLayer class];
}

@end
