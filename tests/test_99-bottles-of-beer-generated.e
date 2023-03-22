// SYNTAX TEST "source.specman" "99 bottles of beer generated"

This is comment
extend sys
for each in bla {

}

<'

// 99 Bottles of beer
// <- comment.line.specman punctuation.definition.comment.specman
// By Thorsten Dworzak
// ^^^^^^^^^^^^^^^^^^^ comment.line.specman

extend sys  {
// <----- keyword.declaration.class.specman
//     ^^^ entity.name.class.specman
//          ^ punctuation.section.class.begin.specman
// <----------- meta.class.declaration.specman
   lyrics: list of string;
// ^^^^^^ variable.other.member.specman
//       ^ punctuation.separator.type.specman
//         ^^^^^^^^^^^^^^ storage.type.specman
//                       ^ punctuation.terminator.specman
// Some comment
// <- punctuation.definition.comment.specman


   keep lyrics.size() == 200;
// ^^^^                     ^ meta.constraint-def.specman
//      ^^^^^^^^^^^^^^^^^^^^  meta.constraint-expression.specman
// ^^^^^^^^^^^^^^^^^^^^^^^^^^ - meta.class.declaration.specman
// ^^^^ keyword.other.constraint.specman
//      ^^^^^^ variable.other.specman
//             ^^^^ support.function.builtin.specman
//                    ^^ keyword.operator.comparison.specman
//                       ^^^ constant.numeric.unsized.integer.specman

   keep beer_c is for each (o) using index (n) in lyrics  {
// ^^^^        ^^ keyword.other.constraint.specman
//      ^^^^^^ entity.name.label.specman
//                ^^^^^^^^     ^^^^^^^^^^^     ^^ keyword.control.specman
//                          ^               ^     ^^^^^^ variable.other.specman
//                                                        ^ punctuation.section.block.begin.specman

// This is a comment within a constraint
// <--------------------------------------- comment.line.specman

      n==0                   => it == appendf("Go to the store and buy some more, 99 bottles of beer on the wall.");
//    ^ variable.other.specman
//     ^^ keyword.operator.comparison.specman
//       ^ constant.numeric.unsized.integer.specman
      ((n%2==1) and (n!= 0)) => it == appendf("%s bottle%s of beer on the wall, %s bottle%s of beer.",
//              ^^^                   keyword.operator.word.specman
//      ^            ^                variable.other.specman
//       ^                            keyword.operator.arithmetic.specman
//         ^^         ^^           ^^ keyword.operator.comparison.specman
//                           ^^       keyword.operator.logical.specman
                                                  (n==1 ? "No more":(n/2).as_a(string)),
                                                  (n==3) ? "":"s",
                                                  (n==1 ? "no more":(n/2).as_a(string)),
                                                  (n==3) ? "":"s");
      (n%2==0) and (n!=0) => it == appendf("Take one down and pass it around, %s bottle%s of beer on the wall.",
                                           (n==2 ? "no more":(n/2-1).as_a(string)),
                                           ((n-1)==3) ? "":"s");
   };

   run() is also {
// ^^^             meta.method.identifier.specman entity.name.function.specman
//       ^^        keyword.other.function.specman
//          ^^^^   keyword.modifier.function.specman
//               ^ punctuation.section.method.begin.specman
      for each in lyrics.reverse() {
         outf("%s\n", append(it, (index % 2 == 1 ? "\n":"")));
//                                      ^ keyword.operator.arithmetic.specman
      };
   };
// ^ punctuation.section.method.end.specman
//  ^ punctuation.terminator.specman
};
// <- punctuation.section.class.end.specman
// <~- punctuation.terminator.specman

'>

This is comment


<'
  extend bla_s {

  };

'>
