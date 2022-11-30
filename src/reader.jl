module Reader

export load_obj

import ..Geometry: Vec3, Mesh

function load_obj(objfile)
    vertices = Vector{Vec3{Float64}}()
    faces = Vector{Vec3{Int}}()
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
        elseif tokens[1] == "f"
            v1 = parse(Int, split(tokens[2], "/")[1])
            v2 = parse(Int, split(tokens[3], "/")[1])
            v3 = parse(Int, split(tokens[4], "/")[1])
            push!(faces, Vec3(v1,v2,v3))
        end
    end
    println("parsed $(length(vertices)) vertices, $(length(faces)) faces \
            from $objfile")
    return Mesh(vertices, faces)
end

end # module Reader

