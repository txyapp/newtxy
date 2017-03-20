

#import <Foundation/Foundation.h>


@interface NSString (NSString_Hashing)

- (NSString *)MD5Hash;
-(NSString *)MD5Hash: (int )byte;
+(NSString*)fileMD5:(NSString*)path;

+(NSString*)dataMD5:(NSData*)data;
@end
