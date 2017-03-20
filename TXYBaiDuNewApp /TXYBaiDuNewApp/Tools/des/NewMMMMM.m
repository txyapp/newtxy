

//
//  NewMMMMM.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/12/29.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "NewMMMMM.h"
#define MGS_LENGTH 128
@implementation NewMMMMM
char* addCoder(char *inStr,char* keyStr,char *keyStr2)
{
    if (!inStr) {
        return nil;
    }
    char * resutl;;
    //memset(resutl, 0, MGS_LENGTH);
    for (int i = 0; i < strlen(inStr); i ++) {
        for (int j = 0; j < strlen(keyStr); j++) {
            if (inStr[i] == keyStr[j]) {
                strcat(resutl,&keyStr2[j]);
            }
        }
    }
    return resutl;
}
@end
