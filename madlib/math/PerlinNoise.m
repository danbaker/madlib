//
//  PerlinNoise.m
//  planetmaker
// See: http://stackoverflow.com/questions/4753055/perlin-noise-generation-for-terrain
//
//  Created by Dan Baker on 4/13/13.
//  Copyright (c) 2013 BakerCrew. All rights reserved.
//

#import "PerlinNoise.h"

@implementation PerlinNoise

- (id)init
{
    self = [super init];
    self.persistence = 0.25;
    self.frequency = 1;             // ? width / 3
    self.amplitude = 1;             // generate values from -1 to +1
    self.octaves = 4;               // 3 to 8
    self.randomseed = 123456;
    return self;
}

- (double) heightX:(double) x Y:(double) y
{
    return self.amplitude * [self totalX:x Y:y];
}

- (double) totalX:(double) i Y:(double)j
{
    //properties of one octave (changing each loop)
    double t = 0.0f;
    double amp = 1;
    double freq = self.frequency;
    
    for(int k = 0; k < self.octaves; k++)
    {
        t += [self valueX:j * freq + self.randomseed Y:i * freq + self.randomseed] * amp;
        amp *= self.persistence;
        freq *= 2;
    }
    
    return t;
}


- (double) valueX:(double) x Y:(double) y
{
    int Xint = (int)x;
    int Yint = (int)y;
    double Xfrac = x - Xint;
    double Yfrac = y - Yint;
    
    //noise values
    double n01 = [self noiseX:Xint-1 Y:Yint-1];
    double n02 = [self noiseX:Xint+1 Y:Yint-1];
    double n03 = [self noiseX:Xint-1 Y:Yint+1];
    double n04 = [self noiseX:Xint+1 Y:Yint+1];
    double n05 = [self noiseX:Xint-1 Y:Yint];
    double n06 = [self noiseX:Xint+1 Y:Yint];
    double n07 = [self noiseX:Xint Y:Yint-1];
    double n08 = [self noiseX:Xint Y:Yint+1];
    double n09 = [self noiseX:Xint Y:Yint];
    
    double n12 = [self noiseX:Xint+2 Y:Yint-1];
    double n14 = [self noiseX:Xint+2 Y:Yint+1];
    double n16 = [self noiseX:Xint+2 Y:Yint];
    
    double n23 = [self noiseX:Xint-1 Y:Yint+2];
    double n24 = [self noiseX:Xint+1 Y:Yint+2];
    double n28 = [self noiseX:Xint Y:Yint+2];
    
    double n34 = [self noiseX:Xint+2 Y:Yint+2];
    
    //find the noise values of the four corners
    double x0y0 = 0.0625*(n01+n02+n03+n04) + 0.125*(n05+n06+n07+n08) + 0.25*(n09);
    double x1y0 = 0.0625*(n07+n12+n08+n14) + 0.125*(n09+n16+n02+n04) + 0.25*(n06);
    double x0y1 = 0.0625*(n05+n06+n23+n24) + 0.125*(n03+n04+n09+n28) + 0.25*(n08);
    double x1y1 = 0.0625*(n09+n16+n28+n34) + 0.125*(n08+n14+n06+n24) + 0.25*(n04);
    
    //interpolate between those values according to the x and y fractions
    double v1 = [self interpolateX:x0y0 Y:x1y0 A:Xfrac]; //interpolate in x direction (y)
    double v2 = [self interpolateX:x0y1 Y:x1y1 A:Xfrac]; //interpolate in x direction (y+1)
    double fin = [self interpolateX:v1 Y:v2 A:Yfrac];  //interpolate in y direction
    
    return fin;
}

- (double) interpolateX:(double) x Y:(double) y A:(double) a
{
    double negA = 1.0 - a;
    double negASqr = negA * negA;
    double fac1 = 3.0 * (negASqr) - 2.0 * (negASqr * negA);
    double aSqr = a * a;
    double fac2 = 3.0 * aSqr - 2.0 * (aSqr * a);

    return x * fac1 + y * fac2; //add the weighted factors
}

- (double) noiseX:(int) x Y:(int) y
{
    int n = x + y * 57;
    n = (n << 13) ^ n;
    int t = (n * (n * n * 15731 + 789221) + 1376312589) & 0x7fffffff;
    return 1.0 - ((double)t) * 0.931322574615478515625e-9;/// 1073741824.0);
}



