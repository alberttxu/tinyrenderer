# stdlib imports
#using Profile
using LinearAlgebra

# local packages (in ./src)
using TinyRenderer

# 3rd party
using Images: load, save, RGB, N0f8
#using ProfileView


function test1()
    height = 100
    width = 100

    img = zeros(RGB, height, width)
    @time line(13, 20, 80, 40, img, white);
    line(20, 13, 40, 80, img, TinyRenderer.red);
    line(80, 80, 13, 20, img, TinyRenderer.red);

    reverse!(img, dims=1)
    save("output.png", img)

    return
end


function test2()
    width = 1000
    height = 1000
    img = zeros(RGB, height, width)

    objfile = "assets/african_head.obj"
    mesh = load_obj(objfile)
    for face in mesh.faces
        v1 = mesh.vertices[face[1]]
        v2 = mesh.vertices[face[2]]
        v3 = mesh.vertices[face[3]]
        corner1 = ortho2d(v1, img)
        corner2 = ortho2d(v2, img)
        corner3 = ortho2d(v3, img)
        line(corner1, corner2, img, white)
        line(corner2, corner3, img, white)
        line(corner3, corner1, img, white)
    end

    reverse!(img, dims=1)
    save("output.png", img)
    return
end


function test_triangle()
    width = 200
    height = 200
    img = zeros(RGB{N0f8}, height, width)
    #println(typeof(img))
    zbuffer = similar(img, Float64)
    corner_zvals = [1.0,0,0]
    @time triangle(Vec2(180,50), Vec2(150,1), Vec2(70,180), img, white, zbuffer, corner_zvals)
end

function test3()
    width = 1000
    height = 1000
    img = zeros(RGB{N0f8}, height, width)
    objfile = "assets/african_head.obj"
    texture_map = "assets/african_head_diffuse.tga"
    texture = load(texture_map)
    mesh = load_obj(objfile)
    @time draw(mesh, texture, img)

    reverse!(img, dims=1)
    save("output.png", img)
    return
end

function main()
    #test1()
    #test2()
    #test_triangle()
    test3()
    return
end

main()

