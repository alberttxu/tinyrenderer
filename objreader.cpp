#include <stdio.h>
#include <assert.h>
#include "debug_macros.h"

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

int load_obj(const char *objfile, Mesh *mesh)
{
    FILE *f = fopen(objfile, "r");
    if (f == NULL)
    {
        perror("fopen");
        fprintf(stderr, "couldn't open obj file %s\n", objfile);
        return -1;
    }

    char *lineptr = NULL;
    size_t bufsize;
    int num_verts = 0;
    int num_faces = 0;
    for (int linenum = 1; getline(&lineptr, &bufsize,  f) != -1; linenum++)
    {
        //showint(linenum);
        if (lineptr[0] == 'v' && lineptr[1] == ' ')
        {
            Vec3 v;
            int n = sscanf(lineptr, "v %f %f %f\n", &v.x, &v.y, &v.z);
            assert(n == 3);
            //showfloat(x);
            mesh->vertices[num_verts] = v;
            num_verts++;
        }
        else if (lineptr[0] == 'f' && lineptr[1] == ' ')
        {
            int v1;
            int v2;
            int v3;
            int u; // unused
            int n = sscanf(lineptr, "f %d/%d/%d %d/%d/%d %d/%d/%d\n",
                           &v1,&u,&u, &v2,&u,&u, &v3,&u,&u);
            assert(n == 9);
            //showint(v1);
            Face face = {v1 - 1, v2 - 1, v3 - 1}; // .obj uses 1-indexing
            mesh->faces[num_faces] = face;
            num_faces++;
        }
    }
    mesh->num_verts = num_verts;
    mesh->num_faces = num_faces;

    printf("parsed %d vertices, %d faces\n", num_verts, num_faces);
    fclose(f);
    return 0;
}
