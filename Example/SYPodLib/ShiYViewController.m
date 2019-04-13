//
//  ShiYViewController.m
//  SYPodLib
//
//  Created by syyyyyy191@126.com on 04/12/2019.
//  Copyright (c) 2019 syyyyyy191@126.com. All rights reserved.
//

#import "ShiYViewController.h"

@interface ShiYViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, copy)NSArray *viewControllerNames;

@end

@implementation ShiYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _viewControllerNames = @[@""];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _viewControllerNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = _viewControllerNames[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc = [[NSClassFromString(_viewControllerNames[indexPath.row]) alloc] init];
    [self presentViewController:vc animated:true completion:nil];
}

- (UITableView *)tableView{
    if (!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}



@end
