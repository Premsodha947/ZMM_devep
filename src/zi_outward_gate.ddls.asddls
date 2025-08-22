@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Outward Gate Entry'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_OUTWARD_GATE
  as select from ztmm_gate_out
{
  key gateoutwardnumber as Gateoutwardnumber,
  key document_num      as DocumentNum,
  key material_num      as MaterialNum,
      material_desc     as MaterialDesc,
      plant             as Plant,
      unit_field        as UnitField,
      @Semantics.quantity.unitOfMeasure: 'UnitField'
      quantity          as Quantity,
      ewaybill_num      as EwaybillNum
}
