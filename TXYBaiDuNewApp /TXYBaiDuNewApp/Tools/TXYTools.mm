//
//  TXYTools.m
//  TXYBaiDuNewApp
//
//  Created by root1 on 15/9/21.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "TXYTools.h"
#import <UIKit/UIKit.h>
#include <sys/sysctl.h>
#import "IOKitLib.h"
#import "IOKitKeys.h"
#import <dlfcn.h>
#import "AppManage.h"
#import "UserAuth.h"
#include <math.h>
#include <iostream>
#include <vector>
#import "TXYConfig.h"
#import <BmobSDK/Bmob.h>
#import "WGS84TOGCJ02.h"
#import "AppInfo.h"
#import "FireToGps.h"
#import "AES128.h"
#import "DeviceAbout.h"
const long double PI = 3.14159265L;
const long double Radius = 6378137.0L;
using namespace std;

struct Tpoint
{
    Tpoint(double a,double b):j(a),w(b){}
    double j;
    double w;
};

typedef unsigned long uint32;

struct MD5Context {
    uint32 buf[4];
    uint32 bits[2];
    unsigned char in[64];
};

typedef struct MD5Context MD5_CTX;

void MD5Init(struct MD5Context *ctx);
void MD5Update(struct MD5Context *ctx, unsigned char *buf, unsigned len);
void MD5Final(unsigned char *digest, struct MD5Context *ctx);
void MD5Transform(uint32 *buf, uint32 *in);


typedef struct MD5Context MD5_CTX;

void MD5Init(struct MD5Context *ctx);
void MD5Update(struct MD5Context *ctx, unsigned char *buf, unsigned len);
void MD5Final(unsigned char *digest, struct MD5Context *ctx);
void MD5Transform(uint32 *buf, uint32 *in);

#ifdef sgi
#define HIGHFIRST
#endif

#ifdef sun
#define HIGHFIRST
#endif

#ifndef HIGHFIRST
#define byteReverse(buf, len)    /* Nothing */
#else
/*
 * Note: this code is harmless on little-endian machines.
 */
void byteReverse(unsigned char *buf, unsigned longs)
{
    uint32 t;
    do {
        t = (uint32) ((unsigned) buf[3] << 8 | buf[2]) << 16 |
        ((unsigned) buf[1] << 8 | buf[0]);
        *(uint32 *) buf = t;
        buf += 4;
    } while (--longs);
}
#endif

/*
 * Start MD5 accumulation. Set bit count to 0 and buffer to mysterious
 * initialization constants.
 */
void MD5Init(struct MD5Context *ctx)
{
    ctx->buf[0] = 0x67452301;
    ctx->buf[1] = 0xefcdab89;
    ctx->buf[2] = 0x98badcfe;
    ctx->buf[3] = 0x10325476;
    
    ctx->bits[0] = 0;
    ctx->bits[1] = 0;
}

/*
 * Update context to reflect the concatenation of another buffer full
 * of bytes.
 */
void MD5Update(struct MD5Context *ctx, unsigned char *buf, unsigned len)
{
    uint32 t;
    
    /* Update bitcount */
    
    t = ctx->bits[0];
    if ((ctx->bits[0] = t + ((uint32) len << 3)) < t)
        ctx->bits[1]++;     /* Carry from low to high */
    ctx->bits[1] += len >> 29;
    
    t = (t >> 3) & 0x3f;    /* Bytes already in shsInfo->data */
    
    /* Handle any leading odd-sized chunks */
    
    if (t) {
        unsigned char *p = (unsigned char *) ctx->in + t;
        
        t = 64 - t;
        if (len < t) {
            memcpy(p, buf, len);
            return;
        }
        memcpy(p, buf, t);
        byteReverse(ctx->in, 16);
        MD5Transform(ctx->buf, (uint32 *) ctx->in);
        buf += t;
        len -= t;
    }
    /* Process data in 64-byte chunks */
    
    while (len >= 64) {
        memcpy(ctx->in, buf, 64);
        byteReverse(ctx->in, 16);
        MD5Transform(ctx->buf, (uint32 *) ctx->in);
        buf += 64;
        len -= 64;
    }
    
    /* Handle any remaining bytes of data. */
    
    memcpy(ctx->in, buf, len);
}

