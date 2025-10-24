`AutoTypedStructs` provides a macro `@autotyped` that creates a parametric
struct where any fields that are not explicitly given a type (either concrete
or an explicitly specified type parameter) are assigned an unrestricted type
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

If it is necessary to restrict the types of some type parameters, it is also
permitted to mix explicitly specified and omitted type parameters, for example
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
