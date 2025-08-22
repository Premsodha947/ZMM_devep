@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Scheduling Agreement'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_SchAgreement_F4Help
  as select from I_SchedgagrmthdrApi01
{
  key SchedulingAgreement,
      Supplier,
      SupplyingSupplier
}
