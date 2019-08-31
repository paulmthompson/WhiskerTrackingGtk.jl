__precompile__()
module WhiskerTracking

using Gtk.ShortNames, Cairo, Images, StatsBase, ImageFiltering, MAT, JLD, Interpolations, Distances, DSP, Polynomials,
Pandas, HDF5, PyPlot, PyCall

if VERSION > v"0.7-"
    using SharedArrays, Libdl
    const Void = Nothing
    const setproperty! = set_gtk_property!
    const getproperty = get_gtk_property
    const unshift! = pushfirst!
    const is_windows() = Sys.iswindows()
    const is_unix() = Sys.isunix()
end

const dlc_module = PyNULL()
const dlc_py = PyNULL()

function __init__()
    copy!(dlc_module, pyimport("deeplabcut"))

    unshift!(PyVector(pyimport("sys")["path"]), "/home/wanglab/Programs/WhiskerTracking.jl/src")

    copy!(dlc_py,pyimport("dlc_python"))
end

include("config.jl")
include("types.jl")
include("gui.jl")
include("janelia_tracker.jl")
include("processing.jl")
include("image_processing.jl")
include("analysis.jl")
include("save_load.jl")
include("dlc.jl")
include("plotting.jl")
include("discrete.jl")
include("analysis/forces.jl")
include("analysis/touch.jl")
include("analysis/math.jl")

end
