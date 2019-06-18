//
//  CycleScrollViewController.m
//  UICycleScrollViewDemo
//
//  Created by yuan on 2018/6/21.
//  Copyright © 2018年 yzh. All rights reserved.
//

#import "CycleScrollViewController.h"
#import "UICycleScrollView.h"

@interface CycleScrollViewController () <UICycleScrollViewDelegate>

/** 注释 */
@property (nonatomic, strong) UICycleScrollView *cycleScrollView;

/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation CycleScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _setupChildView];
}

-(UIButton*)_createBtnWithTitle:(NSString*)title frame:(CGRect)frame tag:(NSInteger)tag inView:(UIView*)inView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    button.frame = frame;
    button.backgroundColor = PURPLE_COLOR;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(_btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [inView addSubview:button];
    return button;
}

-(void)_btnAction:(UIButton*)sender
{
    if (sender.tag == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)_setupChildView
{
    self.view.backgroundColor = WHITE_COLOR;
    
    CGRect frame = CGRectMake(20, 20, 60, 40);
    [self _createBtnWithTitle:@"关闭" frame:frame tag:1 inView:self.view];
    
    CGFloat y = 60;
    frame = CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT - y);
    self.cycleScrollView = [[UICycleScrollView alloc] initWithFrame:frame];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.cycleScroll = NO;
    [self.view addSubview:self.cycleScrollView];
}

#pragma mark
-(NSInteger)numberOfPagesInCycleScrollView:(UICycleScrollView*)cycleScrollView
{
    return 4;
}

-(UIView*)cycleScrollView:(UICycleScrollView*)cycleScrollView viewForPageAtIndex:(NSInteger)index isEnd:(BOOL*)isEnd
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cycleScrollView.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    NSString *imageNamed = [[NSString alloc] initWithFormat:@"%ld.jpg",index+1];
    UIImage *image = [UIImage imageNamed:imageNamed];
    if (image == nil) {
        imageNamed = [[NSString alloc] initWithFormat:@"%ld.png",index+1];
    }
    image = [UIImage imageNamed:imageNamed];
    imageView.image = image;
    return imageView;
}

-(void)cycleScrollView:(UICycleScrollView*)cycleScrollView didSelectedForPageAtIndex:(NSInteger)index
{
    NSLog(@"didSelectedIndex=%@",@(index));
}

-(void)cycleScrollView:(UICycleScrollView*)cycleScrollView prepareForReusedView:(UIView*)reusedView
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
