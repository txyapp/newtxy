//
//  GMSMapsEngineLayer.h
//  Google Maps SDK for iOS
//
//  Copyright 2013 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <GoogleMapsM4B/GMSMapView.h>

@class GMSMapView;

/**
 * A Google Maps Engine layer allows for the display of maps engine data as a
 * map tile overlay.
 *
 * The Maps Engine Layers interface is deprecated and will be removed in a future release.
 */
__GMS_AVAILABLE_BUT_DEPRECATED
@interface GMSMapsEngineLayer : NSObject

/**
 * The asset ID in Google Maps Engine of this layer.  This will be a copy of
 * whatever was passed to the constructor, if constructed by layerID,
 * otherwise nil.
 */
@property(nonatomic, readonly) NSString *layerID;

/**
 * The asset ID in Google Maps Engine of map the layer belongs to.  This will
 * be a copy of whatever was passed to the constructor, if constructed by mapID,
 * otherwise nil.
 */
@property(nonatomic, readonly) NSString *mapID;

/**
 * The sub key in Google Maps Engine of this layer with respect to mapID.  This
 * will be a copy of whatever was passed to the constructor, if constructed by
 * mapID, otherwise nil.
 */
@property(nonatomic, readonly) NSString *layerKey;

/**
 * The version of this layer in Google Maps Engine.  This will be a copy of
 * whatever was passed to the constructor, or the default if this was nil.
 */
@property(nonatomic, readonly) NSString *version;

/**
 * The map this GMSMapsEngineLayer is displayed on. Setting this property will
 * add the layer to the map. Setting it to nil removes this layer from the map.
 * A layer may be active on at most one map at any given time.
 */
@property(nonatomic, weak) GMSMapView *map;

/**
 * Higher |zIndex| value layers will be drawn on top of lower |zIndex|
 * value layers and non-marker overlays.  Equal values result in undefined draw
 * ordering.
 */
@property(nonatomic, assign) int zIndex;

/**
 * If YES (default), any features tapped on will show their details in a default
 * UI.
 * Regardless, feature tap and resolution events will be raised on the map view
 * delegate.
 */
@property(nonatomic, assign) BOOL showDefaultFeatureUI;

/**
 * Returns a Google Maps Engine Layer with the given |layerID| (also known as
 * an asset ID). This defaults to the layer's default, 'published' version.
 */
+ (instancetype)layerWithLayerID:(NSString *)layerID;

/**
 * As per layerWithLayerID:, but allows the layer's |version| to be specified.
 */
+ (instancetype)layerWithLayerID:(NSString *)layerID
                         version:(NSString *)version;

/**
 * Convenience constructor. |mapID| and |key| are mandatory and should
 * correspond to a valid layer in Google Maps Engine. |version| may be nil to
 * indicate the default 'published' version.
 */
+ (instancetype)layerWithMapID:(NSString *)mapID
                           key:(NSString *)key
                       version:(NSString *)version;

@end
