include("geometry.jl")
#include("objreader.jl")

using Images
using .Geometry

red = RGB(1,0,0)
green = RGB(0,1,0)
blue = RGB(0,0,1)
white = RGB(1,1,1)


function line(x0::Int, y0::Int, x1::Int, y1::Int, img, color::RGB)
    if x0 == x1
        for y in minmax(y0, y1)
            img[y,x0] = color
        end
        return
    end

    if x0 > x1
        line(x1, y1, x0, y0, img, color)
        return
    end

    slope = (y1 - y0) / (x1 - x0)

    if abs(slope) > 1
        line(y0, x0, y1, x1, img', color)
        return
    end

    for x in x0:x1
        y = round(Int, slope * (x-x0) + y0)
        img[y,x] = color
    end
end


function test1()
    height = 100
    width = 100

    img = zeros(RGB, height, width)
    line(13, 20, 80, 40, img, white);
    line(20, 13, 40, 80, img, red);
    line(80, 80, 13, 20, img, red);

    reverse!(img, dims=1)
    save("output.png", img)

    return
end


function test2()
    objfile = "assets/african_head.obj"
    #load_obj(objfile)
end


function main()
    test1()
    #test2()
end

main()

