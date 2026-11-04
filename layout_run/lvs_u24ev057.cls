*******************************************************************************
****** dyna_nor_decoder_3x8 schematic lab10_decoder_dyna  <vs>  dyna_nor_decoder_3x8 layout lab10_decoder_dyna
*******************************************************************************

Reduce Statistics
=================                               Original             Reduced
Cell/Device                               schematic  layout   schematic  layout
(static_inv) Cell                                 3       3           3       3
(nmos) MOS                                       25      25           1       1
(pmos) MOS                                        8       8           8       2*
(nmos:ParMos3#1) MosBlk                           -       -           8       2*
(-, nmos:SerMos2#1) MosBlk                        -       -           -       9*
(-, pmos:SerMos2#1) MosBlk                        -       -           -       3*

Match Statistics
================                                  Total             Unmatched
Cell/Device                               schematic  layout   schematic  layout
(static_inv) Cell                                 3       3           0       0
(nmos) MOS                                        1       1           0       0
(pmos) MOS                                        8       2*          8       2*
(nmos:ParMos3#1) MosBlk                           8       2*          8       2*
(-, nmos:SerMos2#1) MosBlk                        -       9*          -       9*
(-, pmos:SerMos2#1) MosBlk                        -       3*          -       3*
                                             ------  ------      ------  ------
Total                                            20      20          16      16

Match Statistics for Nets                        18      72           0      54

=========================================================[dyna_nor_decoder_3x8]
====== Bad Initial Net Bindings (nets don't match) ============================
===============================================================================

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (badbind 1)
Schematic Net:  vin1
S       1   of static_inv vin
S      *4   of nmos:ParMos3#1 {IN1 IN2 IN3}

Layout Net:  vin1
L       1   of static_inv vin

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (badbind 2)
Schematic Net:  vin2
S       1   of static_inv vin
S      *4   of nmos:ParMos3#1 {IN1 IN2 IN3}

Layout Net:  vin2
L       1   of static_inv vin

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (badbind 3)
Schematic Net:  vin3
S       1   of static_inv vin
S      *4   of nmos:ParMos3#1 {IN1 IN2 IN3}

Layout Net:  vin3
L       1   of static_inv vin

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (badbind 4)
Schematic Net:  clk
S       1   of nmos G
S       8   of pmos G

Layout Net:  clk
L       1   of nmos G
L      *2   of pmos G

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (badbind 5)
Schematic Net:  gnd
S       1   of nmos {D S}
S       1   of nmos B
S       3   of static_inv gnd
S       8   of nmos:ParMos3#1 TERM4

Layout Net:  gnd
L       1   of nmos {D S}
L       1   of nmos B
L       3   of static_inv gnd
L      *2   of nmos:ParMos3#1 TERM4
L      *9   of nmos:SerMos2#1 ?TERM4

=========================================================[dyna_nor_decoder_3x8]
====== Unbound Pin ============================================================
===============================================================================

S vdd
S d0
S d1
S d2
S d3
S d6
S d7
S d5
S d4

=========================================================[dyna_nor_decoder_3x8]
====== Unmatched Internal Nets ================================================
===============================================================================

L ?avC4_2
L ?avC4_3
L ?avC37
L ?avS332
L ?avS337
L ?avC28
L ?avC39
L ?avS340
L ?avS346
L ?avC29
L ?avC38
L ?avS349
L ?avC67
L ?avC68
L ?avS330
L ?avC27
L ?avC34
L ?avS333
L ?avS338
L ?avC25
L ?avC36
L ?avS341
L ?avS345
L ?avC26
L ?avC35
L ?avS348
L ?avS331
L ?avC24
L ?avC33
L ?avS334
L ?avS339
L ?avC16
L ?avC31
L ?avS342
L ?avS347
L ?avC23
L ?avC32
L ?avS350
L ?avC53
L ?avS335
L ?avC73
L ?avS336
L ?avC21
L ?avC52
L ?avS343
L ?avC74
L ?avS344
L ?avC20
L ?avC54
L ?avS358
L ?avC75
L ?avS359
L ?avC22
L ?avC17

=========================================================[dyna_nor_decoder_3x8]
====== Bad Matched Nets (don't really match) ==================================
===============================================================================

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(badmatch 1)
Schematic Net:  net2
S       1   of nmos {D S}
S       8   of nmos:ParMos3#1 {OUT OUT2}

Layout Net:  avC15
L       1   of nmos {D S}
L      *2   of nmos:ParMos3#1 {OUT OUT2}

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(badmatch 2)
Schematic Net:  net4
S       1   of static_inv vout
S      *4   of nmos:ParMos3#1 {IN1 IN2 IN3}

Layout Net:  avC65
L       1   of static_inv vout

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(badmatch 3)
Schematic Net:  net3
S       1   of static_inv vout
S      *4   of nmos:ParMos3#1 {IN1 IN2 IN3}

Layout Net:  avC66
L       1   of static_inv vout

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(badmatch 4)
Schematic Net:  net1
S       1   of static_inv vout
S      *4   of nmos:ParMos3#1 {IN1 IN2 IN3}

Layout Net:  avC62
L       1   of static_inv vout

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(badmatch 5)
Schematic Net:  vdd
S      *8   of pmos {D S}
S      *8   of pmos B
S       3   of static_inv vdd

Layout Net:  avC4_1
L      *1   of static_inv vdd

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(badmatch 6)
Schematic Net:  d0
S      *1   of pmos {D S}
S      *1   of nmos:ParMos3#1 {OUT OUT2}

Layout Net:  avC71
L      *1   of nmos:ParMos3#1 {IN1 IN2 IN3}

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(badmatch 7)
Schematic Net:  d2
S      *1   of pmos {D S}
S      *1   of nmos:ParMos3#1 {OUT OUT2}

Layout Net:  avC69
L      *1   of nmos:ParMos3#1 {IN1 IN2 IN3}

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(badmatch 8)
Schematic Net:  d6
S      *1   of pmos {D S}
S      *1   of nmos:ParMos3#1 {OUT OUT2}

Layout Net:  avC72
L      *1   of nmos:ParMos3#1 {IN1 IN2 IN3}

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(badmatch 9)
Schematic Net:  d7
S      *1   of pmos {D S}
S      *1   of nmos:ParMos3#1 {OUT OUT2}

Layout Net:  avC70
L      *1   of nmos:ParMos3#1 {IN1 IN2 IN3}

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (badmatch 10)
Schematic Net:  d5
S      *1   of pmos {D S}
S      *1   of nmos:ParMos3#1 {OUT OUT2}

Layout Net:  avS329
L      *1   of nmos:SerMos2#1 ?{IN1 IN2}

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (badmatch 11)
Schematic Net:  d4
S      *1   of pmos {D S}
S      *1   of nmos:ParMos3#1 {OUT OUT2}

Layout Net:  avC30
L      *1   of nmos:SerMos2#1 ?{OUT OUT2}

=========================================================[dyna_nor_decoder_3x8]
====== Suggested Terminal Rewire ==============================================
===============================================================================

In the layout, terminal 'vdd' of instance I25 probably should connect to net 
avC4_1 instead of net avC4_3.
This makes a better match between layout net avC4_1 and schematic net vdd.

In the layout, terminal 'vdd' of instance I26 probably should connect to net 
avC4_1 instead of net avC4_2.
This makes a better match between layout net avC4_1 and schematic net vdd.


=========================================================[dyna_nor_decoder_3x8]
====== Open Internal Nets =====================================================
===============================================================================

These layout nets should connect together:
L        avC62
L        avC71
L        avC69
L        avC72
L        avC70

=========================================================[dyna_nor_decoder_3x8]
====== Problem Schematic Nets (no exact match in layout) ======================
===============================================================================
S
S ?net2
S       1   of nmos {D S}
S       8   of nmos:ParMos3#1 {OUT OUT2}
S
S ?clk
S       1   of nmos G
S       8   of pmos G
S
S ?d0 ?d2 ?d6 ?d7 ?d5 ?d4
S (total 6) with:
S       1   of pmos {D S}
S       1   of nmos:ParMos3#1 {OUT OUT2}
S
S ?vin1 ?vin2 ?vin3
S (total 3) with:
S       1   of static_inv vin
S       4   of nmos:ParMos3#1 {IN1 IN2 IN3}
S
S ?net4 ?net3 ?net1
S (total 3) with:
S       1   of static_inv vout
S       4   of nmos:ParMos3#1 {IN1 IN2 IN3}
S
S ?vdd
S       8   of pmos {D S}
S       8   of pmos B
S       3   of static_inv vdd
S
S ?gnd
S       1   of nmos {D S}
S       1   of nmos B
S       3   of static_inv gnd
S       8   of nmos:ParMos3#1 TERM4

=========================================================[dyna_nor_decoder_3x8]
====== Problem Layout Nets (no exact match in schematic) ======================
===============================================================================
L
L ?avC4_1 ?avC4_2 ?avC4_3
L (total 3) with:
L       1   of static_inv vdd
L
L ?vin1 ?vin2 ?vin3
L (total 3) with:
L       1   of static_inv vin
L
L ?avC62 ?avC65 ?avC66
L (total 3) with:
L       1   of static_inv vout
L
L ?avC71 ?avC69 ?avC72 ?avC70 ?avC67 ?avC68
L (total 6) with:
L       1   of nmos:ParMos3#1 {IN1 IN2 IN3}
L
L ?avC30 ?avC37 ?avC28 ?avC39 ?avC29 ?avC38 ?avC27 ?avC34 ?avC25 ?avC36 ?avC26
L ?avC35 ?avC24 ?avC33 ?avC16 ?avC31 ?avC23 ?avC32
L (total 18) with:
L       1   of nmos:SerMos2#1 ?{OUT OUT2}
L
L ?avS329 ?avS332 ?avS337 ?avS340 ?avS346 ?avS349 ?avS330 ?avS333 ?avS338
L ?avS341 ?avS345 ?avS348 ?avS331 ?avS334 ?avS339 ?avS342 ?avS347 ?avS350
L (total 18) with:
L       1   of nmos:SerMos2#1 ?{IN1 IN2}
L
L ?avC53 ?avC21 ?avC52 ?avC20 ?avC54 ?avC22
L (total 6) with:
L       1   of pmos:SerMos2#1 ?{OUT OUT2}
L
L ?avC73 ?avC74 ?avC75
L (total 3) with:
L       1   of pmos:SerMos2#1 ?TERM4
L
L ?avS335 ?avS336 ?avS343 ?avS344 ?avS358 ?avS359
L (total 6) with:
L       1   of pmos:SerMos2#1 ?{IN1 IN2}
L
L ?avC15
L       1   of nmos {D S}
L       2   of nmos:ParMos3#1 {OUT OUT2}
L
L ?clk
L       1   of nmos G
L       2   of pmos G
L
L ?avC17
L       2   of pmos {D S}
L       2   of pmos B
L
L ?gnd
L       1   of nmos {D S}
L       1   of nmos B
L       3   of static_inv gnd
L       2   of nmos:ParMos3#1 TERM4
L       9   of nmos:SerMos2#1 ?TERM4

=========================================================[dyna_nor_decoder_3x8]
====== Matched Instances with Bad Net Connections =============================
===============================================================================

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(badcon 1)
Schematic Instance: I26  static_inv
Layout Instance:    I26  static_inv

Pin        SchNet                      : LayNet
---        ------                      : ------
vdd        vdd                         : ?avC4_2

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(badcon 2)
Schematic Instance: I25  static_inv
Layout Instance:    I25  static_inv

Pin        SchNet                      : LayNet
---        ------                      : ------
vdd        vdd                         : ?avC4_3

=========================================================[dyna_nor_decoder_3x8]
====== Unmatched Schematic Instances ==========================================
===============================================================================

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (schinst 1)
Schematic Instance: PM5  pmos

S Pin        Net
S ---        ---
S D          d6
S G          clk
S S          vdd
S B          vdd

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (schinst 2)
Schematic Instance: PM2  pmos

S Pin        Net
S ---        ---
S D          d3
S G          clk
S S          vdd
S B          vdd

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (schinst 3)
Schematic Instance: PM0  pmos

S Pin        Net
S ---        ---
S D          d0
S G          clk
S S          vdd
S B          vdd

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (schinst 4)
Schematic Instance: PM4  pmos

S Pin        Net
S ---        ---
S D          d7
S G          clk
S S          vdd
S B          vdd

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (schinst 5)
Schematic Instance: PM1  pmos

S Pin        Net
S ---        ---
S D          d1
S G          clk
S S          vdd
S B          vdd

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (schinst 6)
Schematic Instance: PM7  pmos

S Pin        Net
S ---        ---
S D          d4
S G          clk
S S          vdd
S B          vdd

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (schinst 7)
Schematic Instance: PM6  pmos

S Pin        Net
S ---        ---
S D          d5
S G          clk
S S          vdd
S B          vdd

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (schinst 8)
Schematic Instance: PM3  pmos

S Pin        Net
S ---        ---
S D          d2
S G          clk
S S          vdd
S B          vdd

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (schinst 9)
Schematic Instance: I##37  nmos:ParMos3#1

S Pin        Net
S ---        ---
S OUT        net2
S OUT2       d0
S TERM4      gnd
S IN1        vin3
S IN2        vin2
S IN3        vin1

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(schinst 10)
Schematic Instance: I##38  nmos:ParMos3#1

S Pin        Net
S ---        ---
S OUT        net2
S OUT2       d1
S TERM4      gnd
S IN1        net1
S IN2        vin3
S IN3        vin2

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(schinst 11)
Schematic Instance: I##39  nmos:ParMos3#1

S Pin        Net
S ---        ---
S OUT        net2
S OUT2       d2
S TERM4      gnd
S IN1        net4
S IN2        vin3
S IN3        vin1

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(schinst 12)
Schematic Instance: I##40  nmos:ParMos3#1

S Pin        Net
S ---        ---
S OUT        net2
S OUT2       d3
S TERM4      gnd
S IN1        vin3
S IN2        net1
S IN3        net4

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(schinst 13)
Schematic Instance: I##41  nmos:ParMos3#1

S Pin        Net
S ---        ---
S OUT        net2
S OUT2       d6
S TERM4      gnd
S IN1        net3
S IN2        net4
S IN3        vin1

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(schinst 14)
Schematic Instance: I##42  nmos:ParMos3#1

S Pin        Net
S ---        ---
S OUT        net2
S OUT2       d7
S TERM4      gnd
S IN1        net1
S IN2        net4
S IN3        net3

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(schinst 15)
Schematic Instance: I##43  nmos:ParMos3#1

S Pin        Net
S ---        ---
S OUT        net2
S OUT2       d5
S TERM4      gnd
S IN1        net3
S IN2        net1
S IN3        vin2

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(schinst 16)
Schematic Instance: I##44  nmos:ParMos3#1

S Pin        Net
S ---        ---
S OUT        net2
S OUT2       d4
S TERM4      gnd
S IN1        net3
S IN2        vin2
S IN3        vin1

=========================================================[dyna_nor_decoder_3x8]
====== Unmatched Layout Instances =============================================
===============================================================================

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (layinst 1)
Layout Instance:    avD27_7  pmos

L Pin        Net
L ---        ---
L D          d1
L G          clk
L S          ?avC17
L B          ?avC17

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (layinst 2)
Layout Instance:    avD27_8  pmos

L Pin        Net
L ---        ---
L D          ?avC17
L G          clk
L S          d3
L B          ?avC17

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (layinst 3)
Layout Instance:    I##37  nmos:SerMos2#1

L Pin        Net
L ---        ---
L OUT        d4
L OUT2       ?avC37
L TERM4      gnd
L IN1        d5
L IN2        ?avS332

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (layinst 4)
Layout Instance:    I##38  nmos:SerMos2#1

L Pin        Net
L ---        ---
L OUT        ?avC28
L OUT2       ?avC39
L TERM4      gnd
L IN1        ?avS337
L IN2        ?avS340

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (layinst 5)
Layout Instance:    I##39  nmos:SerMos2#1

L Pin        Net
L ---        ---
L OUT        ?avC29
L OUT2       ?avC38
L TERM4      gnd
L IN1        ?avS346
L IN2        ?avS349

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (layinst 6)
Layout Instance:    I##40  nmos:SerMos2#1

L Pin        Net
L ---        ---
L OUT        ?avC27
L OUT2       ?avC34
L TERM4      gnd
L IN1        ?avS330
L IN2        ?avS333

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (layinst 7)
Layout Instance:    I##41  nmos:SerMos2#1

L Pin        Net
L ---        ---
L OUT        ?avC25
L OUT2       ?avC36
L TERM4      gnd
L IN1        ?avS338
L IN2        ?avS341

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (layinst 8)
Layout Instance:    I##42  nmos:SerMos2#1

L Pin        Net
L ---        ---
L OUT        ?avC26
L OUT2       ?avC35
L TERM4      gnd
L IN1        ?avS345
L IN2        ?avS348

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = (layinst 9)
Layout Instance:    I##43  nmos:SerMos2#1

L Pin        Net
L ---        ---
L OUT        ?avC24
L OUT2       ?avC33
L TERM4      gnd
L IN1        ?avS331
L IN2        ?avS334

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(layinst 10)
Layout Instance:    I##44  nmos:SerMos2#1

L Pin        Net
L ---        ---
L OUT        ?avC16
L OUT2       ?avC31
L TERM4      gnd
L IN1        ?avS339
L IN2        ?avS342

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(layinst 11)
Layout Instance:    I##45  nmos:SerMos2#1

L Pin        Net
L ---        ---
L OUT        ?avC23
L OUT2       ?avC32
L TERM4      gnd
L IN1        ?avS347
L IN2        ?avS350

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(layinst 12)
Layout Instance:    I##46  pmos:SerMos2#1

L Pin        Net
L ---        ---
L OUT        ?avC53
L OUT2       ?avC21
L TERM4      ?avC73
L IN1        ?avS335
L IN2        ?avS336

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(layinst 13)
Layout Instance:    I##47  pmos:SerMos2#1

L Pin        Net
L ---        ---
L OUT        ?avC52
L OUT2       ?avC20
L TERM4      ?avC74
L IN1        ?avS343
L IN2        ?avS344

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(layinst 14)
Layout Instance:    I##48  pmos:SerMos2#1

L Pin        Net
L ---        ---
L OUT        ?avC54
L OUT2       ?avC22
L TERM4      ?avC75
L IN1        ?avS358
L IN2        ?avS359

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(layinst 15)
Layout Instance:    I##49  nmos:ParMos3#1

L Pin        Net
L ---        ---
L OUT        net2
L OUT2       d1
L TERM4      gnd
L IN1        ?avC67
L IN2        d2
L IN3        d0

= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =(layinst 16)
Layout Instance:    I##50  nmos:ParMos3#1

L Pin        Net
L ---        ---
L OUT        net2
L OUT2       d3
L TERM4      gnd
L IN1        ?avC68
L IN2        d7
L IN3        d6

=========================================================[dyna_nor_decoder_3x8]
====== Summary of Errors ======================================================
===============================================================================

Schematic  Layout     Error Type
---------  ------     ----------
 5          5         Bad Initial Net Bindings
 11         11        Bad Matched Nets
 -          2         Suggested Terminal Rewire
 -          54        Unmatched Internal Nets
 -          1         Open Internal Nets
 2          2         Matched Instances with Bad Net Connections
 16         16        Unmatched Instances
 9          -         Unbound Pin

