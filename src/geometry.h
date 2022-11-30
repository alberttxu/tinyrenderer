#pragma once

#include <math.h>

struct Vec2i
{
    int x;
    int y;
    Vec2i() {}
    Vec2i(int a, int b)
    {
        x = a;
        y = b;
    }
};

struct Vec3
{
    float x;
    float y;
    float z;
};

static Vec3 operator*(float a, const Vec3 &v)
{
    Vec3 result;
    result.x = a * v.x;
    result.y = a * v.y;
    result.z = a * v.z;
    return result;
}

static Vec3 operator+(const Vec3 &u, const Vec3 &v)
{
    Vec3 result;
    result.x = u.x + v.x;
    result.y = u.y + v.y;
    result.z = u.z + v.z;
    return result;
}

static Vec3 operator-(const Vec3 &u, const Vec3 &v)
{
    return -1 * u + v;
}

float dot(const Vec3 *a, const Vec3 *b)
{
    return a->x * b->x + a->y * b->y + a->z * b->z;
}

float norm(const Vec3 *v)
{
    return sqrt(dot(v,v));
}

void normalize(Vec3 *v)
{
    float normv = norm(v);
    v->x /= normv;
    v->y /= normv;
    v->z /= normv;
}

Vec3 crossproduct(const Vec3 *a, const Vec3 *b)
{
    Vec3 normal = {
        a->y * b->z - a->z * b->y,
        a->z * b->x - a->x * b->z,
        a->x * b->y - a->y * b->x,
    };
    return normal;
}


struct Face
{
    int vertidx[3];
};

constexpr int max_vertices = 10000;
constexpr int max_faces =    10000;

struct Mesh
{
    Vec3 *vertices;
    Face *faces;
    int num_verts;
    int num_faces;
    Mesh()
    {
        vertices = (Vec3 *) malloc(sizeof(Vec3) * max_vertices);
        faces = (Face *) malloc(sizeof(Face) * max_faces);
        num_verts = 0;
        num_faces = 0;
    }
    ~Mesh()
    {
        free(vertices);
        free(faces);
        vertices = NULL;
        faces = NULL;
        num_verts = 0;
        num_faces = 0;
    }
};

