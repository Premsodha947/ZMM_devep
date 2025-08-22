@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MACPL Purchase Orders'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_PurchaseOrder_F4help
  as select from I_PurchaseOrderAPI01
{
  key PurchaseOrder,
      PurchaseOrderType,
      Supplier,
      SupplyingPlant
}
