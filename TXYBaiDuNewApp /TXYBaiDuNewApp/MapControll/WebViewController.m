//
//  WebViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/11/20.
//  Copyright © 2015年 yunlian. All rights reserved.
//

#import "WebViewController.h"
#import "juHua.h"

#define Height [UIScreen mainScreen ].bounds.size.height
#define Width  [UIScreen mainScreen ].bounds.size.width
#define StateHeight [[[UIDevice currentDevice] systemVersion] floatValue]>=7?20:0
#define IWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
@interface WebViewController ()<UIWebViewDelegate>{
    UIWebView* _webView;
    UIButton* button1;
    UIButton* button2;
    UIButton* button3;
    UIButton* button4;
    juHua* _juhua;
}

@end

@implementation WebViewController

- (void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    
    self.navigationItem.leftBarButtonItem = items;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(10, 0, 50, 50);
//    [self.navigationController.navigationBar addSubview:button];
//    [button setBackgroundImage:[UIImage imageNamed:@"houtui1.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self makeView];
}

- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)makeView{
    self.title = @"天下论坛";
    _juhua = [[juHua alloc]init];
    _webView = [[UIWebView alloc]init];
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://bbs.txyapp.com"]];
    [self.view addSubview: _webView];
    _webView.delegate = self;
    [_webView loadRequest:request];
    
    
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, Height - 50, Width/4, 50);
    [button1 setBackgroundColor:[UIColor whiteColor]];
 //   [button1 setTitle:@"后退" forState:UIControlStateNormal];
    button1.tag = 5000;
    [button1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* imageView1 = [[UIImageView alloc]init];
    imageView1.frame = CGRectMake(5, 0, 50, 50);
    imageView1.image = [UIImage imageNamed:@"houtui1"];
    [button1 addSubview:imageView1];
    [self.view addSubview:button1];
    
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(Width/4, Height - 50, Width/4, 50);
  //  [button2 setTitle:@"前进" forState:UIControlStateNormal];
    [button2 setBackgroundColor:[UIColor whiteColor]];
    UIImageView* imageView2 = [[UIImageView alloc]init];
    imageView2.frame = CGRectMake(20, 0, 50, 50);
    imageView2.image = [UIImage imageNamed:@"qianjin1"];
    button2.tag = 5001;
    [button2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addSubview:imageView2];
    [self.view addSubview:button2];
    
    button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(Width/2, Height - 50, Width/4, 50);
    [button3 setBackgroundColor:[UIColor whiteColor]];
    UIImageView* imageView3 = [[UIImageView alloc]init];
    imageView3.frame = CGRectMake(20, 0, 50, 50);
    imageView3.image = [UIImage imageNamed:@"tingzhi1"];
    button3.tag = 5002;
    [button3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button3 addSubview:imageView3];
    [self.view addSubview:button3];
    
    button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame = CGRectMake(Width/4*3, Height - 50, Width/4, 50);
  //  [button4 setTitle:@"刷新" forState:UIControlStateNormal];
    [button4 setBackgroundColor:[UIColor whiteColor]];
    UIImageView* imageView4 = [[UIImageView alloc]init];
    imageView4.frame = CGRectMake(20, 0, 50, 50);
    imageView4.image = [UIImage imageNamed:@"shuaxin1"];
    button4.tag = 5003;
    [button4 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button4 addSubview:imageView4];
    [self.view addSubview:button4];
}

- (void)btnClick:(UIButton*)button{
    //后退
    if (button.tag == 5000) {
        if([_webView canGoBack]){
            
            [_webView goBack];
            
        }else{
            
        }
    }
    //前进
    if (button.tag == 5001) {
        if([_webView canGoForward])
            
            [_webView goForward];
    }
    //停止
    if (button.tag == 5002) {
        [_webView stopLoading];
    }
    //刷新
    if (button.tag == 5003) {
        [_webView reload];
    }
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
//    [_juhua showAllScreen:YES Image:[UIImage imageNamed:@"zhuan"]];
//    _juhua.label.text = @"加载中";
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    [_juhua hide];
//    [_juhua hide];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
//     [_juhua hide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
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
