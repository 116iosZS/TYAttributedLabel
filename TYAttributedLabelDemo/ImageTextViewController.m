//
//  ImageTextViewController.m
//  TYAttributedLabelDemo
//
//  Created by SunYong on 15/4/17.
//  Copyright (c) 2015年 tanyang. All rights reserved.
//

#import "ImageTextViewController.h"
#import "TYAttributedLabel.h"
#import "TYDrawImageStorage.h"
#import "TYTextStorage.h"
#import "RegexKitLite.h"

@interface ImageTextViewController ()
@property (nonatomic,weak) TYAttributedLabel *label1;
@property (nonatomic, weak) UIScrollView *scrollView;
@end

#define RGB(r,g,b,a)	[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation ImageTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addScrollView];
    
    // appendAttributedText
    [self addTextAttributedLabel1];
    
    // addAttributedText
    [self addTextAttributedLabel2];
    
}

- (void)addScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
}

// appendAttributedText
- (void)addTextAttributedLabel1
{
    TYAttributedLabel *label = [[TYAttributedLabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0)];
    [_scrollView addSubview:label];
    _label1 = label;
    
    NSString *text = @"\t总有一天你将破蛹而出，成长得比人们期待的还要美丽。\n\t但这个过程会很痛，会很辛苦，有时候还会觉得灰心。\n\t面对着汹涌而来的现实，觉得自己渺小无力。\n\t但这，也是生命的一部分，做好现在你能做的，然后，一切都会好的。\n\t我们都将孤独地长大，不要害怕。";
    
    NSArray *textArray = [text componentsSeparatedByString:@"\n\t"];
    NSArray *colorArray = @[RGB(213, 0, 0, 1),RGB(0, 155, 0, 1),RGB(103, 0, 207, 1),RGB(209, 162, 74, 1),RGB(206, 39, 206, 1)];
    NSInteger index = 0;
    [label appendImageWithContent:@"CYLoLi" size:CGSizeMake(CGRectGetWidth(label.frame), 180)];
    for (NSString *text in textArray) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
        
        if (index != 4) {
            [attributedString addAttributeTextColor:colorArray[index%5]];
            [attributedString addAttributeFont:[UIFont systemFontOfSize:15+arc4random()%4]];
            [label appendTextAttributedString:attributedString];
            [label appendImageWithContent:@"haha"];
            [label appendText:@"\n\t"];
        } else {
            [label appendImageWithContent:@"avatar" size:CGSizeMake(60, 60)];
            [label appendText:text];
        }
        index++;
    }
    //两种方法 [label appendImageWithContent:@"avatar" size:CGSizeMake(60, 60)];
    TYDrawImageStorage *imageStorage = [[TYDrawImageStorage alloc]init];
    imageStorage.imageContent = @"haha";
    imageStorage.size = CGSizeMake(15, 15);
    [label appendTextStorage:imageStorage];
    
    [label sizeToFit];
}

// addAttributedText
- (void)addTextAttributedLabel2
{
    //使用 RegexKitLite，添加 -fno-objc-arc，同时添加 libicucore.dylib
    //其实所有漂泊的人，不过是为了有一天能够不再漂泊，能用自己的力量撑起身后的家人和自己爱的人。
    TYAttributedLabel *label = [[TYAttributedLabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_label1.frame) + 20, CGRectGetWidth(self.view.frame), 0)];
    [_scrollView addSubview:label];
    
    
    NSString *text = @"[CYLoLi,320,180]其实所有漂泊的人，[haha,15,15]不过是为了有一天能够不再漂泊，[haha,15,15]能用自己的力量撑起身后的家人和自己爱的人。[avatar,60,60]";
    label.text = text;
    NSMutableArray *tmpArray = [NSMutableArray array];
    [text enumerateStringsMatchedByRegex:@"\\[(\\w+?),(\\d+?),(\\d+?)\\]" usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        if (captureCount > 3) {
            TYDrawImageStorage *imageRun = [[TYDrawImageStorage alloc]init];
            imageRun.imageContent = capturedStrings[1];
            imageRun.range = capturedRanges[0];
            imageRun.size = CGSizeMake([capturedStrings[2]intValue], [capturedStrings[3]intValue]);
            
            [tmpArray addObject:imageRun];
        }
    }];
    
    [label addTextStorageArray:tmpArray];
    TYTextStorage *textStorage = [[TYTextStorage alloc]init];
    textStorage.range = [text rangeOfString:@"[CYLoLi,320,180]其实所有漂泊的人，"];
    textStorage.textColor = RGB(213, 0, 0, 1);
    textStorage.font = [UIFont systemFontOfSize:16];
    [label addTextStorage:textStorage];
    textStorage = [[TYTextStorage alloc]init];
    textStorage.range = [text rangeOfString:@"不过是为了有一天能够不再漂泊，"];
    textStorage.textColor = RGB(0, 155, 0, 1);
    textStorage.font = [UIFont systemFontOfSize:18];
    [label addTextStorage:textStorage];
    
    [label sizeToFit];
    
    [_scrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(label.frame)+10)];
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