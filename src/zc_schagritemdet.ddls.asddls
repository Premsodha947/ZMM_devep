@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Scheduling Agreement Item Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_SchAgrItemDet
  as select from I_SchedgAgrmtItmApi01
{
  key SchedulingAgreement,
  key SchedulingAgreementItem,
      PurchasingDocumentItemText,
      Material,
      Plant,
      OrderQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      TargetQuantity
}
