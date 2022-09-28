

function add_pad_callbacks(b::Gtk.GtkBuilder,handles::Tracker_Handles)

    signal_connect(pad_gen_cb,b["pad_check_button"],"clicked",Nothing,(),false,(handles,))
    nothing
end

view_pad(b::Gtk.GtkBuilder)=get_gtk_property(b["pad_check_button"],:active,Bool)

function pad_gen_cb(w::Ptr, user_data::Tuple{Tracker_Handles})

    han, = user_data

    if get_gtk_property(han.b["pad_check_button"],:active,Bool)
        han.selection_mode = 10
    else
        han.selection_mode = 1
    end

    redraw_all(han)

    nothing
end
