
SKF_W1		= 0;
SKF_N 		= 1;
SKF_H		= 2;
SKF_H2		= 3;
SKF_H3		= 4;
SKF_L1		= 5;
SKF_L2		= 6;
SKF_L3		= 7;
SKF_L4		= 8;
SKF_W3		= 9;
SKF_H4		= 10;
SKF_H5		= 11;
SKF_S2		= 12;
SKF_W		= 13;
SKF_H1		= 14;
SKF_H6		= 15;
SKF_F		= 16;
SKF_D1		= 17;
SKF_D2		= 18;
SKF_Emin	= 19;
SKF_Emax	= 20;
SKF_Lmax	= 21;
SKF_KGC		= 22;
SKF_KGR		= 23;
SKF_C		= 24;
SKF_C0		= 25;
SKF_Mx		= 26;
SKF_Mx0		= 27;
SKF_Myz		= 28;
SKF_Myz0	= 29;

SKF_PARAM_NAME = ["W1",  "N", "H", "H2", "H3",   "L1",  "L2",  "L3",  "L4",   "W3", "H4", "H5", "S2", "W", "H1",  "H6", "F", "D1", "D2", "E>", "E<",  "L<", "KGW", "KGR",   "C",  "C0", "Mx", "Mx0", "Myz", "Myz0"];     
SKF_LLTHC_U15  = [  34,  9.5,  24, 4.2,   4.6,   63.3,    40,    26,   4.3,    26,   4.0,  4.3,   4,  15, 	 14,   8.5,  60,  4.5,  7.5,   10,   50,  3920,  0.17,   1.4,  8400, 15400,   56,   103,     49,    90];
SKF_LLTHC_U20  = [  44,   12,  30, 8.3,   5.0,   73.3,    50,    36,  15.0,    32,   6.5,  5.7,   5,  20,    18,   9.3,  60,  6.0,  9.5,   10,   50,  3920,  0.26,   2.3, 12400, 24550,  112,   221,     90,   179];
//etc
	
module skf_rail(P, l=1000)
{
	//check l < SKF_Lmax
	w = P[SKF_W];
	h = P[SKF_H1];
	z = P[SKF_H];
	color("#666666")
	translate([-l/2, -w/2, -z])
	cube([l, w, h]);
}

module skf_carriage_bolts(P)
{
	for (i=[-1,1], j=[-1,1]) 
	translate([i*P[SKF_L3] ,j*P[SKF_W3],0]/2)
	children();
}

module skf_carriage(P)
{
	w  = P[SKF_W1];
	h  = P[SKF_H] - P[SKF_H3];
	l1 = P[SKF_L1];
	l2 = P[SKF_L2];
	b  = P[SKF_H4];
	
	difference()
	{
		union()
		{
			color("silver")
			translate([-l2/2, -w/2, -h])
			cube([l2, w, h]);
		
			color("#444444")
			translate([-l1/2, -w/2+0.1, -h])
			cube([l1, w-0.2, h-0.1]);
		}
		color("black")
		skf_carriage_bolts(P) translate([0,0,-b])
		cylinder(d=P[SKF_S2], h=b+0.1);
	}
}

module skf_assembly(P = SKF_LLTHC_U15, l=600, car=[0.5])
{
	translate([0,0,P[SKF_H]]) 
	{
		skf_rail(P,l);
		travel = l - P[SKF_L1];
		for (c = car)
		{
			translate([-travel/2 + travel * c, 0, 0])
			skf_carriage(P);
		}
		children();
	}
}


if ($preview) skf_assembly(car=[0.25 + sin($t*360)/4, 0.75 + (cos($t*360)*0.25)]);
