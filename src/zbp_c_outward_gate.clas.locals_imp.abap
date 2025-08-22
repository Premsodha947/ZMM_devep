CLASS lhc_zc_outward_gate DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zc_outward_gate RESULT result.

    METHODS populatematerialdesc FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zc_outward_gate~populatematerialdesc.

ENDCLASS.

CLASS lhc_zc_outward_gate IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD populatematerialdesc.
  ENDMETHOD.

ENDCLASS.