/*
 * Final wrapup - pad to 64-byte boundary with the bit pattern
 * 1 0* (64-bit count of bits processed, MSB-first)
 */
void MD5Final(unsigned char *digest, struct MD5Context *ctx)
{
    unsigned count;
    unsigned char *p;
    
    /* Compute number of bytes mod 64 */
    count = (ctx->bits[0] >> 3) & 0x3F;
    
    /* Set the first char of padding to 0x80. This is safe since there is
     always at least one byte free */
    p = ctx->in + count;
    *p++ = 0x80;
    
    /* Bytes of padding needed to make 64 bytes */
    count = 64 - 1 - count;
    
    /* Pad out to 56 mod 64 */
    if (count < 8) {
        /* Two lots of padding: Pad the first block to 64 bytes */
        memset(p, 0, count);
        byteReverse(ctx->in, 16);
        MD5Transform(ctx->buf, (uint32 *) ctx->in);
        
        /* Now fill the next block with 56 bytes */
        memset(ctx->in, 0, 56);
    } else {
        /* Pad block to 56 bytes */
        memset(p, 0, count - 8);
    }
    byteReverse(ctx->in, 14);
    
    /* Append length in bits and transform */
    ((uint32 *) ctx->in)[14] = ctx->bits[0];
    ((uint32 *) ctx->in)[15] = ctx->bits[1];
    
    MD5Transform(ctx->buf, (uint32 *) ctx->in);
    byteReverse((unsigned char *) ctx->buf, 4);
    memcpy(digest, ctx->buf, 16);
    memset(ctx, 0, sizeof(ctx));        /* In case it's sensitive */
}


/* The four core functions - F1 is optimized somewhat */

/* #define F1(x, y, z) (x & y | ~x & z) */
#define F1(x, y, z) (z ^ (x & (y ^ z)))
#define F2(x, y, z) F1(z, x, y)
#define F3(x, y, z) (x ^ y ^ z)
#define F4(x, y, z) (y ^ (x | ~z))

/* This is the central step in the MD5 algorithm. */
#define MD5STEP(f, w, x, y, z, data, s) \
( w += f(x, y, z) + data, w = w<<s | w>>(32-s), w += x )

/*
 * The core of the MD5 algorithm, this alters an existing MD5 hash to
 * reflect the addition of 16 longwords of new data. MD5Update blocks
 * the data and converts bytes into longwords for this routine.
 */
