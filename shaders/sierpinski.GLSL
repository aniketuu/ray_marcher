float DE(vec3 p){
    float n;
    float iters = 6.0;
    for(n = 0; n<iters; n++){
        pFoldSierpinski(p);
        p = p * 2.0 - 1.0;
    }
    
    return de_tetrahedron(p,1.0) * pow(2.0, -iters);    
}