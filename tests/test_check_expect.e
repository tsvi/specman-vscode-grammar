// SYNTAX TEST "source.specman" "Check expect"

expect  dhkljashd
<'


extend sys {

    expect sdjasdfl sdfh ;
//  ^^^^^^  keyword.other.statement.specman
//
    expect ffooo is @clock;
//               ^^ keyword.other.specman
    check that foo == 1;
//  ^^^^^ keyword.statement.specman
//        ^^^^ keyword.other.specman
//                 ^^ keyword.operator.comparison.specman
//                    ^ constant.numeric.unsized.integer.specman
    check quux that (a==b) else dut_error("BLA");
//                    ^^ keyword.operator.comparison.specman
//                              ^^^^^^^^^        support.function.builtin.specman
//                                         ^^^   string.quoted.double.specman
//                                        ^      punctuation.definition.string.begin.specman
//                                            ^  punctuation.definition.string.end.specman

    finalize() is also {
//  ^^^^^^^^ meta.method.identifier.specman entity.name.function.specman

      check foo.is_empty();
//              ^^^^^^^^ support.function.builtin.specman
    };

};

'>
