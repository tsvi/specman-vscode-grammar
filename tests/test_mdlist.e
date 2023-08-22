// SYNTAX TEST "source.specman" "test_mdlist.e"
 Testcase to show that <multi-dimensional-list>.is_a_permutation(<other list>) is broken in Specman 13.2

<'
extend sys {
   lol: list of list of int;
   keep lol == {
      {0;1};
      {2;3};
      {98;99}
   };
   
   run() is also {
      var rnd_lol: list of list of int;
      
      gen rnd_lol keeping {
//    ^^^                   keyword.other.gen.specman
//        ^^^^^^^           variable.other.specman
//                ^^^^^^^   keyword.other.constraint.specman
//                        ^ punctuation.section.constraint_block.begin.specman
         -- This constraint is not adhered to and(!) also destroys lol
//       ^^ comment.line.specman punctuation.definition.comment.specman
         it.is_a_permutation(lol);
      };
//    ^  punctuation.section.constraint_block.end.specman
//     ^ punctuation.terminator.specman
      
      var foo : uint;
      // Multiple line example
      gen foo
//    ^^^                   keyword.other.gen.specman
//        ^^^               variable.other.specman
      keeping
//    ^^^^^^^               keyword.other.constraint.specman
      {
//    ^                     punctuation.section.constraint_block.begin.specman               
         foo == 5;
      }
//    ^                     punctuation.section.constraint_block.end.specman                     
      ;
//    ^ punctuation.terminator.specman
      print rnd_lol;
      
      print lol;
   };
};
'>
