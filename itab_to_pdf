    CALL FUNCTION 'GET_PRINT_PARAMETERS'
      EXPORTING
        in_archive_parameters  = w_arcpar
        in_parameters          = w_pripar
        layout                 = 'X_65_132'
        line_count             = 65
        line_size              = 132
        no_dialog              = 'X'
      IMPORTING
        out_archive_parameters = w_arcpar
        out_parameters         = w_pripar
        valid                  = g_val.
    IF g_val NE space AND sy-subrc = 0.
      w_pripar-prrel = space.
      w_pripar-primm = space.
      NEW-PAGE PRINT ON NEW-SECTION PARAMETERS w_pripar ARCHIVE PARAMETERS w_arcpar NO DIALOG. 
    ENDIF.
    TRY.
        cl_salv_table=>factory(
        EXPORTING
        list_display = if_salv_c_bool_sap=>false
        IMPORTING
        r_salv_table = DATA(it_final_display)
        CHANGING
        t_table = itab "itab to convert into pdf
        ).
      CATCH cx_salv_msg.
    ENDTRY.

    it_final_display->display( ).

    NEW-PAGE PRINT OFF.
    CALL FUNCTION 'ABAP4_COMMIT_WORK'.
    spoolid = sy-spono.
    CALL FUNCTION 'CONVERT_ABAPSPOOLJOB_2_PDF'
      EXPORTING
        src_spoolid   = spoolid
        no_dialog     = ' '
      IMPORTING
        pdf_bytecount = l_no_of_bytes
        pdf_spoolid   = l_pdf_spoolid
        btc_jobname   = l_jobname
        btc_jobcount  = l_jobcount
      TABLES
        pdf           = i_pdf.

    CLEAR: filestr, path, fullpath.
    CALL METHOD cl_gui_frontend_services=>file_save_dialog
      EXPORTING
*       window_title              =
        default_extension         = 'pdf'
        default_file_name         = 'default_name'
      CHANGING
        filename                  = filestr
        path                      = path
        fullpath                  = fullpath
      EXCEPTIONS
        cntl_error                = 1
        error_no_gui              = 2
        not_supported_by_gui      = 3
        invalid_default_file_name = 4
        OTHERS                    = 5.
    IF sy-subrc <> 0.
*     Implement suitable error handling here
    ENDIF.

    CALL METHOD cl_gui_frontend_services=>gui_download
      EXPORTING
        filename                = fullpath
        filetype                = 'BIN'
      CHANGING
        data_tab                = i_pdf
      EXCEPTIONS
        file_write_error        = 1
        no_batch                = 2
        gui_refuse_filetransfer = 3
        invalid_type            = 4
        no_authority            = 5
        unknown_error           = 6
        header_not_allowed      = 7
        separator_not_allowed   = 8
        filesize_not_allowed    = 9
        header_too_long         = 10
        dp_error_create         = 11
        dp_error_send           = 12
        dp_error_write          = 13
        unknown_dp_error        = 14
        access_denied           = 15
        dp_out_of_memory        = 16
        disk_full               = 17
        dp_timeout              = 18
        file_not_found          = 19
        dataprovider_exception  = 20
        control_flush_error     = 21
        not_supported_by_gui    = 22
        error_no_gui            = 23
        OTHERS                  = 24.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.
