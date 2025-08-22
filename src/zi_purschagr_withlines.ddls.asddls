@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Scheduling Agreement Item with lines'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PURSCHAGR_WITHLINES
  as select from    I_SchedgAgrmtItmApi01 as item
    inner join      I_SchedglineApi01     as line      on  item.SchedulingAgreement     = line.SchedulingAgreement
                                                       and item.SchedulingAgreementItem = line.SchedulingAgreementItem
    left outer join I_SchedgagrmthdrApi01 as sa_header on item.SchedulingAgreement = sa_header.SchedulingAgreement
{
      // Key fields
  key item.SchedulingAgreement,
  key item.SchedulingAgreementItem,

      // Item details
      item.Material,
      item.PurchasingDocumentItemText,
      item.Plant,
      item.TaxCode,
      item.OrderQuantityUnit,
      item.DocumentCurrency,

      item.AccountAssignmentCategory      as AccountAssignmentCategory,

      // New supplier fields from I_SchedgAgrmtHdrApi01
      sa_header.Supplier                  as Supplier,

      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      item.NetPriceQuantity,

      // Amounts and quantities
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      item.NetPriceAmount,

      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      item.TargetQuantity,

      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      sum(line.ScheduleLineOrderQuantity) as TotalScheduledQuantity
}
// Group by all non-aggregated fields
group by
  item.SchedulingAgreement,
  item.SchedulingAgreementItem,
  item.Material,
  item.PurchasingDocumentItemText,
  item.Plant,
  item.TaxCode,
  item.OrderQuantityUnit,
  item.DocumentCurrency,
  item.AccountAssignmentCategory,
  sa_header.Supplier,
  item.NetPriceQuantity,
  item.NetPriceAmount,
  item.TargetQuantity
