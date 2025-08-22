CLASS zcl_badi_mmim_check_matdocitem DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_badi_mmim_check_matdoc_item .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_BADI_MMIM_CHECK_MATDOCITEM IMPLEMENTATION.


  METHOD if_badi_mmim_check_matdoc_item~check_item.

* -- This BADI should trigger only for Goods Movement against mfg order

    IF item_matdoc-goodsmovementtype = '101' OR item_matdoc-goodsmovementtype = '261'
        OR item_matdoc-goodsmovementtype = '531'.

      IF item_matdoc-manufacturingorder IS NOT INITIAL.

***-- Get production version and other data
        SELECT SINGLE manufacturingorder,
                      manufacturingordercategory,
                      material,
                      productionplant,
                      storagelocation,
                      productionversion
               FROM i_manufacturingorder WITH PRIVILEGED ACCESS
               WHERE manufacturingorder = @item_matdoc-manufacturingorder
               INTO @DATA(ls_mfgorder_data).

*
        IF sy-subrc = 0 AND ls_mfgorder_data-manufacturingordercategory = '10'.

*-- Check fields based on reservation number

          SELECT SINGLE plant,
                        storagelocation,
                        product,
                        goodsmovementtype
          FROM i_reservationdocumentitem WITH PRIVILEGED ACCESS
          WHERE reservation = @item_matdoc-reservation
          AND reservationitem = @item_matdoc-reservationitem
          INTO @DATA(ls_goodsmv_db).
*
          IF sy-subrc = 0.
            DATA(lv_flag) = COND abap_boolean( WHEN ls_goodsmv_db-plant <> item_matdoc-plant THEN 'X'
                                               WHEN ls_goodsmv_db-storagelocation <> item_matdoc-storagelocation THEN 'X'
                                               WHEN ls_goodsmv_db-product <> item_matdoc-material THEN 'X'
                                               WHEN ls_goodsmv_db-goodsmovementtype <> item_matdoc-goodsmovementtype THEN 'X' ).
*
            IF lv_flag = 'X'.
              INSERT VALUE #(
                                   messagetype = 'E'
                                   messagetext = 'You cannot change goods movements data. Revert the changes and try again'
                                 ) INTO TABLE messages.
              RETURN.
            ENDIF.

          ELSE.

            lv_flag = COND abap_boolean( WHEN ls_mfgorder_data-storagelocation <> item_matdoc-storagelocation THEN 'X'
                                               WHEN ls_mfgorder_data-material <> item_matdoc-material THEN 'X'
                                               WHEN item_matdoc-goodsmovementtype <> '101' THEN 'X' ).

            IF lv_flag = 'X'.
              INSERT VALUE #(
                                   messagetype = 'E'
                                   messagetext = 'You cannot change goods movements data. Revert the changes and try again'
                                 ) INTO TABLE messages.
              RETURN.
            ENDIF.
          ENDIF.

*Validation on storage locations based on Goods Movement and Plants.( PP )
          IF item_matdoc-goodsmovementtype = '261'

              AND (  item_matdoc-plant = '1100' OR
              item_matdoc-plant = '1200' OR
               item_matdoc-plant = '1300' OR
                item_matdoc-plant = '1400' OR
                 item_matdoc-plant = '2100' OR
                  item_matdoc-plant = '2200' )
              AND (   item_matdoc-storagelocation = 'IN01' OR
              item_matdoc-storagelocation = 'IN02' OR
              item_matdoc-storagelocation = 'IN03' OR
               item_matdoc-storagelocation = 'IN04' OR
                item_matdoc-storagelocation = 'IN05' OR
                item_matdoc-storagelocation = 'IN06' OR
                item_matdoc-storagelocation = 'IN07' OR
                item_matdoc-storagelocation = 'IN08' OR
                item_matdoc-storagelocation = 'IN09' OR
                item_matdoc-storagelocation = 'IN10' OR
                item_matdoc-storagelocation = 'IN11' OR
                item_matdoc-storagelocation = 'IN12' OR
                item_matdoc-storagelocation = 'IN13' OR
                item_matdoc-storagelocation = 'IN14' OR
                item_matdoc-storagelocation = 'IN15'  ) .

            APPEND VALUE #( messagetype = 'E' messagetext = 'Please enter Storage Location for Shop Floor' ) TO messages.

          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.


**-- Get BOM variant
*        SELECT SINGLE billofmaterialvariant
*           FROM i_productionversion WITH PRIVILEGED ACCESS
*           WHERE material = @item_matdoc-material
*           AND plant = @item_matdoc-plant
*           AND productionversion = @ls_mfgorder_data-productionversion
*           INTO @DATA(lv_bom_variant).
*
*        IF sy-subrc = 0.
**
*** -- In this BOM check what are all components are available
*          SELECT material,
*                 plant,
*                 billofmaterialcomponent,
*                 billofmaterialitemnumber,
*                 billofmaterialitemquantity,
*                 prodorderissuelocation
*          FROM i_billofmaterialitemtp_2 WITH PRIVILEGED ACCESS
*          WHERE billofmaterialvariant = @lv_bom_variant
*          AND material = @item_matdoc-material
*          AND plant = @item_matdoc-plant
*          INTO TABLE @DATA(lt_bomcomponent).
**
*          IF sy-subrc = 0.
*
***-- Get base unit to calculate quantity
*            SELECT SINGLE bomheaderquantityinbaseunit
*             FROM i_billofmaterialtp_2 WITH PRIVILEGED ACCESS
*             WHERE billofmaterialvariant = @lv_bom_variant
*             AND material = @item_matdoc-material
*             AND plant = @item_matdoc-plant
*             INTO @DATA(lv_baseunit).
**
*            IF sy-subrc = 0.
**
*              READ TABLE lt_bomcomponent INTO DATA(ls_bomcomponent)
*                                     WITH KEY billofmaterialcomponent = item_matdoc-material.
*              IF sy-subrc = 0.
**
*                DATA lv_comp_qty TYPE p LENGTH 7  DECIMALS 3.
*                lv_comp_qty = ( ls_bomcomponent-billofmaterialitemquantity / lv_baseunit ) * item_matdoc-quantityinbaseunit.
*
*              ENDIF. "
**
*            ENDIF."
**
*          ENDIF."
*        ENDIF. "
*      ENDIF. "


** S/C MIGO, Child item qty field should NOT be editable
*      IF item_matdoc-storagelocation IS INITIAL.
*
*        SELECT SINGLE requiredquantity
*               FROM i_posubcontractingcompapi01 WITH PRIVILEGED ACCESS
*               WHERE ltrim( purchaseorder, '0' ) = ltrim( @item_matdoc-purchaseorder, '0' )
*               AND ltrim( purchaseorderitem, '0' ) = ltrim( @item_matdoc-purchaseorderitem, '0' )
*               AND ltrim( material, '0' ) = ltrim( @item_matdoc-material, '0' )
*               INTO @DATA(lv_qty).
*
**      IF item_matdoc-quantityinbaseunit <> lv_qty.
**        APPEND VALUE #( messagetype = 'E' messagetext = 'Child item qty is uneditable' ) TO messages.
**      ENDIF.
*
*      ENDIF.

  ENDMETHOD.
ENDCLASS.
