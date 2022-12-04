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
              img::AbstractMatrix{RGB{N0f8}}, color::RGB{N0f8})
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

function line(v1::Vec2{Int}, v2::Vec2{Int}, img::Matrix{RGB{N0f8}}, color::RGB{N0f8})
    line(v1.x, v1.y, v2.x, v2.y, img, color)
end


# for performance - default det allocates
function det3x3(A) :: Float64
    return (A[1,1] * A[2,2] * A[3,3]
          + A[1,2] * A[2,3] * A[3,1]
          + A[1,3] * A[2,1] * A[3,2]
          - A[1,3] * A[2,2] * A[3,1]
          - A[1,2] * A[2,1] * A[3,3]
          - A[1,1] * A[2,3] * A[3,2])
end

function triangle(v1::Vec2{Int}, v2::Vec2{Int}, v3::Vec2{Int},
                  img::Matrix{RGB{N0f8}}, color::RGB{N0f8},
                  zbuffer::Matrix{Float64}, corner_zvals::Vector{Float64})

    # bounding box bottom-left and upper-right corners
    xmin = min(v1.x, v2.x, v3.x)
    xmax = max(v1.x, v2.x, v3.x)
    ymin = min(v1.y, v2.y, v3.y)
    ymax = max(v1.y, v2.y, v3.y)

    A = SA_F64[v1.x  v2.x  v3.x;
               v1.y  v2.y  v3.y;
               1     1     1]

    tol = 1e-6
    if det3x3(A) < tol
        return
    end

    for x in xmin:xmax
        for y in ymin:ymax
            barycentric_coords = A \ SA_F64[x, y, 1]
            isinside = all(barycentric_coords .>= 0)
            if !isinside
                continue
            end

            pixel_z = dot(corner_zvals, barycentric_coords)
            if zbuffer[y,x] > pixel_z
                continue
            end
            img[y,x] = color
            zbuffer[y,x] = pixel_z
        end
    end
end

end # module TinyRenderer

