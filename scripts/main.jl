using Pkg
Pkg.activate("..")
Pkg.instantiate()

using HebbLSMRL

# include("../arg.jl")
# include("./rl-rc/data_pipeline.jl")

using DelimitedFiles
using StableRNGs

# seeds = [001993 109603 619089 071198 383163 213556 410290 908818 123123 456456]
seeds = [809669, 689741]

model_type, total_eps = get_main_arg(get_Args())

for (j, total_ep) in enumerate(total_eps)
	@info "Running each experiments for $total_ep episodes"

	frame = Matrix{Float64}(undef, total_ep, 0)

	for (i, seed) in enumerate(seeds)
		@info "Starting experiment $i"
		reward = run_exp(StableRNG(seed), model_type=model_type, total_eps=total_ep)
		@info "Completed $(i/length(seeds)*100)% of experiments of $total_ep episodes"
		frame = hcat(frame, reward)
	end

	# store col first
	io = open("./results/Q$model_type-e=$total_ep.txt", "a") do io
		writedlm(io, frame)
		@info "Logged runs!"
	end

	@info "Completed $(j/length(total_eps)*100)% of steps experiments"
end