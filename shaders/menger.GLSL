float map(vec3 p){
    //float box_size = sin(iTime * 0.75)*0.015 + 1.5;
    float box_size = 2.5;
    float d = de_box(p, vec3(box_size));
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
    /*
    vec3 norm = vec3(0.57735);
    float pl = dot( p, norm )-smoothstep(0.05, 1.0, sin(iTime*0.0954-2.5248)*0.5+0.5)*6.0;
    //float pl = dot(p, norm);
    return max(res,pl);*/
    return res;
}