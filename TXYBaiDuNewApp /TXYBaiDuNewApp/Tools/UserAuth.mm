//
//  UserAuth.m
//  TXYBaiDuNewApp
//
//  Created by root1 on 15/9/22.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "UserAuth.h"
#import "TXYTools.h"
#import "NSString+Hashing.h"
#import "TXYConfig.h"
#import <BmobSDK/Bmob.h>
#import "UMOnlineConfig.h"
#import "txysec.h"
#import "MBProgressHUD.h"
#import "MyAlert.h"
#import "AES128.h"
static UserAuth *userAuth=nil;
static int count=0;
@implementation UserAuth

#define key1 @"123456789"
#define key2 @"987654321"

#pragma obfuscate on
+ (instancetype)sharedUserAuth{
    @synchronized (self){
        if (userAuth==nil) {
            userAuth=[[UserAuth alloc]init];
        }
    }
    return userAuth;
}


-(NSInteger)authValueForFile{
#if defined(DEBUG)
    return 1;
#else
    NSMutableDictionary *setDict=[[TXYTools sharedTools]loadSetDictForPath:kSetPlist];
    NSInteger value=[[setDict objectForKey:@"authValue"] integerValue];
    return value;
#endif
}

-(void)resquestWithUrl:(NSString *)baseURL{
//    NSString *machineCode = [[TXYTools sharedTools] machineCode];
//    NSString *md5= [[NSString stringWithFormat:@"%@%@",machineCode,key1] MD5Hash];
//    NSString *str1=@"?appid=11223344&md5=75a8c0bc984d721ab299416fd9014705&parameter=%26mutualkey%3db44a79ad8494258b9e2058b9b5f15c29%26openid%3d";
//    str1=[NSString stringWithFormat:@"%@%@",baseURL,str1];
//    NSString *str2=@"%26sign%3d";
//    NSString *str3=@"%26api%3dkey.iphone%26BSphpSeSsL%3dABC123456789%26class%3d12";
//    NSString *strurl=[NSString stringWithFormat:@"%@%@%@%@%@&txy=%d",str1,machineCode,str2,md5,str3,(int)[NSDate date].timeIntervalSince1970];
//    NSLog(@"%@",strurl);
//    
//    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
//    [dict setObject:[NSString stringWithFormat:@"%d",(int)[NSDate date].timeIntervalSince1970] forKey:@"txy"];
//    
//    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
//    //[mgr.requestSerializer setValue:head forHTTPHeaderField:@"txyhead"];
//    [mgr POST:strurl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //NSLog(@"请求成功:%@",responseObject);  //responseObject 是字典
//        
//        NSDictionary *responseDict=responseObject;
//        NSString *str = [[NSString stringWithFormat:@"%@%@%@%@%@%@%@",[responseDict objectForKey:@"openid"],key2,[responseDict objectForKey:@"infoid"],[responseDict objectForKey:@"endtime"],[responseDict objectForKey:@"regtime"],[responseDict objectForKey:@"isok"],[responseDict objectForKey:@"unix"]] MD5Hash];
//        //NSLog(@"%@",str);
//        NSString *endTime=[responseDict objectForKey:@"endtime"];
//        //NSLog(@"endtime  %@",endTime);
//        [[TXYConfig sharedConfig] setDaoQiTime:endTime];
//        if ([str isEqualToString:[responseDict objectForKey:@"sign"]]&&[[responseDict objectForKey:@"isok"]isEqualToString:@"1"]){
//            NSMutableDictionary *setDict=[[TXYTools sharedTools] loadSetDictForPath:kSetPlist];
//            [setDict setObject:@(1) forKey:@"authValue"];
//            NSLog(@"yes   .....................................");
//            //[self authValueFormWeb];
//            [[TXYTools sharedTools] writeDict:setDict toPath:kSetPlist];
//            NSNotification * notice = [NSNotification notificationWithName:@"authok" object:nil userInfo:nil];
//            [[NSNotificationCenter defaultCenter]postNotification:notice];
//            count=0;
//        }else{
//            NSMutableDictionary *setDict=[[TXYTools sharedTools] loadSetDictForPath:kSetPlist];
//            [setDict setObject:@(0) forKey:@"authValue"];
//            NSLog(@"no ........................");
//            [[TXYTools sharedTools] writeDict:setDict toPath:kSetPlist];
//            NSNotification * notice = [NSNotification notificationWithName:@"authok" object:nil userInfo:nil];
//            [[NSNotificationCenter defaultCenter]postNotification:notice];
//            if (count<=3) {
//                NSLog(@"re ......................");
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self authValueFormWeb];
//                });
//                count++;
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        count++;
//        if (count<5) {
//            NSLog(@"请求失败%@\n%@",operation.response,error);
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self authValueFormWeb];
//            });
//        }
//        
//    }];
    
    
}