void MD5Transform(uint32 *buf, uint32 *in)
{
    register uint32 a, b, c, d;
    
    a = buf[0];
    b = buf[1];
    c = buf[2];
    d = buf[3];
    
    MD5STEP(F1, a, b, c, d, in[0] + 0xd76aa478, 7);
    MD5STEP(F1, d, a, b, c, in[1] + 0xe8c7b756, 12);
    MD5STEP(F1, c, d, a, b, in[2] + 0x242070db, 17);
    MD5STEP(F1, b, c, d, a, in[3] + 0xc1bdceee, 22);
    MD5STEP(F1, a, b, c, d, in[4] + 0xf57c0faf, 7);
    MD5STEP(F1, d, a, b, c, in[5] + 0x4787c62a, 12);
    MD5STEP(F1, c, d, a, b, in[6] + 0xa8304613, 17);
    MD5STEP(F1, b, c, d, a, in[7] + 0xfd469501, 22);
    MD5STEP(F1, a, b, c, d, in[8] + 0x698098d8, 7);
    MD5STEP(F1, d, a, b, c, in[9] + 0x8b44f7af, 12);
    MD5STEP(F1, c, d, a, b, in[10] + 0xffff5bb1, 17);
    MD5STEP(F1, b, c, d, a, in[11] + 0x895cd7be, 22);
    MD5STEP(F1, a, b, c, d, in[12] + 0x6b901122, 7);
    MD5STEP(F1, d, a, b, c, in[13] + 0xfd987193, 12);
    MD5STEP(F1, c, d, a, b, in[14] + 0xa679438e, 17);
    MD5STEP(F1, b, c, d, a, in[15] + 0x49b40821, 22);
    
    MD5STEP(F2, a, b, c, d, in[1] + 0xf61e2562, 5);
    MD5STEP(F2, d, a, b, c, in[6] + 0xc040b340, 9);
    MD5STEP(F2, c, d, a, b, in[11] + 0x265e5a51, 14);
    MD5STEP(F2, b, c, d, a, in[0] + 0xe9b6c7aa, 20);
    MD5STEP(F2, a, b, c, d, in[5] + 0xd62f105d, 5);
    MD5STEP(F2, d, a, b, c, in[10] + 0x02441453, 9);
    MD5STEP(F2, c, d, a, b, in[15] + 0xd8a1e681, 14);
    MD5STEP(F2, b, c, d, a, in[4] + 0xe7d3fbc8, 20);
    MD5STEP(F2, a, b, c, d, in[9] + 0x21e1cde6, 5);
    MD5STEP(F2, d, a, b, c, in[14] + 0xc33707d6, 9);
    MD5STEP(F2, c, d, a, b, in[3] + 0xf4d50d87, 14);
    MD5STEP(F2, b, c, d, a, in[8] + 0x455a14ed, 20);
    MD5STEP(F2, a, b, c, d, in[13] + 0xa9e3e905, 5);
    MD5STEP(F2, d, a, b, c, in[2] + 0xfcefa3f8, 9);
    MD5STEP(F2, c, d, a, b, in[7] + 0x676f02d9, 14);
    MD5STEP(F2, b, c, d, a, in[12] + 0x8d2a4c8a, 20);
    
    MD5STEP(F3, a, b, c, d, in[5] + 0xfffa3942, 4);
    MD5STEP(F3, d, a, b, c, in[8] + 0x8771f681, 11);
    MD5STEP(F3, c, d, a, b, in[11] + 0x6d9d6122, 16);
    MD5STEP(F3, b, c, d, a, in[14] + 0xfde5380c, 23);
    MD5STEP(F3, a, b, c, d, in[1] + 0xa4beea44, 4);
    MD5STEP(F3, d, a, b, c, in[4] + 0x4bdecfa9, 11);
    MD5STEP(F3, c, d, a, b, in[7] + 0xf6bb4b60, 16);
    MD5STEP(F3, b, c, d, a, in[10] + 0xbebfbc70, 23);
    MD5STEP(F3, a, b, c, d, in[13] + 0x289b7ec6, 4);
    MD5STEP(F3, d, a, b, c, in[0] + 0xeaa127fa, 11);
    MD5STEP(F3, c, d, a, b, in[3] + 0xd4ef3085, 16);
    MD5STEP(F3, b, c, d, a, in[6] + 0x04881d05, 23);
    MD5STEP(F3, a, b, c, d, in[9] + 0xd9d4d039, 4);
    MD5STEP(F3, d, a, b, c, in[12] + 0xe6db99e5, 11);
    MD5STEP(F3, c, d, a, b, in[15] + 0x1fa27cf8, 16);
    MD5STEP(F3, b, c, d, a, in[2] + 0xc4ac5665, 23);
    
    MD5STEP(F4, a, b, c, d, in[0] + 0xf4292244, 6);
    MD5STEP(F4, d, a, b, c, in[7] + 0x432aff97, 10);
    MD5STEP(F4, c, d, a, b, in[14] + 0xab9423a7, 15);
    MD5STEP(F4, b, c, d, a, in[5] + 0xfc93a039, 21);
    MD5STEP(F4, a, b, c, d, in[12] + 0x655b59c3, 6);
    MD5STEP(F4, d, a, b, c, in[3] + 0x8f0ccc92, 10);
    MD5STEP(F4, c, d, a, b, in[10] + 0xffeff47d, 15);
    MD5STEP(F4, b, c, d, a, in[1] + 0x85845dd1, 21);
    MD5STEP(F4, a, b, c, d, in[8] + 0x6fa87e4f, 6);
    MD5STEP(F4, d, a, b, c, in[15] + 0xfe2ce6e0, 10);
    MD5STEP(F4, c, d, a, b, in[6] + 0xa3014314, 15);
    MD5STEP(F4, b, c, d, a, in[13] + 0x4e0811a1, 21);
    MD5STEP(F4, a, b, c, d, in[4] + 0xf7537e82, 6);
    MD5STEP(F4, d, a, b, c, in[11] + 0xbd3af235, 10);
    MD5STEP(F4, c, d, a, b, in[2] + 0x2ad7d2bb, 15);
    MD5STEP(F4, b, c, d, a, in[9] + 0xeb86d391, 21);
    
    buf[0] += a;
    buf[1] += b;
    buf[2] += c;
    buf[3] += d;
}

