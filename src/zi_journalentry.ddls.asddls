@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Journal Entry'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_JournalEntry
  as select from I_JournalEntry as je
{
  key  je.CompanyCode,
  key  je.AccountingDocument  as DocumentNumber,
  key  je.FiscalYear,

       // Header information
       je.AccountingDocumentType,
       je.DocumentDate,
       je.TransactionCurrency as Currency
}
where
     je.AccountingDocumentType = 'UV'
  or je.AccountingDocumentType = 'UR'
  or je.AccountingDocumentType = 'CS'
  or je.AccountingDocumentType = 'KZ'
  or je.AccountingDocumentType = 'SA'
  or je.AccountingDocumentType = 'ZS'
