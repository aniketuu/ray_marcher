float DE(vec3 p){
    float n;
    float iters = 4.0;
    for(n = 0; n<iters; n++){
        pRotY(p, 190.794946);
        pFoldSierpinski(p);
        pRotX(p, 8.594366);
        pFoldMenger(p);
        p = p * 1.57 + vec3(-6.61, -4.0, -2.42);
    }
    
    return de_box(p,vec3(4.8)) * pow(1.57, -iters);    
}