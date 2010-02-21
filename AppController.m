//
//  AppController.m
//  Colourspot
//
//  Copyright 2010 - Jesse Andrews
//
//  This file may be used under the terms of of the
//  GNU General Public License Version 2 or later (the "GPL"),
//  http://www.gnu.org/licenses/gpl.html
//
//  Copyright 2010 Jesse Andrews
//

#import "AppController.h"

@implementation AppController

- (NSMenu *) createMenu
{
	NSZone *menuZone = [NSMenu menuZone];
	NSMenu *menu = [[NSMenu allocWithZone:menuZone] init];
	NSMenuItem *menuItem;
	
	menuItem = [menu addItemWithTitle:@"Quit"
							   action:@selector(appQuit:)
						keyEquivalent:@""];
	
	[menuItem setTarget:self];
	
	return menu;
}

- (void) appQuit:(id)sender 
{
	[NSApp terminate:sender];
}

- (void) followMouse:(NSTimer*)aTimer 
{
	// Generate a CG event so we can determine the mouse location
	CGEventRef ourEvent = CGEventCreate(NULL);
	CGPoint point = CGEventGetLocation(ourEvent);
	
	// only update the colour spot if shift is pressed
	if (CGEventGetFlags(ourEvent) & kCGEventFlagMaskShift) {
	
		// take a screenshot of the pixel under the mouse cursor
		CGRect rect = CGRectMake(point.x, point.y, 1, 1);
		CGImageRef screenShot = CGWindowListCreateImage(rect, kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageDefault);

		// update the statusbar
		[self updateTitle:screenShot];
		[self updatePreview:screenShot];
	}
}

- (void) updatePreview:(CGImageRef)image
{
	CGRect imageRect;
	imageRect.size.height = 16;
	imageRect.size.width = 16;
	
	[previewImage lockFocus];
	CGContextRef imageContext = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	CGContextDrawImage(imageContext, imageRect, image);
	[previewImage unlockFocus];
}

- (void) updateTitle:(CGImageRef)image
{
	CFDataRef m_DataRef = CGDataProviderCopyData(CGImageGetDataProvider(image));
	UInt8 *m_PixelBuf = (UInt8 *) CFDataGetBytePtr(m_DataRef);
	NSString *hex = [NSString stringWithFormat:@"#%02x%02x%02x", m_PixelBuf[2], m_PixelBuf[1], m_PixelBuf[0]];

	NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
	[attributes setObject:[NSFont fontWithName:@"Monaco" size:12] forKey:NSFontAttributeName];
	NSAttributedString *as = [[NSAttributedString alloc] initWithString:hex attributes: attributes];	
	
	[statusItem setTitle: (NSString *)as];
}

- (void) awakeFromNib
{
	// create the image to display color in the menu bar
	NSSize size;
	size.width = 15;
	size.height = 15;
	previewImage = [[[NSImage alloc] initWithSize:size] autorelease];	
	
	// create the statusbar
	NSMenu *menu = [self createMenu];
	statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:-1] retain];
	[statusItem setTarget: self];
	[statusItem setImage: previewImage];
	[statusItem setTitle: @"colour"];	
	[statusItem setMenu:menu];
	[statusItem setHighlightMode: YES];
			
	[[NSTimer scheduledTimerWithTimeInterval:0.08 target:self 
									selector:@selector(followMouse:) userInfo:nil repeats:YES] retain];
}

@end
