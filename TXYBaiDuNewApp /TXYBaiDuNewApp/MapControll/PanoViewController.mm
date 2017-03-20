//
//  PanoViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/10/9.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "PanoViewController.h"
#import "BaiduPanoramaView.h"
#import "BaiduPanoDataFetcher.h"
#import "BaiduPanoUtils.h"
#import "BaiduPanoImageOverlay.h"
#import "BaiduPanoLabelOverlay.h"
#import "BaiduPoiPanoData.h"
#import "BaiduLocationPanoData.h"
#import "MBProgressHUD.h"
#import "juHua.h"
@interface PanoViewController ()<BaiduPanoramaViewDelegate>{
    juHua* _juhua;
}

//创建全景类
@property(strong, nonatomic) BaiduPanoramaView  *panoramaView;

@end

@implementation PanoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
    [self makeView];
}
- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden =  NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.panoramaView.delegate = nil;
    _panoramaView = nil;
}

//创建ui
- (void)makeView{


    
    //实例化全景类
    _panoramaView = [[BaiduPanoramaView alloc]initWithFrame:[UIScreen mainScreen].bounds key:BaiduKey];
    
    // 为全景设定一个代理
    self.panoramaView.delegate = self;
    [self.view addSubview:self.panoramaView];
    // 设定全景的清晰度， 默认为middle
    [self.panoramaView setPanoramaImageLevel:ImageDefinitionMiddle];
    
    //根据百度坐标显示全景图
   // [self.panoramaView setPanoramaWithLon:120.49 lat:39.84];
    NSLog(@"1= %f  2= %f",_coord.longitude,_coord.latitude);
    
  CLLocationCoordinate2D coo=  [BaiduPanoUtils  baiduCoorEncryptLon:_coord.longitude lat:_coord.latitude coorType:COOR_TYPE_GPS];
    
    NSLog(@"3= %f   4= %f",coo.longitude,coo.latitude);
    
    
    [_juhua showAllScreen:YES Image:[UIImage imageNamed:@"zhuan"]];
    _juhua.label.text = @"加载中";
    [self.panoramaView setPanoramaWithLon:_coord.longitude lat:_coord.latitude];
    
  //  [self.panoramaView setPanoramaWithPid:@"01002200001309101607372275K"];
  
}

- (void)buttonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)panoramaDidLoad:(BaiduPanoramaView *)panoramaView descreption:(NSString *)jsonStr{
    [_juhua hide];
}


- (void)panoramaLoadFailed:(BaiduPanoramaView *)panoramaView error:(NSError *)error{
    NSLog(@"加载失败");
    NSLog(@"error = %@",error);
    dispatch_async(dispatch_get_main_queue(), ^(){
//        MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:self.panoramaView animated:YES];
//        progressHud.mode = MBProgressHUDModeText;
//        progressHud.labelText = @"当前选点没有全景图";
//        progressHud.margin = 20.0;
//        progressHud.square = NO;
//        progressHud.xOffset = 0;
//        progressHud.yOffset = 0;
//        progressHud.removeFromSuperViewOnHide = YES;
//        [progressHud hide:YES afterDelay:2.0];
        

        [_juhua hide];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"18949999_105118151147_2" ofType:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:path];
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 300)];
        webView.backgroundColor = [UIColor clearColor];
        webView.scalesPageToFit = YES;
        [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        UILabel* lab = [[UILabel alloc]init];
        lab.text = @"当前选点没有全景图";
        lab.textAlignment = NSTextAlignmentCenter;
        lab.frame = CGRectMake(0, 200, self.view.frame.size.width, 50);
        [webView addSubview:lab];
        [self.view addSubview:webView];
        
//        NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"18949999_105118151147_2" withExtension:@"gif"];
//        SvGifView* _gifView = [[SvGifView alloc] initWithCenter:CGPointMake(self.view.bounds.size.width / 2, 130) fileURL:fileUrl];
//        NSLog(@"%f/%f",_gifView.bounds.size.height,_gifView.bounds.size.width);
//        _gifView.backgroundColor = [UIColor clearColor];
//        _gifView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//        [self.view addSubview:_gifView];
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
