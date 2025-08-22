@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Entry Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_GateEnrtyHdr_Det
  as select from zinward_gate_hdr
{
  key gate_entry_id as GateEntryId,
      invoice_no    as InvoiceNo,
      plant         as Plant,
      inwardtype    as Inwardtype,
      fiscalyear    as Fiscalyear,
      system_date   as SystemDate,
      system_time   as SystemTime,
      invoice_date  as InvoiceDate,
      lrdate        as Lrdate,
      lrnumber      as Lrnumber,
      ponumber      as Ponumber,
      ewayno        as Ewayno,
      amount        as Amount,
      vehicleno     as Vehicleno,
      transporter   as Transporter,
      zchalan       as Zchalan,
      vendor        as Vendor,
      qrcode        as Qrcode,
      status        as Status
}
where
  status = '01'
