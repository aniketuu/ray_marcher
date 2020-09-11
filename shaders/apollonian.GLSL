vec4 orb;
float apollonian(vec3 p)
{
   	float scale = 1.0;
	orb = vec4(1000.0); 
	
	for( int i=0; i < 8;i++ )
	{
		p = -1.0 + 2.0*fract(0.5*p+0.5);
        float r2 = dot(p,p);
        orb = min( orb, vec4(abs(p),r2) );
        float k = 1.2/ r2;
		p *= k;
		scale *= k;
	}
	
	return 0.25*abs(p.y)/scale;
}

float map(vec3 p)
{
    vec3 q=p;

    float d0=apollonian(p*0.2)*5.;;
    float d1=abs(p.y-0.02);
    float d3 = de_box(q+vec3(0.,-2.,0.), 2.9*vec3(3.,2.,2.3));
    float d = max(d0, d3);
    d=min(d,d1);
    return d;
}

/* move up to see *//