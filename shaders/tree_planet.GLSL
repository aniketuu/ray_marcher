float DE(vec3 p){
    float n;
    float iters = 32.0;
    for(n = 0; n<iters; n++){
        pRotY(p, 25.210143);
        pFoldAbs(p);
        pFoldMenger(p);
        p = p * 1.3 + vec3(-2.0, -4.8, 0);
        pFoldPlane(p, vec3(0,0,1), 0.0);
    }
    
    return de_box(p,vec3(4.8)) * pow(1.3, -iters);    
}