//
//  GMSMapsEngineFeature.h
//  Google Maps SDK for iOS
//
//  Copyright 2014 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <CoreLocation/CoreLocation.h>

#import <GoogleMapsM4B/GMSMapView.h>

@class GMSMapsEngineLayer;

/**
 * Holds details about a Google Maps Engine feature that was under a tap.
 * Immutable, except for the description and featureID fields.
 *
 * Maps Engine Layers and related interfaces are deprecated and will be removed in a future
 * release.
 */
__GMS_AVAILABLE_BUT_DEPRECATED
@interface GMSMapsEngineFeature : NSObject

/** Layer which contains the tapped feature. */
@property(nonatomic, readonly) GMSMapsEngineLayer *layer;

/** Closest location of the feature to the tap center. */
@property(nonatomic, readonly) CLLocationCoordinate2D location;

/** HTML description of the feature. Only populated once the resolve event has been fired. */
@property(nonatomic, readonly) NSString *description;

/**
 * Google Maps Engine id of the tapped feature. Only populated once the resolve event has been
 * fired.
 */
@property(nonatomic, readonly) NSString *featureID;

@end
