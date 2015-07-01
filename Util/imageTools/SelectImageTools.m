//
//  SelectImageTools.m
//  BJDataProject
//
//  Created by YangXIAOYU on 14/10/27.
//  Copyright (c) 2014年 YangXIAOYU. All rights reserved.
//

#import "SelectImageTools.h"
//#import "UIActionSheet+Photos.h"
#import "ConfirmImageController.h"
#import "QBImagePickerController.h"

@interface SelectImageTools ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ConfirmImageControllerDelegate,QBImagePickerControllerDelegate>

@property (nonatomic, assign) int picNum;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* album;
@property (nonatomic, strong) NSString* takePicture;
@property (nonatomic, assign) bool frontCamera;
@property (nonatomic, strong) id<NSObject> params;
@property (nonatomic, assign) UIViewController *viewController;
@property (nonatomic, copy) finishSelectedImageCallback callback;
@property (nonatomic, assign) BOOL allowEditing;

@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, strong) QBImagePickerController *QBImagePicker;
- (void)show;
@end

@implementation SelectImageTools

+ (instancetype)shareSelectImageTools
{
    static SelectImageTools *tools = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        tools = [[SelectImageTools alloc] init];
    });
    return tools;
}

- (void)selectImagesBeginWith:(id)controller
              andAllowEditing:(BOOL)allowEditing
                    andPicNum:(int)picNum
                   andOptions:(NSDictionary *)options
               andFrontCamera:(BOOL)frontCamera
            andFinishCallback:(finishSelectedImageCallback)callback
                    andParams:(id)params{
    self.picNum = picNum;
    self.allowEditing = allowEditing;
    if (options) {
        self.title = options[ActionTitle];
        self.album = options[AlbumTitle];
        self.takePicture = options[TakePictureTitle];
    }else
    {
        self.title = @"选择图片来源";
        self.album = @"相册";
        self.takePicture = @"拍照";
    }
    self.frontCamera = frontCamera;
    self.callback = callback;
    self.params = params;
    self.viewController = controller;
    self.imagePicker.allowsEditing = self.allowEditing;
    [self show];
}

- (UIImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}

- (QBImagePickerController *)QBImagePicker
{
    if (!_QBImagePicker) {
        _QBImagePicker = [[QBImagePickerController alloc] init];
        _QBImagePicker.delegate = self;
        _QBImagePicker.allowsMultipleSelection = YES;
        _QBImagePicker.limitsMaximumNumberOfSelection = YES;
    }
    return _QBImagePicker;
}

- (void)show
{
    UIActionSheet *sheet = [UIActionSheet bk_actionSheetWithTitle:self.title];
    [sheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [sheet bk_addButtonWithTitle:self.album handler:^{
        self.QBImagePicker.maximumNumberOfSelection = self.picNum;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.QBImagePicker];
        [self.viewController presentViewController:navigationController animated:YES completion:NULL];
    }];
    [sheet bk_addButtonWithTitle:self.takePicture handler:^{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            if (self.frontCamera) {
                BOOL isRearSupport = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
                if (isRearSupport) {
                    self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }else
                {
                    UIAlertView *show = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持前置摄像头" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
                    [show show];
                }
            }
            [self.viewController presentViewController:self.imagePicker animated:YES completion:^{
                
            }];
        }else
        {
            UIAlertView *show = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的设备不支持摄像头" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [show show];
        }

    }];
    [sheet showInView:self.viewController.view];
}

- (void)dealloc
{
    
}

#pragma mark -- UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"info = %@",info);
    if (picker.sourceType==UIImagePickerControllerSourceTypePhotoLibrary&&!self.allowEditing) {
        ConfirmImageController *vc = [[ConfirmImageController alloc] init];
        vc.delegate = self;
        [picker presentViewController:vc animated:YES completion:^{
            vc.contentView.image = info[@"UIImagePickerControllerOriginalImage"];
        }];
        return;
        
    }
    if (info[@"UIImagePickerControllerOriginalImage"]) {
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        if (self.callback) {
            self.callback(@[image], self.params);
        }
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
    
    }];
}

#pragma mark -- ConfirmImageControllerDelegate
- (void)confirmSelectImage:(ConfirmImageController *)con andImage:(UIImage *)image{
    [self.imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
    if (self.callback) {
        self.callback(@[image], self.params);
    }
}

#pragma mark - QBImagePickerControllerDelegate

- (void)QBimagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    if(imagePickerController.allowsMultipleSelection) {
        NSArray *mediaInfoArray = (NSArray *)info;
        
        NSLog(@"Selected %d photos and mediaInfoArray==%@", mediaInfoArray.count,mediaInfoArray);
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dic in mediaInfoArray) {
            [arr addObject:dic[@"UIImagePickerControllerOriginalImage"]];
        }
        if (self.callback) {
            self.callback(arr, nil);
        }
    } else {
        NSDictionary *mediaInfo = (NSDictionary *)info;
        NSLog(@"Selected: %@", mediaInfo);
    }
    
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"取消选择");
    
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)descriptionForSelectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"";
}

- (NSString *)descriptionForDeselectingAllAssets:(QBImagePickerController *)imagePickerController
{
    return @"";
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
{
    return [NSString stringWithFormat:@"图片%ld张", numberOfPhotos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"视频%ld", numberOfVideos];
}

- (NSString *)imagePickerController:(QBImagePickerController *)imagePickerController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos
{
    return [NSString stringWithFormat:@"图片%ld 视频%ld", numberOfPhotos, numberOfVideos];
}

@end
