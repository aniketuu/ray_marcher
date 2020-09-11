float map(vec3 p){
    p = pFold3D(p, 4.0);
    float b = de_box(p, vec3(1.0));
    float s = de_sphere(p, 1.0);
    float f = 0.5;
    float c = f * s + (1.0 - f) * b;
    return c;
}