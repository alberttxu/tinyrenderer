#include <math.h>
#include "tgaimage.h"
#include "debug_macros.h"
#include "objreader.cpp"

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
    if (x0 == x1)
    {
        int y_start = min(y0, y1);
        int y_end = max(y0, y1);
        for (int y = y_start; y <= y_end; y++)
        {
            image.set(x0, y, color);
        }
        return;
    }

    if (x0 > x1)
    {
        swap(&x0, &x1);
        swap(&y0, &y1);
    }

    float slope = (float)(y1 - y0) / (float)(x1 - x0);
    if (slope > 1.0)
    {
        float invslope = 1.0 / slope;
        for (int y = y0; y <= y1; y++)
        {
            int x = round(invslope * (y - y0) + x0);
            image.set(x, y, color);
        }
    }
    else if (slope < -1.0)
    {
        float invslope = 1.0 / slope;
        for (int y = y0; y >= y1; y--)
        {
            int x = round(invslope * (y - y0) + x0);
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


void line(Vec3 v0, Vec3 v1, TGAImage *image, TGAColor color)
{
    int x0 = (v0.x + 1.0) * image->get_width()/2.0;
    int y0 = (v0.y + 1.0) * image->get_height()/2.0;
    int x1 = (v1.x + 1.0) * image->get_width()/2.0;
    int y1 = (v1.y + 1.0) * image->get_height()/2.0;
    line(x0, y0, x1, y1, *image, color);
}


void draw_mesh(Mesh *mesh, TGAImage *image)
{
    for (int fi = 0; fi < mesh->num_faces; fi++)
    {
        int v0i = mesh->faces[fi].vertidx[0];
        int v1i = mesh->faces[fi].vertidx[1];
        int v2i = mesh->faces[fi].vertidx[2];
        Vec3 v0 = mesh->vertices[v0i];
        Vec3 v1 = mesh->vertices[v1i];
        Vec3 v2 = mesh->vertices[v2i];
        line(v0, v1, image, white);
        line(v1, v2, image, white);
        line(v2, v0, image, white);
    }
}


int main(int argc, char** argv) {
	TGAImage image(1000, 1000, TGAImage::RGB);

    /* 1st exercise
    line(13, 20, 80, 40, image, white);
    line(20, 13, 40, 80, image, red);
    line(80, 40, 13, 20, image, red);
    */

    /* 2nd exercise
    Mesh mesh;
    if (load_obj("assets/african_head.obj", &mesh) < 0)
        return 1;
    draw_mesh(&mesh, &image);
    */

	image.flip_vertically(); // i want to have the origin at the left bottom corner of the image
	image.write_tga_file("output.tga");
	return 0;
}

