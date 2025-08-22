@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Item details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_PurOrderItemDet
  as select from I_PurchaseOrderItemAPI01
{
  key PurchaseOrder,
  key PurchaseOrderItem,
      Material,
      PurchaseOrderItemText,
      Plant,
      BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      OrderQuantity

}
