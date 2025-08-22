@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Entry Item Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_GateEnrtyItm_Det
  as select from zinward_gate_itm
{
  key gate_entry_id  as GateEntryId,
      ponumber       as Ponumber,
      itemno         as Itemno,
      material       as Material,
      materialdesc   as Materialdesc,
      quantity       as Quantity,
      postedquantity as Postedquantity
}