int cmpPassword9(char *p1,char *p2)
{
    *p1 = *p1-*p2;
    return (*p1)*(*p2);
}

int cmpPassword8(char *p1,char *p2)
{
    *p1 = *p1<2;
    return (*p1)*(*p2)*cmpPassword9(p1,p2);
}

int cmpPassword7(char *p1,char *p2)
{
    *p1 = *p1>2;
    return (*p1)*(*p2)*cmpPassword8(p1,p2);
}

int cmpPassword6(char *p1,char *p2)
{
    *p1 = *p1-*p2;
    return (*p1)*(*p2)*cmpPassword7(p1,p2);
}

int cmpPassword5(char *p1,char *p2)
{
    *p1 = *p1&*p2;
    return (*p1)*(*p2)*cmpPassword6(p1,p2);
}


int cmpPassword4(char *p1,char *p2)
{
    *p1 = (*p1)/(*p2);
    return (*p1)*(*p2)*cmpPassword5(p1,p2);
}

int cmpPassword3(char *p1,char *p2)
{
    *p1 = *p1+*p2;
    return (*p1)*(*p2)*cmpPassword4(p1,p2);
}

int cmpPassword2(char *p1,char *p2)
{
    *p1 = *p1-*p2;
    return (*p1)*(*p2)*cmpPassword3(p1,p2);
}

int cmpPassword1(char *p1,char *p2)
{
    *p1 = *p1|*p2;
    return (*p1)*(*p2)*cmpPassword2(p1,p2);
}


/*
extern NSString * SBSCopyLocalizedApplicationNameForDisplayIdentifier(NSString *identifier);
extern NSString * SBSCopyIconImagePathForDisplayIdentifier(NSString *identifier);
extern NSArray * SBSCopyApplicationDisplayIdentifiers(BOOL activeOnly, BOOL unknown);

static BOOL isFirmware3x = NO;
static NSData * (*SBSCopyIconImagePNGDataForDisplayIdentifier)(NSString *identifier) = NULL;
*/
static TXYTools *tools=nil;
@implementation TXYTools

#pragma obfuscate on
+ (instancetype)sharedTools{
    @synchronized (self){
        if (tools==nil) {
            tools=[[TXYTools alloc]init];
        }
    }
    return tools;
}

- (instancetype)init{
    self=[super init];
    if (self) {
//        isFirmware3x = [[[UIDevice currentDevice] systemVersion] hasPrefix:@"3"];
//        if (!isFirmware3x) {
//            // Firmware >= 4.0
//            SBSCopyIconImagePNGDataForDisplayIdentifier = (NSData*(*)(NSString*))dlsym(RTLD_DEFAULT, "SBSCopyIconImagePNGDataForDisplayIdentifier");
//        }
    }
    return self;
}


