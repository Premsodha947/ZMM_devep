@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Authorization Matrix for Mfg. Order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@Metadata.allowExtensions: true
define root view entity ZC_USER_AUTH
  provider contract transactional_query
  as projection on ZI_USER_AUTH
{
  key Userid,
      Username,
      Authflag
}
