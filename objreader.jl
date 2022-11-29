using .Geometry

function load_obj(objfile)
    for line in eachline(objfile)
        println(line)
    end
end
