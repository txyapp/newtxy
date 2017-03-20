//
//  EditTableViewController.m
//  TXYBaiDuNewApp
//
//  Created by yunlian on 15/9/25.
//  Copyright (c) 2015年 yunlian. All rights reserved.
//

#import "EditViewController.h"
#import "CollectViewController.h"
#import "MySaveDataManager.h"
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define Height ([UIScreen mainScreen].bounds.size.height)
#define Width ([UIScreen mainScreen].bounds.size.width)

@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.single !=0) {
        _name = self.LinesName;
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClick)];
    self.navigationItem.rightBarButtonItem = item;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
     _field = [[UITextField alloc]init];
    if (!iOS7) {
        _field.frame = CGRectMake(10, 0, Width - 20, 44);
    }else{
        _field.frame = CGRectMake(10, 64, Width - 20, 44);
    }
    
    [_field setBorderStyle:UITextBorderStyleBezel];
    _field.text = _name;
    
    _field.enabled = YES;
    
    [_field becomeFirstResponder];
    [self.view addSubview:_field];
}

- (void)buttonClick{
    if (self.single == 0) {
        [_field endEditing:YES];
        
        NSLog(@"%@",_field.text);
        NSLog(@"  %d",_index);
        
        NSUserDefaults *userPoint = [NSUserDefaults standardUserDefaults];
        
        NSArray* array = [userPoint objectForKey:@"collect"];
        NSMutableArray* userArray = nil;
        if (array == nil){
            userArray = [NSMutableArray array];
        }else{
            userArray = [NSMutableArray arrayWithArray:array];
        }
        
        NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:userArray[_index]];
        NSLog(@"dict.name = %@",dict[@"name"]);
        [dict setObject:_field.text forKey:@"name"];
        NSLog(@"dict.name = %@",dict[@"name"]);
        [userArray replaceObjectAtIndex:_index withObject:(NSDictionary*)dict];
        [userPoint setObject:userArray forKey:@"collect"];
        [userPoint synchronize];
    }
    else
    {
        MySaveDataManager *manager = [MySaveDataManager shareInatance];
        if (![_field.text isEqualToString:self.LinesName]&&_field.text) {
            if ([manager changeCollectionLinesName:self.LinesName withNewDate:_field.text]) {
                NSLog(@"%@",@"更新成功");
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
