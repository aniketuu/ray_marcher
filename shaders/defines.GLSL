//  ray marching 
#define MIN_DIST                            0.001
#define MAX_DIST                            500.0
#define MAX_STEPS                           1024.0
#define EPSILON                             0.0001

//   world/global/shading related
#define BACKGROUND_COLOR                    vec3(0.4, 0.6, 0.9)
#define LIGHT_COLOR                         vec3(1.0)
#define LIGHT_DIRECTION                     vec3(-0.36, 0.48, 0.80)
#define SPECULAR_HIGHLIGHT                  0
#define SHADOW_ENABLED                      0
#define SHADOW_DARKNESS                     0.8
#define AMBIENT_OCCLUSION_STRENGTH          0.01
#define FOG_ENABLED                         1
#define FOG_MULTIPLIER                      2.0
#define GLOW_ENABLED                        0
#define GLOW_COLOR_DELTA                    vec3(-0.2, 0.5, -0.2)
#define GLOW_SHARPNESS                      4.0 
#define SUN_ENABLED                         0
#define SUN_SIZE                            0.005
#define SUN_SHARPNESS                       2.0


//  camera related
#define SENSOR_DISTANCE                     3.5
#define VIGNETTE_STRENGTH                   0.5