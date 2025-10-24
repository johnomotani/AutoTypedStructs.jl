using AutoTypedStructs, Test

@testset "AutoTypedStructs" begin
    @autotyped struct Foo1
        x
        y
    end
    f1 = Foo1(42, "hello")
    @test [typeof(f1).parameters...] == [Int64, String]

    @autotyped struct Foo2
        x::Int64
        y
        z
    end
    f2 = Foo2(42, 43.0, "hello")
    @test [typeof(f2).parameters...] == [Float64, String]

    @autotyped struct Foo3
        x
        y::Int64
        z
    end
    f3 = Foo3(43.0, 42, "hello")
    @test [typeof(f3).parameters...] == [Float64, String]

    @autotyped struct Foo4
        x
        y
        z::Int64
    end
    f4 = Foo4(43.0, "hello", 42)
    @test [typeof(f4).parameters...] == [Float64, String]

    @autotyped struct Foo5{T1}
        x::T1
        y
    end
    f5 = Foo5(42, "hello")
    @test [typeof(f5).parameters...] == [Int64, String]

    @autotyped struct Foo6{T}
        x::T
        y
    end
    f6 = Foo6(42, "hello")
    @test [typeof(f6).parameters...] == [Int64, String]

    @autotyped struct Foo7{T <: Number}
        x::T
        y
    end
    f7 = Foo7(42, "hello")
    @test [typeof(f7).parameters...] == [Int64, String]

    @autotyped struct Foo8{T <: Number}
        x::Int64
        y::T
        z
    end
    f8 = Foo8(42, 43.0, "hello")
    @test [typeof(f8).parameters...] == [Float64, String]

    @autotyped struct Foo9{T <: Number}
        x::T
        y::Int64
        z
    end
    f9 = Foo9(43.0, 42, "hello")
    @test [typeof(f9).parameters...] == [Float64, String]

    @autotyped struct Foo10{T <: Number}
        x::T
        y
        z::Int64
    end
    f10 = Foo10(43.0, "hello", 42)
    @test [typeof(f10).parameters...] == [Float64, String]
end
