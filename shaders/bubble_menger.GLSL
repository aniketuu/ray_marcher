float DE(vec3 p){
    float n;float iters = 2.0; float t;
    for(n = 0.0; n<iters; n++){
        p = abs(p);
        if(p.x < p.y){
            t = p.x; p.x = p.y; p.y = t; 
        }
        if(p.y < p.z){
            t = p.y; p.y = p.z; p.z = t;
        }
        if(p.x < p.y){
            t = p.x; p.x = p.y; p.y = t; 
        }
        p.x = p.x *3.0 -2.0;
        p.y = p.y *3.0 -2.0;
        p.z = p.z *3.0 -2.0;
        if(p.z < -1.0){
            p.z += 2.0;
        }
    }
    return (length(p)-1.5) * pow(3.0, -iters);
}