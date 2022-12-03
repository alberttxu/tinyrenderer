module TinyRenderer

export red, green, blue, white
export line, triangle
export load_obj
export Vec2, Vec3, Mesh, Triangle2D

using LinearAlgebra
using StaticArrays

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
        ymin, ymax = minmax(y0, y1)
        for y in ymin:ymax
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


#= works but could be better
function isInsideTriangle(v1::Vec2{Int}, v2::Vec2{Int}, v3::Vec2{Int}, query::Vec2{Int}) :: Bool
    basis1 = [v2-v1 v3-v1]
    solution1 = basis1 \ (query - v1)
    if any(component -> component < 0, solution1)
        return false
    end
    basis2 = [v1-v2 v3-v2]
    solution2 = basis2 \ (query - v2)
    if any(component -> component < 0, solution2)
        return false
    end
    return true
end
=#

# check barycentric coordinates
function isInsideTriangle(A, rhs) :: Bool
    barycentric_coords = A \ rhs
    return all(barycentric_coords .>= 0)
end

function triangle(v1::Vec2{Int}, v2::Vec2{Int}, v3::Vec2{Int},
        img::M, color::RGB) where M <: AbstractMatrix{RGB}
    # bounding box bottom-left and upper-right corners
    xmin, ymin = min.(v1, v2, v3)
    xmax, ymax = max.(v1, v2, v3)

    A = SA_F64[v1.x  v2.x  v3.x;
               v1.y  v2.y  v3.y;
               1     1     1]

    if rank(A) < 3
        line(v1, v2, img, color)
        line(v2, v3, img, color)
        line(v3, v1, img, color)
        return
    end

    for x in xmin:xmax
        for y in ymin:ymax
            rhs = SA_F64[x, y, 1]
            if isInsideTriangle(A, rhs)
                img[y,x] = color
            end
        end
    end
end

function triangle(tri::Triangle2D, img::M, color::RGB) where M <: AbstractMatrix{RGB}
    triangle(tri.v1, tri.v2, tri.v3, img, color)
end

end # module TinyRenderer

