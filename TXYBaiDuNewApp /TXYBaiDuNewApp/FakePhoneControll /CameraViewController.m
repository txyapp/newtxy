//
//  CameraViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 16/11/2.
//  Copyright © 2016年 yunlian. All rights reserved.
//

#import "CameraViewController.h"
#import "CameraTableViewCell.h"
#import "KGStatusBar.h"
#import "juHua.h"
#import "ProgressHUD.h"
@interface CameraViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    UITableView* _tableView;
    UIImage *getImage;
    juHua *_juhua;
}

@end

@implementation CameraViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    getImage = nil;
    self.view .backgroundColor = [UIColor whiteColor];
    self.title = @"打卡拍照";
    self.tabBarController.tabBar.hidden = YES;
    UIBarButtonItem *items = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"cufanhui.png"] style:UIBarButtonItemStylePlain target:self action:@selector(fanhui)];
    self.navigationItem.leftBarButtonItem = items;
    UIBarButtonItem *Ritems = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveToPhone)];
    self.navigationItem.rightBarButtonItem =Ritems;
    [self makeView];
    // Do any additional setup after loading the view.
}
//判断本地是否有图片
-(void)chargeImage
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:@"/var/mobile/Library/Preferences/img.png"]||[fileManager fileExistsAtPath:@"/var/mobile/Library/Preferences/img.jpg"]) {
        //表示已经存在
        UIImage *hadImage;
        hadImage=[[UIImage alloc]initWithContentsOfFile:@"/var/mobile/Library/Preferences/img.png"];
        if (!hadImage) {
            hadImage = [[UIImage alloc]initWithContentsOfFile:@"/var/mobile/Library/Preferences/img.jpg"];
        }
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
        CameraTableViewCell * cell =  [_tableView cellForRowAtIndexPath:path];
        CGRect screenBounds=[UIScreen mainScreen].bounds;
        UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenBounds.size.width*0.6, screenBounds.size.width*0.6/9*16)];
        imagev.image = hadImage;
        cell.backgroundView = imagev;
    }
}
//返回
- (void)fanhui{
    [self.navigationController popViewControllerAnimated:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)makeView{
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine; 
    _tableView.rowHeight = 50;
    [self.view addSubview:_tableView];
}
//开关按钮
- (void)switchClick:(UISwitch*)sender{
    NSString *str = HeaithKit;
    NSMutableDictionary *plistDict;
    if (str) {
        plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:HeaithKit];
        if (plistDict==nil) {
            plistDict=[NSMutableDictionary dictionary];
        }
    }else{
        plistDict=[NSMutableDictionary dictionary];
    }
    NSNumber *cameraOn;
    if (sender.on) {
        cameraOn  = [NSNumber numberWithInt:1];
        NSLog(@"1");
    }else{
        cameraOn  = [NSNumber numberWithInt:0];
        NSLog(@"0");
    }
    [plistDict setObject:cameraOn forKey:@"CameraSwitch"];
    //同步操作
    BOOL result=[plistDict writeToFile:HeaithKit atomically:YES];
    if (result) {
        NSLog(@"存入成功");
        [_tableView reloadData];
    }else{
        NSLog(@"存入失败");
    }
}
#pragma Mark tableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }
    else
    {
        CGRect screenBounds=[UIScreen mainScreen].bounds;
        return screenBounds.size.width*0.6/9*16;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 20;
    }
    return 0;//section头部高度
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==0) {
        return 0;
    }
    return 30;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section ==1) {
        return @"·点击添加或修改照片";
    }
    return @" ";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"开关";
            UISwitch *switchView = [[UISwitch alloc] init];
            switchView.onTintColor = IWColor(60, 170,249);
            switchView.tintColor = [UIColor whiteColor];
            [switchView addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
            [cell addSubview:switchView];
            NSString *str = HeaithKit;
            NSMutableDictionary *plistDict;
            if (str) {
                plistDict = [[NSMutableDictionary alloc]initWithContentsOfFile:HeaithKit];
                if (plistDict==nil) {
                    plistDict=[NSMutableDictionary dictionary];
                }
            }else{
                plistDict=[NSMutableDictionary dictionary];
            }
            NSNumber *cameraIsOn = [plistDict objectForKey:@"CameraSwitch"];
            if (cameraIsOn && [cameraIsOn intValue] == 1) {
                switchView.on = YES;
            }else{
                switchView.on = NO;
            }
        }
    }
    if (indexPath.section == 1) {
        CameraTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell==nil) {
            cell=[[CameraTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:@"/var/mobile/Library/Preferences/img.png"]||[fileManager fileExistsAtPath:@"/var/mobile/Library/Preferences/img.jpg"]) {
            //表示已经存在
            UIImage *hadImage;
            hadImage=[[UIImage alloc]initWithContentsOfFile:@"/var/mobile/Library/Preferences/img.png"];
            if (!hadImage) {
                hadImage = [[UIImage alloc]initWithContentsOfFile:@"/var/mobile/Library/Preferences/img.jpg"];
            }
            
            CGRect screenBounds=[UIScreen mainScreen].bounds;
            UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenBounds.size.width*0.6, screenBounds.size.width*0.6/9*16)];
            imagev.image = hadImage;
            cell.backgroundView = imagev;
        }
        return cell;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        UIActionSheet* mySheet = [[UIActionSheet alloc]
                                  initWithTitle:@"添加照片"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"从相册添加",@"拍照", nil];
        [mySheet showInView:self.view];
    }
}
//
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // 从相册选择
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
        
        // 设置导航默认标题的颜色及字体大小
        picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                     NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
        [self presentViewController:picker animated:YES completion:nil];
    } else if (buttonIndex == 1) { // 拍照
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        // 设置导航默认标题的颜色及字体大小
        picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                     NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
        [self presentViewController:picker animated:YES completion:nil];
    }
    return;
}

#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:1];
    CameraTableViewCell * cell =  [_tableView cellForRowAtIndexPath:path];
    CGRect screenBounds=[UIScreen mainScreen].bounds;
    UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenBounds.size.width*0.6, screenBounds.size.width*0.6/9*16)];
    imagev.image = image;
    getImage = image;
    
    cell.backgroundView = imagev;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, nil, NULL);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 图片保存完毕的回调
- (void) image: (UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo: (void *)contextInf{
    NSLog(@"存储成功");
    //getImage = image;
}
#pragma savePhone 图片保存到本地
-(void)saveToPhone
{
    [ProgressHUD show:@"正在存储"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (getImage) {
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:@"/var/mobile/Library/Preferences/img.png"]||[fileManager fileExistsAtPath:@"/var/mobile/Library/Preferences/img.jpg"]) {
                //表示已经存在
                [fileManager removeItemAtPath:@"/var/mobile/Library/Preferences/img.png" error:nil];
                [fileManager removeItemAtPath:@"/var/mobile/Library/Preferences/img.jpg" error:nil];
            }
            //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
            NSData *data;
            // NSString *imagePath;
            if (UIImageJPEGRepresentation(getImage, 0.5) != nil) {
                data = UIImageJPEGRepresentation(getImage, 0.5);
                [fileManager createFileAtPath:@"/var/mobile/Library/Preferences/img.jpg" contents:data attributes:nil];
                
            } else {
                data = UIImagePNGRepresentation(getImage);
                [fileManager createFileAtPath:@"/var/mobile/Library/Preferences/img.png" contents:data attributes:nil];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [ProgressHUD showSuccess:@"存储成功"];
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
    });
    
    
}
// 取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)aPicker {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    
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
