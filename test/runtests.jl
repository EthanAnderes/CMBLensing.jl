using Test

@testset "CMBLensing" begin

##

@testset "Algebra" begin
    
    for f in [FlatMap(rand(4,4)), FlatQUMap(rand(4,4), rand(4,4))]
        
        @testset "f::$(typeof(f))" begin
            
            @test ((@inferred f + f); true)
            @test ((@inferred ∇₀ * f); true)
            
        end
        
    end
    
end

##

@testset "FieldTuple basis conversions" begin 

    f = FlatMap(rand(4,4))
    f_basistuple = FieldTuple(A=f, B=f)

    @test basis(@inferred    Fourier(f_basistuple)) <: BasisTuple{Tuple{Fourier,Fourier}}
    @test basis(@inferred        Map(f_basistuple)) <: BasisTuple{Tuple{Map,Map}}
    @test basis(@inferred DerivBasis(f_basistuple)) <: BasisTuple{Tuple{Fourier,Fourier}}

    @test_broken BasisTuple{Tuple{Fourier,Fourier}}(f_basistuple)

    f_concretebasis = FlatQUMap(rand(4,4), rand(4,4))

    @test basis(@inferred    Fourier(f_concretebasis)) <: BasisTuple{Tuple{Fourier,Fourier}}
    @test basis(@inferred        Map(f_concretebasis)) <: BasisTuple{Tuple{Map,Map}}
    @test basis(@inferred DerivBasis(f_concretebasis)) <: QUFourier

end

##

using Zygote

@testset "Autodiff" begin

    f = FlatMap(rand(2,2))

    check_grad(f) = Zygote.gradient(x -> (y=(x .* f); y⋅y), 1)[1]

    @test (@inferred check_grad(f.Ix)) ≈ 2*norm(f,2)^2
    @test (@inferred check_grad(f)) ≈ 2*norm(f,2)^2
    
end

##


end
