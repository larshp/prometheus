class ZCL_PROMETHEUS_SICF definition
  public
  final
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
protected section.
private section.

  methods GET_DUMPS
    returning
      value(RV_DUMPS) type I .
ENDCLASS.



CLASS ZCL_PROMETHEUS_SICF IMPLEMENTATION.


  METHOD get_dumps.

    GET TIME STAMP FIELD DATA(lv_stamp).

    lv_stamp = cl_abap_tstmp=>subtractsecs(
      tstmp = lv_stamp
      secs  = 300 ).

* todo, make sure the timezones are okay
    CONVERT TIME STAMP lv_stamp TIME ZONE 'UTC'
      INTO DATE DATA(lv_date) TIME DATA(lv_time).

    SELECT COUNT( * ) FROM snap INTO @rv_dumps
      WHERE datum >= @lv_date
      AND uzeit >= @lv_time
      AND seqno = '000'.

  ENDMETHOD.


  METHOD if_http_extension~handle_request.

    server->response->set_header_field(
      name  = 'content-type'
      value = 'text/plain; version=0.0.4' ).

* see https://prometheus.io/docs/instrumenting/exposition_formats/
    server->response->set_cdata( |dumps { get_dumps( ) }| ).

  ENDMETHOD.
ENDCLASS.