-(NSString *)machineCode{
    const NSString *SerialNumber_ = nil;
    NSString *tmpDeviceIDString = nil;
    char MD5Input[200];
    struct MD5Context md5c;
    unsigned char MD5MidString[16];
    char MD5FinalBuf[33]={'\0'};
    char MD5tmp[3]={'\0'};
    int i;
    
    CFMutableDictionaryRef dict = IOServiceMatching("IOPlatformExpertDevice");
    if (dict) {
        io_service_t service = IOServiceGetMatchingService(kIOMasterPortDefault, dict);
        if (service) {
            CFTypeRef serial = IORegistryEntryCreateCFProperty(service, CFSTR(kIOPlatformSerialNumberKey), kCFAllocatorDefault, 0);
            if (serial) {
                SerialNumber_ = [NSString stringWithString:(__bridge NSString *)serial];
                CFRelease(serial);
            }
            IOObjectRelease(service);
        }
    }
    memset(MD5Input, 0,200);
    sprintf(MD5Input,"%s%s%s%s%s%s%s","t","x","y","a","p","p",[SerialNumber_ UTF8String]);
    MD5Init( &md5c );
    MD5Update( &md5c, (unsigned char *)MD5Input, strlen(MD5Input) );
    MD5Final( MD5MidString, &md5c );
    
    for( i=0; i<8; i++ ){
        sprintf(MD5tmp,"%02X", MD5MidString[i] );
        strcat(MD5FinalBuf,MD5tmp);
    }
    
    tmpDeviceIDString = [NSString stringWithFormat:@"%s",MD5FinalBuf];

#if defined(DEBUG)
    return @"8009C86CCA342166";
#else
    if (tmpDeviceIDString==nil) {
        tmpDeviceIDString=@"8009C86CCA342166";
    }
    return tmpDeviceIDString;
#endif
   
}

 

-(BOOL)isCanOpen{
    NSInteger userAuth=[[UserAuth sharedUserAuth] authValueForFile];
    NSLog(@"%ld",(long)userAuth);
    if (userAuth>0) {
        return YES;
    }else{
        return NO;
    }
}


 double distance( double Aj, double Aw, double Bj, double Bw)  // //求B相对A的距离
{
     double COSC = cosl(PI/2 - Bw*PI/180)*cosl(PI/2 - Aw*PI/180) +
    sinl(PI/2 - Bw*PI/180)*sinl(PI/2 - Aw*PI/180)*cosl((Bj - Aj)*PI/180);
     double result = acosl(COSC) * Radius;   //单位米
    cout<<acosl(COSC)*Radius<<endl;
    NSLog(@"两点间距离:%lf",result);
    return result;
}

 double Azimuth( double Aj, double Aw, double Bj, double Bw)  //求B相对A的方位角
{
     double COSC = cosl(PI/2 - Bw*PI/180)*cosl(PI/2 - Aw*PI/180) +
    sinl(PI/2 - Bw*PI/180)*sinl(PI/2 - Aw*PI/180)*cosl((Bj - Aj)*PI/180);
     double SINC = sqrt(1.0 - COSC*COSC);
     double Ap = asinl(sinl(PI/2 - Bw*PI/180)*sinl((Bj - Aj)*PI/180)/SINC);
    if(Ap>=0)
    {
        if(Bw>Aw)   //第一象限
            return Ap*180.0L/PI;
        else   //第四象限
            return 180 - Ap*180.0L/PI;
    }
    else
    {
        if(Bw>Aw)   //第二象限
            return 360.0L + Ap*180.0L/PI;
        else  //第三象限
            return 180.0L - Ap*180.0L/PI;
    }
}

