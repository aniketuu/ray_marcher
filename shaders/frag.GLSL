#version 330 core

// CAMERA_PROPERTIES

// HELPER0
// HELPER1
// HELPER2
// HELPER3
// HELPER4
// HELPER5
// HELPER6
// HELPER7

struct Camera{
    vec3 position;
    vec3 direction;
    vec3 up_axis;
    vec3 right_axis;
};

struct Ray{
    vec3 position;
    vec3 direction;
};

uniform vec2 display_res;
uniform Camera camera;

out vec4 frag_color;

void sdfSphere(vec3 p, inout float r){
    r = length(p) - r;
}

float sdfBox( vec3 p, vec3 b )
{
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

float sdfScene(vec3 p){
    pMod3(p,vec3(2.0));
    vec3 a = vec3(0.0);
    vec3 b = vec3(1.0);
    float box = fSphere(p, 0.4);
    return box;
}


float rayMarch(Ray ray){
    vec3 p = ray.position;
    float dist = START;
    for(int i = 0; i<MAX_STEPS; i++){
        p = ray.position + dist * ray.direction;
        //p = mod(abs(p),2.0);
        float temp = sdfScene(p);
        if(temp < EPSILON){
            // hit
            return dist;
        }
        dist += temp;
        if(dist >= MAX_DIST){
            return MAX_DIST;
        }
    }
    return MAX_DIST;
}

vec3 estimateNormal(vec3 p) {
    return normalize(vec3(
        sdfScene(vec3(p.x + EPSILON, p.y, p.z)) - sdfScene(vec3(p.x - EPSILON, p.y, p.z)),
        sdfScene(vec3(p.x, p.y + EPSILON, p.z)) - sdfScene(vec3(p.x, p.y - EPSILON, p.z)),
        sdfScene(vec3(p.x, p.y, p.z  + EPSILON)) - sdfScene(vec3(p.x, p.y, p.z - EPSILON))
    ));
}

vec3 getDirection(vec2 uv){
    vec3 ray_dir = sensor_dist*camera.direction + uv.x*camera.right_axis + uv.y*camera.up_axis;
    return normalize(ray_dir);
}

void main(){
    // uv
    vec2 uv = gl_FragCoord.xy/display_res;
    uv = uv  * 2.0 - 1.0;
    uv.x *= display_res.x/display_res.y; 

    // ray
    
    vec3 eye = camera.position;
    vec3 ray_dir = getDirection(uv);
    
    Ray ray;
    ray.position = eye;
    ray.direction = ray_dir;

    // light pos & col
    vec3 light_pos = vec3(3.5, 3.5, 3.5);
    vec3 light_col = vec3(0.7, 0.0, 0.7);

    // obj
    vec3 object_color = vec3(1.0, 1.0, 1.0);

    float dist = rayMarch(ray);
    if(dist == MAX_DIST){
        frag_color = vec4(0.0);
    } 
    else{
        vec3 frag_pos = ray.position + dist * ray.direction;
        //frag_pos = mod(frag_pos,2.0);
        vec3 light_dir = normalize(light_pos - frag_pos);
        vec3 view_dir = normalize(eye - frag_pos);

        // normal
        vec3 normal = estimateNormal(frag_pos);

        //reflect
        vec3 reflect_dir = reflect(-light_dir, normal);  

        // ambient 
        float ambient_strength = 0.35;
        vec3 ambient = light_col * ambient_strength;

        // diffuse
        float diffuse_strength = max(dot(normal, light_dir), 0.0);
        vec3 diffuse = light_col * diffuse_strength;

        // specular
        float specular_strength = 0.5;
        float specular_radius = pow(max(dot(view_dir, reflect_dir), 0.0), 32);
        vec3 specular = specular_strength * specular_radius * light_col;  

        vec3 color = (ambient + diffuse + specular) * object_color;  // spec is creating a shading problem
        //vec3 color = vec3(dist/4.0);
        frag_color = vec4(color, 1.0);
    }

}