@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MACPL Materials with respect to plant'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_Material_F4Help
  as select from I_ProductPlantBasic as product
  association [1..1] to I_ProductText as _productText on $projection.Product = _productText.Product
{
  key product.Product,
  key product.Plant,
      product.BaseUnit as Unit,
      _productText.ProductName
}
where
  _productText.Language = 'E'
