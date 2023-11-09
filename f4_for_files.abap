PARAMETERS: file    TYPE string OBLIGATORY.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR file.
  PERFORM f4_for_files USING file.

*&---------------------------------------------------------------------*
*&      Form  F4_FOR_FILES
*&---------------------------------------------------------------------*
FORM f4_for_files USING l_filepc.

  DATA: ld_default_extension TYPE string VALUE ' '.
  DATA: lt_file_tab          TYPE filetable.
  DATA: ls_file_line         TYPE file_table.
  DATA: ld_rc                TYPE i.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      default_extension       = ld_default_extension
      multiselection          = abap_false
    CHANGING
      file_table              = lt_file_tab
      rc                      = ld_rc
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    CHECK ld_rc = 1.
    READ TABLE lt_file_tab INTO ls_file_line INDEX 1.
    CHECK sy-subrc = 0.
    MOVE ls_file_line-filename TO l_filepc.
  ENDIF.

ENDFORM.                    " F4_FOR_FILES

START-OF-SELECTION.