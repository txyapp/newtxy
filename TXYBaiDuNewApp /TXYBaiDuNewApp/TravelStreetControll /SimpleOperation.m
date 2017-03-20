//
//  SimpleOperation.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/18.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "SimpleOperation.h"
#import "TXYConfig.h"
#import "TXYTools.h"
#import <Foundation/Foundation.h>
#import "FireToGps.h"
#import "ScanPointManager.h"
@implementation SimpleOperation
- (id)init {
    self = [super init];
    if (self) {
        executing = NO;
        finished  = NO;
        self.IsDel = 0;
        self.isStop= 0;
        self.isShowLineStop = 0;
        self.AllCancle = 0;
        jdc = 0;
    }
    return self;
}

// 定义初始化方法
- (id) initWithObject:(NSObject *)paramObject withIndexRow:(int)row withArr:(NSMutableArray *)arr withWhichBoundle:(NSString *)boundle{
    self = [super init];
    if (self != nil){
        givenObject = paramObject;
        indexRow = row;
        dataArr = arr;
        Boundle = boundle;
        self.whichSingle = Boundle;
       // [self addObserver:self forKeyPath:@"courseName" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];

        NSLog(@"%@",paramObject);
    }
    return(self);
}
- (void) start {
    
    if ([self isCancelled]){
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    } else {
        
        [self willChangeValueForKey:@"isExecuting"];
        executing = YES;
        [self main];
        [self didChangeValueForKey:@"isExecuting"];
        
    }
}
- (void) main {
    @try {
        @autoreleasepool {
            ScanPointManager *mangager = [ScanPointManager defaultManager];
            NSMutableArray * curentA = [NSMutableArray arrayWithCapacity:0];
            if (self.isCancelled) return;
           // UISwitch *cs1 = (UISwitch *)givenObject;
           // NSLog(@"%ld",(long)cs1.tag);
            DBResultModel model;
            NSData *lastData = dataArr[0];
            [lastData getBytes:&model length:sizeof(DBResultModel)];
            float length = model.len;
           // NSLog(@"总共有:%d点",dataArr.count);
            int m = 0;
            int b = 0;
            int a = 0;
            while (1) {
                for (int n = 0; n < dataArr.count-1 ; n++)
                {
                    [curentA removeAllObjects];
                    DBResultModel firstModel;
                    NSData *firstData = dataArr[n];
                    [firstData getBytes:&firstModel length:sizeof(DBResultModel)];
                    CLLocationCoordinate2D first;
                   first =  MKCoordinateForMapPoint(MKMapPointMake(firstModel.x, firstModel.y));
                    DBResultModel endModel;
                    NSData *endData = dataArr[n+1];
                    [endData getBytes:&endModel length:sizeof(DBResultModel)];
                    CLLocationCoordinate2D end;
                    end =  MKCoordinateForMapPoint(MKMapPointMake(endModel.x, endModel.y));
                    // NSLog(@"%d",n);
                    curentA =[NSMutableArray arrayWithArray:[[self chargeDasticencewithstarCLL:first withEndCLL:end length:length withInt:n chargeWait:firstModel.isWaitPoint withTime:firstModel.waiteSeconds andIsWaite:firstModel.waitePoint] copy]] ;
                    m++;
                   // NSLog(@"循环了:%d次,当前路段点数:%d",m,curentA.count);
                    NSLog(@"--------是否为停留点:%d",firstModel.isWaitPoint);
                    a += curentA.count;
                    //NSLog(@"一共有:%d个点",a);
                    //NSLog(@"此次需要循环%d次",curentA.count);
                    int stopPointNum = 0;
                    for (int l =0;  l < curentA.count-1;  l++)
                    {
                        
                        if (self.isStop == 0 && self.isShowLineStop == 0){
                            stopPointNum = l;
                            if (self.isCancelled)
                            {
                                dispatch_sync(dispatch_get_main_queue(), ^(){
                                    if (self.IsDel ==0&&self.AllCancle ==0) {
                                        [self.delegate refreshWithRow:self.whichSingle];
                                    }
                                });
                                [self willChangeValueForKey:@"isFinished"];
                                finished = YES;
                                [self didChangeValueForKey:@"isFinished"];
                                return;
                            }
                            // NSLog(@"%ld",(long)cs1.tag);
                            DBResultModel model;
                            NSData *lastData = curentA[l];
                            [lastData getBytes:&model length:sizeof(DBResultModel)];
                            MKMapPoint touchPoint;
                            touchPoint.x = model.x;
                            touchPoint.y = model.y;
                            CLLocationCoordinate2D coords = MKCoordinateForMapPoint(touchPoint);
                            DBResultModel model1;
                            NSData *lastData1 = curentA[l+1];
                            [lastData1 getBytes:&model1 length:sizeof(DBResultModel)];
                            MKMapPoint touchPoint1;
                            touchPoint1.x = model1.x;
                            touchPoint1.y = model1.y;
                            CLLocationCoordinate2D ToCoords = MKCoordinateForMapPoint(touchPoint1);
                            double jd = [[TXYTools sharedTools]getWithFromCoor:coords andToCoor:ToCoords];
                            if ((0<(int)jd && (int)jd<360)&&!isnan(jd)) {
                                if ((int)jd >180) {
                                    if (l<1 ) {
                                        self.jiaodu = [NSString stringWithFormat:@"%lf",jd];
                                        jdc = jd;
                                    }
                                    else
                                    {
                                        self.jiaodu = [NSString stringWithFormat:@"%lf",jdc];
                                    }
                                }
                                else
                                {
                                    self.jiaodu = [NSString stringWithFormat:@"%lf",jd];
                                    jdc = jd;
                                }
                                
                            }
                            else
                            {
                                self.jiaodu = [NSString stringWithFormat:@"%lf",jdc];
                            }
                            // NSLog(@"当前角度: %@",self.jiaodu);
                            NSDictionary *dic = @{@"model":lastData,@"boundle":Boundle,@"jiaodu":[NSString stringWithFormat:@"%lf",[self.jiaodu doubleValue]]};
                            //
                            //发送通知
                            if (self.IsDel == 0) {
                                mangager.dic = [[NSMutableDictionary alloc]init];
                                [mangager.dic setValue:dic forKey:[Boundle stringByReplacingOccurrencesOfString:@"." withString:@""]];
                                //NSLog(@"%@",mangager.dic);
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:dic];
                                if( n  == dataArr.count -2 && l == curentA.count-2)
                                {
                                    DBResultModel model1;
                                    NSData *firstData = [dataArr lastObject];
                                    [firstData getBytes:&model1 length:sizeof(DBResultModel)];
                                    end =  MKCoordinateForMapPoint(MKMapPointMake(model1.x, model1.y));
                                    DBResultModel model;
                                    model.latitude = end.latitude;
                                    model.longtitude = end.longitude;
                                    model.x = MKMapPointForCoordinate(end).x;
                                    model.y = MKMapPointForCoordinate(end).y;
                                    model.isWaitPoint = 0;
                                    model.whichbundle = model1.whichbundle;
                                    model.ScanRate = model1.ScanRate;
                                    model.isCycle = model1.isCycle;
                                    model.isState = model1.isState;
                                    NSData *msgData = [[NSData alloc]initWithBytes:&model length:sizeof(DBResultModel)];
                                    NSDictionary *dic1 = @{@"model":msgData,@"boundle":Boundle,@"jiaodu":[NSString stringWithFormat:@"%lf",[self.jiaodu doubleValue]]};
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:dic1];
                                    //[mangager.dic setValue:dic1 forKey:Boundle];
                                    [mangager.dic removeObjectForKey:[Boundle stringByReplacingOccurrencesOfString:@"." withString:@""]];
                                    
                                }
                                b ++;
                                //  NSLog(@"传了%d点",b);
                            }
                            NSMutableDictionary *scanDict=[NSMutableDictionary dictionary];
                            //CBD
                            CLLocationCoordinate2D new = [[FireToGps sharedIntances]gcj02Decrypt:coords.latitude gjLon:coords.longitude];
                            NSDictionary *GPSdict1=@{@"Latitude":@(new.latitude),
                                                     @"Longitude":@(new.longitude)};
                            [scanDict setObject:GPSdict1 forKey:Boundle];
                            // NSLog(@"客户端%@",GPSdict1);
                            [[TXYConfig sharedConfig] scanStreetWithBundleDict:scanDict];
                            // NSLog(@"model.isState is  :%d",model.isState);
                            // NSLog(@"%d",l);
                            DBResultModel Lmodel;
                            NSData *LData = [curentA lastObject];
                            [LData getBytes:&Lmodel length:sizeof(DBResultModel)];
                            if (model.isCycle == 0 && n==dataArr.count -2 && l == curentA.count -2) {
                                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                                if (localNotification == nil) {
                                    return;
                                }
                                //设置本地通知的触发时间（如果要立即触发，无需设置），这里设置为20妙后
                                localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
                                //设置本地通知的时区
                                localNotification.timeZone = [NSTimeZone defaultTimeZone];
                                //设置通知的内容
                                localNotification.alertBody = @"扫街已完成";
                                //设置通知动作按钮的标题
                                //                                localNotification.alertAction = @"点击查看";
                                //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
                                localNotification.soundName = UILocalNotificationDefaultSoundName;
                                // 设置应用程序右上角的提醒个数
                                localNotification.applicationIconBadgeNumber++;
                                //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
                                NSDictionary *infoDic = nil;
                                localNotification.userInfo = infoDic;
                                //[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                                if (iOS8) {
                                    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
                                        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
                                        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                                                 categories:nil];
                                        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                                    }
                                }
                                [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                            }
                            //最后一个位置了并且不再循环
                            if (model.isCycle == 0 && n  == dataArr.count -2 ) {
                                if (l == curentA.count-2 && curentA.count !=0) {
                                    if (model.isState == 0) {
                                        [[TXYConfig sharedConfig] stopScanStreetWithBundleId:Boundle];
                                    }
                                    else if(model.isState == 1)
                                    {
                                        
                                    }
                                    dispatch_sync(dispatch_get_main_queue(), ^(){
                                        if (self.IsDel == 0) {
                                            [self.delegate refreshWithRow:self.whichSingle];
                                        }
                                    });
                                    [self willChangeValueForKey:@"isFinished"];
                                    finished = YES;
                                    [self didChangeValueForKey:@"isFinished"];
                                    return;
                                }
                            }
                            if (![[TXYConfig sharedConfig]getToggle]) {
                                dispatch_sync(dispatch_get_main_queue(), ^(){
                                    if (self.IsDel == 0) {
                                        [self.delegate cancleAll];
                                        return;
                                    }
                                });
                            }
                            NSLog(@"停留时间:%d    红绿灯时间:%d    频率:%f   是否是拐点:%d",model.waiteSeconds,model.redWaitSeconds,model.ScanRate,model.isWaitPoint);
                            //isWaitPoint  拐点标识 waitePoint 手动暂停点标识
                            
                            if (model.isWaitPoint == 1 || model.waitePoint == 1) {
                                if (model.isWaitPoint ==1) {
                                    self.isStop =1;
                                    NSTimer *timer = [NSTimer timerWithTimeInterval:(model.redWaitSeconds + model.ScanRate) target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
                                    //将定时器添加到runloop中
                                    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
                                    [[NSRunLoop currentRunLoop] run];
                                }
                                if (model.waitePoint == 1) {
                                    self.isStop =1;
                                    NSTimer *timer = [NSTimer timerWithTimeInterval:(model.waiteSeconds + model.ScanRate) target:self selector:@selector(timerAction) userInfo:nil repeats:NO];
                                    //将定时器添加到runloop中
                                    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
                                    [[NSRunLoop currentRunLoop] run];
//                                    [NSThread sleepForTimeInterval:model.waiteSeconds];
//                                    [NSThread sleepForTimeInterval:model.ScanRate];
                                }
                            }
                            else
                            {
                                [NSThread sleepForTimeInterval:model.ScanRate];
                            }
                        }
                        else
                        {
                            l = stopPointNum;
                        }
                    }
                }
            }
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception %@", e);
    }
}

