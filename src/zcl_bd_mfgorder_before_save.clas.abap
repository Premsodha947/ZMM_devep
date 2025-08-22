CLASS zcl_bd_mfgorder_before_save DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_mfgorder_check_before_save .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BD_MFGORDER_BEFORE_SAVE IMPLEMENTATION.


  METHOD if_mfgorder_check_before_save~check_before_save.

    TYPES: BEGIN OF ty_bomcomponent,
             material                   TYPE c LENGTH 40,
             billofmaterialitemnumber_2 TYPE c LENGTH 4,
             plant                      TYPE c LENGTH 4,
             storagelocation            TYPE c LENGTH 4,
             baseunit                   TYPE c LENGTH 3,
             requiredquantity           TYPE p LENGTH 13 DECIMALS 3,
           END OF ty_bomcomponent.

    DATA: lv_user                   TYPE syuname,
          lt_mfgordercomponents     TYPE STANDARD TABLE OF ty_bomcomponent,
          lt_mfgordercomponents_old TYPE STANDARD TABLE OF ty_bomcomponent.


    lv_user = cl_abap_context_info=>get_user_technical_name(  ).

    SELECT SINGLE authflag
     FROM zpp_user_auth
     WHERE userid = @lv_user
     INTO @DATA(lv_usr_flag).

    IF lv_usr_flag <> 'X'.

*-- CHANGE OPERATION
      IF manufacturingorder-manufacturingordercategory = '10'.
        IF mfgordercomponents_old IS NOT INITIAL AND
              manufacturingorder-manufacturingorder = '%00000000001'.


          lt_mfgordercomponents = VALUE #( FOR ls_mfgordercomponents IN mfgordercomponents
                                                ( material = ls_mfgordercomponents-material
                                                billofmaterialitemnumber_2 = ls_mfgordercomponents-billofmaterialitemnumber_2
                                                plant = ls_mfgordercomponents-plant
*                                              storagelocation = ls_mfgordercomponents-storagelocation
                                                baseunit = ls_mfgordercomponents-baseunit
                                                requiredquantity = ls_mfgordercomponents-requiredquantity ) ).

          lt_mfgordercomponents_old = VALUE #( FOR ls_mfgordercomponents IN mfgordercomponents_old
                                                ( material = ls_mfgordercomponents-material
                                                billofmaterialitemnumber_2 = ls_mfgordercomponents-billofmaterialitemnumber_2
                                                plant = ls_mfgordercomponents-plant
*                                              storagelocation = ls_mfgordercomponents-storagelocation
                                                baseunit = ls_mfgordercomponents-baseunit
                                                requiredquantity = ls_mfgordercomponents-requiredquantity ) ).

          IF lt_mfgordercomponents <> lt_mfgordercomponents_old.
            INSERT VALUE #(
                                 messagetype = 'E'
                                 messagetext = 'You cannot change component. Revert the changes and try again'
                               ) INTO TABLE messages.
            RETURN.
          ENDIF.

        ELSE.

*-- CREATE OPERATION
          SELECT SINGLE billofmaterialvariant
             FROM i_productionversion WITH PRIVILEGED ACCESS
             WHERE material = @manufacturingorder-product
             AND plant = @manufacturingorder-productionplant
             AND productionversion = @manufacturingorder-productionversion
             INTO @DATA(lv_bom_variant).

          IF sy-subrc = 0.

            SELECT material,
                   plant,
                   billofmaterialcomponent,
                   billofmaterialitemnumber,
                   billofmaterialitemquantity,
                   prodorderissuelocation
            FROM i_billofmaterialitemtp_2 WITH PRIVILEGED ACCESS
            WHERE billofmaterialvariant = @lv_bom_variant
            AND material = @manufacturingorder-product
            AND plant = @manufacturingorder-productionplant
            INTO TABLE @DATA(lt_bomcomponent).

            IF sy-subrc = 0.

*--check if component is added
              DATA(lv_comp_cnt1) = lines( lt_bomcomponent ).
              DATA(lv_comp_cnt2) = lines( mfgordercomponents ).
              IF lv_comp_cnt1 <> lv_comp_cnt2.
                INSERT VALUE #(
                                     messagetype = 'E'
                                     messagetext = 'Additional components are added. You cannot change component'
                                   ) INTO TABLE messages.
                RETURN.
              ENDIF.
**-- end of check

              SELECT SINGLE bomheaderquantityinbaseunit
               FROM i_billofmaterialtp_2 WITH PRIVILEGED ACCESS
               WHERE billofmaterialvariant = @lv_bom_variant
               AND material = @manufacturingorder-product
               AND plant = @manufacturingorder-productionplant
               INTO @DATA(lv_baseunit).

              IF sy-subrc = 0.

              ENDIF.

*-- check if plant,componet,item,storage location, quantity is changed
              LOOP AT mfgordercomponents ASSIGNING FIELD-SYMBOL(<fs_mfgordercomponents>).
                READ TABLE lt_bomcomponent INTO DATA(ls_bomcomponent)
                                       WITH KEY billofmaterialcomponent = <fs_mfgordercomponents>-material
                                                billofmaterialitemnumber = <fs_mfgordercomponents>-billofmaterialitemnumber_2.
                IF sy-subrc = 0.

                  DATA: lv_comp_qty TYPE p LENGTH 7  DECIMALS 3,
                        lv_req_qty  TYPE p LENGTH 7 DECIMALS 3.

                  CASE <fs_mfgordercomponents>-goodsmovementtype.
                    WHEN '531'.
                      lv_comp_qty = ( ls_bomcomponent-billofmaterialitemquantity / lv_baseunit ) * manufacturingorder-mfgorderplannedtotalqty * -1.
                      lv_comp_qty = round( val = lv_comp_qty dec = 2 ).
                    WHEN OTHERS.
                      lv_comp_qty = ( ls_bomcomponent-billofmaterialitemquantity / lv_baseunit ) * manufacturingorder-mfgorderplannedtotalqty.
                      lv_comp_qty = round( val = lv_comp_qty dec = 2 ).
                  ENDCASE.

                  lv_req_qty = <fs_mfgordercomponents>-requiredquantity.
                  lv_req_qty = round( val = lv_req_qty dec = 2 ).

                  DATA(lv_flag) = COND abap_boolean( WHEN ls_bomcomponent-plant <> <fs_mfgordercomponents>-plant THEN 'X'
*                                                   WHEN ls_bomcomponent-prodorderissuelocation <> <fs_mfgordercomponents>-storagelocation THEN 'X'
*                                                   WHEN lv_comp_qty <> <fs_mfgordercomponents>-requiredquantity THEN 'X'  ).
                                                     WHEN lv_comp_qty <> lv_req_qty THEN 'X'  ).

                  IF lv_flag = 'X'.
                    INSERT VALUE #(
                                         messagetype = 'E'
                                         messagetext = 'You cannot change component. Revert the changes and try again'
                                       ) INTO TABLE messages.
                    RETURN.
                  ENDIF.

                ELSE.
                  INSERT VALUE #(
                                       messagetype = 'E'
                                       messagetext = 'You cannot change component. Revert the changes and try again'
                                     ) INTO TABLE messages.
                  RETURN.

                ENDIF.
              ENDLOOP.
*-- End of check
            ENDIF.
          ENDIF.

        ENDIF.
      ENDIF.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
