// SYNTAX TEST "source.specman" "test_literals.e"

<'

extend sys {
  run() is also {
      var u: uint(bytes:2) = 0c"a";
      var c: int =  32'hffffxxxx;
      var c: int =  32'HFFFFXXXX;
      var c: int =  19'dL0001;
      var c: int =  14'D123;
      var c: int =  14'D1;
      var c: int =  64'bz_1111_0000_1111_0000 ;

      var kilos: list of uint := {32K; 32k; 128k};
      var megas: list of uint := {1m; 10M};
      var gigas: list of uint := {1g; 5G};
//                                ^^ constant.numeric.unsized.integer.specman
//                                    ^^ constant.numeric.unsized.integer.specman
      var teras: list of uint := {2t; 4T};
//                                ^^ constant.numeric.unsized.integer.specman
//                                    ^^ constant.numeric.unsized.integer.specman

      var flt1: real := 7.321E-3;
      var flt2: real = 1.0e12;
      var pi: real := SN_M_PI;

      -- Test literal characters (1.1.4.6)
      var u2: uint(bytes:2) = 0c"a";
//                            ^^^^^ constant.character.literal.specman
      var u3: uint = 0c"1";
//                   ^^^^^ constant.character.literal.specman
      var u4: uint = 0c" ";
//                   ^^^^^ constant.character.literal.specman

      /* This is a multi-line comment
         spanning multiple lines */
      /* Single-line block comment */
  };
};

'>
