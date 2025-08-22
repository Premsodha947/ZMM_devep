CLASS lhc_outwardgateheader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR outwardgateheader RESULT result.

    METHODS calculatenonkeyfields FOR DETERMINE ON MODIFY
      IMPORTING keys FOR outwardgateheader~calculatenonkeyfields.

ENDCLASS.

CLASS lhc_outwardgateheader IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD calculatenonkeyfields.

    DATA: lt_reported TYPE RESPONSE FOR REPORTED z_i_outwardgate_header,
          lt_failed   TYPE RESPONSE FOR FAILED z_i_outwardgate_header.

    READ ENTITIES OF z_i_outwardgate_header IN LOCAL MODE
       ENTITY outwardgateheader
         FIELDS ( gateentryid ) WITH CORRESPONDING #( keys )
         RESULT DATA(lt_entities).

    " Update non-key fields
    MODIFY ENTITIES OF z_i_outwardgate_header IN LOCAL MODE
      ENTITY outwardgateheader
        UPDATE FIELDS ( qrcode )
        WITH VALUE #( FOR ls_entity IN lt_entities
                      ( %key = ls_entity-%key
                        qrcode = 'OT' && ls_entity-gateentryid
                        ) )
      REPORTED lt_reported
      FAILED lt_failed.


  ENDMETHOD.

ENDCLASS.

CLASS lsc_z_i_outwardgate_header DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_z_i_outwardgate_header IMPLEMENTATION.

  METHOD adjust_numbers.
    DATA: nr_number  TYPE cl_numberrange_runtime=>nr_number,
          l_nr_range TYPE cl_numberrange_runtime=>nr_interval.

    LOOP AT mapped-outwardgateheader ASSIGNING FIELD-SYMBOL(<fs_mapped>).
      IF <fs_mapped>-gateentryid IS INITIAL.

        READ ENTITIES OF z_i_outwardgate_header IN LOCAL MODE
        ENTITY outwardgateheader
        ALL FIELDS
        WITH CORRESPONDING #( mapped-outwardgateheader )
        RESULT DATA(lt_outwardgateheader).

        READ TABLE lt_outwardgateheader INTO DATA(ls_outwardgateheader) INDEX 1.
        IF ls_outwardgateheader-plant = '1100'.
          l_nr_range = '01'.
        ELSE.
          IF  ls_outwardgateheader-plant = '1200'.
            l_nr_range = '02'.
          ELSE.
            IF  ls_outwardgateheader-plant = '1300'.
              l_nr_range = '03'.
            ELSE.
              IF  ls_outwardgateheader-plant = '1400'.
                l_nr_range = '04'.
              ELSE.
                IF  ls_outwardgateheader-plant = '2100'.
                  l_nr_range = '05'.
                ELSE.
                  IF  ls_outwardgateheader-plant = '2200'.
                    l_nr_range = '06'.

                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

        TRY.
            cl_numberrange_runtime=>number_get(
              EXPORTING
                nr_range_nr = l_nr_range
                object      = 'ZMM_OGE_NR'
              IMPORTING
                number      = nr_number
            ).

            <fs_mapped>-gateentryid  = nr_number.
*             <fs_mapped>-GateEntryId = 'Grentry002'.
            IF <fs_mapped>-gateentryid IS INITIAL.
              APPEND VALUE #( %key = <fs_mapped>-%key
                              %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                            text = 'Cannot assign unique GateEntryId' ) )
                     TO reported-outwardgateheader.
            ENDIF.

*            <fs_mapped>-QRCode = 'IN' + <fs_mapped>-GateEntryId.

          CATCH cx_number_ranges INTO DATA(lx_nr).
            APPEND VALUE #( %key = <fs_mapped>-%key
                            %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text = lx_nr->get_text( ) ) )
                   TO reported-outwardgateheader.
        ENDTRY.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
