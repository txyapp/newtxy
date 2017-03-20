//
//  GMSMapView+Enterprise.h
//  Google Maps SDK for iOS
//
//  Copyright 2013 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <GoogleMapsM4B/GMSMapView.h>

@class GMSMapsEngineLayer;

/**
 * This interface may be used in place of GMSMapViewDelegate as the map view
 * delegate property in order to be notified of additional enterprise specific
 * events.
 */
@protocol GMSEnterpriseMapViewDelegate <GMSMapViewDelegate>
@optional

/**
 * Called after one or more Google Maps Engine layers have been tapped.
 * Features returned by this method will not be fully populated, but it will be called as soon as
 * the tap has occurred.
 * All features under the tap are reported, in a prioritized order.
 *
 * @param mapView The map view that was pressed.
 * @param features Array of GMSMapsEngineFeature instances with initial details.
 *
 * Maps Engine Layers related methods are deprecated and will be removed in a future release.
 */
- (void)mapView:(GMSMapView *)mapView
    didTapFeatures:(NSArray *)features __GMS_AVAILABLE_BUT_DEPRECATED;

/**
 * Called after one or more Google Maps Engine layers have been tapped and the features have been
 * resolved to provide additional information.
 * All features under the tap are reported, in a prioritized order.
 *
 * @param mapView The map view that was pressed.
 * @param features The same array as returned by the corresponding mapView:didTapFeatures: call,
 * but with all available information now populated in the internal instances.
 *
 * Maps Engine Layers related methods are deprecated and will be removed in a future release.
 */
- (void)mapView:(GMSMapView *)mapView
    didResolveFeatures:(NSArray *)features __GMS_AVAILABLE_BUT_DEPRECATED;

/**
 * Called when a maps engine layer is successfully added to a map.
 *
 * @param mapView The map view that had the layer added to it.
 * @param layer The layer that was added to the map.
 *
 * Maps Engine Layers related methods are deprecated and will be removed in a future release.
 */
- (void)mapView:(GMSMapView *)mapView
    didAddMapsEngineLayer:(GMSMapsEngineLayer *)layer __GMS_AVAILABLE_BUT_DEPRECATED;

/**
 * Called when a maps engine layer fails to be added to a map.
 *
 * @param mapView The map view that was intended to show the layer.
 * @param error Details of why the add failed. The error's code will be one of the values defined by
 * GMSMapsEngineLayerAddErrorCodes.
 * @param layer The layer that failed to be added to the map.
 *
 * Maps Engine Layers related methods are deprecated and will be removed in a future release.
 */
- (void)mapView:(GMSMapView *)mapView
                   error:(NSError *)error
    onAddMapsEngineLayer:(GMSMapsEngineLayer *)layer __GMS_AVAILABLE_BUT_DEPRECATED;

@end

/**
 * Error codes that can be returned by mapView:error:onAddMapsEngineLayer:.
 *
 * Maps Engine Layers related methods are deprecated and will be removed in a future release.
 */
__GMS_AVAILABLE_BUT_DEPRECATED
typedef NS_ENUM(NSInteger, GMSMapsEngineLayerAddErrorCodes) {
  /** Requested layer requires different credentials. */
  kGMSMapsEngineLayerAddNotAuthorized,
  /** Credentials provided are invalid. */
  kGMSMapsEngineLayerAddInvalidCredentials,
  /** The layer details provided are not valid. */
  kGMSMapsEngineLayerAddInvalidLayer,
  /** Failure to resolve layer details. */
  kGMSMapsEngineLayerAddFailure,
  /** An unexpected error occurred while resolving layer details. */
  kGMSMapsEngineLayerAddUnexpectedError,
};

/**
 * Extensions for GMSMapView for enterprise.
 */
@interface GMSMapView (Enterprise)

/**
 * Extend the default delegate for enterprise-specific events.
 */
@property(nonatomic, weak) id<GMSEnterpriseMapViewDelegate> delegate;

@end

