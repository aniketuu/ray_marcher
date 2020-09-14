#version 330 core

uniform vec2    iResolution;
uniform float   iTime;
uniform vec3    camera_position;
uniform vec3    camera_direction;
uniform vec3    camera_up;

out vec4 frag_color;

//  SETTINGS
//  SDF LIBRARY

vec3 getDirection(vec2 uv){
    vec3 camera_right = cross(camera_direction, camera_up);
    vec3 ray_dir = vec3(CAMERA_SENSOR_DISTANCE * camera_direction + uv.x * camera_right + uv.y * camera_up);
    return normalize(ray_dir);
}

//  MAP

float rayMarch(vec3 ro, vec3 rd){
    float total_dist = 0.0;
    //vec2 result = vec2(-1.0);
    float present_dist = 1.0;
    for(int i = 0; i<MAX_STEPS; i++){
        if(present_dist < EPSILON || total_dist > MAX_DISTANCE){
            break;
        }
        present_dist = map(ro + total_dist * rd);
        //result = vec4(total_dist);
        total_dist += present_dist;
    }
    if(total_dist > MAX_DISTANCE){
        total_dist = -1.0;
    }
    return total_dist;
}

float refMarch(vec3 ro, vec3 rd){
    float rtotal_dist = 0.0;
    //vec2 result = vec2(-1.0);
    float rpresent_dist = 1.0;
    for(int i = 0; i<REFLECTION_MAX_STEPS; i++){
        if(rpresent_dist < EPSILON || rtotal_dist > REFLECTION_MAX_DISTANCE){
            break;
        }
        rpresent_dist = map(ro + rtotal_dist * rd);
        //result = vec4(total_dist);
        rtotal_dist += rpresent_dist;
    }
    if(rtotal_dist > REFLECTION_MAX_DISTANCE){
        rtotal_dist = -1.0;
    }
    return rtotal_dist;
}


vec3 getNormal(vec3 p){
    vec2 e = vec2(EPSILON/2.0, -EPSILON/2.0); 
    return normalize(
        e.xyy * map(p + e.xyy) + 
        e.yyx * map(p + e.yyx) + 
        e.yxy * map(p + e.yxy) + 
        e.xxx * map(p + e.xxx));
}

float calcOcclusion(vec3 pos,vec3 nor){
	float ao = 0.0;
    float sca = 1.0;
    for( int i=0; i<8; i++ ){
        float h = EPSILON + 0.5*pow(float(i)/7.0,1.5);
        float d = map( pos + h*nor );
        ao += -(d-h)*sca;
        sca *= 0.95;
    }
    return clamp( 1.0 - 0.8*ao, 0.0, 1.0 );
}

float shadow(vec3 ro, vec3 rd, float mint, float maxt, float f){
    float k = 1.0;
    for( float t=mint; t<maxt; ){
        float h = map(ro + rd*t);
        if( h<EPSILON ){
            return 0.0;
        }
        k = min( k, f*h/t );
        t += h;
    }
    return k;
}
vec3 getColorFronNormal(vec3 n, vec3 oc){
/*    vec3 col = n * 0.5 + 0.5;
    col = 1.0 - col;
    col *= oc;
    col *= vec3(cos(oc));
    col.b = cos((col.b)*4.3)*0.5+0.5;
    //col.g = cos((col.r)*2.6)*0.6+0.4;
    //col.b = cos((col.g)*7.3)*0.7+0.3;
*/

    vec3 col = n * 0.5 + 0.5;
    col *= oc;
/* menger    col.b = cos((col.b)*4.3)*0.5+0.5;
    col.x = cos(col.z) * col.x; 
    */
    clamp(col, 0.0, 1.0);
    return col;
}

vec3 getColorFromPos(vec3 p){
    // "floor(p)" is analogous to a unique ID - based on position.
    vec3 ip = floor(p);
    
    // Unique random cell number.
    //float rnd = fract(sin(dot(ip, vec3(27.17, 112.61, 57.53)))*43758.5453);
    float rnd = fract(sin(dot(ip, vec3(207.87, 12.61, 257.53)))*42258.5453);
    // Color up the objects in a cubic checkered arrangement using a subtle version
    // of IQ's palette formula.
    /*
    vec3 col = (fract(dot(ip, vec3(.5))) > .001)? 
         .5 + .45*cos(mix(3., 4., rnd) + vec3(.9, .45, 1.5)) //vec3(.6, .3, 1.)
         : vec3(.7 + .3*rnd);*/
    vec3 col = (fract(dot(ip, vec3(.7))) > .001)? 
         .5 + .75*cos(mix(3., 4., rnd) + vec3(2.6, .5, 1.2)) //vec3(.6, .3, 1.)
         : vec3(.7 + .3*rnd);
    
    // Reverse the RGB channels on some of the objects, for a bit of variance.
    if(fract(rnd*1183.5437 + .42)>.65) col = col.zyx;
    
    return col;
}

