@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Outward Gate Entry with Delete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_OUTWARD_WITHDEL
  as select from zout_gate_hdr  as hdr
    inner join   zout_gate_item as item on hdr.gate_entry_id = item.gate_entry_id
{


  key hdr.gate_entry_id,
  key item.itemno,
  key item.billingno,
      hdr.plant,
      hdr.vehicletype,
      hdr.vehicleno,
      hdr.transporter,
      hdr.qrcode,
      hdr.status,
      hdr.remarks,
      item.odnnumber,
      item.ewaybill,
      item.lrnumber

}
where
  hdr.status <> '05'
