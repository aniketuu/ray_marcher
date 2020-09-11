float map(vec3 p){
    float d = de_box(p, vec3(1.0));
    float res = d;
    float s = 1.0;
    for(int m = 0; m<4; m++){
        vec3 a = mod(p * s, 2.0) - 1.0;
        s *= 3.0;
        vec3 r = abs(1.0 - 3.0*abs(a));
        float da = max(r.x, r.y);
        float db = max(r.y, r.z);
        float dc = max(r.z, r.x);
        float c = (min(da, min(db,dc)) - 1.0)/s;
        if(c > d){
            d = c;
            res = d;
        }
    }
    vec3 norm = vec3(0.57735);
    float pl = dot(p, norm);
    return max(res,pl);
}