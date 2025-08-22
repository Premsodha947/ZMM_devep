@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material based on PO & Sch. Agreement'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    dataClass: #MIXED
}
define view entity ZC_MaterialItem_Det
  as select from    I_PurchaseOrderItemAPI01 as a

    left outer join ZI_INWARD_WITHDEL        as b         on  a.PurchaseOrder     = b.ponumber
                                                          and a.PurchaseOrderItem = b.itemno

    left outer join I_PurchaseOrderAPI01     as po_header on a.PurchaseOrder = po_header.PurchaseOrder

  // Add join to the status table
    left outer join I_PurchaseOrderStatus    as po_status on a.PurchaseOrder = po_status.PurchaseOrder

{
  key a.PurchaseOrder,
  key a.PurchaseOrderItem,
      a.Material,
      a.PurchaseOrderItemText,
      a.Plant,
      a.BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      a.OrderQuantity,
      a.DocumentCurrency,
      a.TaxCode,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      a.NetAmount,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      a.EffectiveAmount           as EffectiveAmt,
      // Add calculated field for adjusted price
      case
          when a.TaxCode = 'G3' or a.TaxCode = 'G4' or
          a.TaxCode = 'GG' or a.TaxCode = 'GK' or
          a.TaxCode = 'GP' or a.TaxCode = 'K1' or
          a.TaxCode = 'R3' or a.TaxCode = 'R7' or
          a.TaxCode = 'RC' or a.TaxCode = 'RG' or
          a.TaxCode = 'TU' or a.TaxCode = 'TC' or
          a.TaxCode = 'HT' or a.TaxCode = 'TI' or
          a.TaxCode = 'LT' or a.TaxCode = 'TM' or a.TaxCode = 'TQ'
            then cast( round(cast(a.NetAmount as abap.dec(11,2)) * cast( '1.18' as abap.dec(3,2)), 4) as abap.dec( 30, 4 ) )

          when a.TaxCode = 'G9' or a.TaxCode = 'GC' or
          a.TaxCode = 'GF' or a.TaxCode = 'GJ' or
          a.TaxCode = 'GO' or a.TaxCode = 'R2' or
          a.TaxCode = 'R6' or a.TaxCode = 'RB' or
          a.TaxCode = 'RF' or a.TaxCode = 'TT' or
          a.TaxCode = 'TB' or a.TaxCode = 'FT' or
          a.TaxCode = 'TF' or a.TaxCode = 'KT' or
          a.TaxCode = 'TL' or a.TaxCode = 'TP'
            then cast( round(cast(a.NetAmount as abap.dec(11,2)) * cast( '1.12' as abap.dec(3,2)), 4) as abap.dec( 30, 4 ) )

          when a.TaxCode = 'GA'or a.TaxCode = 'GD' or
          a.TaxCode = 'GH' or a.TaxCode = 'GL' or
          a.TaxCode = 'GQ' or a.TaxCode = 'K5' or
          a.TaxCode = 'R4' or a.TaxCode = 'R8' or
          a.TaxCode = 'RD' or a.TaxCode = 'RH' or
          a.TaxCode = 'TV' or a.TaxCode = 'TD' or
          a.TaxCode = 'IT' or a.TaxCode = 'TJ'or
          a.TaxCode = 'MT' or a.TaxCode = 'TN'
            then cast( round(cast(a.NetAmount as abap.dec(11,2)) * cast( '1.28' as abap.dec(3,2)), 4) as abap.dec( 30, 4 ) )

          when a.TaxCode = 'G1' or a.TaxCode = 'GB' or
          a.TaxCode = 'GE' or a.TaxCode = 'GI' or
          a.TaxCode = 'GM' or a.TaxCode = 'R1' or
          a.TaxCode = 'R5' or a.TaxCode = 'RA' or
          a.TaxCode = 'RE' or a.TaxCode = 'TS' or
          a.TaxCode = 'TA' or a.TaxCode = 'ET' or
          a.TaxCode = 'TE' or a.TaxCode = 'TK' or
          a.TaxCode = 'TO' or a.TaxCode = 'JT'
            then cast( round(cast(a.NetAmount as abap.dec(11,2)) * cast( '1.05' as abap.dec(3,2)), 4) as abap.dec( 30, 4 ) )

          when a.TaxCode = 'GX'
            then cast( round(cast(a.NetAmount as abap.dec(11,2)) * cast( '1.015' as abap.dec(4,3)), 4) as abap.dec( 30, 4 ) )

          when a.TaxCode = 'GV' or a.TaxCode = 'GW'
            then cast( round(cast(a.NetAmount as abap.dec(11,2)) * cast( '1.29' as abap.dec(3,2)), 4) as abap.dec( 30, 4 ) )

          when a.TaxCode = 'GS' or a.TaxCode = 'GW'
            then cast( round(cast(a.NetAmount as abap.dec(11,2)) * cast( '1.19' as abap.dec(3,2)), 4) as abap.dec( 30, 4 ) )

          when a.TaxCode = 'GU' or a.TaxCode = 'NT' or
               a.TaxCode = 'QT' or a.TaxCode = 'TX'
            then cast( round(cast(a.NetAmount as abap.dec(11,2)) * cast( '1.018' as abap.dec(4,3)), 4) as abap.dec( 30, 4 ) )

          when a.TaxCode = 'GV' or a.TaxCode = 'AT' or a.TaxCode = 'OT'
            then cast( round(cast(a.NetAmount as abap.dec(11,2)) * cast( '1.009' as abap.dec(4,3)), 4) as abap.dec( 30, 4 ) )

          when a.TaxCode = 'PT'
            then cast( round(cast(a.NetAmount as abap.dec(11,2)) * cast( '1.01' as abap.dec(3,2)), 4) as abap.dec( 30, 4 ) )

      // Add more tax codes as needed
          else cast(a.NetAmount as abap.dec(30,4))
      end                         as EffectiveAmount,

      a.AccountAssignmentCategory as AccountAssignmentCategory,

      b.ponumber                  as Ponumber1,
      b.itemno                    as Itemno1,
      b.material                  as Material1,
      b.materialdesc              as Materialdesc1,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      b.quantity                  as Quantity1,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      b.postedquantity,
      b.status,
      b.gate_entry_id,

      case
          when b.postedquantity is not null then cast(b.postedquantity as abap.dec(13,2))
          else cast(a.OrderQuantity as abap.dec(13,2))
      end                         as final_qty,

      // New supplier fields from I_PurchaseOrderAPI01
      po_header.Supplier          as Supplier
}
where
       a.AccountAssignmentCategory        <> 'K'
  and(
       po_status.PurchasingDocumentStatus <> '02'
    or po_status.PurchasingDocumentStatus is null
  )
