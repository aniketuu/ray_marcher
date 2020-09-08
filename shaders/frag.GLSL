#version 330 core

// HELPER0
// HELPER1
// HELPER2
// HELPER3
// HELPER4
// HELPER5
// HELPER6
// HELPER7


uniform vec2 display_res;
uniform vec3 camera_position;
uniform vec3 camera_direction;
uniform vec3 camera_up;

out vec4 frag_color;

vec4 getDirection(vec2 uv){
    vec3 camera_right = cross(camera_direction, camera_up);
    vec3 ray_dir = SENSOR_DISTANCE*camera_direction + uv.x*camera_right + uv.y*camera_up;
    return vec4(normalize(ray_dir), 0.0);
}

float DE(vec4 p){
    //pFold(p.xyz, 4.0);
    float sp =  de_sphere(p.xyz, 0.8);
    return sp;
}

vec3 estimateNormal(vec4 p, float dx) {
    const vec3 k = vec3(1,-1,0);
    return normalize(k.xyy*DE(p + k.xyyz*dx) +
					 k.yyx*DE(p + k.yyxz*dx) +
					 k.yxy*DE(p + k.yxyz*dx) +
					 k.xxx*DE(p + k.xxxz*dx));
}

vec4 rayMarch(inout vec4 p, vec4 ray, float sharpness, float td){
    float dist = MIN_DIST;
    float s = 0.0;
    float min_d = 1.0;
    for(int i = 0; i<MAX_STEPS; i++){
        dist = DE(p);
        if(dist <= EPSILON){
            s += dist/MIN_DIST;
            break;
        }
        else if(td >= MAX_DIST){
            break;
        }
        td += dist;
        p += ray * dist;
        min_d = min(min_d, sharpness * dist/td);
    }
    return vec4(dist, s, td, min_d);
}

vec4 scene(inout vec4 origin, inout vec4 ray, float vignette, float td){
    vec4 p = origin;
    vec4 d_s_td_min_d = rayMarch(p, ray, GLOW_SHARPNESS, td);
    float d = d_s_td_min_d.x;
    float s = d_s_td_min_d.y;
    td = d_s_td_min_d.z;
    float m = d_s_td_min_d.w;

    // determine col for fragment
    vec3 col = vec3(0.0);
    if(d < MIN_DIST){
        // get ormal and reflected
        vec3 normal = estimateNormal(p, MIN_DIST * 10.0);
        vec3 reflected = ray.xyz - 2.0*dot(ray.xyz, normal) * normal;
        
        // object color
        vec3 orignal_col = vec3(1.0, 0.5, 0.7);

        // shadowws
        float k = 1.0;
        #if SHADOWS_ENABLED
            vec4 light_pt = p;
            light_pt.xyz += normal * MIN_DIST * 10;
            vec4 rm = rayMarch(light_pt, vec4(LIGHT_DIRECTION, 0.0), SHADOW_SHARPNESS, 0.0);
            k = rm.w * min(1.0, rm.z);
        #endif        

        // specular
        #if SPECULAR_HIGHLIGHT > 0
            float specular = max(dot(reflected, LIGHT_DIRECTION), 0.0);
            specular = pow(specular, SPECULAR_HIGHLIGHT);
            col += specular * k * LIGHT_COLOR;
        #endif

        // diffuse
        #if DIFFUSE_ENHANCED_ENABLED
            k = min(k, SHADOW_DARKNESS * 0.5 *(dot(normal, LIGHT_DIRECTION)-1.0) + 1.0);        
        #elif DIFFUSE_ENABLED
            k = min(k, dot(normal, LIGHT_DIRECTION));
        #endif
        
        // lghtening the shadows
        k = max(k, 1.0 - SHADOW_DARKNESS);
        col += orignal_col * LIGHT_COLOR * k;

        // ambient
        float a = 1.0 / (1.0 + s * AMBIENT_OCCLUSION_STRENGTH);
        col += (1.0 - a) * AMBIENT_OCCLUSION_COLOR_DELTA;

        #if FOG_ENABLED
            a = td / MAX_DIST;
			col = (1.0 - a) * col + a * BACKGROUND_COLOR;
        #endif
        
    }
    else{
        col += BACKGROUND_COLOR;

        #if GLOW_ENABLED
            col += (1.0 - m) * (1.0 - m) * GLOW_COLOR_DELTA;
        #endif

        col *= vignette;

        // render sun
        #if SUN_ENABLED
			float sun_spec = dot(ray.xyz, LIGHT_DIRECTION) - 1.0 + SUN_SIZE;
			sun_spec = min(exp(sun_spec * SUN_SHARPNESS / SUN_SIZE), 1.0);
			col += LIGHT_COLOR * sun_spec;
		#endif

    }
    return vec4(col, 1.0);
}

void main(){
    // uv
    vec2 screen_pos = gl_FragCoord.xy/display_res;
    vec2 uv = screen_pos  * 2.0 - 1.0;
    uv.x *= display_res.x/display_res.y; 

    // getting ray origin and direction
    vec4 ro = vec4(camera_position, 1.0);
    vec4 rd = getDirection(uv);

    float vignette = 1.0; - VIGNETTE_STRENGTH * length(screen_pos - 0.5);

    frag_color = scene(ro, rd, vignette, 0.0);
}

