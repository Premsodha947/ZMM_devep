@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Outward Gate Entry'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_OUTWARDGATE_ITEM
  as projection on Z_I_OUTWARD_ITEM
{
  key GateEntryId,
      Itemno,
      Billingno,
      Odnnumber,
      Ewaybill,
      Lrnumber,
      /* Associations */
      _Header : redirected to parent ZC_OUTWARDGATE_HEADER1
}
