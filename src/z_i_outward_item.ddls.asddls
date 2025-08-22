@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Outward Gate Entry'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_I_OUTWARD_ITEM
  as select from zout_gate_item
  association to parent Z_I_OUTWARDGATE_HEADER as _Header on $projection.GateEntryId = _Header.GateEntryId
{
  key gate_entry_id as GateEntryId,
      itemno        as Itemno,
      billingno     as Billingno,
      odnnumber     as Odnnumber,
      ewaybill      as Ewaybill,
      lrnumber      as Lrnumber,
      _Header
}
