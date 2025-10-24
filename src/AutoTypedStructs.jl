module AutoTypedStructs

export @autotyped

"""
    @autotyped

Creates a parametric struct where any fields that are not explicitly given a type (either
concrete or an explicitly specified type parameter) are assigned an unrestricted type
parameter.

For example
```julia
@autotyped struct Foo
    x::Float64
    y
    z
end
```
is equivalent to
```julia
struct Foo{T1,T2}
    x::Float64
    y::T1
    z::T2
end
```

If it is necessary to restrict the types of some type parameters, it is also permitted to
mix explicitly specified and omitted type parameters, for example
```julia
@autotyped struct Bar{T <: Number}
    x::T
    y
    z
end
```

If you want to combine this with `@kwdef`, the `@kwdef` has to come first, for example
```julia
@kwdef @autotyped Foo
    x
    y
end
f = Foo(; x=42, y="hello")
"""
macro autotyped(expr)
    if expr.head != :struct
        error("@autotyped argument is not a struct definition.")
    end

    # Find how many struct fields are missing a template parameter.
    potential_type_parameters = Set{Symbol}()
    fields_list = expr.args[3].args
    for field ∈ fields_list
        if isa(field, Expr)
            if field.head === Symbol("::")
                # This is a field, but already has a type specification.
                push!(potential_type_parameters, field.args[2])
            else
                error("@autotyped does not know how to handle a field: $field")
            end
        end
    end

    # Make the struct into a parametric struct to which we can add type parameters.
    if isa(expr.args[2], Symbol)
        expr.args[2] = Expr(:curly, expr.args[2])
    elseif !(isa(expr.args[2], Expr) && expr.args[2].head === :curly)
        error("Unexpected form of struct declaration $(expr.args[2])")
    end

    # Need potential_type_parameters to be separate from type_parameters, because when the
    # input already had some type parameters, potentially with `<:` restrictions,
    # declared, `type_parameters` may not be just a list of names. So we have constructed
    # `potential_type_parameters` which is just a Set of the names of the type parameters.
    type_parameters = expr.args[2].args
    type_suffix = 1
    for i ∈ 1:length(fields_list)
        if isa(fields_list[i], Symbol)
            # Need to add a type parameter, and assign it to this entry.
            tp = Symbol("T", type_suffix)
            while tp ∈ potential_type_parameters
                # Ensure that no type parameters are repeated.
                type_suffix +=1
                tp = Symbol("T", type_suffix)
            end
            type_suffix +=1
            push!(potential_type_parameters, tp)
            push!(type_parameters, tp)

            fields_list[i] = Expr(Symbol("::"), fields_list[i], tp)
        end
    end

    return expr
end

end # module AutoTypedStructs
