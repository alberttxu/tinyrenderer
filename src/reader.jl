module Reader

export load_obj

using ..Geometry


function load_obj(objfile)
    vertices = Vector{Vec3{Float64}}()
    vert_idxs = Vector{Vec3{Int}}()
    textures = Vector{Vec2{Float64}}()
    texture_idxs = Vector{Vec3{Int}}()
    faces = Vector{Face}()

    for line in eachline(objfile)
        #println(line)
        tokens = split(line)
        if length(tokens) == 0
            continue
        end
        if tokens[1] == "v"
            x = parse(Float64, tokens[2])
            y = parse(Float64, tokens[3])
            z = parse(Float64, tokens[4])
            push!(vertices, Vec3(x,y,z))
        elseif tokens[1] == "vt"
            u = parse(Float64, tokens[2])
            v = parse(Float64, tokens[3])
            push!(textures, Vec2(u,v))
        elseif tokens[1] == "f"
            vert_idxs = [parse(Int, split(tokens[i], "/")[1]) for i in 2:4]
            texture_idxs = [parse(Int, split(tokens[i], "/")[2]) for i in 2:4]
            push!(faces, Face(Vec3(vert_idxs...), Vec3(texture_idxs...)))
        end
    end

    println("parsed $(length(vertices)) vertices, $(length(faces)) faces \
            from $objfile")
    return Mesh(vertices, textures, faces)
end

end # module Reader