-(void)authValueFormWeb{
//    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
//    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
//    mgr.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//    NSString *url=@"http://apt1-server.stor.sinaapp.com/url.txt";
//    double time=[NSDate date].timeIntervalSince1970;
//    url=[NSString stringWithFormat:@"%@?t=%f",url,time];
//    [mgr GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *jsonObject=[NSJSONSerialization
//                                  JSONObjectWithData:responseObject
//                                  options:NSJSONReadingMutableLeaves
//                                  error:nil];
//        NSArray *urlArr=[jsonObject objectForKey:@"url"];
//        int x = arc4random() % urlArr.count;
//        NSString *baseURL=urlArr[x];
//     
//        [BmobCloud callFunction:@"urlCount" withParameters:@{@"url":baseURL}];
//        [self resquestWithUrl:baseURL];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//        count++;
//        if (count<5) {
//            //NSLog(@"请求失败%@\n%@",operation.response,error);
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self authValueFormWeb];
//            });
//        }else{
//            NSString *baseURL=[UMOnlineConfig getConfigParams:@"login"];
//            [BmobCloud callFunction:@"urlCount" withParameters:@{@"url":@"umeng"}];
//            [self resquestWithUrl:baseURL];
//        }
//    }];

}

//新的验证流程
-(void)newAuthValueFormWeb{
    NSString *user =    [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if (user && token ) {
        //说明有账号 此时验证vip
        AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
        NSString *url = [NSString stringWithFormat:@"%@%@",MainApi,GetUserInfo];//117
        NSDictionary *userDic = @{@"username":user,@"token":token};
        NSString *userString =[self convertToJSONData:userDic];
        NSDictionary *requestDic = @{@"data":userString,@"header":getPhonePublicInfo};
        NSString *stringR = [self convertToJSONData:requestDic];
       // NSLog(@"string ===== %@",stringR);
        NSString *bbbb = [AES128 AES128Encrypt:stringR withKey:AESKey];
//        NSString *bbbb = [NSString stringWithFormat:@"%s",bb];
         NSDictionary *dic = @{@"body":bbbb,@"t1":[NSString stringWithFormat:@"%lld",uptime],@"type":@"117",@"flag":@"4"};
        [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *responseDict=responseObject;
            NSLog(@"%@",responseDict);
            if (responseDict) {
                int state = [responseDict[@"status"] integerValue];
                if (state == 0) {
                    NSString *data = responseDict[@"data"];
//                    char *bb11 = dec_data_impl(data.UTF8String);
                    NSString *bbbb11 = [AES128 AES128Decrypt:data withKey:AESKey];
                  //  NSLog(@"enc111 : %@",bbbb11);
                    NSData *jsonData = [bbbb11 dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                    if ([dic[@"status"] integerValue]==0) {
                        //判断dic 的 vip字段
                        NSDictionary *dic1 = dic[@"user_info"];
                       // NSLog(@"-------%@",dic1);
                        int isVip = [dic1[@"vip"] integerValue];
                        if (isVip == 0) {
                            //非会员
                            NSMutableDictionary *setDict=[[TXYTools sharedTools] loadSetDictForPath:kSetPlist];
                            [setDict setObject:@(0) forKey:@"authValue"];
                            [[TXYConfig sharedConfig] setToggleWithBool:NO];
                            [[TXYTools sharedTools] writeDict:setDict toPath:kSetPlist];
                        }
                        else
                        {
                            //会员
                            NSMutableDictionary *setDict=[[TXYTools sharedTools] loadSetDictForPath:kSetPlist];
                            [setDict setObject:@(1) forKey:@"authValue"];
                            [[TXYTools sharedTools] writeDict:setDict toPath:kSetPlist];
                            if (dic1[@"expire_time"]) {
                                int time = [dic1[@"expire_time"] integerValue];
                                if(time !=0)
                                {
                                    [[NSUserDefaults standardUserDefaults]setObject:[self timeFormatted:time] forKey:@"expiretime"];
                                }
                                else
                                {
                                    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"expiretime"];
                                }
                            }
                        }
                        
                    }
                    else
                    {
                        NSLog(@"%@",dic[@"msg"]);
                        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"expiretime"];
                        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"token"];
                        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userName"];
                        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"NewUserStatus"];
                        //退出登录后把开关权限关闭
                        NSMutableDictionary *setDict=[[TXYTools sharedTools] loadSetDictForPath:kSetPlist];
                        [setDict setObject:@(0) forKey:@"authValue"];
                        [[TXYTools sharedTools] writeDict:setDict toPath:kSetPlist];
                    }
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
    else
    {
        
        NSString *str = LoginPlist;
        NSMutableDictionary *plistDict;
        if (str) {
            plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:LoginPlist];
            if (plistDict==nil) {
                plistDict=[NSMutableDictionary dictionary];
            }
        }else{
            plistDict=[NSMutableDictionary dictionary];
        }
        NSDictionary* codeDic = [plistDict objectForKey:@"existCode"];
        NSMutableDictionary* existCodeDic = nil;
        if (codeDic == nil){
            existCodeDic = [[NSMutableDictionary alloc]init];
        }else{
            existCodeDic = [NSMutableDictionary dictionaryWithDictionary:codeDic];
        }
        if ([existCodeDic[@"existMachine"] isEqualToString:@"yes"]) {
            return;
        }
        else{
            //没有账号  就验证机器码
            NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
            NSString *machineCode = [[TXYTools sharedTools] machineCode];
            NSDictionary *userDic = @{@"l_user_id":machineCode};
            NSString *userString =[self convertToJSONData:userDic];
            NSDictionary *requestDic = @{@"data":userString,@"header":getPhonePublicInfo};
            NSString *stringR = [self convertToJSONData:requestDic];
            NSString *bbbb = [AES128 AES128Encrypt:stringR withKey:AESKey];
            // NSString *bbbb = [NSString stringWithFormat:@"%s",bb];
            NSDictionary *dic = @{@"body":bbbb,@"t1":[NSString stringWithFormat:@"%lld",uptime],@"type":@"124",@"flag":@"4"};
            AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
            NSString *url = [NSString stringWithFormat:@"%@%@",MainApi,checkIsVIP];//124
            [mgr POST:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"%@",responseObject);
                NSDictionary *responseDict=responseObject;
                NSLog(@"%@",responseDict);
                if (responseDict) {
                    int state = [responseDict[@"status"] integerValue];
                    if (state == 0) {
                        //本机器码 是会员 但是没有注册绑定过账号
                        NSString *data = responseDict[@"data"];
                        if (!data) return ;
                        NSString *bbbb11 = [AES128 AES128Decrypt:data withKey:AESKey];
                        // NSLog(@"enc111 : %@",bbbb11);
                        NSData *jsonData = [bbbb11 dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
                        if ([dic[@"status"] integerValue]==0) {
                            NSLog(@"%@",dic[@"msg"]);
                            //把会员状态存储起来,1是会员但未注册0是非会员未注册
                            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"NewUserStatus"];
                            [userPoint synchronize];
                            NSMutableDictionary *setDict=[[TXYTools sharedTools] loadSetDictForPath:kSetPlist];
                            [setDict setObject:@(0) forKey:@"authValue"];
                            [[TXYTools sharedTools] writeDict:setDict toPath:kSetPlist];
                            [[TXYConfig sharedConfig] setToggleWithBool:NO];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"mainUpdata" object:machineCode];
                            
                        }
                    }
                    else
                    {
                        NSLog(@"%@",responseDict[@"info"]);
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
            }];
        }
    }
}
//转化时间
- (NSString *)timeFormatted:(int)totalSeconds
{
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:totalSeconds];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strDate = [dateFormatter stringFromDate:localeDate];
    NSLog(@"strDate=%@",strDate);
    return strDate;
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
