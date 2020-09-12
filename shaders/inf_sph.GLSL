float map(vec3 p){
    p = pFold3D(p, 4.0);
    float s = de_sphere(p, 1.0);
    return s;
}