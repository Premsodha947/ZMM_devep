@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Check Print Form - Data Structure'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_CheckPrint_Det
  as select from    ZI_JournalEntry     as je
  /* Join to line items - must be 1:1 match */
    inner join      ZI_JournalEntryItem as jei       on  je.CompanyCode    = jei.CompanyCode
                                                     and je.DocumentNumber = jei.AccountingDocument
                                                     and je.FiscalYear     = jei.FiscalYear

  /* Optional join to supplier */
    left outer join I_Supplier          as _Supplier on jei.Supplier = _Supplier.Supplier
{
      // Document identification
  key je.CompanyCode,
  key je.DocumentNumber,
  key je.FiscalYear,

      // Header information
      je.AccountingDocumentType,
      je.DocumentDate,
      je.Currency,

      // Line item information
      @Semantics.amount.currencyCode: 'Currency'
      abs(jei.Amount) as Amount,
      jei.GLAccount,

      // Supplier information
      jei.Supplier,
      _Supplier.SupplierName

}
