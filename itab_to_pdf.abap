SELECT * FROM t100 INTO TABLE @DATA(t_table) UP TO 100 ROWS.

"check if all these variables are really necessary
DATA:g_val         TYPE c,
     w_pripar      TYPE pri_params,
     w_arcpar      TYPE arc_params,
     i_pdf         TYPE TABLE OF tline,
     spoolid       TYPE tsp01-rqident,
     l_no_of_bytes TYPE i,
     l_pdf_spoolid TYPE tsp01-rqident,
     l_jobname     TYPE tbtcjob-jobname,
     l_jobcount    TYPE tbtcjob-jobcount,
     w_print       TYPE slis_print_alv,
     g_program     TYPE sy-repid VALUE sy-repid,
     gr_print      TYPE REF TO cl_salv_print.

TRY.
    cl_salv_table=>factory(
    EXPORTING
    list_display = if_salv_c_bool_sap=>false
    IMPORTING
    r_salv_table = DATA(it_final_display)
    CHANGING
    t_table = t_table "itab you want to print
    ).
  CATCH cx_salv_msg.
ENDTRY.

gr_print = it_final_display->get_print( ).
gr_print->set_print_only( 'N' ).
it_final_display->display( ).

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

CALL FUNCTION 'GUI_DOWNLOAD'
  EXPORTING
    filename = 'C:\Users\*yourusername*\Desktop\prova.pdf' "Give the pdf location of your system where you want to store
    filetype = 'BIN'
  TABLES
    data_tab = i_pdf.
