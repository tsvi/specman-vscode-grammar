// SYNTAX TEST "source.specman" "test_string_test.e"
<'

unit ifx_irq_source {
   on state_change$ {
      messagef(IFX_IRQ, HIGH, "(%s) : \"string-within-string\"", trans.state, name, trans);
//    ^^^^^^^^ support.function.builtin.specman
//                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^  string.quoted.double.specman
//                                    ^^                    ^^  constant.character.escape.specman
//                            ^                                 punctuation.definition.string.begin.specman
//                                                            ^ punctuation.definition.string.end.specman
      messagef(IFX_IRQ, HIGH, "Raw IRQ %s change dected (%s): %s", trans.state, name, trans);
      chg_raw$.write(trans);
   };


   run() is also {
      trans = new with {
         .origin = me;
      };
      state = CLEAR;
      sel   = 0;
   };
};

extend ifx_irq_trans {
   origin : ifx_irq_source;
};

'>
