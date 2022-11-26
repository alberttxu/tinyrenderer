#include <math.h>
#include <map>

#include "tgaimage.h"
#include "debug_macros.h"
#include "objreader.cpp"

const TGAColor white = TGAColor(255, 255, 255, 255);
const TGAColor red   = TGAColor(255, 0,   0,   255);
const TGAColor green = TGAColor(0,   255, 0,   255);

#define min(a,b) (((a)<(b))?(a):(b))
#define max(a,b) (((a)>(b))?(a):(b))


void swap(int *a, int *b)
{
    int temp = *a;
    *a = *b;
    *b = temp;
}


void line(int x0, int y0, int x1, int y1, TGAImage *image, TGAColor color)
{
    if (x0 == x1)
    {
        int y_start = min(y0, y1);
        int y_end = max(y0, y1);
        for (int y = y_start; y <= y_end; y++)
        {
            image->set(x0, y, color);
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
            image->set(x, y, color);
        }
    }
    else if (slope < -1.0)
    {
        float invslope = 1.0 / slope;
        for (int y = y0; y >= y1; y--)
        {
            int x = round(invslope * (y - y0) + x0);
            image->set(x, y, color);
        }
    }
    else
    {
        for (int x = x0; x <= x1; x++)
        {
            int y = round(slope * (x - x0) + y0);
            image->set(x, y, color);
        }
    }
}


void line(Vec3 v0, Vec3 v1, TGAImage *image, TGAColor color)
{
    int x0 = (v0.x + 1.0) * image->get_width()/2.0;
    int y0 = (v0.y + 1.0) * image->get_height()/2.0;
    int x1 = (v1.x + 1.0) * image->get_width()/2.0;
    int y1 = (v1.y + 1.0) * image->get_height()/2.0;
    line(x0, y0, x1, y1, image, color);
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

// map: y -> [xmin, xmax]
typedef std::map<int, std::pair<int,int>> Xlist;

void updateEntry(Xlist &xlist, int y, int xmin, int xmax)
{
    if (!xlist.contains(y))
    {
        xlist[y] = {xmin, xmax};
        return;
    }

    if (xmin < xlist[y].first)
    {
        xlist[y].first = xmin;
    }
    if (xmax > xlist[y].second)
    {
        xlist[y].second = xmax;
    }
}

void updateXlist(Xlist *xlist, Vec2i v0, Vec2i v1)
{
    int x0 = v0.x;
    int y0 = v0.y;
    int x1 = v1.x;
    int y1 = v1.y;

    if (x0 == x1)
    {
        int y_start = min(y0, y1);
        int y_end = max(y0, y1);
        for (int y = y_start; y <= y_end; y++)
        {
            updateEntry(*xlist, y, x0, x0);
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
            updateEntry(*xlist, y, x, x);
        }
    }
    else if (slope < -1.0)
    {
        float invslope = 1.0 / slope;
        for (int y = y0; y >= y1; y--)
        {
            int x = round(invslope * (y - y0) + x0);
            updateEntry(*xlist, y, x, x);
        }
    }
    else
    {
        for (int x = x0; x <= x1; x++)
        {
            int y = round(slope * (x - x0) + y0);
            updateEntry(*xlist, y, x, x);
        }
    }
}

void triangle(Vec2i v0, Vec2i v1, Vec2i v2, TGAImage *image, TGAColor color)
{
    Xlist xlist;
    updateXlist(&xlist, v0, v1);
    updateXlist(&xlist, v1, v2);
    updateXlist(&xlist, v2, v0);
    for (const auto& [y, bounds] : xlist)
    {
        //showint(key);
        int xmin = bounds.first;
        int xmax = bounds.second;
        for (int x = xmin; x <= xmax; x++)
        {
            image->set(x, y, color);
        }
    }
}


int lesson1()
{
    /*
	TGAImage image(100, 100, TGAImage::RGB);
    line(13, 20, 80, 40, image, white);
    line(20, 13, 40, 80, image, red);
    line(80, 40, 13, 20, image, red);
    */

	TGAImage image(1000, 1000, TGAImage::RGB);
    Mesh mesh;
    if (load_obj("assets/african_head.obj", &mesh) < 0)
        return -1;
    draw_mesh(&mesh, &image);

	image.flip_vertically(); // i want to have the origin at the left bottom corner of the image
	image.write_tga_file("output.tga");
	return 0;
}

void lesson2()
{
	TGAImage image(200, 200, TGAImage::RGB);
    Vec2i t0[3] = {Vec2i(10, 70),   Vec2i(50, 160),  Vec2i(70, 80)};
    Vec2i t1[3] = {Vec2i(180, 50),  Vec2i(150, 1),   Vec2i(70, 180)};
    Vec2i t2[3] = {Vec2i(180, 150), Vec2i(120, 160), Vec2i(130, 180)};
    triangle(t0[0], t0[1], t0[2], &image, red);
    triangle(t1[0], t1[1], t1[2], &image, white);
    triangle(t2[0], t2[1], t2[2], &image, green);

	image.flip_vertically(); // i want to have the origin at the left bottom corner of the image
	image.write_tga_file("output.tga");
}

int main(int argc, char** argv)
{
    //assert(lesson1() == 0);
    lesson2();

    return 0;
}

