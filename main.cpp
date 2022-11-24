#include <math.h>
#include "tgaimage.h"
#include "debug_macros.h"

const TGAColor white = TGAColor(255, 255, 255, 255);
const TGAColor red   = TGAColor(255, 0,   0,   255);

#define min(a,b) (((a)<(b))?(a):(b))
#define max(a,b) (((a)>(b))?(a):(b))

void swap(int *a, int *b)
{
    int temp = *a;
    *a = *b;
    *b = temp;
}


void line(int x0, int y0, int x1, int y1, TGAImage &image, TGAColor color)
{
    if (x0 > x1)
        swap(&x0, &x1);

    float slope = (float)(y1 - y0) / (float)(x1 - x0);
    if (slope > 1)
    {
        float invslope = 1.0 / slope;
        int y_start = min(y0, y1);
        int y_end = max(y0, y1);
        for (int y = y_start; y <= y_end; y++)
        {
            int x = round(invslope * (y - y_start) + x0);
            image.set(x, y, color);
        }
    }
    else
    {
        for (int x = x0; x <= x1; x++)
        {
            int y = round(slope * (x - x0) + y0);
            image.set(x, y, color);
        }
    }
}


int main(int argc, char** argv) {
	TGAImage image(100, 100, TGAImage::RGB);

    line(13, 20, 80, 40, image, white);
    line(20, 13, 40, 80, image, red);
    line(80, 40, 13, 20, image, red);

	image.flip_vertically(); // i want to have the origin at the left bottom corner of the image
	image.write_tga_file("output.tga");
	return 0;
}

