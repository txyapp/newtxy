//
//  UpdateProcessProtocol.h
//  TXYUpdateModule
//
//  Created by aa on 16/9/27.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    UpdateTpyeNone,
    UpdateTpyeBeta,
    UpdateTpyeRelease
}UpdateTpye;

@protocol UpdateProcessProtocol <NSObject>

- (void)didUpdateProcessFinishedWithUpdateTpye:(UpdateTpye)type;

@end
