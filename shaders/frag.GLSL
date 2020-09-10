#version 330 core

// DEFINES

uniform vec2 display_res;
uniform vec3 camera_position;
uniform vec3 camera_direction;
uniform vec3 camera_up;

out vec4 frag_color;

// LIBRARY

vec3 getDirection(vec2 uv){
    vec3 camera_right = cross(camera_direction, camera_up);
    vec3 ray_dir = vec3(SENSOR_DISTANCE * camera_direction + uv.x * camera_right + uv.y * camera_up);
    return normalize(ray_dir);
}

// DE


vec4 rayMarch(inout vec3 ro, inout vec3 rd, float glow_sharpness){
    float total_dist = MIN_DIST;
    float present_radius = 0.0;
    float glow_factor = 1.0;
    ro = ro + total_dist * rd;
    float steps;
    for(steps = 0.0; steps<MAX_STEPS;steps+=1.0){
        present_radius = DE(ro);
        if(present_radius <= EPSILON){
            break;
        }
        if(total_dist >= MAX_DIST){
            break;
        }
        ro += present_radius * rd;
        total_dist += present_radius;
        glow_factor = min(glow_factor, glow_sharpness * present_radius / total_dist);
    }
    steps = 1.0 - steps/MAX_STEPS;
    return vec4(total_dist, steps, glow_factor, present_radius);
}

vec3 estimateNormal(vec3 p){
    float x = DE(vec3(p.x + EPSILON, p.yz)) - DE(vec3(p.x - EPSILON, p.yz));
    float y = DE(vec3(p.x,p.y + EPSILON, p.z)) - DE(vec3(p.x, p.y - EPSILON, p.z));
    float z = DE(vec3(p.xy, p.z + EPSILON)) - DE(vec3(p.xy, p.z - EPSILON));
    return normalize(vec3(x,y,z)); 
}

float shadow(vec3 ro, vec3 rd, float mint, float maxt, float f){
    float k = 1.0;
    for( float t=mint; t<maxt; ){
        float h = DE(ro + rd*t);
        if( h<EPSILON ){
            return 0.0;
        }
        k = min( k, f*h/t );
        t += h;
    }
    return k;
}

vec4 scene(inout vec3 p, inout vec3 ray){
    // ray march
    vec4 td_s_g_pr = rayMarch(p, ray, GLOW_SHARPNESS);
    float dist = td_s_g_pr.x;
    float step_factor = td_s_g_pr.y;
    float g_factor = td_s_g_pr.z;
    float hit_identifier = td_s_g_pr.w;

    // get color
    vec3 col = vec3(0.0);
    if(hit_identifier < EPSILON){
        //return vec4(1.0);
        vec3 normal = estimateNormal(p);
        vec3 reflected = ray - 2 * (dot(ray, normal)) * normal;

        // shadow factor
        float k = 1.0;

        // check for shadows
        #if SHADOW_ENABLED
            vec3 shade_pt = p;
            shade_pt += normal * MIN_DIST * 10;
            k = shadow(shade_pt, LIGHT_DIRECTION, MIN_DIST, MAX_DIST, 8.0);
        #endif
        // add specular
        #if SPECULAR_HIGHLIGHT
            float specular = max(dot(reflected, LIGHT_DIRECTION), 0.0);
            specular = pow(specular, SPECULAR_HIGHLIGHT);
            col += specular * k * LIGHT_COLOR;
        #endif

        // add diffuse
        vec3 orignal_color = vec3(0.8, 0.0, 1.0);
        float lambert = max(dot(normal,LIGHT_DIRECTION), 0.0);
        k = min(k, lambert);
        k = max(k, 1.0 - SHADOW_DARKNESS); // nw shadows wont be fully black
        col += orignal_color * LIGHT_COLOR * k;

        // temp ambient 
        col += orignal_color * LIGHT_COLOR * 0.1 * step_factor;

        // fog
        #if FOG_ENABLED
            float a = dist / MAX_DIST;
            a *= FOG_MULTIPLIER;
			col = (1.0 - a) * col + a * BACKGROUND_COLOR;
        #endif
    }
    else{
        col += BACKGROUND_COLOR;

        #if GLOW_ENABLED
            col += (1.0 - g_factor) * (1.0 - g_factor) * GLOW_COLOR_DELTA;
        #endif

        #if SUN_ENABLED
			float sun_spec = dot(ray, LIGHT_DIRECTION) - 1.0 + SUN_SIZE;
			sun_spec = min(exp(sun_spec * SUN_SHARPNESS / SUN_SIZE), 1.0);
			col += LIGHT_COLOR * sun_spec;
		#endif
    }
    float gamma = 2.2;
    col.x = pow(col.x, 1.0/gamma);
    col.y = pow(col.y, 1.0/gamma);
    col.z = pow(col.z, 1.0/gamma);
    return vec4(col, 1.0);
}

void main(){
    // uv
    vec2 screen_pos = gl_FragCoord.xy/display_res;
    vec2 uv = screen_pos  * 2.0 - 1.0;
    uv.x *= display_res.x/display_res.y; 

    // getting ray origin and direction
    vec3 ro = camera_position;
    vec3 rd = getDirection(uv);

    frag_color = scene(ro, rd);
}

