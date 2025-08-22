@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry Item Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_JournalEntryItem
  as select from I_JournalEntryItem as jei

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
      jei.Supplier,
      jei.DebitCreditCode
}
where
       jei.SourceLedger = '0L'
  and  jei.Ledger       = '0L'
  and(
       jei.GLAccount    = '0011001020'
    or jei.GLAccount    = '0011002020'
    or jei.GLAccount    = '0011003020'
  )
