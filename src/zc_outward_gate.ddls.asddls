@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Outward Gate Entry'
@Metadata.ignorePropagatedAnnotations: true
@UI: {
  headerInfo: {
    typeName: 'Material Ewaybill',
    typeNamePlural: 'Material Ewaybills',
    title: {
      type: #STANDARD,
      label: 'Gate Outward No#',
      value: 'Gateoutwardnumber'
    }
  }
}
define root view entity ZC_OUTWARD_GATE
  as select from ZI_OUTWARD_GATE
{
  key Gateoutwardnumber,
  key DocumentNum,
  key MaterialNum,
      @UI: {
        identification: [ { position: 10 } ],
        lineItem: [ { position: 10 } ]
      }
      MaterialDesc,
      @UI: {
        identification: [ { position: 20 } ],
        lineItem: [ { position: 20 } ]
      }
      Plant,
      @UI: {
        identification: [ { position: 30 } ],
        lineItem: [ { position: 30 } ]
      }
      UnitField,
      @UI: {
        identification: [ { position: 40 } ],
        lineItem: [ { position: 40 } ]
      }
      @Semantics.quantity.unitOfMeasure: 'UnitField'
      Quantity,
      @UI: {
        identification: [ { position: 50 } ],
        lineItem: [ { position: 50 } ]
      }
      EwaybillNum
}
