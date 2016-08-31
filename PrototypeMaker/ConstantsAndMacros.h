//
// Wavefront_OBJ_Loaderconstants.h
//  Wavefront OBJ Loader
//
//  Created by Jeff LaMarche on 12/14/08.
//  Copyright Jeff LaMarche 2008. All rights reserved.
//

// How many times a second to refresh the screen
#define kRenderingFrequency 60.0

// Macros
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(__RADIAN__) (180.0 * __RADIAN__ / M_PI)
#define CONVERT_UV_U_TO_ST_S(u) ((2*u) / M_PI)
#define ARC4RANDOM_MAX      0x100000000
