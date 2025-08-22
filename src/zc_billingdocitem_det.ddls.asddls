@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Document Item Details'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_BillingDocItem_Det
  as select from    I_BillingDocument              as BillingDoc
    inner join      I_BillingDocumentItem          as BillingItem        on BillingDoc.BillingDocument = BillingItem.BillingDocument
    left outer join I_BillingDocumentItemPrcgElmnt as PricingElement     on  BillingItem.BillingDocument     = PricingElement.BillingDocument
                                                                         and BillingItem.BillingDocumentItem = PricingElement.BillingDocumentItem
    left outer join I_IN_ElectronicDocInvoice      as ElectronicDoc      on BillingDoc.BillingDocument = ElectronicDoc.ElectronicDocSourceKey
    left outer join I_DeliveryDocument             as DeliveryDoc        on BillingItem.ReferenceSDDocument = DeliveryDoc.DeliveryDocument
    left outer join I_BusinessPartner              as BusinessPartner    on BillingDoc.SoldToParty = BusinessPartner.BusinessPartner
    left outer join I_Businesspartnertaxnumber     as BusinessPartnerTax on BusinessPartner.BusinessPartner = BusinessPartnerTax.BusinessPartner
    left outer join I_ProductPlantBasic            as ProductPlant       on  BillingItem.Material = ProductPlant.Product
                                                                         and BillingItem.Plant    = ProductPlant.Plant
    left outer join I_SalesDocumentItem            as SalesOrderItem     on  BillingItem.SalesDocument     = SalesOrderItem.SalesDocument
                                                                         and BillingItem.SalesDocumentItem = SalesOrderItem.SalesDocumentItem
    left outer join I_SalesDocument                as SalesOrder         on BillingItem.SalesDocument = SalesOrder.SalesDocument
    left outer join I_ProductText                  as Product            on BillingItem.Material = Product.Product
{
      // Fields from I_BillingDocument
  key BillingDoc.BillingDocument,
      BillingDoc.BillingDocumentType,
      BillingDoc.BillingDocumentDate,
      BillingDoc.SoldToParty,
      BillingDoc.PayerParty,
      BillingDoc.CreationDate,
      BillingDoc.DocumentReferenceID               as CustInvNo,
      //    BillingDoc.SoldToPartyName,
      //    BillingDoc.BillingDocumentCurrency,

      // Fields from I_BillingDocumentItem
      BillingItem.BillingDocumentItem,
      BillingItem.Product                          as Material,
      // BillingItem.MaterialDescription,
      //    BillingItem.MaterialDescription,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      BillingItem.BillingQuantity,
      BillingItem.BillingQuantityUnit,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      BillingItem.NetAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      BillingItem.TaxAmount,
      BillingItem.TransactionCurrency,
      BillingItem.Plant,

      // Fields from I_BillingDocumentItemPrcgElmnt
      PricingElement.ConditionRateValue,
      PricingElement.ConditionRateAmount,
      case
              when PricingElement.ConditionType = 'ZBSM' then 'ZDOM'
              when PricingElement.ConditionType = 'ZSPR' then 'ZDOM'
              else PricingElement.ConditionType
            end                                    as ConditionType,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      PricingElement.ConditionAmount,
      PricingElement.ConditionCurrency,

      // Fields from I_IN_ElectronicDocInvoice
      ElectronicDoc.IN_EDocEInvcEWbillNmbr,
      ElectronicDoc.IN_EDocEInvcEWbillCreateDate,
      ElectronicDoc.IN_EDocEInvcVehicleNumber,
      ElectronicDoc.IN_ElectronicDocQRCodeTxt,
      ElectronicDoc.IN_ElectronicDocInvcRefNmbr,
      ElectronicDoc.IN_EDocEInvcTransptDocNmbr,
      ElectronicDoc.IN_EDocEInvcTransptrName,

      // Fields from I_DeliveryDocument
      DeliveryDoc.DeliveryDocument,
      DeliveryDoc.DeliveryDocumentType,
      DeliveryDoc.DocumentDate,
      DeliveryDoc.YY1_vehicleno_DLH,
      DeliveryDoc.YY1_LRNO_DLH,
      DeliveryDoc.YY1_LR_DATE_DLH,

      //    DeliveryDoc.ShippingLocation,
      //    DeliveryDoc.ShippingLocationDescription

      // Fields from I_BusinessPartner
      BusinessPartner.BusinessPartnerIDByExtSystem as VendorCode,

      // Fields from I_BusinessPartnerTaxNumber
      BusinessPartnerTax.BPTaxNumber               as GSTIN,

      // Fields from I_ProductPlantBasic
      ProductPlant.ConsumptionTaxCtrlCode,

      // Fields from I_SalesDocumentItem
      SalesOrderItem.PurchaseOrderByCustomer,
      SalesOrderItem.UnderlyingPurchaseOrderItem,
      SalesOrderItem.MaterialByCustomer,
      SalesOrderItem.ShippingPoint,

      // Fields from I_SalesDocument
      SalesOrder.SalesDocument,
      SalesOrder.PurchaseOrderByCustomer           as custpohdr,
      SalesOrder.YY1_UnloadingPoint_SDH            as VendorPlant,

      // Fields from I_Product (Material Description)
      Product.ProductName                          as MaterialDescription

}
where
  Product.Language = 'E'
