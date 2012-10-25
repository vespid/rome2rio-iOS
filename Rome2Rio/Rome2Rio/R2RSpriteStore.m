//
//  R2RSpriteStore.m
//  Rome2Rio
//
//  Created by Ash Verdoorn on 16/10/12.
//  Copyright (c) 2012 Rome2Rio. All rights reserved.
//

#import "R2RSpriteStore.h"
#import "R2RImageLoader.h"
#import "R2RSpriteViewsModel.h"

@interface R2RSpriteStore() <R2RImageLoaderDelegate>

@property (strong, nonatomic) NSMutableDictionary *imageStore; //key path, object image
@property (strong, nonatomic) NSMutableDictionary *imageLoaders; //store of loaders currently downloading images. key path, object imageLoader
@property (strong, nonatomic) NSMutableDictionary *spriteViews; //store of views awaiting images currently downloading images. key path, object view array

@end

@implementation R2RSpriteStore

-(id)init
{
    self = [super init];
    
    if (self != nil)
    {
        self.imageStore = [[NSMutableDictionary alloc] init];
        self.imageLoaders = [[NSMutableDictionary alloc] init];
        self.spriteViews = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(UIImage *)loadImage:(NSString *)path
{
    UIImage *image = [self.imageStore objectForKey:path];
    if (!image && [path length] > 0)
    {
        NSURL *urlPath = [[NSURL alloc] initWithString:path];
        if ([[urlPath pathComponents] count] == 1) //local file
        {
            image = [UIImage imageNamed:path];
            [self.imageStore setObject:image forKey:path];
            return image;
        }
                
        R2RImageLoader *loader = [self.imageLoaders objectForKey:path];
        if (!loader)
        {
            loader = [[R2RImageLoader alloc] initWithPath:path];
            loader.delegate = self;
            [loader sendAsynchronousRequest];
            [self.imageLoaders setObject:loader forKey:path];
        }
    }
    if (!image) image = [[UIImage alloc] init];
    
    return image;
}

-(void)setSpriteInButton:(R2RSprite *)sprite :(id)button
{
    if(![button isKindOfClass:[UIButton class]])
    {
        return;
    }
    
    UIImage *image = [self loadImage:sprite.path];
    //    UIImage *image = [self.imageStore objectForKey:sprite.path];
    if (image)
    {
        [button setImage:[sprite getSprite:image] forState:UIControlStateNormal];
         return;
    }
    
    //if this is reached, image is being requested so store view for delegate to load image in
    R2RSpriteViewsModel *spriteView = [self.spriteViews objectForKey:sprite.path];
    if (!spriteView)
    {
        spriteView = [[R2RSpriteViewsModel alloc] init];
    }
    spriteView.sprite = sprite;
    [spriteView.views addObject:button];
    [self.spriteViews setObject:spriteView forKey:sprite.path];

}


-(void)setSpriteInView:(R2RSprite *)sprite :(UIImageView *)view
{
    UIImage *image = [self loadImage:sprite.path];
//    UIImage *image = [self.imageStore objectForKey:sprite.path];
    if (image)
    {
        [view setImage:[sprite getSprite:image]];
        return;
    }

    //if this is reached, image is being requested so store view for delegate to load image in
    R2RSpriteViewsModel *spriteView = [self.spriteViews objectForKey:sprite.path];
    if (!spriteView)
    {
        spriteView = [[R2RSpriteViewsModel alloc] init];
    }
    spriteView.sprite = sprite;
    [spriteView.views addObject:view];
    [self.spriteViews setObject:spriteView forKey:sprite.path];
    
}

-(void)r2rImageDidLoad:(R2RImageLoader *)delegateImageLoader
{
    R2RImageLoader *loader = [self.imageLoaders objectForKey:delegateImageLoader.path];
    if (loader)
    {
        [self.imageStore setObject:delegateImageLoader.image forKey:delegateImageLoader.path];
//        R2RLog(@"loaded %@, %@", delegateImageLoader.path, delegateImageLoader.image);
        
        R2RSpriteViewsModel *spriteView = [self.spriteViews objectForKey:delegateImageLoader.path];
        if ([spriteView.views count] > 0) //if any views are waiting for image, set it
        {
            for (id view in spriteView.views)
            {
                if ([view isKindOfClass:[UIButton class]])
                {
                    [view setImage:[spriteView.sprite getSprite:delegateImageLoader.image] forState:UIControlStateNormal];
                }
                else
                {
                    [view setImage:[spriteView.sprite getSprite:delegateImageLoader.image]];
                }
            }
            [self.spriteViews removeObjectForKey:delegateImageLoader.path];
        }
        
        [self.imageLoaders removeObjectForKey:delegateImageLoader.path];
    }
}

@end