vec4 doColor(vec3 pos, vec3 nor, vec3 ref, float march_res){
        vec4 col = vec4(0.0);

        
        vec3 light_dir;
        vec3 light_col;
        //vec3 orignal_col = vec3(0.2, 0.8, 0.4);
        //vec3 orignal_col = getColorFronNormal(nor, vec3(0.7, 0.2, 0.8)); 
        vec3 orignal_col = getColorFromPos(pos);
        #if GLOBAL_LIGHT
            light_dir = GLOBAL_LIGHT_DIRECTION;
            light_col = GLOBAL_LIGHT_COLOR ;
        #else
            vec3 light_pos = ro + vec3(0, 0.0, 0.5);
            light_dir = light_pos - pos;
            light_dir = normalize(light_dir);
            light_col = GLOBAL_LIGHT_COLOR;
        #endif

        // shadows
        float k = 1.0;
        #if SHADOW_ENABLED
            vec3 shad_pt = pos + nor * 4 * EPSILON;
            k = shadow(shad_pt, light_dir, 0.01, 16.0, SHADOW_HARDNESS);
        #endif

        // diffuse 
        
        col.xyz = orignal_col;
        float lambert = max(dot(nor, light_dir), 0.0);
        k = min(k, lambert);
        k = max(k, 1.0 - SHADOW_DARKNESS);
        col.xyz  = orignal_col * light_col * k;

        // specular
        #if SPECULAR_HIGHLIGHT
            float specular = max(dot(ref, light_dir), 0.0);
            specular = pow(specular, SPECULAR_HIGHLIGHT);
            col.xyz += specular * light_col;
        #endif

        // ambient
        float occ = calcOcclusion(pos, nor);
        col.xyz += orignal_col * light_col * occ * occ * AMBIENT_STRENGTH;//* occ for menger instead of ambient strength

        // fog
        #if FOG_ENABLED
            float a = march_res / MAX_DISTANCE;
            a *= FOG_MULTIPLIER;
			col.xyz = (1.0 - a) * col.xyz + a * BACKGROUND_COLOR;
        #endif  

    col.xyz = clamp(col.xyz, 0.0, 1.0);
    col.w = k;
    return col;
}

vec3 render(vec3 ro, vec3 rd){
    
    vec4 col = vec4(0.0);

    // ray march
    float march_res = rayMarch(ro, rd);

    if(march_res > 0.0){
        
        vec3 pos = ro + march_res * rd;
        vec3 nor = getNormal(pos);
        vec3 ref = rd - 2.0 * (dot(rd, nor)) * nor;
        col = doColor(pos, nor, ref, march_res);

        #if REFLECTION
            float ref_res = refMarch(pos + 10 * EPSILON * nor, ref);
            if(ref_res > 0.0 && col.w > 1.0 - SHADOW_DARKNESS){
                vec3 ref_pos = pos + ref_res * ref;
                vec3 ref_nor = getNormal(ref_pos);
                vec3 ref_ref = ref - 2.0 * dot(ref,ref_nor) * ref_nor;
                col += doColor(ref_pos, ref_nor, ref_ref, ref_res) * 0.25 * col.w;
            }
            
        #endif
    }
    else{
        col.xyz = BACKGROUND_COLOR;
        
        #if GLOBAL_LIGHT
            #if RENDER_SUN
                float sun_spec = dot(rd, GLOBAL_LIGHT_DIRECTION) - 1.0 + RENDER_SUN_SIZE;
			    sun_spec = min(exp(sun_spec * RENDER_SUN_SHARPNESS / RENDER_SUN_SIZE), 1.0);
			    col.xyz += GLOBAL_LIGHT_COLOR * sun_spec;
            #endif
        #endif

    }
    // gamma correction
    col.x = pow(col.x, 1.0/GAMMA);
    col.y = pow(col.y, 1.0/GAMMA);
    col.z = pow(col.z, 1.0/GAMMA);
    return col.xyz;
}


void main(){
    vec3 col = vec3(0.0);
    vec3 ro = camera_position;
    //vec3 ro = 1.1*vec3(2.5*sin(0.25*iTime),-1.0+1.0*cos(iTime*.13),2.5*cos(0.25*iTime));
    // Anti-Aliasing
    for(float m = 0; m<AA; m++){
        for(float n = 0; n<AA; n++){
            // uv coordinates
            vec2 o = vec2(m,n)/AA - 0.5;
            vec2 uv = (2.0 * (gl_FragCoord.xy + o) - iResolution)/iResolution.y;
            // get ray direction from uv
            vec3 rd = getDirection(uv);
            col += render(ro, rd);
        }
    }
    col /= AA*AA;
    frag_color = vec4(col, 1.0);
}

