module TinyRenderer

export red, green, blue, white
export line
export load_obj
export Vec2, Vec3, Mesh

include("geometry.jl")
using .Geometry

include("reader.jl")
using .Reader

using Images

red = RGB(1,0,0)
green = RGB(0,1,0)
blue = RGB(0,0,1)
white = RGB(1,1,1)


function line(x0::Int, y0::Int, x1::Int, y1::Int,
             img::M, color::RGB) where M <: AbstractMatrix{RGB}
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

function line(v1::Vec2{Int}, v2::Vec2{Int},
             img::M, color::RGB) where M <: AbstractMatrix{RGB}
    line(v1.x, v1.y, v2.x, v2.y, img, color)
end

end # module TinyRenderer

