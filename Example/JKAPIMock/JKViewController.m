//
//  JKViewController.m
//  JKAPIMock
//
//  Created by HHL110120 on 03/11/2017.
//  Copyright (c) 2017 HHL110120. All rights reserved.
//

#import "JKViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <JKAPIMock/JKAPIMock.h>
#ifndef __OPTIMIZE__



#define NSLog(...) printf("%f %s %ld :%s\n",[[NSDate date]timeIntervalSince1970],strrchr(__FILE__,'/'),[[NSNumber numberWithInt:__LINE__] integerValue],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);



#endif
@interface JKViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_mainTable;
    NSArray *_dataArray;
}
@end

@implementation JKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    _mainTable = [[UITableView alloc] initWithFrame:self.view.frame];
    [_mainTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
    _mainTable.delegate =self;
    _mainTable.dataSource =self;
    [self.view addSubview:_mainTable];
    _dataArray = @[@{@"url":@"/china/index.php?name=123&sex=male&age=22",@"method":@"GET",@"cellTitle":@"GET请求"},@{@"url":@"/china/abc.php",@"params":@{@"name":@"122",@"sex":@"dd",@"age":@"22"},@"method":@"POST",@"cellTitle":@"POST请求"}];
    [JKMockManager registerWithJsonFile:@"RequestsData"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
    cell.textLabel.text = _dataArray[indexPath.row][@"cellTitle"];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *url = _dataArray[indexPath.row][@"url"];
    NSDictionary *params = _dataArray[indexPath.row][@"params"];
    NSString *method = _dataArray[indexPath.row][@"method"];
    url = [NSString stringWithFormat:@"%@%@",@"https://www.baidu.com",url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if ([method isEqualToString:@"GET"]) {
        [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject %@",responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"alert" message:[NSString stringWithFormat:@"%@",responseObject] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        

    }else if ([method isEqualToString:@"POST"]){
    
        [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"responseObject %@",responseObject);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"alert" message:[NSString stringWithFormat:@"%@",responseObject] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
        
    }
   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
