// SYNTAX TEST "source.specman" "Coverage constructs"

<'

extend sys {

   cover done using radix = HEX is {
// ^^^^^ keyword.other.coverage.specman
//            ^^^^^ keyword.other.coverage.specman
//                  ^^^^^ keyword.other.coverage-option.specman
//                        ^ keyword.operator.assignment.specman
//                          ^^^ constant.language.radix.specman
//                              ^^ keyword.other.specman
//                                 ^ punctuation.section.block.begin.specman
      item len: uint (bits: 3) = me.len;
//    ^^^^ keyword.declaration.coverage-item.specman
//         ^^^ variable.other.coverage-item.specman
//            ^ punctuation.separator.type.specman
//                               ^^ variable.language.specman
      item data: byte = data using
//    ^^^^ keyword.declaration.coverage-item.specman
//         ^^^^ variable.other.coverage-item.specman
//             ^ punctuation.separator.type.specman
//                    ^ keyword.operator.assignment.specman
//                           ^^^^^ keyword.other.coverage.specman
         ranges = {range([0..0xff], "", 4)},
//       ^^^^^^ keyword.other.coverage-option.specman
//              ^ keyword.operator.assignment.specman
//                 ^^^^^ support.function.builtin.specman
         radix = HEX;
//       ^^^^^ keyword.other.coverage-option.specman
//             ^ keyword.operator.assignment.specman
//               ^^^ constant.language.radix.specman
      item mask: uint (bits: 2) = sys.mask using radix = BIN;
//    ^^^^ keyword.declaration.coverage-item.specman
//         ^^^^ variable.other.coverage-item.specman
//             ^ punctuation.separator.type.specman
//                                ^^^ keyword.other.singleton.specman
//                                         ^^^^^ keyword.other.coverage.specman
//                                               ^^^^^ keyword.other.coverage-option.specman
//                                                     ^ keyword.operator.assignment.specman
//                                                       ^^^ constant.language.radix.specman
   };

   cover ended is {
// ^^^^^ keyword.other.coverage.specman
//             ^^ keyword.other.specman
//                ^ punctuation.section.block.begin.specman
      item address : address_t = address
//    ^^^^ keyword.declaration.coverage-item.specman
//         ^^^^^^^ variable.other.coverage-item.specman
//                 ^ punctuation.separator.type.specman
//                             ^ keyword.operator.assignment.specman
      using ranges = {
//    ^^^^^ keyword.other.coverage.specman
//          ^^^^^^ keyword.other.coverage-option.specman
//                 ^ keyword.operator.assignment.specman
       range([set_of_values(address_t).min()], "First address");
//     ^^^^^ support.function.builtin.specman
//            ^^^^^^^^^^^^^ support.function.builtin.specman
       range([set_of_values(address_t).min() + 1..set_of_values(address_t).max() - 1], "",
//     ^^^^^ support.function.builtin.specman
//            ^^^^^^^^^^^^^ support.function.builtin.specman
                set_of_values(address_t).uint_size() / 10);
       range([set_of_values(address_t).max()], "Last address");
      };
   };

   cover done is also {
// ^^^^^ keyword.other.coverage.specman
//            ^^ keyword.other.specman
//               ^^^^ keyword.modifier.specman
      item len using also (ignore = it<2);
//    ^^^^ keyword.declaration.coverage-item.specman
//             ^^^^^ keyword.other.coverage.specman
   };

};
'>
