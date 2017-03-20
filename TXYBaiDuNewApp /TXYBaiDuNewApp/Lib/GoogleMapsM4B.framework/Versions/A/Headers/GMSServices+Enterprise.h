//
//  GMSServices+Enterprise.h
//  Google Maps SDK for iOS
//
//  Copyright 2014 Google Inc.
//
//  Usage of this SDK is subject to the Google Maps/Google Earth APIs Terms of
//  Service: https://developers.google.com/maps/terms
//

#import <GoogleMapsM4B/GMSServices.h>

/*
 * The GTMFetcherAuthorizationProtocol protocol is specified as part of the gtm-http-fetcher
 * library (in GTMHTTPFetcher.h) which is available separately at
 * https://code.google.com/p/gtm-http-fetcher/
 * For reference purposes it is documented here and any object instance conforming to this
 * can potentially be used for GMSServices provideAuthorizationProvider:.
 * This reference documentation matches gtm-http-fetcher as of r136.
 *
 * @protocol GTMFetcherAuthorizationProtocol <NSObject>
 * @required
 *
 *
 * - (void)authorizeRequest:(NSMutableURLRequest *)request
 *                 delegate:(id)delegate
 *        didFinishSelector:(SEL)sel;
 *
 * - (void)stopAuthorization;
 *
 * - (void)stopAuthorizationForRequest:(NSURLRequest *)request;
 *
 * - (BOOL)isAuthorizingRequest:(NSURLRequest *)request;
 *
 * - (BOOL)isAuthorizedRequest:(NSURLRequest *)request;
 *
 * @property (retain, readonly) NSString *userEmail;
 *
 * @optional
 *
 *
 *
 * @property (readonly) BOOL canAuthorize;
 *
 *
 *
 * @property (assign) BOOL shouldAuthorizeAllRequests;
 *
 * #if NS_BLOCKS_AVAILABLE
 * - (void)authorizeRequest:(NSMutableURLRequest *)request
 *        completionHandler:(void (^)(NSError *error))handler;
 * #endif
 *
 * @property (assign) id <GTMHTTPFetcherServiceProtocol> fetcherService;
 *
 * - (BOOL)primeForRefresh;
 *
 * @end
 */
@protocol GTMFetcherAuthorizationProtocol;

/**
 * Specifies the required OAuth2 scope in order to enable private Google Maps Engine
 * layers.
 */
extern NSString *const kGMSOAuth2MapsEngineScope;

/** Extensions for GMSServices for M4B build. */
@interface GMSServices (Enterprise)

/**
 * Allows for the specification of authentication details for communicating to the Google server.
 *
 * Providing an instance of GTMOAuth2Authentication from https://code.google.com/p/gtm-oauth2/ will
 * enable OAuth2 authentication with the Google server, enabling private Maps Engine layers to be
 * shown if correct authentication details are provided. This requires the OAuth2 scope
 * https://www.googleapis.com/auth/mapsengine to be specified. This is the primary intended use
 * case of this method and any other usage should provide an |authorizer| which behaves similarly.
 */
+ (void)provideAuthorizationProvider:(id<GTMFetcherAuthorizationProtocol>)authorizer;

@end
