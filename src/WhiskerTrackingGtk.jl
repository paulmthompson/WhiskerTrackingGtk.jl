
module WhiskerTrackingGtk

#Standard Library
#using Statistics,Random,Distributed,SharedArrays,DelimitedFiles,LinearAlgebra, Libdl, Dates

#Deep Learning Libraries
#using CuArrays, CuArrays.CUFFT, CUDAnative, Knet
#using CUDA, Knet

#using Images, ImageFiltering, MAT, JLD2, Interpolations, DSP,
#FFTW, IterTools, FFMPEG, StackedHourglass, Polynomials, StatsBase


using WhiskerTracking
using Gtk.ShortNames, Cairo, FFMPEG, StackedHourglass
import WhiskerTracking: Whisker1, Tracker, Tracked_Whisker, classifier, NeuralNetwork, Manual_Class

include("gui/types.jl")
include("gui/save_load.jl")
include("gui/gui.jl")
include("gui/manual.jl")
include("gui/analog.jl")
include("gui/whisker_pad.jl")
include("gui/discrete.jl")
include("gui/mask.jl")
include("gui/pole.jl")
include("gui/view.jl")
include("gui/tracing.jl")
include("gui/image.jl")
include("gui/janelia.jl")
include("gui/export.jl")
include("gui/contact.jl")
include("gui/deeplearning.jl")
include("gui/zoom.jl")
include("gui/whisker_table.jl")

include("drawing_tools/draw.jl")
include("drawing_tools/erase.jl")
include("drawing_tools/shapes.jl")

#include("precompile.jl")
#_precompile()

end
