@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry Item Supplier Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_JournalEntryItemSupplier
  as select from    I_JournalEntryItem as jei
  /* Optional join to supplier */
    left outer join I_Supplier         as _Supplier on jei.Supplier = _Supplier.Supplier

{
  key jei.SourceLedger,
  key jei.CompanyCode,
  key jei.AccountingDocument,
  key jei.FiscalYear,
  key jei.Ledger,
  key jei.LedgerGLLineItem,

      jei.TransactionCurrency         as Currency,

      @Semantics.amount.currencyCode: 'Currency'
      jei.AmountInTransactionCurrency as Amount,

      jei.GLAccount,
      jei.DebitCreditCode,
      jei.FinancialAccountType,

      // Supplier information
      jei.Supplier,
      _Supplier.SupplierName
}
where
      jei.SourceLedger         = '0L'
  and jei.Ledger               = '0L'
  and jei.FinancialAccountType = 'K'
