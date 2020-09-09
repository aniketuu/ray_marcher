//////////////////////////////////////////////////////////////////////
//	PRIMITIVES
/////////////////////////////////////////////////////////////////////
float de_Sphere(vec3 p, float r){
	return length(p) - r;
}
float de_Box(vec3 p, vec3 b){
  vec3 q = abs(p) - b;
  return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}
float de_Cross(vec3 p){
  float da = de_Box(p.xyz,vec3(MAX_DIST,1.0,1.0));
  float db = de_Box(p.yzx,vec3(1.0,MAX_DIST,1.0));
  float dc = de_Box(p.zxy,vec3(1.0,1.0,MAX_DIST));
  return min(da,min(db,dc));
}
/////////////////////////////////////////////////////////////////////
//	SPACE FOLDING
/////////////////////////////////////////////////////////////////////
void pFold1D(inout float x, float size){
	float half_size = 0.5 * size;
	x = mod((x + half_size), size) - half_size;
}
void pFold2D(inout vec2 p, float size){
	float half_size = 0.5 * size;
	p = mod((p + half_size), size) - half_size;
}
void pFold3D(inout vec3 p, float size){
	float half_size = 0.5 * size;
	p = mod((p + half_size), size) - half_size;
}