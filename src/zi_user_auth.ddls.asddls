@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Authorization Matrix for Mfg. Order'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZI_USER_AUTH
  as select from zpp_user_auth
{
  key userid   as Userid,
      username as Username,
      authflag as Authflag

}
