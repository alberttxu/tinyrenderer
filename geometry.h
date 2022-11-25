#pragma once

struct Vec3
{
    float x;
    float y;
    float z;
};

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

