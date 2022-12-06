module Geometry

export Vec2, Vec3, Face, Mesh, Triangle2D

struct Vec2{T<:Real} <: AbstractVector{T}
    x::T
    y::T
end

Base.size(::Vec2) = (2,)

function Base.getindex(v::Vec2, i::Int)
    if i == 1
        return v.x
    elseif i == 2
        return v.y
    else
        throw(DomainError(i, "argument must be either 1 or 2"))
    end
end

function Vec2(v::T) where T <: AbstractVector{<:Real}
    @assert length(v) == 2
    return Vec2(v[1], v[2])
end


struct Vec3{T<:Real} <: AbstractVector{T}
    x::T
    y::T
    z::T
end

Base.size(::Vec3) = (3,)

function Base.getindex(v::Vec3, i::Int)
    if i == 1
        return v.x
    elseif i == 2
        return v.y
    elseif i == 3
        return v.z
    else
        throw(DomainError(i, "argument must be either 1, 2, or 3"))
    end
end

function Vec3(v::T) where T <: AbstractVector{<:Real}
    @assert length(v) == 3
    return Vec2(v[1], v[2], v[3])
end


struct Face
    vert_idxs::Vec3{Int}
    texture_idxs::Vec3{Int}
end

struct Mesh
    vertices::Vector{Vec3{Float64}}
    textures::Vector{Vec2{Float64}}
    faces::Vector{Face}
end


struct Triangle2D
    v1::Vec2{Int}
    v2::Vec2{Int}
    v3::Vec2{Int}
end

function Base.getindex(tri::Triangle2D, i::Int)
    if i == 1
        return tri.v1
    elseif i == 2
        return tri.v2
    elseif i == 3
        return tri.v3
    else
        throw(DomainError(i, "argument must be either 1, 2, or 3"))
    end
end

end # module Geometry
