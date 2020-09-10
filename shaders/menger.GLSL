float DE(vec3 p){
    float iters = 6.0;
    float i;
    for(i = 0.0; i<iters; i++){
        pFoldAbs(p);
        pFoldMenger(p);
        p = p * 3.0 - 2.0;
        pFoldPlane(p, vec3(0.0, 0.0, 1.0), -1.0);
    }
    return de_box(p,vec3(1.5)) * pow(3.0, -iters);
    
}