void GetPoint(double Aj,double Aw,double L,double Angle,double &Bj,double &Bw)   //求B经纬度,Bj,Bw为输入参数，用于保存结果
{
    double C = L/Radius;
    double COSA = cosl(PI/2 - Aw*PI/180)*cosl(C) +
    sinl(PI/2 - Aw*PI/180)*sin(C)*cosl(Angle*PI/180);
    double SINA = sqrt(1.0 - COSA*COSA);
    double w = 90 - acosl(COSA)*180/PI;
    double j = Aj + asinl(sinl(C)*sinl(Angle*PI/180)/SINA)*180/PI;
    Bj = j;
    Bw = w;
}

NSMutableArray* DiscretePoint(double Aj,double Aw,double Bj,double Bw,double step)  //计算两点之间离散点经纬度并输出，step为步长
{
    vector<Tpoint> v;
    double Pj,Pw;
    double prevj = Aj;
    double prevw = Aw;
    double dist = distance(Aj,Aw,Bj,Bw);
    double angle = Azimuth(Aj,Aw,Bj,Bw);
    NSMutableArray *array=[NSMutableArray array];
    if (dist >step) {
        for(double total = step;total < dist;total=total + step)
        {
            GetPoint(prevj,prevw,step,angle,Pj,Pw);
            Tpoint p(Pj,Pw);
            v.push_back(p);
            prevj = Pj;
            prevw = Pw;
        }
        for(int i=0;i<v.size();i++)
        {
            if ( !isnan(v[i].w) || !isnan(v[i].j)) {
                CLLocationCoordinate2D coor;
                coor.latitude=v[i].w;
                coor.longitude=v[i].j;
                // NSLog(@"%f   %f ",coor.latitude,coor.longitude);
                [array addObject:[NSValue value:&coor withObjCType:@encode(CLLocationCoordinate2D)]];
            }
        }
    }
    if (array.count == 0) {
        CLLocationCoordinate2D start;
        start.latitude = Aw;
        start.longitude = Aj;
        CLLocationCoordinate2D end;
        end.latitude =Bw;
        end.longitude = Bj;
        [array insertObject:[NSValue value:&start withObjCType:@encode(CLLocationCoordinate2D)] atIndex:0];
        [array insertObject:[NSValue value:&end withObjCType:@encode(CLLocationCoordinate2D)] atIndex:array.count];
    }
    if (array.count == 1) {
        CLLocationCoordinate2D end;
        end.latitude =Bw;
        end.longitude = Bj;
        [array insertObject:[NSValue value:&end withObjCType:@encode(CLLocationCoordinate2D)] atIndex:array.count];
    }
    return array;
}

-(NSMutableArray *)cutWithFromCoor:(CLLocationCoordinate2D)fromCoor andToCoor:(CLLocationCoordinate2D)toCoor andLength:(double)length{
    return DiscretePoint(fromCoor.longitude, fromCoor.latitude ,toCoor.longitude, toCoor.latitude ,length);
}

#define kRad2Deg (180/M_PI) // 180/π
#define kDeg2Rad (M_PI/180) // π/180
-(double)getWithFromCoor:(CLLocationCoordinate2D)fromCoor andToCoor:(CLLocationCoordinate2D)toCoor
{
    CLLocationCoordinate2D desired=toCoor;
    CLLocationCoordinate2D current=fromCoor;
    
    double lat1 = current.latitude*kDeg2Rad;
    double lat2 = desired.latitude*kDeg2Rad;
    double lon1 = current.longitude;
    double lon2 = desired.longitude;
    double dlon = (lon2-lon1)*kDeg2Rad;
    
    double y = sin(dlon)*cos(lat2);
    double x = cos(lat1)*sin(lat2) - sin(lat1)*cos(lat2)*cos(dlon);
    
    double heading=atan2(y,x);
    heading=heading*kRad2Deg;
    heading=heading+360.0;
    heading=fmod(heading,360.0);
    return heading;

    //return Azimuth(fromCoor.longitude, fromCoor.latitude ,toCoor.longitude, toCoor.latitude);
}