//停留时间到了以后
-(void)timerAction
{
    self.isStop = 0;
}
//切路线
-(NSMutableArray *)chargeDasticencewithstarCLL:(CLLocationCoordinate2D )start withEndCLL:(CLLocationCoordinate2D )end length:(float)len withInt:(int)whitch chargeWait:(int)iswaitePoint withTime:(int)waiteTime andIsWaite:(int)waite
{
    //NSLog(@"%f",len);
    NSMutableArray *resultA = [NSMutableArray arrayWithCapacity:0];
    NSArray *a1 =[[[TXYTools sharedTools] cutWithFromCoor:start andToCoor:end andLength:len] copy];
    for (int m = 0; m < a1.count;  m++) {
        CLLocationCoordinate2D c;
        NSValue *value = a1[m];
        [value getValue:&c];
        if (c.latitude!=0&&c.longitude!=0) {
            DBResultModel model;
            model.latitude =c.latitude;
            model.longtitude = c.longitude;
            model.x = MKMapPointForCoordinate(c).x;
            model.y = MKMapPointForCoordinate(c).y;
            model.isWaitPoint = 0;
            // model.whichbundle = (char*)[self.boundle UTF8String];
            DBResultModel model1;
            NSData *Data = dataArr[0];
            [Data getBytes:&model1 length:sizeof(DBResultModel)];
            model.whichbundle = model1.whichbundle;
            model.ScanRate = model1.ScanRate;
            model.isCycle = model1.isCycle;
            model.isState = model1.isState;
            model.redWaitSeconds = model1.redWaitSeconds;
            model.waiteSeconds = model1.waiteSeconds;
            model.waitePoint = 0;
            if (iswaitePoint ==1 || waite ==1) {
                if (m==0) {
                    if (iswaitePoint ==1) {
                        model.isWaitPoint = 1;
                    }
                    if(waite == 1)
                    {
                        model.waitePoint = 1;
                        model.waiteSeconds = waiteTime;
                    }
                }
            }
            NSLog(@"红绿灯:------%d,等待时间:------%d",model1.redWaitSeconds,waiteTime);
            NSData *msgData = [[NSData alloc]initWithBytes:&model length:sizeof(DBResultModel)];
            [resultA addObject:msgData];
        }
    }
    return resultA;
}
// 跟同步不同的地方。
// 必须重载Operation的实例方法 isConcurrent并在该方法中返回 YES



- (BOOL) isConcurrent{
    return YES;
}
-(BOOL)isReady
{
    return YES;
}
- (BOOL) isFinished{
    ScanPointManager *mangager = [ScanPointManager defaultManager];
    [mangager.dic removeObjectForKey:[Boundle stringByReplacingOccurrencesOfString:@"." withString:@""]];
    return finished;
}

- (BOOL) isExecuting{
    
    return executing;
}
@end
