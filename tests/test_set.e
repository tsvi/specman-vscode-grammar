// SYNTAX TEST "source.specman" "Sets and Enums"

Sets and Enums
// <------------ comment.block.specman
<'
// <- punctuation.section.begin.body.specman

type c_t: [FOO, BAR, LOO, HEDGE, BROKEN];
// <--- keyword.declaration.specman
//   ^^^ storage.type.enum.specman
//      ^ punctuation.separator.type.specman
//        ^ punctuation.brackets.begin.specman
//         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^ meta.type.enum.specman
//         ^^^  ^^^  ^^^  ^^^^^  ^^^^^^ constant.other.enum.specman
//            ^    ^    ^      ^ punctuation.separator.specman
//                                     ^ punctuation.brackets.end.specman
//                                      ^ punctuation.terminator.specman


struct connections_s {
   !a: set;
   !b: set;
   
   add_conn(source: c_t, dest: c_t) is {
      a = a.union([source.as_a(uint)]);
      b = b.union([dest.as_a(uint)]);
   };
   
   display() is {
      for each (s) in all_values(c_t) {
         for each (d) in  all_values(c_t) {
            if a.intersect([s.as_a(uint)]) == [s.as_a(uint)] and b.intersect([d.as_a(uint)]) == [d.as_a(uint)] {
               outf("connect %s -> %s\n",s, d);
            };
         };
      };
      
      var x: int = 10;
      if x in [5..11] { out( "x in [5..11]" ) };
   };
};


extend sys {
   conns: connections_s;
   
   run() is also {  
      conns.add_conn(FOO, BAR);
      conns.add_conn(FOO, HEDGE);
      conns.add_conn(LOO, BROKEN);
      
      conns.display();
   };
};
'>