@end

/*
 PerlinNoise::PerlinNoise()
 {
 persistence = 0;
 frequency = 0;
 amplitude  = 0;
 octaves = 0;
 randomseed = 0;
 }
 
 PerlinNoise::PerlinNoise(double _persistence, double _frequency, double _amplitude, int _octaves, int _randomseed)
 {
 persistence = _persistence;
 frequency = _frequency;
 amplitude  = _amplitude;
 octaves = _octaves;
 randomseed = 2 + _randomseed * _randomseed;
 }
 
 void PerlinNoise::Set(double _persistence, double _frequency, double _amplitude, int _octaves, int _randomseed)
 {
 persistence = _persistence;
 frequency = _frequency;
 amplitude  = _amplitude;
 octaves = _octaves;
 randomseed = 2 + _randomseed * _randomseed;
 }
 
 double PerlinNoise::GetHeight(double x, double y) const
 {
 return amplitude * Total(x, y);
 }
 
 double PerlinNoise::Total(double i, double j) const
 {
 //properties of one octave (changing each loop)
 double t = 0.0f;
 double _amplitude = 1;
 double freq = frequency;
 
 for(int k = 0; k < octaves; k++)
 {
 t += GetValue(j * freq + randomseed, i * freq + randomseed) * _amplitude;
 _amplitude *= persistence;
 freq *= 2;
 }
 
 return t;
 }
 
 double PerlinNoise::GetValue(double x, double y) const
 {
 int Xint = (int)x;
 int Yint = (int)y;
 double Xfrac = x - Xint;
 double Yfrac = y - Yint;
 
 //noise values
 double n01 = Noise(Xint-1, Yint-1);
 double n02 = Noise(Xint+1, Yint-1);
 double n03 = Noise(Xint-1, Yint+1);
 double n04 = Noise(Xint+1, Yint+1);
 double n05 = Noise(Xint-1, Yint);
 double n06 = Noise(Xint+1, Yint);
 double n07 = Noise(Xint, Yint-1);
 double n08 = Noise(Xint, Yint+1);
 double n09 = Noise(Xint, Yint);
 
 double n12 = Noise(Xint+2, Yint-1);
 double n14 = Noise(Xint+2, Yint+1);
 double n16 = Noise(Xint+2, Yint);
 
 double n23 = Noise(Xint-1, Yint+2);
 double n24 = Noise(Xint+1, Yint+2);
 double n28 = Noise(Xint, Yint+2);
 
 double n34 = Noise(Xint+2, Yint+2);
 
 //find the noise values of the four corners
 double x0y0 = 0.0625*(n01+n02+n03+n04) + 0.125*(n05+n06+n07+n08) + 0.25*(n09);
 double x1y0 = 0.0625*(n07+n12+n08+n14) + 0.125*(n09+n16+n02+n04) + 0.25*(n06);
 double x0y1 = 0.0625*(n05+n06+n23+n24) + 0.125*(n03+n04+n09+n28) + 0.25*(n08);
 double x1y1 = 0.0625*(n09+n16+n28+n34) + 0.125*(n08+n14+n06+n24) + 0.25*(n04);
 
 //interpolate between those values according to the x and y fractions
 double v1 = Interpolate(x0y0, x1y0, Xfrac); //interpolate in x direction (y)
 double v2 = Interpolate(x0y1, x1y1, Xfrac); //interpolate in x direction (y+1)
 double fin = Interpolate(v1, v2, Yfrac);  //interpolate in y direction
 
 return fin;
 }
 
 double PerlinNoise::Interpolate(double x, double y, double a) const
 {
 double negA = 1.0 - a;
 double negASqr = negA * negA;
 double fac1 = 3.0 * (negASqr) - 2.0 * (negASqr * negA);
 double aSqr = a * a;
 double fac2 = 3.0 * aSqr - 2.0 * (aSqr * a);
 
 return x * fac1 + y * fac2; //add the weighted factors
 }
 
 double PerlinNoise::Noise(int x, int y) const
 {
 int n = x + y * 57;
 n = (n << 13) ^ n;
 int t = (n * (n * n * 15731 + 789221) + 1376312589) & 0x7fffffff;
 return 1.0 - double(t) * 0.931322574615478515625e-9;/// 1073741824.0);
 }
*/