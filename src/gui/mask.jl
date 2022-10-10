
function add_mask_callbacks(b::Gtk.GtkBuilder,handles::Tracker_Handles)

    signal_connect(mask_min_cb,b["mask_min_button"],"value-changed",Nothing,(),false,(handles,))
    signal_connect(mask_max_cb,b["mask_max_button"],"value-changed",Nothing,(),false,(handles,))
    signal_connect(mask_gen_cb,b["mask_gen_button"],"clicked",Nothing,(),false,(handles,))

    nothing
end

function mask_gen_cb(w::Ptr, user_data::Tuple{Tracker_Handles})

    han, = user_data

    redraw_all(han)
    plot_mask(han)

    nothing
end

function mask_min_cb(w::Ptr, user_data::Tuple{Tracker_Handles})

    han, = user_data

    mymin=get_gtk_property(han.b["mask_min_button"],:value,Int)
    mymax=get_gtk_property(han.b["mask_max_button"],:value,Int)

    generate_mask(han.wt,han.current_frame2,mymin,mymax)

    redraw_all(han)
    plot_mask(han)

    nothing
end

function mask_max_cb(w::Ptr, user_data::Tuple{Tracker_Handles})

    han, = user_data

    mymin=get_gtk_property(han.b["mask_min_button"],:value,Int)
    mymax=get_gtk_property(han.b["mask_max_button"],:value,Int)

    redraw_all(han)
    generate_mask(han.wt,han.current_frame2,mymin,mymax)

    plot_mask(han)

    nothing
end

function upload_mask(wt,mask_file)

    #Load mask
    myimg = reinterpret(UInt8,load(string(wt.data_path,mask_file)))

    if size(myimg,3) == 1
        wt.mask = myimg.==0
    else
        wt.mask=myimg[1,:,:].==0
    end

    nothing
end

function generate_mask(wt,myimg,min_val,max_val)

    myimg[myimg.>max_val] .= 255
    myimg[myimg.<min_val] .= 0

    wt.mask=myimg.==0

    #Find connected Regions
    comp=label_components(wt.mask)

    if maximum(comp)>1
        total_counts=zeros(Int64,maximum(comp))
        for i=1:length(total_counts)
            total_counts[i]=length(find(comp.==i))
        end

        max_comp=indmax(total_counts)

        for i=1:length(wt.mask)
            if comp[i] != max_comp
                wt.mask[i] = false
            end
        end
    end

    nothing
end

function plot_mask(han::Tracker_Handles)

    img=han.wt.mask'.*255

    ctx=Gtk.getgc(han.c)

    w,h = size(img)

    for i=1:length(img)
        if (img[i]>0)
            han.plot_frame[i] = (convert(UInt32,img[i]) << 16)
        end
    end
    stride = Cairo.format_stride_for_width(Cairo.FORMAT_RGB24, w)
    @assert stride == 4*w
    surface_ptr = ccall((:cairo_image_surface_create_for_data,Cairo._jl_libcairo),
                Ptr{Nothing}, (Ptr{Nothing},Int32,Int32,Int32,Int32),
                han.plot_frame, Cairo.FORMAT_RGB24, w, h, stride)

    ccall((:cairo_set_source_surface,Cairo._jl_libcairo), Ptr{Nothing},
    (Ptr{Nothing},Ptr{Nothing},Float64,Float64), ctx.ptr, surface_ptr, 0, 0)

    rectangle(ctx, 0, 0, w, h)

    fill(ctx)

    reveal(han.c)
end

function draw_mask(han::Tracker_Handles)

    ctx=Gtk.getgc(han.c)

    set_source_rgb(ctx,1.0,0.0,0.0)

    move_to(ctx,han.mask[1][1],han.mask[1][2])
    for i=2:length(han.mask)
        line_to(ctx,han.mask[i][1],han.mask[i][2])
    end
    stroke(ctx)

    reveal(han.c)
end

function find_mask_intersection(mask,x::Array{T,1},y::Array{T,1}) where T

    found = false
    ind = 0

    for i=2:length(x)
        wx2 = x[i]
        wx1 = x[i-1]
        wy2 = y[i]
        wy1 = y[i-1]
        for j=2:length(mask)
            if WhiskerTracking.intersect(mask[j-1][1],mask[j][1], wx1,wx2,
                mask[j-1][2],mask[j][2],wy1,wy2)
                ind = i
                found = true 
                break
            end
        end
        if found
            break 
        end
    end
    return ind
end

function find_mask_intersection(mask,w::Whisker1)

    find_mask_intersection(mask,w.x,w.y)
end