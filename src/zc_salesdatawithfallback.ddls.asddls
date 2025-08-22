@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SalesOrder & SchAgreement View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_SalesDataWithFallback
  as select from    I_SalesDocument     as so
    left outer join I_SalesDocumentItem as soi on so.SalesDocument = soi.SalesDocument
{
  key so.SalesDocument,
  key soi.SalesDocumentItem,
      soi.PurchaseOrderByCustomer,
      soi.UnderlyingPurchaseOrderItem,
      soi.MaterialByCustomer,
      soi.ShippingPoint,
      so.PurchaseOrderByCustomer as custpohdr,
      //      so.YY1_UnloadingPoint_SDH  as VendorPlant,
      'SO'                       as DataSource
}
where
  so.SalesDocument is not null

union all

select from       I_SalesSchedgAgrmt     as sa
  inner join      I_SalesSchedgAgrmtItem as sai      on sa.SalesSchedulingAgreement = sai.SalesSchedulingAgreement
  left outer join I_SalesDocument        as so_check on sa.SalesSchedulingAgreement = so_check.SalesDocument
{
  key sa.SalesSchedulingAgreement      as SalesDocument,
  key sai.SalesSchedulingAgreementItem as SalesDocumentItem,
      sai.PurchaseOrderByCustomer      as PurchaseOrderByCustomer,
      sai.UnderlyingPurchaseOrderItem  as UnderlyingPurchaseOrderItem,
      sai.MaterialByCustomer           as MaterialByCustomer,
      sai.ShippingPoint,
      sa.PurchaseOrderByCustomer       as custpohdr,
      //      so.YY1_UnloadingPoint_SDH        as VendorPlant,
      'SA'                             as DataSource
}
where
  so_check.SalesDocument is null // Only include SA records that don't exist as SO
