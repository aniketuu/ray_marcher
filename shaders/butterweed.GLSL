float DE(vec3 p){
    float n;
    float iters = 30.0;
    for(n = 0.0; n < iters; n++){
        pFoldAbs(p);
        p = p * 1.5;
        p = p + vec3(-1.0, -0.5, -0.2);
        pRotX(p, 206.8378);
        pRotY(p, 116.3104);
    }
    return de_sphere(p, 1.0) * pow(1.5, -iters);
}