@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Outward Gate Entry'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Z_I_OUTWARDGATE_HEADER
  as select from zout_gate_hdr
  composition [1..*] of Z_I_OUTWARD_ITEM as _item

{

  key gate_entry_id as GateEntryId,
      plant         as Plant,
      system_date   as SystemDate,
      system_time   as SystemTime,
      vehicletype   as Vehicletype,
      vehicleno     as Vehicleno,
      transporter   as Transporter,
      qrcode        as Qrcode,
      status        as Status,
      remarks       as Remarks,
      _item
}
