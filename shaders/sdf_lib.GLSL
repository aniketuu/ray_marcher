//////////////////////////////////////////////////////////////////////////
//  UTILS
/////////////////////////////////////////////////////////////////////////
float vmax(vec3 p){
    return max(p.x, max(p.y,p.z));
}

/////////////////////////////////////////////////////////////////////////
//  PRIMITIVES
/////////////////////////////////////////////////////////////////////////
float de_sphere(vec3 p, float r){
    return length(p) - r;
}
float de_box(vec3 p, vec3 b){
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(vmax(q),0.0);
}
float de_box(vec3 p, vec3 b, float r){
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(vmax(q),0.0) - r;
}
float de_tetrahedron(vec3 p, float r) {
	float md = max(max(-p.x - p.y - p.z, p.x + p.y - p.z),
				   max(-p.x + p.y + p.z, p.x - p.y + p.z));
	return (md - r) / sqrt(3.0);
}
/////////////////////////////////////////////////////////////////////////
//  SPACE FOLDING
/////////////////////////////////////////////////////////////////////////
vec3 pFold3D(vec3 p, float size){
  float half_size = 0.5 * size;
  return mod((p + half_size), size) - half_size;
}
void pFoldSierpinski(inout vec3 p){
	p.xy -= min(p.x + p.y, 0.0);
	p.zx -= min(p.z + p.x, 0.0);
	p.yz -= min(p.y + p.z, 0.0);
}