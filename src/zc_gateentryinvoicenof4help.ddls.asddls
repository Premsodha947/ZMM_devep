@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GateEntryInvoiceNoF4Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_GateEntryInvoiceNoF4Help
  as select from    zinward_gate_hdr      as a
    left outer join I_PurchaseOrderAPI01  as b on a.ponumber = b.PurchaseOrder
    left outer join I_SchedgagrmthdrApi01 as c on a.ponumber = c.SchedulingAgreement
{
  key a.gate_entry_id as GateEntryId,
      a.invoice_no    as InvoiceNo,
      a.plant         as Plant,
      a.ponumber      as Ponumber,

      // Supplier resolution
      case
        when b.PurchaseOrder is not null then b.Supplier
        else c.Supplier
      end             as Vendor,

      a.status        as Status
}
where
  a.status <> '05'
