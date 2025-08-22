@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Outward Gate Entry'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_OUTWARDGATE_HEADER1
  provider contract transactional_query
  as projection on Z_I_OUTWARDGATE_HEADER
{
  key GateEntryId,
      Plant,
      SystemDate,
      SystemTime,
      Vehicletype,
      Vehicleno,
      Transporter,
      Qrcode,
      Status,
      Remarks,
      /* Associations */
      _item : redirected to composition child ZC_OUTWARDGATE_ITEM
}

where
  Status <> '05'
