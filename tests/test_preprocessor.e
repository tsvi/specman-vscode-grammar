// SYNTAX TEST "source.specman" "test_preprocessor.e"
<'


import mod2.e;
// <----- keyword.control.import.specman
//     ^^^^^^ entity.name.filename.specman
//           ^ punctuation.terminator.specman

#ifdef optional_syntax then {
   import mod1.e;
// ^^^^^^ keyword.control.import.specman
//        ^^^^^^ entity.name.filename.specman
//              ^ punctuation.terminator.specman
};

extend sys {
#ifdef set_this {
   when TRUE'has_this my_struct_s {

   };
} #else {

   when FALSE'has_this my_struct_s {
      print "#ifdef { ";

      #ifdef `FROM_VERILOG {
         // this is nested
      };
   };
};

#undef set_this;


};


'>
