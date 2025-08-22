@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inward Gate Entry with Delete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_INWARD_WITHDEL
  as select from zinward_gate_hdr as hdr
    inner join   zinward_gate_itm as item on hdr.gate_entry_id = item.gate_entry_id
{

  key hdr.gate_entry_id,
  key item.itemno,

      // Header fields
      hdr.invoice_no,
      hdr.plant,
      hdr.inwardtype,
      hdr.status,
      hdr.ponumber,
      hdr.vendor,
      hdr.vehicleno,
      hdr.transporter,

      // Item fields
      item.material,
      item.materialdesc,
      item.quantity,
      item.postedquantity,

      // Combined fields
      hdr.ponumber  as header_ponumber,
      item.ponumber as item_ponumber
}
where
  hdr.status <> '05'
