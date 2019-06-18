//
//  UICycleScrollView.h
//  DlodloVR
//
//  Created by captain on 16/4/18.
//  Copyright (c) 2016年 dlodlo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, UICycleScrollViewStyle)
{
    UICycleScrollViewStyleHorizontal     = 0,
    UICycleScrollViewStyleVertical       = 1,
};


@class UICycleScrollView;

@protocol UICycleScrollViewDelegate <NSObject>
/*
 *返回滚动的页数
 *返回 <0 表示可以无限的向前或者向后滚动，没有循环滚动
 *返回 ==0 表示没有页数
 *返回 >0 表示可以有限的向前向后滚动，可以循环滚动
 */
-(NSInteger)numberOfPagesInCycleScrollView:(UICycleScrollView*)cycleScrollView;
/*
 *返回index所在的页，isEnd表示是否已经到末端了
 */
//-(UIView*)cycleScrollView:(UICycleScrollView*)cycleScrollView viewForPageAtIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex isEnd:(BOOL*)isEnd;
-(UIView*)cycleScrollView:(UICycleScrollView*)cycleScrollView viewForPageAtIndex:(NSInteger)index isEnd:(BOOL*)isEnd;
-(void)cycleScrollView:(UICycleScrollView*)cycleScrollView didSelectedForPageAtIndex:(NSInteger)index;
//-(void)cycleScrollView:(UICycleScrollView*)cycleScrollView currentPageAtIndex:(NSInteger)index andLastPassedView:(UIView*)lastPassedView;
-(void)cycleScrollView:(UICycleScrollView*)cycleScrollView prepareForReusedView:(UIView*)reusedView;
@end

@interface UICycleScrollView : UIView

@property (nonatomic, strong, readonly) UIScrollView *scrollView;

@property (nonatomic, weak) id <UICycleScrollViewDelegate> delegate;
/*
 * startPageIndex,开始展示的页，默认为0
 * 为正数的话，返回的numberOfPage必须是>0
 * 为负数的话，修改到默认值0
 *
 */
@property (nonatomic, assign) NSInteger startPageIndex;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) CGFloat pageSpace;

@property (nonatomic, assign) UICycleScrollViewStyle scrollViewStyle;

//如果开启了自动滚动的效果，在关闭时需要调用autoScroll ＝ NO,默认为NO
@property (nonatomic, assign) BOOL autoScroll;

@property (nonatomic, assign) CGFloat scrollTimeInterval;

@property (nonatomic, assign) BOOL cycleScroll;

/** prepareLoad，预加载，是否支持预加载*/
@property (nonatomic, assign) BOOL prepareLoad;

-(instancetype)initWithFrame:(CGRect)frame andSpecialScrollView:(UIScrollView*)scrollView;

//立即开启或者关闭定时器
-(void)startAutoCycleScroll:(BOOL)autoCycleScroll;

-(void)reloadData;
@end