- (NSMutableDictionary *)loadSetDictForPath:(NSString *)path{
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    if (str) {
        NSString *desStr = [DES decryptString:str];
        NSData *jsonData = [desStr dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *dict = [[NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil] mutableCopy];
        if (dict==nil) {
            dict=[NSMutableDictionary dictionary];
        }
        return dict;
    }else{
        return [NSMutableDictionary dictionary];
    }

}


- (BOOL)writeDict:(NSMutableDictionary *)dict toPath:(NSString *)path{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *desStr = [DES encryptString:str];
    NSError *error;
    BOOL result=[desStr writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:&error];
    return result;
}


#pragma mark - 上传国外用户信息
- (void)getOldInfoWithCoor:(CLLocationCoordinate2D)coor andAdress:(NSString *)address
{
    int isOut =  [[[NSUserDefaults standardUserDefaults]objectForKey:@"outOfMainland"] intValue];
    if (isOut == 1) {
        if ([[TXYTools sharedTools] isCanOpen]) {
            if([[NSUserDefaults standardUserDefaults]objectForKey:@"userName"])
            {
                NSMutableDictionary *coordic = [NSMutableDictionary dictionary];
                //NSLog(@"%@",dict[@"name"]);
                [coordic setValue:[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"] forKey:@"username"];
                [coordic setValue:@([[TXYConfig sharedConfig]getRealGPS].latitude) forKey:@"real lat"];
                [coordic setValue:@([[TXYConfig sharedConfig]getRealGPS].longitude) forKey:@"real lng"];
                [coordic setValue:@(coor.latitude) forKey:@"mock lat"];
                [coordic setValue:@(coor.longitude) forKey:@"mock lng"];
                [coordic setValue:[[DeviceAbout sharedDevice]deviceNum] forKey:@"uuid"];
                [coordic setValue:address forKey:@"mock address"];
                NSString *userString =[self convertToJSONData:coordic];
                NSDictionary *requestDic = @{@"data":userString,@"header":getPhonePublicInfo};
                NSString *stringR = [self convertToJSONData:requestDic];
                NSString *bbbb = [AES128 AES128Encrypt:stringR withKey:AESKey];
                NSDictionary *dic = @{@"body":bbbb,@"t1":[NSString stringWithFormat:@"%lld",uptime],@"type":@"1008",@"flag":@"4"};
                AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
                NSString *url = @"http://ipay.txyapp.com:7658/api/entrance/";
                [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    //上传成功后
                    NSLog(@"quanjudian shangchuan");
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                }];
            }
            
        }
    }
}

- (void)setOldCoordinate:(CLLocationCoordinate2D)coor
{
    if ([WGS84TOGCJ02 isLocationOutOfChina:coor]) {
        [[TXYConfig sharedConfig] setIsVip:YES];
    }else{
        [[TXYConfig sharedConfig] setIsVip:NO];
    }
}

//如果真实位置在0 0点则不上传
- (BOOL)isZeroPoint
{
    CLLocationCoordinate2D oldCoor = [[TXYConfig sharedConfig] getRealGPS];
    if (oldCoor.longitude < 0.01 && oldCoor.longitude > -0.01 && oldCoor.latitude < 0.01 && oldCoor.latitude > -0.01) {
        return YES;
    }else{
        return NO;
    }
}

//由于国外用户会先百度坐标转称gps 所以要转回百度坐标  国外测出来的坐标本身就是gps坐标
- (CLLocationCoordinate2D)convertGPStoGPS:(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D oriHuoxing = [[FireToGps sharedIntances] gcj02Encrypt:coordinate.latitude bdLon:coordinate.longitude];
    CLLocationCoordinate2D oriBaiDu = [[FireToGps sharedIntances] hhTrans_bdGPS:oriHuoxing];
    return oriBaiDu;
}
- (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict options:NSJSONWritingPrettyPrinted  error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return jsonString;
}
@end
