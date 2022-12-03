# stdlib imports
#using Profile

# local packages (in ./src)
using TinyRenderer

# 3rd party
using Images
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


function ortho2d(v::Vec3, img) :: Vec2{Int}
    scale = 0.85
    height, width = size(img)
    return Vec2(@. round(Int, ((scale * v[1:2]) + 1) * (width,height) / 2))
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


function draw(mesh, img)
    for (i, face) in enumerate(mesh.faces)
        v1 = mesh.vertices[face[1]]
        v2 = mesh.vertices[face[2]]
        v3 = mesh.vertices[face[3]]
        corner1 = ortho2d(v1, img)
        corner2 = ortho2d(v2, img)
        corner3 = ortho2d(v3, img)
        triangle(corner1, corner2, corner3, img, white)
    end
end


function test3()
    #=
    width = 200
    height = 200
    img = zeros(RGB, height, width)
    t0 = Triangle2D(Vec2(180,50), Vec2(150,1), Vec2(70,180))
    @time triangle(t0, img, white)
    =#

    width = 1000
    height = 1000
    img = zeros(RGB, height, width)
    objfile = "assets/african_head.obj"
    mesh = load_obj(objfile)
    @time draw(mesh, img)

    reverse!(img, dims=1)
    save("output.png", img)
    return
end


function main()
    #test1()
    #test2()
    test3()
    return
end

main()

