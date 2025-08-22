@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Document Details for Outward Gate Entry App'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_BillingDoc_Outgate
  as select from    I_BillingDocument         as billdoc
    inner join      I_BillingDocumentItem     as item on billdoc.BillingDocument = item.BillingDocument
    left outer join I_IN_ElectronicDocInvoice as edoc on billdoc.BillingDocument = edoc.ElectronicDocSourceKey
  //    left outer join zout_gate_item            as cust on billdoc.BillingDocument = cust.billingno
    left outer join ZI_OUTWARD_WITHDEL        as cust on billdoc.BillingDocument = cust.billingno
{
  key billdoc.BillingDocument     as BillingDocument,
      billdoc.DocumentReferenceID as ODNNumber,
      item.Plant                  as Plant,
      // Fields from I_IN_ElectronicDocInvoice
      edoc.IN_EDocEInvcEWbillNmbr,
      edoc.IN_EDocEInvcVehicleNumber,
      edoc.IN_ElectronicDocInvcRefNmbr,
      edoc.IN_EDocEInvcTransptDocNmbr,
      billdoc.BillingDocumentType as DocumentType,
      billdoc.BillingDocumentDate as DocumentDate
}
where
  cust.billingno is null;
